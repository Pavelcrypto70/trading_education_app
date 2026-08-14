import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';
import 'backend_service.dart';
import 'premium_service.dart';

/// Cloud sync for progress data. Premium is never written from client progress blob.
class SyncService {
  SyncService._();

  static Timer? _debounce;
  static const _syncKeys = [
    'completedLessons',
    'quizHistory',
    'streak',
    'lastActive',
    'virtualBalance',
    'position',
    'positionSize',
    'entryPrice',
    'priceHistory',
    'currentPrice',
    'dailyChallengeDate',
    'dailyChallengeDone',
    'dailyChallengeScore',
    'flashcardsReviewed',
    'dailyActivity',
    'moduleQuizScores',
    'homeworkSubmitCounts',
    'certificateIssued',
    'totalXp',
    'userLevel',
    'tradeJournalEntries',
    'spacedReviewQueue',
    'referralMyCode',
    'referralRedeemedCode',
    'referralAllRedemptions',
    'referralXpAwardedCount',
    'demoMarketCandles',
    'demoMarketPrice',
    'demoMarketVersion',
    'onboardingCompleted',
    'userGoal',
  ];

  static Future<void> pullAndMerge() async {
    if (!BackendService.isAvailable || !AuthService.isSignedIn) return;

    final userId = AuthService.currentUser!.id;
    final prefs = await SharedPreferences.getInstance();

    try {
      final row = await BackendService.client
          .from('user_progress')
          .select('data, updated_at')
          .eq('user_id', userId)
          .maybeSingle();

      if (row != null && row['data'] is Map) {
        final remote = Map<String, dynamic>.from(row['data'] as Map);
        await _mergeRemoteIntoLocal(prefs, remote);
      }

      await PremiumService.refreshFromServer();
      await pushNow();
    } catch (_) {
      // Offline — local data remains.
    }
  }

  static void schedulePush() {
    if (!BackendService.isAvailable || !AuthService.isSignedIn) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), pushNow);
  }

  static Future<void> pushNow() async {
    if (!BackendService.isAvailable || !AuthService.isSignedIn) return;

    final userId = AuthService.currentUser!.id;
    final prefs = await SharedPreferences.getInstance();
    final payload = <String, dynamic>{};

    for (final key in _syncKeys) {
      if (!prefs.containsKey(key)) continue;
      final value = prefs.get(key);
      if (value is List<String>) {
        payload[key] = value;
      } else if (value is String) {
        payload[key] = value;
      } else if (value is int) {
        payload[key] = value;
      } else if (value is double) {
        payload[key] = value;
      } else if (value is bool) {
        payload[key] = value;
      }
    }

    try {
      await BackendService.client.from('user_progress').upsert({
        'user_id': userId,
        'data': payload,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      // Retry on next mutation.
    }
  }

  static Future<void> _mergeRemoteIntoLocal(
    SharedPreferences prefs,
    Map<String, dynamic> remote,
  ) async {
    // Completed lessons: union
    final remoteCompleted = _asStringList(remote['completedLessons']);
    if (remoteCompleted.isNotEmpty) {
      final local = prefs.getStringList('completedLessons') ?? [];
      final merged = {...local, ...remoteCompleted}.toList();
      await prefs.setStringList('completedLessons', merged);
    }

    // Streak: max
    final remoteStreak = remote['streak'] as int?;
    final localStreak = prefs.getInt('streak') ?? 0;
    if (remoteStreak != null && remoteStreak > localStreak) {
      await prefs.setInt('streak', remoteStreak);
    }

    // XP: max
    final remoteXp = remote['totalXp'] as int?;
    final localXp = prefs.getInt('totalXp') ?? 0;
    if (remoteXp != null && remoteXp > localXp) {
      await prefs.setInt('totalXp', remoteXp);
      await prefs.setInt('userLevel', remote['userLevel'] as int? ?? 1);
    }

    // Quiz history: keep longer list
    final remoteHistory = _asStringList(remote['quizHistory']);
    final localHistory = prefs.getStringList('quizHistory') ?? [];
    if (remoteHistory.length > localHistory.length) {
      await prefs.setStringList('quizHistory', remoteHistory);
    }

    // Scalar fields: prefer remote if local empty/default
    await _mergeString(prefs, 'lastActive', remote['lastActive']);
    await _mergeString(prefs, 'dailyChallengeDate', remote['dailyChallengeDate']);
    await _mergeString(prefs, 'dailyActivity', remote['dailyActivity']);
    await _mergeString(prefs, 'moduleQuizScores', remote['moduleQuizScores']);
    await _mergeString(prefs, 'homeworkSubmitCounts', remote['homeworkSubmitCounts']);
    await _mergeString(prefs, 'certificateIssued', remote['certificateIssued']);
    await _mergeString(prefs, 'userGoal', remote['userGoal']);
    await _mergeString(prefs, 'tradeJournalEntries', remote['tradeJournalEntries']);
    await _mergeString(prefs, 'spacedReviewQueue', remote['spacedReviewQueue']);

    await _mergeDouble(prefs, 'virtualBalance', remote['virtualBalance']);
    await _mergeString(prefs, 'position', remote['position']);
    await _mergeDouble(prefs, 'positionSize', remote['positionSize']);
    await _mergeDouble(prefs, 'entryPrice', remote['entryPrice']);
    await _mergeDouble(prefs, 'currentPrice', remote['currentPrice']);
    await _mergeStringList(prefs, 'priceHistory', remote['priceHistory']);
    await _mergeStringList(prefs, 'demoMarketCandles', remote['demoMarketCandles']);

    if (remote['onboardingCompleted'] == true) {
      await prefs.setBool('onboardingCompleted', true);
    }
  }

  static List<String> _asStringList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    return [];
  }

  static Future<void> _mergeString(
    SharedPreferences prefs,
    String key,
    dynamic remote,
  ) async {
    if (remote is String && remote.isNotEmpty) {
      final local = prefs.getString(key);
      if (local == null || local.isEmpty) {
        await prefs.setString(key, remote);
      }
    }
  }

  static Future<void> _mergeDouble(
    SharedPreferences prefs,
    String key,
    dynamic remote,
  ) async {
    if (remote is num) {
      final local = prefs.getDouble(key);
      if (local == null) await prefs.setDouble(key, remote.toDouble());
    }
  }

  static Future<void> _mergeStringList(
    SharedPreferences prefs,
    String key,
    dynamic remote,
  ) async {
    final list = _asStringList(remote);
    if (list.isNotEmpty) {
      final local = prefs.getStringList(key) ?? [];
      if (list.length > local.length) {
        await prefs.setStringList(key, list);
      }
    }
  }
}
