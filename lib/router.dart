import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/lesson.dart';
import 'models/quiz_question.dart';
import 'screens/daily_challenge_screen.dart';
import 'screens/flashcards_screen.dart';
import 'screens/home_screen.dart';
import 'screens/home_shell.dart';
import 'screens/journal_screen.dart';
import 'screens/learning_screen.dart';
import 'screens/learning_path_screen.dart';
import 'screens/module_quiz_screen.dart';
import 'screens/lesson_screen.dart';
import 'screens/market_screen.dart';
import 'screens/certificate_screen.dart';
import 'screens/glossary_screen.dart';
import 'screens/syllabus_screen.dart';
import 'screens/onboarding_goal_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/premium_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/quiz_play_screen.dart';
import 'screens/quiz_result_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/trading_screen.dart';
import 'services/onboarding_service.dart';

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
    ShellRoute(
      builder: (context, state, child) => HomeShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/learning',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LearningScreen(),
          ),
        ),
        GoRoute(
          path: '/quiz',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: QuizScreen(),
          ),
        ),
        GoRoute(
          path: '/practice',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TradingScreen(),
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
      path: '/journal',
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
      path: '/premium',
      builder: (context, state) => const PremiumScreen(),
    ),
    GoRoute(
      path: '/flashcards',
      builder: (context, state) => const FlashcardsScreen(),
    ),
    GoRoute(
      path: '/daily-challenge',
      builder: (context, state) => const DailyChallengeScreen(),
    ),
    GoRoute(
      path: '/quiz-play',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return QuizPlayScreen(
          title: extra['title'] as String,
          questions: extra['questions'] as List<QuizQuestion>,
          isDailyChallenge: extra['isDailyChallenge'] as bool? ?? false,
          moduleId: extra['moduleId'] as String?,
          passPercent: extra['passPercent'] as int?,
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
      path: '/quiz-result',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return QuizResultScreen(
          score: extra['score'] as int,
          total: extra['total'] as int,
          title: extra['title'] as String,
          isDailyChallenge: extra['isDailyChallenge'] as bool? ?? false,
        );
      },
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final completed = await OnboardingService.isCompleted();
  final location = state.matchedLocation;
  final onOnboarding = location.startsWith('/onboarding');

  if (!completed && !onOnboarding) {
    return '/onboarding';
  }
  if (completed && onOnboarding) {
    return '/';
  }
  return null;
}
