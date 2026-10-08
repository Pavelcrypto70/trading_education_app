import 'package:go_router/go_router.dart';

import '../screens/journey/academy_intro_screen.dart';
import '../screens/journey/homework_review_screen.dart';
import '../screens/journey/homework_stage1_screen.dart';
import '../screens/journey/hub_language_screen.dart';
import '../screens/journey/key_web_screens.dart';
import '../screens/journey/module_test_result_screens.dart';
import '../screens/journey/path_stage1_screen.dart';
import '../screens/journey/placement_exam_intro_screen.dart';
import '../screens/journey/save_progress_screen.dart';
import '../screens/journey/stage1_gates_screen.dart';
import '../screens/journey/subscription_screen.dart';

/// Trade Master journey screens 03–22 (GoRouter paths).
List<RouteBase> get journeyRoutes => [
      GoRoute(
        path: '/placement',
        builder: (context, state) => const PlacementExamIntroScreen(),
      ),
      GoRoute(
        path: '/save-progress',
        builder: (context, state) => const SaveProgressScreen(),
      ),
      GoRoute(
        path: '/path',
        builder: (context, state) => const PathStage1Screen(),
      ),
      GoRoute(
        path: '/hub-language',
        builder: (context, state) => const HubLanguageScreen(),
      ),
      GoRoute(
        path: '/module-test',
        builder: (context, state) => const ModuleTestScreen(),
      ),
      GoRoute(
        path: '/module-test/result',
        builder: (context, state) => const ModuleTestResultScreen(),
      ),
      GoRoute(
        path: '/gates',
        builder: (context, state) => const Stage1GatesScreen(),
      ),
      GoRoute(
        path: '/academy',
        builder: (context, state) => const AcademyJoinScreen(),
      ),
      GoRoute(
        path: '/academy/intro',
        builder: (context, state) => const AcademyIntroScreen(),
      ),
      GoRoute(
        path: '/homework/s1',
        builder: (context, state) => const HomeworkStage1Screen(),
      ),
      GoRoute(
        path: '/homework/review',
        builder: (context, state) => const HomeworkReviewScreen(),
      ),
      GoRoute(
        path: '/subscribe',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: '/key',
        builder: (context, state) => const KeyLandingScreen(),
      ),
      GoRoute(
        path: '/key/register',
        builder: (context, state) => const KeyRegisterScreen(),
      ),
      GoRoute(
        path: '/key/not-found',
        builder: (context, state) => const KeyNotFoundScreen(),
      ),
      GoRoute(
        path: '/key/active',
        builder: (context, state) => const KeyActiveScreen(),
      ),
    ];

/// Same paths as a map (name → path) for deep links and tests.
const Map<String, String> journeyRoutePaths = {
  'placement': '/placement',
  'saveProgress': '/save-progress',
  'path': '/path',
  'hubLanguage': '/hub-language',
  'moduleTest': '/module-test',
  'moduleTestResult': '/module-test/result',
  'gates': '/gates',
  'academy': '/academy',
  'academyIntro': '/academy/intro',
  'homeworkS1': '/homework/s1',
  'homeworkReview': '/homework/review',
  'subscribe': '/subscribe',
  'key': '/key',
  'keyRegister': '/key/register',
  'keyNotFound': '/key/not-found',
  'keyActive': '/key/active',
};
