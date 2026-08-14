import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../data/lessons_repository.dart';
import '../models/lesson.dart';
import '../services/gamification_service.dart';
import '../services/locale_service.dart';
import '../services/onboarding_service.dart';
import '../services/progress_service.dart';
import '../widgets/community_banner.dart';
import '../services/program_service.dart';
import '../services/referral_service.dart';
import '../theme.dart';



class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});



  @override

  State<HomeScreen> createState() => _HomeScreenState();

}



class _HomeScreenState extends State<HomeScreen> {

  int _completed = 0;

  int _totalLessons = 47;

  int _streak = 0;

  bool _dailyDone = false;

  int? _dailyScore;

  String? _goal;

  Lesson? _continueLesson;
  bool _loading = true;
  int _xp = 0;
  int _level = 1;
  int _programDay = 1;
  bool _programOnTrack = true;



  @override

  void initState() {

    super.initState();

    _load();

  }



  Future<void> _load() async {

    final completed = await ProgressService.getCompletedCount();

    final streak = await ProgressService.getStreak();

    final dailyDone = await ProgressService.isDailyChallengeDone();

    final dailyScore = await ProgressService.getDailyChallengeScore();

    final goal = await OnboardingService.getGoal();
    await ReferralService.syncInviteRewards();
    final lessons = await LessonsRepository().loadLessons();
    final completedSet = await ProgressService.getCompletedLessons();
    final xp = await GamificationService.getXp();
    final level = await GamificationService.getLevel();
    final programDay = await ProgramService.getCurrentDay();
    final onTrack = ProgramService.isOnTrack(completed, programDay, lessons.length);



    Lesson? next;

    for (final lesson in lessons) {

      if (!completedSet.contains(lesson.id)) {

        next = lesson;

        break;

      }

    }



    if (!mounted) return;

    setState(() {

      _completed = completed;

      _totalLessons = lessons.length;

      _streak = streak;

      _dailyDone = dailyDone;

      _dailyScore = dailyScore;

      _goal = goal;

      _continueLesson = next;
      _xp = xp;
      _level = level;
      _programDay = programDay;
      _programOnTrack = onTrack;
      _loading = false;

    });

  }



  int get _progressPercent =>

      _totalLessons == 0 ? 0 : ((_completed / _totalLessons) * 100).round();



  String _goalLabel(String? goal) {

    final l10n = LocaleService.instance.strings;

    switch (goal) {

      case 'learn_trading':

        return l10n.learningFromScratch;

      case 'practice_demo':

        return l10n.demoTradingFocus;

      case 'pass_quiz':

        return l10n.knowledgeTesting;

      case 'build_discipline':

        return l10n.buildingDiscipline;

      default:

        return l10n.yourTradingJourney;

    }

  }



  Future<void> _shareApp() async {
    final l10n = context.l10n;
    final text = await ReferralService.buildShareMessage(l10n.shareMessage);
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.linkCopied), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {

    final l10n = context.l10n;



    if (_loading) {

      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    }



    return Scaffold(

      body: SafeArea(

        child: RefreshIndicator(

          onRefresh: _load,

          child: SingleChildScrollView(

            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Row(

                  children: [

                    Container(

                      width: 48,

                      height: 48,

                      decoration: BoxDecoration(

                        color: AppTheme.gold.withValues(alpha: 0.15),

                        borderRadius: BorderRadius.circular(14),

                        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.3)),

                      ),

                      child: const Icon(Icons.trending_up, color: AppTheme.gold),

                    ),

                    const SizedBox(width: 12),

                    Expanded(

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Text(

                            l10n.appName,

                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),

                          ),

                          Text(

                            _goalLabel(_goal),

                            style: const TextStyle(color: Colors.white54, fontSize: 13),

                          ),

                        ],

                      ),

                    ),

                    IconButton(

                      onPressed: () => context.push('/premium'),

                      icon: const Icon(Icons.workspace_premium_outlined, color: AppTheme.gold),

                    ),

                  ],

                ),

                const SizedBox(height: 16),

                const CommunityBanner(),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        title: l10n.homeworkTitle,
                        subtitle: l10n.homeworkHomeSubtitle,
                        icon: Icons.assignment_outlined,
                        color: AppTheme.accentCommunity,
                        onTap: () => context.push('/homework'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        title: l10n.certificateTitle,
                        subtitle: l10n.certificateHomeSubtitle,
                        icon: Icons.verified_outlined,
                        color: AppTheme.gold,
                        onTap: () => context.push('/certificate'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _ProgramDayCard(
                  day: _programDay,
                  completed: _completed,
                  total: _totalLessons,
                  onTrack: _programOnTrack,
                ),

                const SizedBox(height: 16),

                Container(

                  width: double.infinity,

                  padding: const EdgeInsets.all(22),

                  decoration: AppTheme.heroGradient(),

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(

                        l10n.percentComplete(_progressPercent),

                        style: const TextStyle(

                          color: AppTheme.gold,

                          fontWeight: FontWeight.w700,

                        ),

                      ),

                      const SizedBox(height: 8),

                      Text(

                        l10n.keepBuildingEdge,

                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),

                      ),

                      const SizedBox(height: 10),

                      Text(

                        l10n.lessonsCompleted(_completed, _totalLessons),

                        style: const TextStyle(color: Colors.white70),

                      ),

                      const SizedBox(height: 16),

                      ClipRRect(

                        borderRadius: BorderRadius.circular(8),

                        child: LinearProgressIndicator(

                          value: _totalLessons == 0 ? 0 : _completed / _totalLessons,

                          minHeight: 8,

                          backgroundColor: Colors.white12,

                          color: AppTheme.gold,

                        ),

                      ),

                    ],

                  ),

                ),

                const SizedBox(height: 12),

                _XpCard(
                  xp: _xp,
                  level: _level,
                  lang: LocaleService.instance.languageCode,
                ),

                const SizedBox(height: 12),

                _ShareCard(onTap: _shareApp),

                const SizedBox(height: 16),

                Row(

                  children: [

                    Expanded(

                      child: _StatTile(

                        label: l10n.streak,

                        value: '$_streak ${l10n.days}',

                        icon: Icons.local_fire_department,

                      ),

                    ),

                    const SizedBox(width: 12),

                    Expanded(

                      child: _StatTile(

                        label: l10n.lessons,

                        value: '$_completed',

                        icon: Icons.menu_book,

                      ),

                    ),

                  ],

                ),

                const SizedBox(height: 20),

                if (_continueLesson != null) ...[

                  Text(l10n.continueLearning, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),

                  const SizedBox(height: 12),

                  _ContinueCard(

                    lesson: _continueLesson!,

                    onTap: () => context.push('/lesson/${_continueLesson!.id}', extra: _continueLesson),

                  ),

                  const SizedBox(height: 20),

                ],

                Text(l10n.interactiveTraining, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        title: l10n.dailyChallenge,
                        subtitle: _dailyDone
                            ? l10n.dailyChallengeDone(_dailyScore ?? 0)
                            : l10n.dailyChallengeNew,
                        icon: Icons.bolt,
                        color: AppTheme.accentQuizzes,
                        badge: _dailyDone ? l10n.done : l10n.newBadge,
                        onTap: () => context.push('/daily-challenge'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        title: l10n.flashcards,
                        subtitle: l10n.flashcardsSubtitle,
                        icon: Icons.style,
                        color: AppTheme.accent,
                        onTap: () => context.push('/flashcards'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _ActionCard(
                  title: l10n.paperTrading,
                  subtitle: l10n.paperTradingSubtitle,
                  icon: Icons.candlestick_chart,
                  color: AppTheme.accentLessons,
                  onTap: () => context.go('/practice'),
                ),

                const SizedBox(height: 20),

                Text(l10n.explore, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),

                const SizedBox(height: 12),

                _ActivityChart(),

                const SizedBox(height: 12),

                _ActionCard(
                  title: l10n.marketConcepts,
                  subtitle: l10n.marketConceptsSubtitle,
                  icon: Icons.show_chart,
                  color: AppTheme.accentPath,
                  onTap: () => context.push('/market'),
                ),

              ],

            ),

          ),

        ),

      ),

    );

  }

}



class _StatTile extends StatelessWidget {

  final String label;

  final String value;

  final IconData icon;



  const _StatTile({required this.label, required this.value, required this.icon});



  @override

  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(16),

      decoration: AppTheme.cardDecoration(),

      child: Row(

        children: [

          Icon(icon, color: AppTheme.gold, size: 22),

          const SizedBox(width: 10),

          Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),

              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),

            ],

          ),

        ],

      ),

    );

  }

}



class _ContinueCard extends StatelessWidget {

  final Lesson lesson;

  final VoidCallback onTap;



  const _ContinueCard({required this.lesson, required this.onTap});



  @override

  Widget build(BuildContext context) {

    final l10n = context.l10n;



    return InkWell(

      borderRadius: BorderRadius.circular(18),

      onTap: onTap,

      child: Container(

        padding: const EdgeInsets.all(18),

        decoration: AppTheme.accentCardDecoration(
          AppTheme.gold,
          color: AppTheme.gold.withValues(alpha: 0.08),
        ),

        child: Row(

          children: [

            Container(

              width: 44,

              height: 44,

              decoration: BoxDecoration(

                color: AppTheme.gold.withValues(alpha: 0.2),

                borderRadius: BorderRadius.circular(12),

              ),

              child: Center(

                child: Text('${lesson.id}', style: const TextStyle(fontWeight: FontWeight.w800)),

              ),

            ),

            const SizedBox(width: 14),

            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w700)),

                  Text(l10n.moduleName(lesson.module), style: const TextStyle(color: Colors.white54, fontSize: 13)),

                ],

              ),

            ),

            const Icon(Icons.play_arrow_rounded, color: AppTheme.gold, size: 32),

          ],

        ),

      ),

    );

  }

}



class _ActionCard extends StatelessWidget {

  final String title;

  final String subtitle;

  final IconData icon;

  final Color color;

  final String? badge;

  final VoidCallback onTap;



  const _ActionCard({

    required this.title,

    required this.subtitle,

    required this.icon,

    required this.color,

    this.badge,

    required this.onTap,

  });



  @override

  Widget build(BuildContext context) {

    return InkWell(

      borderRadius: BorderRadius.circular(18),

      onTap: onTap,

      child: Container(

        padding: const EdgeInsets.all(14),

        decoration: AppTheme.accentCardDecoration(color),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Row(

              children: [

                Container(

                  width: 40,

                  height: 40,

                  decoration: BoxDecoration(

                    color: color.withValues(alpha: 0.15),

                    borderRadius: BorderRadius.circular(12),

                  ),

                  child: Icon(icon, color: color, size: 22),

                ),

                const Spacer(),

                if (badge != null)

                  Container(

                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),

                    decoration: BoxDecoration(

                      color: color.withValues(alpha: 0.2),

                      borderRadius: BorderRadius.circular(999),

                      border: Border.all(color: color.withValues(alpha: 0.35)),

                    ),

                    child: Text(

                      badge!,

                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),

                    ),

                  ),

              ],

            ),

            const SizedBox(height: 12),

            Text(

              title,

              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),

              maxLines: 2,

              overflow: TextOverflow.ellipsis,

            ),

            const SizedBox(height: 4),

            Text(

              subtitle,

              style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.3),

              maxLines: 2,

              overflow: TextOverflow.ellipsis,

            ),

          ],

        ),

      ),

    );

  }

}



class _ActivityChart extends StatefulWidget {
  @override
  State<_ActivityChart> createState() => _ActivityChartState();
}

class _ActivityChartState extends State<_ActivityChart> {
  List<int> _data = const [0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ProgressService.getWeeklyActivity();
    if (!mounted) return;
    setState(() => _data = data);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final maxY = (_data.isEmpty ? 1 : _data.reduce((a, b) => a > b ? a : b)).toDouble();
    final chartMax = maxY < 1 ? 4.0 : maxY + 1;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.accentCardDecoration(AppTheme.gold),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.learningActivity, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(l10n.weeklyMomentum, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: chartMax,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      _data.length,
                      (i) => FlSpot(i.toDouble(), _data[i].toDouble()),
                    ),
                    isCurved: true,
                    barWidth: 3,
                    color: AppTheme.gold,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.gold.withValues(alpha: 0.25),
                          AppTheme.gold.withValues(alpha: 0.02),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramDayCard extends StatelessWidget {
  final int day;
  final int completed;
  final int total;
  final bool onTrack;

  const _ProgramDayCard({
    required this.day,
    required this.completed,
    required this.total,
    required this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final expected = ProgramService.expectedLessonsByDay(day, total);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.accentCardDecoration(
        onTrack ? AppTheme.accentLessons : Colors.orangeAccent,
        color: onTrack ? Colors.greenAccent.withValues(alpha: 0.06) : Colors.orangeAccent.withValues(alpha: 0.06),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(onTrack ? Icons.flag : Icons.flag_outlined,
                  color: onTrack ? Colors.greenAccent : Colors.orangeAccent, size: 22),
              const SizedBox(width: 8),
              Text(l10n.programDayTitle(day, ProgramService.programDays),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.programDaySubtitle(completed, expected, total),
            style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _XpCard extends StatelessWidget {
  final int xp;
  final int level;
  final String lang;
  const _XpCard({required this.xp, required this.level, required this.lang});
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final progress = GamificationService.xpProgressInLevel(xp);
    final needed = GamificationService.xpNeededForNextLevel(xp);
    final title = GamificationService.levelTitle(level, lang);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.accentCardDecoration(AppTheme.gold),
      child: Row(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.gold.withValues(alpha: 0.3), AppTheme.gold.withValues(alpha: 0.1)]),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(child: Text('$level', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppTheme.gold))),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$title · ${l10n.level} $level', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: needed == 0 ? 0 : progress / needed, minHeight: 6, backgroundColor: Colors.white12, color: AppTheme.gold),
          ),
          const SizedBox(height: 4),
          Text(l10n.levelProgress(progress, needed), style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ])),
      ]),
    );
  }
}

class _ShareCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ShareCard({required this.onTap});
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: AppTheme.accent.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.accent.withValues(alpha: 0.25))),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.share_rounded, color: AppTheme.accent),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.shareApp, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(l10n.shareMessage, style: const TextStyle(color: Colors.white54, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
            ])),
            const Icon(Icons.copy, color: Colors.white38, size: 18),
          ]),
        ),
      ),
    );
  }
}
