import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'config/desk_key_config.dart';
import 'models/lesson.dart';
import 'models/quiz_question.dart';
import 'screens/daily_challenge_screen.dart';
import 'screens/desk_key_screen.dart';
import 'screens/flashcards_screen.dart';
import 'screens/path_hub_screen.dart';
import 'screens/home_shell.dart';
import 'screens/journal_screen.dart';
import 'screens/learning_screen.dart';
import 'screens/learning_path_screen.dart';
import 'screens/module_quiz_screen.dart';
import 'screens/lesson_screen.dart';
import 'screens/market_screen.dart';
import 'screens/certificate_screen.dart';
import 'screens/homework_screen.dart';
import 'screens/glossary_screen.dart';
import 'screens/syllabus_screen.dart';
import 'screens/onboarding_goal_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/owner_unlock_screen.dart';
import 'screens/placement_screen.dart';
import 'screens/soft_ref_screen.dart';
import 'screens/club_screen.dart';
import 'screens/cutoff_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/streak_screen.dart';
import 'services/club_service.dart';
import 'screens/quiz_play_screen.dart';
import 'screens/quiz_result_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/trading_screen.dart';
import 'services/onboarding_service.dart';
import 'services/quiz_session.dart';
import 'journey/journey_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: _redirect,
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/onboarding/goal',
      builder: (context, state) => const OnboardingGoalScreen(),
    ),
    GoRoute(
      path: '/placement',
      builder: (context, state) => const PlacementScreen(),
    ),
    GoRoute(
      path: '/owner-unlock',
      redirect: (_, __) => DeskKeyConfig.ownerUnlockEnabled ? null : '/',
      builder: (context, state) => const OwnerUnlockScreen(),
    ),
    ...journeyRoutes,
    ShellRoute(
      builder: (context, state, child) => HomeShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PathHubScreen(),
          ),
        ),
        GoRoute(
          path: '/learning',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LearningScreen(),
          ),
        ),
        GoRoute(
          path: '/practice',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TradingScreen(),
          ),
        ),
        GoRoute(
          path: '/club',
          pageBuilder: (context, state) => NoTransitionPage(
            child: ClubScreen(
              key: ValueKey('club-${state.uri.queryParameters['tab']}'),
              initialTab: state.uri.queryParameters['tab'] == 'chats' ? 1 : 0,
            ),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: '/lesson/:id',
      builder: (context, state) {
        final lesson = state.extra as Lesson?;
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return LessonScreen(
          key: ValueKey('lesson-$id'),
          lesson: lesson,
          lessonId: id,
        );
      },
    ),
    GoRoute(
      path: '/journal/lesson',
      builder: (context, state) {
        final lessonId = int.tryParse(state.uri.queryParameters['lessonId'] ?? '');
        final title = state.uri.queryParameters['title'];
        return JournalScreen(
          prefillLessonId: lessonId,
          prefillLessonTitle: title != null ? Uri.decodeComponent(title) : null,
        );
      },
    ),
    GoRoute(
      path: '/market',
      builder: (context, state) => const MarketScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    // Legacy paywall URL — course is free; soft ref on web only.
    GoRoute(
      path: '/premium',
      redirect: (_, __) => DeskKeyConfig.enabled ? '/soft-ref' : '/learning',
    ),
    GoRoute(
      path: '/soft-ref',
      redirect: (_, __) => DeskKeyConfig.enabled ? null : '/learning',
      builder: (context, state) => const SoftRefScreen(),
    ),
    GoRoute(
      path: '/key',
      // Web: Tiger soft path. Store: no broker — stay on learning (course is free).
      redirect: (_, __) => DeskKeyConfig.enabled ? null : '/learning',
      builder: (context, state) => const DeskKeyScreen(),
    ),
    GoRoute(
      path: '/flashcards',
      builder: (context, state) => const FlashcardsScreen(),
    ),
    GoRoute(
      path: '/streak',
      builder: (context, state) => const StreakScreen(),
    ),
    GoRoute(
      path: '/cutoff/:chat',
      builder: (context, state) => CutoffScreen(
        chat: state.pathParameters['chat'] == 'pro' ? ClubChat.pro : ClubChat.students,
      ),
    ),
    GoRoute(
      path: '/daily-challenge',
      builder: (context, state) => const DailyChallengeScreen(),
    ),
    GoRoute(
      path: '/quiz-play',
      redirect: (_, state) {
        final extra = state.extra;
        if (extra is Map<String, dynamic> && extra['questions'] != null) return null;
        if (QuizSession.hasSession) return null;
        return '/quiz';
      },
      builder: (context, state) {
        final extra = state.extra is Map<String, dynamic>
            ? state.extra as Map<String, dynamic>
            : null;
        if (extra != null && extra['questions'] != null) {
          return QuizPlayScreen(
            title: extra['title'] as String,
            questions: extra['questions'] as List<QuizQuestion>,
            isDailyChallenge: extra['isDailyChallenge'] as bool? ?? false,
            moduleId: extra['moduleId'] as String?,
            passPercent: extra['passPercent'] as int?,
            isPlacement: extra['isPlacement'] as bool? ?? false,
            placementLessonIds: List<int>.from(extra['placementLessonIds'] as List? ?? const []),
          );
        }
        return QuizPlayScreen(
          title: QuizSession.title!,
          questions: QuizSession.questions!,
          isDailyChallenge: QuizSession.isDailyChallenge,
          moduleId: QuizSession.moduleId,
          passPercent: QuizSession.passPercent,
          isPlacement: QuizSession.isPlacement,
          placementLessonIds: QuizSession.placementLessonIds,
        );
      },
    ),
    GoRoute(
      path: '/syllabus',
      builder: (context, state) => const SyllabusScreen(),
    ),
    GoRoute(
      path: '/glossary',
      builder: (context, state) => const GlossaryScreen(),
    ),
    GoRoute(
      path: '/module-quiz',
      builder: (context, state) => const ModuleQuizScreen(),
    ),
    GoRoute(
      path: '/learning-path',
      builder: (context, state) => const LearningPathScreen(),
    ),
    GoRoute(
      path: '/certificate',
      builder: (context, state) => const CertificateScreen(),
    ),
    GoRoute(
      path: '/homework',
      builder: (context, state) {
        final lessonId = int.tryParse(state.uri.queryParameters['lessonId'] ?? '');
        return HomeworkScreen(initialLessonId: lessonId);
      },
    ),
    GoRoute(
      path: '/quiz-result',
      redirect: (_, state) => state.extra == null ? '/quiz' : null,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return QuizResultScreen(
          score: extra['score'] as int,
          total: extra['total'] as int,
          title: extra['title'] as String,
          isDailyChallenge: extra['isDailyChallenge'] as bool? ?? false,
          isPlacement: extra['isPlacement'] as bool? ?? false,
          reviewLessons: List<Map<String, dynamic>>.from(
            (extra['reviewLessons'] as List?)?.map((e) => Map<String, dynamic>.from(e as Map)) ??
                const [],
          ),
        );
      },
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final completed = await OnboardingService.isCompleted();
  final location = state.matchedLocation;
  final onOnboarding = location.startsWith('/onboarding');

  // Sign-in is reachable from the first screen («У меня уже есть аккаунт»).
  if (!completed && location == '/auth') return null;
  if (!completed && !onOnboarding) {
    return '/onboarding';
  }
  if (completed && onOnboarding) {
    return '/';
  }
  return null;
}
