import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import 'backend_service.dart';
import 'certificate_service.dart';
import 'gamification_service.dart';
import 'progress_service.dart';
import 'streak_service.dart';
import 'sync_service.dart';

enum ClubChat { students, pro }

class CutoffCheck {
  const CutoffCheck(this.label, this.done, this.detail, this.route);

  final String label;
  final bool done;
  final String detail;

  /// Where to go to close this condition.
  final String route;
}

class ClubStatus {
  const ClubStatus({
    required this.points,
    required this.weekPoints,
    required this.streak,
    required this.publicId,
    required this.displayName,
    required this.students,
    required this.pro,
    required this.studentsChecks,
    required this.proChecks,
  });

  final int points;
  final int weekPoints;
  final StreakState streak;
  final String publicId;
  final String? displayName;
  final bool students;
  final bool pro;
  final List<CutoffCheck> studentsChecks;
  final List<CutoffCheck> proChecks;

  League get league => GamificationService.leagueFor(points);
  String get shownName => (displayName == null || displayName!.isEmpty) ? 'Ученик $publicId' : displayName!;
}

class LadderRow {
  const LadderRow({
    required this.rank,
    required this.name,
    required this.publicId,
    required this.points,
    this.telegram,
    this.online = false,
    this.isMe = false,
  });

  final int rank;
  final String name;
  final String publicId;
  final int points;
  final String? telegram;
  final bool online;
  final bool isMe;

  factory LadderRow.fromMap(Map<String, dynamic> m, String myId) => LadderRow(
        rank: (m['rank'] as num?)?.toInt() ?? 0,
        name: (m['display_name'] as String?)?.trim().isNotEmpty == true
            ? m['display_name'] as String
            : 'Ученик ${m['public_id']}',
        publicId: m['public_id'] as String? ?? '',
        points: (m['points'] as num?)?.toInt() ?? 0,
        telegram: m['telegram'] as String?,
        online: m['online'] == true,
        isMe: m['public_id'] == myId,
      );
}

class LadderResult {
  const LadderResult({required this.rows, required this.live, this.myRank, this.serverPoints, this.note});

  final List<LadderRow> rows;

  /// false = server unreachable: only the user's own row is real.
  final bool live;

  /// Why the shared board isn't shown, in words for the user.
  final String? note;
  final int? myRank;

  /// Points the server has accepted so far (growth is capped at 800 a day).
  final int? serverPoints;
}

/// Ladder, cutoffs and closed chats of Desk Club.
class ClubService {
  static const nameKey = 'clubDisplayName';
  static const publicIdKey = 'clubPublicId';
  static const secretKey = 'clubSecret';
  static const studentsAtKey = 'cutoffStudentsAt';
  static const proAtKey = 'cutoffProAt';
  static const studentsSeenKey = 'cutoffStudentsSeen';
  static const proSeenKey = 'cutoffProSeen';

  /// Keys that identify the person in the club; progress reset keeps them.
  static const identityKeys = [nameKey, publicIdKey, secretKey];

  /// Entry goes through an application in the club: the admin checks the ID
  /// against the ladder and sends the invite.
  static const clubUrl = 'https://t.me/Desk_Club';

  static const stage1Lessons = 14;
  static const proPlanTrades = 8;
  static const studentsStreak = 7;
  static const proStreak = 30;

  static Future<String?> getDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(nameKey);
  }

  static Future<void> setDisplayName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(nameKey, name.trim());
    SyncService.schedulePush();
  }

  static String _newId(Random r) => 'TM-${10000 + r.nextInt(90000)}';

  static Future<String> publicId() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(publicIdKey);
    if (id == null || !RegExp(r'^TM-\d{5}$').hasMatch(id)) {
      id = _newId(Random.secure());
      await prefs.setString(publicIdKey, id);
      SyncService.schedulePush();
    }
    return id;
  }

  static Future<String> _secret() async {
    final prefs = await SharedPreferences.getInstance();
    var s = prefs.getString(secretKey);
    if (s == null || s.length < 24) {
      final r = Random.secure();
      const abc = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      s = List.generate(32, (_) => abc[r.nextInt(abc.length)]).join();
      await prefs.setString(secretKey, s);
      SyncService.schedulePush();
    }
    return s;
  }

  static Future<ClubStatus> status() async {
    final prefs = await SharedPreferences.getInstance();
    final points = await GamificationService.getPoints();
    final week = await GamificationService.getWeekPoints();
    final streak = await StreakService.load();
    final completed = await ProgressService.getCompletedLessons();
    final modules = await ProgressService.getModuleResults();
    final cert = await CertificateService.loadIssued();
    final planTrades = await GamificationService.getPlanTrades();
    final id = await publicId();

    final s1Done = List.generate(stage1Lessons, (i) => i + 1).where(completed.contains).toList();
    final s1Missing = List.generate(stage1Lessons, (i) => i + 1).where((n) => !completed.contains(n));
    final s1Tests = ['spotfut', 'chart'].where(modules.containsKey).length;
    final stage1 = s1Missing.isEmpty && s1Tests == 2;
    final stage1Route = s1Missing.isNotEmpty ? '/lesson/${s1Missing.first}' : '/module-quiz';

    final studentsChecks = [
      CutoffCheck('${_fmt(GamificationService.cutoffStudents)} очков',
          points >= GamificationService.cutoffStudents, 'у тебя ${_fmt(points)}', '/streak'),
      CutoffCheck('Ступень 1 пройдена', stage1, 'уроки ${s1Done.length}/$stage1Lessons · тесты $s1Tests/2',
          stage1Route),
      CutoffCheck('Серия от $studentsStreak дней', streak.days >= studentsStreak, 'сейчас ${streak.days}',
          '/streak'),
    ];
    final proChecks = [
      CutoffCheck('${_fmt(GamificationService.cutoffPro)} очков',
          points >= GamificationService.cutoffPro, 'у тебя ${_fmt(points)}', '/streak'),
      CutoffCheck('Диплом · ступень 4', cert != null, cert != null ? 'есть' : 'ещё нет', '/certificate'),
      CutoffCheck('$proPlanTrades сделок по плану', planTrades >= proPlanTrades, '$planTrades из $proPlanTrades',
          '/practice'),
      CutoffCheck('Серия $proStreak дней', streak.days >= proStreak, 'сейчас ${streak.days}', '/streak'),
    ];

    var studentsAt = prefs.getString(studentsAtKey);
    var proAt = prefs.getString(proAtKey);
    final nowIso = DateTime.now().toIso8601String();
    if (studentsAt == null && studentsChecks.every((c) => c.done)) {
      studentsAt = nowIso;
      await prefs.setString(studentsAtKey, nowIso);
    }
    if (proAt == null && proChecks.every((c) => c.done)) {
      proAt = nowIso;
      await prefs.setString(proAtKey, nowIso);
    }

    return ClubStatus(
      points: points,
      weekPoints: week,
      streak: streak,
      publicId: id,
      displayName: prefs.getString(nameKey),
      students: studentsAt != null,
      pro: proAt != null,
      studentsChecks: studentsChecks,
      proChecks: proChecks,
    );
  }

  /// A freshly passed cutoff that the user hasn't celebrated yet.
  static Future<ClubChat?> pendingCelebration() async {
    final s = await status();
    final prefs = await SharedPreferences.getInstance();
    if (s.pro && prefs.getBool(proSeenKey) != true) return ClubChat.pro;
    if (s.students && prefs.getBool(studentsSeenKey) != true) return ClubChat.students;
    return null;
  }

  static Future<void> markCelebrated(ClubChat chat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(chat == ClubChat.pro ? proSeenKey : studentsSeenKey, true);
  }

  /// The ladder is public: no account needed, only the server.
  static bool get isLive => BackendService.isAvailable;

  /// Text the user sends to the club admin to get into a closed chat.
  static String application(ClubStatus s, ClubChat chat) {
    final name = chat == ClubChat.pro ? 'Чат профи' : 'Чат учеников';
    return 'Заявка в «$name» · ${s.shownName} · ${s.publicId} · ${_fmt(s.points)} очков · '
        'серия ${s.streak.days} дн. Проверь меня в ладере Trade Master.';
  }

  static Future<Map<String, dynamic>?> _upsert(ClubStatus s) async {
    final prefs = await SharedPreferences.getInstance();
    for (var attempt = 0; attempt < 3; attempt++) {
      final id = await publicId();
      final rows = await BackendService.client.rpc('ladder_upsert', params: {
        'p_public_id': id,
        'p_secret': await _secret(),
        'p_display_name': s.displayName ?? '',
        'p_points': s.points,
        'p_week_points': s.weekPoints,
        'p_streak': s.streak.days,
        'p_students': s.students,
        'p_pro': s.pro,
      });
      final row = Map<String, dynamic>.from((rows as List).first as Map);
      if (row['status'] != 'id_taken') return row;
      await prefs.remove(publicIdKey);
    }
    return null;
  }

  static Future<LadderResult> ladder({required bool week}) async {
    var s = await status();
    LadderRow me(ClubStatus st) => LadderRow(
          rank: 0,
          name: st.shownName,
          publicId: st.publicId,
          points: week ? st.weekPoints : st.points,
          isMe: true,
        );
    const keep = 'Твои очки считаются на устройстве и не пропадут.';
    if (!isLive) {
      return LadderResult(rows: [me(s)], live: false, note: 'Общий рейтинг недоступен в этой сборке. $keep');
    }
    try {
      final before = s.publicId;
      final up = await _upsert(s).timeout(_timeout);
      if (up == null || up['status'] != 'ok') {
        return LadderResult(rows: [me(s)], live: false, note: 'Сервер рейтинга не принял запись. $keep');
      }
      if (await publicId() != before) s = await status();
      final rows = await BackendService.client.rpc('ladder_top', params: {
        'p_period': week ? 'week' : 'all',
        'p_limit': 100,
      }).timeout(_timeout);
      final list = (rows as List)
          .map((e) => LadderRow.fromMap(Map<String, dynamic>.from(e as Map), s.publicId))
          .toList();
      final rank = (week ? up['rank_week'] : up['rank_all']) as num?;
      return LadderResult(
        rows: list,
        live: true,
        myRank: rank?.toInt(),
        serverPoints: (up['points'] as num?)?.toInt(),
      );
    } on PostgrestException catch (e) {
      final missing = e.code == 'PGRST202' || e.code == '42883' || e.code == '42P01';
      return LadderResult(
        rows: [me(s)],
        live: false,
        note: missing
            ? 'Общий рейтинг включается — скоро тут появятся все ученики. $keep'
            : 'Общий рейтинг сейчас не загрузился — потяни экран вниз. $keep',
      );
    } catch (_) {
      return LadderResult(
        rows: [me(s)],
        live: false,
        note: 'Общий рейтинг сейчас недоступен — загляни позже или потяни экран вниз. $keep',
      );
    }
  }

  static const _timeout = Duration(seconds: 8);

  static Future<List<LadderRow>> members(ClubChat chat) async {
    if (!isLive) return const [];
    try {
      final id = await publicId();
      final rows = await BackendService.client.rpc('club_chat_members', params: {
        'p_chat': chat == ClubChat.pro ? 'pro' : 'students',
        'p_public_id': id,
        'p_secret': await _secret(),
      }).timeout(_timeout);
      return (rows as List)
          .map((e) => LadderRow.fromMap(Map<String, dynamic>.from(e as Map), id))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  static String _fmt(int v) {
    final s = v.toString();
    if (s.length <= 3) return s;
    return '${s.substring(0, s.length - 3)} ${s.substring(s.length - 3)}';
  }

  static String fmt(int v) => _fmt(v);
}
