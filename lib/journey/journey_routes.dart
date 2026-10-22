import 'package:go_router/go_router.dart';

import '../screens/journal_screen.dart';
import '../screens/stage_soon_screen.dart';

/// Old journey links (Telegram posts, bookmarks) lead to the live screens.
/// Stages 5–6 have no live flow yet and show an honest "opens after diploma" page.
const _redirects = <String, String>{
  // /placement is a real screen (module-1 diagnostic for «пробовал и потерял»).
  '/save-progress': '/auth',
  '/path': '/learning',
  '/path/2': '/learning',
  '/hub-language': '/glossary',
  '/module-test': '/module-quiz',
  '/module-test/result': '/module-quiz',
  '/gates': '/club?tab=chats',
  '/academy': '/club?tab=chats',
  '/academy/intro': '/club?tab=chats',
  '/hub-admit': '/club?tab=chats',
  '/homework/s1': '/homework',
  '/homework/review': '/homework',
  '/markup': '/homework',
  '/markup/grade': '/homework',
  '/subscribe': '/learning',
  // /key is DeskKeyScreen on web (soft Tiger path), not a paywall.
  '/key/register': '/key',
  '/key/not-found': '/key',
  '/key/active': '/key',
  '/weekly-report': '/streak',
  '/practice/gates': '/practice',
  '/trade/plan': '/practice',
  '/trade/open': '/practice',
  '/trade/review': '/practice',
  '/trade/rejected': '/practice',
  '/exam': '/certificate',
  '/exam/result': '/certificate',
  '/checklist': '/certificate',
  '/diploma': '/certificate',
};

const _stage5 = ['/real/lesson', '/real/checklist', '/real/risk', '/real/first-trade'];
const _stage6 = [
  '/30/today', '/30/report', '/30/stop', '/30/paper', '/30/chat', '/30/done', '/desk', '/desk/review',
];

List<RouteBase> get journeyRoutes => [
      for (final e in _redirects.entries) GoRoute(path: e.key, redirect: (_, __) => e.value),
      GoRoute(path: '/journal', builder: (_, __) => const JournalScreen()),
      GoRoute(path: '/stage/:n', builder: (_, state) => StageSoonScreen(stage: int.tryParse(state.pathParameters['n'] ?? '') ?? 5)),
      for (final p in _stage5) GoRoute(path: p, redirect: (_, __) => '/stage/5'),
      for (final p in _stage6) GoRoute(path: p, redirect: (_, __) => '/stage/6'),
    ];
