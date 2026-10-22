import 'package:shared_preferences/shared_preferences.dart';

import '../utils/num_format.dart';
import 'locale_service.dart';

class StreakState {
  const StreakState({
    required this.days,
    required this.best,
    required this.freezes,
    required this.litToday,
    required this.week,
  });

  /// Current live streak (0 if it has burned out).
  final int days;
  final int best;
  final int freezes;
  final bool litToday;

  /// Last 7 days, oldest first: true = flame lit (or frozen).
  final List<bool> week;

  double get multiplier => StreakService.multiplierFor(days);
}

/// What happened when today's flame was lit.
class StreakEvent {
  const StreakEvent({required this.days, required this.freezeEarned, required this.freezesUsed});

  final int days;
  final bool freezeEarned;
  final int freezesUsed;

  String get message {
    final l10n = LocaleService.instance.strings;
    final parts = <String>[l10n.streakLitEvent(days)];
    if (freezesUsed > 0) parts.add(l10n.streakFreezeUsedPart);
    if (freezeEarned) parts.add(l10n.streakFreezeEarnedPart);
    final m = StreakService.multiplierFor(days);
    if (m > 1) parts.add(l10n.streakPointsMultPart(fmtNum(m, 1)));
    return parts.join(' · ');
  }
}

/// Daily flame: lit by 3 lesson steps, a quiz, journal entry or practice. Gives a
/// points multiplier, counts toward cutoffs, and earns freezes every 7 days.
class StreakService {
  static const _streakKey = 'streak';
  static const _lastActiveKey = 'lastActive';
  static const _bestKey = 'bestStreak';
  static const _freezesKey = 'streakFreezes';
  static const _litDaysKey = 'streakLitDays';

  static const maxFreezes = 2;

  static double multiplierFor(int days) {
    if (days >= 30) return 2.0;
    if (days >= 7) return 1.5;
    if (days >= 3) return 1.2;
    return 1.0;
  }

  static String _key(DateTime d) => '${d.year}-${d.month}-${d.day}';

  static DateTime? _parse(String? key) {
    if (key == null) return null;
    final p = key.split('-');
    if (p.length != 3) return null;
    final y = int.tryParse(p[0]), m = int.tryParse(p[1]), d = int.tryParse(p[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  /// The last lighting not yet shown to the user.
  static StreakEvent? _pending;

  static StreakEvent? takePending() {
    final e = _pending;
    _pending = null;
    return e;
  }

  /// Lights today's flame. Missed days are covered by freezes when available.
  /// Returns null if the flame was already lit today.
  static Future<StreakEvent?> light() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _today();
    final last = _parse(prefs.getString(_lastActiveKey));
    if (last != null && last == today) return null;

    var streak = prefs.getInt(_streakKey) ?? 0;
    var freezes = prefs.getInt(_freezesKey) ?? 0;
    final freezesBefore = freezes;
    var used = 0;
    final lit = (prefs.getStringList(_litDaysKey) ?? []).toSet();

    if (last == null) {
      streak = 1;
    } else {
      final missed = today.difference(last).inDays - 1;
      if (missed <= 0) {
        streak += 1;
      } else if (missed <= freezes) {
        freezes -= missed;
        used = missed;
        for (var i = 1; i <= missed; i++) {
          lit.add(_key(last.add(Duration(days: i))));
        }
        streak += missed + 1;
      } else {
        streak = 1;
      }
    }

    if (streak % 7 == 0 && freezes < maxFreezes) freezes += 1;
    lit.add(_key(today));
    final cutoff = today.subtract(const Duration(days: 40));
    lit.removeWhere((k) => (_parse(k) ?? today).isBefore(cutoff));

    final best = prefs.getInt(_bestKey) ?? 0;
    await prefs.setInt(_streakKey, streak);
    await prefs.setInt(_freezesKey, freezes);
    await prefs.setInt(_bestKey, streak > best ? streak : best);
    await prefs.setString(_lastActiveKey, _key(today));
    await prefs.setStringList(_litDaysKey, lit.toList());
    final event = StreakEvent(
      days: streak,
      freezeEarned: freezes > freezesBefore - used,
      freezesUsed: used,
    );
    _pending = event;
    return event;
  }

  static Future<StreakState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _today();
    final last = _parse(prefs.getString(_lastActiveKey));
    final stored = prefs.getInt(_streakKey) ?? 0;
    final freezes = prefs.getInt(_freezesKey) ?? 0;
    final lit = (prefs.getStringList(_litDaysKey) ?? []).toSet();
    if (last != null) lit.add(_key(last));

    var days = 0;
    if (last != null) {
      final missed = today.difference(last).inDays - 1;
      if (missed <= 0 || missed <= freezes) days = stored;
    }
    final best = prefs.getInt(_bestKey) ?? stored;
    return StreakState(
      days: days,
      best: best > days ? best : days,
      freezes: freezes,
      litToday: last == today,
      week: [
        for (var i = 6; i >= 0; i--) lit.contains(_key(today.subtract(Duration(days: i)))),
      ],
    );
  }

  static Future<int> currentDays() async => (await load()).days;
}
