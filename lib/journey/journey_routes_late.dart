import 'package:go_router/go_router.dart';

import '../screens/journey/day_report_screen.dart';
import '../screens/journey/desk_trader_home_screen.dart';
import '../screens/journey/diploma_screen.dart';
import '../screens/journey/exam_result_screen.dart';
import '../screens/journey/first30_chat_screen.dart';
import '../screens/journey/first_real_trade_screen.dart';
import '../screens/journey/graduate_screen.dart';
import '../screens/journey/homework_queue_screen.dart';
import '../screens/journey/hub_admit_screen.dart';
import '../screens/journey/journal_list_screen.dart';
import '../screens/journey/markup_grade_screen.dart';
import '../screens/journey/markup_lesson_screen.dart';
import '../screens/journey/paper_week_screen.dart';
import '../screens/journey/path_stage2_screen.dart';
import '../screens/journey/practice_counter_screen.dart';
import '../screens/journey/readiness_checklist_screen.dart';
import '../screens/journey/readiness_exam_screen.dart';
import '../screens/journey/real_account_checklist_screen.dart';
import '../screens/journey/real_account_lesson_screen.dart';
import '../screens/journey/risk_confirm_screen.dart';
import '../screens/journey/stop_day_screen.dart';
import '../screens/journey/thirty_today_screen.dart';
import '../screens/journey/trade_open_screen.dart';
import '../screens/journey/trade_plan_screen.dart';
import '../screens/journey/trade_rejected_screen.dart';
import '../screens/journey/trade_review_screen.dart';
import '../screens/journey/weekly_report_screen.dart';

/// GoRoutes for Trade Master journey screens 23–52 (outside tab shell).
List<RouteBase> get journeyLateRoutes => [
      GoRoute(path: '/path/2', builder: (_, __) => const PathStage2Screen()),
      GoRoute(path: '/markup', builder: (_, __) => const MarkupLessonScreen()),
      GoRoute(path: '/markup/grade', builder: (_, __) => const MarkupGradeScreen()),
      GoRoute(path: '/weekly-report', builder: (_, __) => const WeeklyReportScreen()),
      GoRoute(path: '/practice/gates', builder: (_, __) => const PracticeCounterScreen()),
      GoRoute(path: '/trade/plan', builder: (_, __) => const TradePlanScreen()),
      GoRoute(path: '/trade/open', builder: (_, __) => const TradeOpenScreen()),
      GoRoute(path: '/trade/review', builder: (_, __) => const TradeReviewScreen()),
      GoRoute(path: '/trade/rejected', builder: (_, __) => const TradeRejectedScreen()),
      GoRoute(
        path: '/journal',
        builder: (_, __) => const JournalListScreen(),
      ),
      GoRoute(path: '/exam', builder: (_, __) => const ReadinessExamScreen()),
      GoRoute(path: '/exam/result', builder: (_, __) => const ExamResultScreen()),
      GoRoute(path: '/checklist', builder: (_, __) => const ReadinessChecklistScreen()),
      GoRoute(path: '/diploma', builder: (_, __) => const DiplomaScreen()),
      GoRoute(path: '/hub-admit', builder: (_, __) => const HubAdmitScreen()),
      GoRoute(path: '/real/lesson', builder: (_, __) => const RealAccountLessonScreen()),
      GoRoute(path: '/real/checklist', builder: (_, __) => const RealAccountChecklistScreen()),
      GoRoute(path: '/real/risk', builder: (_, __) => const RiskConfirmScreen()),
      GoRoute(path: '/real/first-trade', builder: (_, __) => const FirstRealTradeScreen()),
      GoRoute(path: '/30/today', builder: (_, __) => const ThirtyTodayScreen()),
      GoRoute(path: '/30/report', builder: (_, __) => const DayReportScreen()),
      GoRoute(path: '/30/stop', builder: (_, __) => const StopDayScreen()),
      GoRoute(path: '/30/paper', builder: (_, __) => const PaperWeekScreen()),
      GoRoute(path: '/30/chat', builder: (_, __) => const First30ChatScreen()),
      GoRoute(path: '/30/done', builder: (_, __) => const GraduateScreen()),
      GoRoute(path: '/desk', builder: (_, __) => const DeskTraderHomeScreen()),
      GoRoute(path: '/desk/review', builder: (_, __) => const HomeworkQueueScreen()),
    ];
