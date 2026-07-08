import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';



import '../services/locale_service.dart';

import '../services/onboarding_service.dart';

import '../theme.dart';



class OnboardingGoalScreen extends StatefulWidget {

  const OnboardingGoalScreen({super.key});



  @override

  State<OnboardingGoalScreen> createState() => _OnboardingGoalScreenState();

}



class _OnboardingGoalScreenState extends State<OnboardingGoalScreen> {

  String? _selectedGoal;

  bool _loading = false;



  static const _goals = [

    _Goal(id: 'learn_trading', icon: Icons.school_outlined),

    _Goal(id: 'practice_demo', icon: Icons.candlestick_chart_outlined),

    _Goal(id: 'pass_quiz', icon: Icons.quiz_outlined),

    _Goal(id: 'build_discipline', icon: Icons.psychology_outlined),

  ];



  String _goalTitle(String id) {

    final l10n = context.l10n;

    switch (id) {

      case 'learn_trading':

        return l10n.goalLearnTrading;

      case 'practice_demo':

        return l10n.goalDemoPractice;

      case 'pass_quiz':

        return l10n.goalTestKnowledge;

      case 'build_discipline':

        return l10n.goalBuildDiscipline;

      default:

        return id;

    }

  }



  String _goalSubtitle(String id) {

    final l10n = context.l10n;

    switch (id) {

      case 'learn_trading':

        return l10n.goalLearnTradingSub;

      case 'practice_demo':

        return l10n.goalDemoPracticeSub;

      case 'pass_quiz':

        return l10n.goalTestKnowledgeSub;

      case 'build_discipline':

        return l10n.goalBuildDisciplineSub;

      default:

        return '';

    }

  }



  Future<void> _finish() async {

    if (_selectedGoal == null) return;

    setState(() => _loading = true);

    await OnboardingService.saveGoal(_selectedGoal!);

    await OnboardingService.markCompleted();

    if (!mounted) return;

    context.go('/');

  }



  @override

  Widget build(BuildContext context) {

    final l10n = context.l10n;



    return Scaffold(

      appBar: AppBar(title: Text(l10n.yourGoal)),

      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.all(24),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(

                l10n.goalQuestion,

                style: Theme.of(context).textTheme.headlineSmall?.copyWith(

                      fontWeight: FontWeight.w800,

                    ),

              ),

              const SizedBox(height: 8),

              Text(

                l10n.goalSubtitle,

                style: Theme.of(context).textTheme.bodyMedium?.copyWith(

                      color: Colors.white70,

                    ),

              ),

              const SizedBox(height: 24),

              Expanded(

                child: ListView.separated(

                  itemCount: _goals.length,

                  separatorBuilder: (_, __) => const SizedBox(height: 12),

                  itemBuilder: (context, index) {

                    final goal = _goals[index];

                    final selected = _selectedGoal == goal.id;

                    return InkWell(

                      borderRadius: BorderRadius.circular(18),

                      onTap: () => setState(() => _selectedGoal = goal.id),

                      child: Container(

                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(

                          color: selected

                              ? AppTheme.gold.withValues(alpha: 0.12)

                              : AppTheme.card,

                          borderRadius: BorderRadius.circular(18),

                          border: Border.all(

                            color: selected ? AppTheme.gold : Colors.white12,

                            width: selected ? 2 : 1,

                          ),

                        ),

                        child: Row(

                          children: [

                            Icon(goal.icon, color: selected ? AppTheme.gold : Colors.white70),

                            const SizedBox(width: 14),

                            Expanded(

                              child: Column(

                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [

                                  Text(

                                    _goalTitle(goal.id),

                                    style: const TextStyle(

                                      fontWeight: FontWeight.w700,

                                      fontSize: 15,

                                    ),

                                  ),

                                  const SizedBox(height: 4),

                                  Text(

                                    _goalSubtitle(goal.id),

                                    style: const TextStyle(

                                      color: Colors.white54,

                                      fontSize: 13,

                                    ),

                                  ),

                                ],

                              ),

                            ),

                            if (selected)

                              const Icon(Icons.check_circle, color: AppTheme.gold),

                          ],

                        ),

                      ),

                    );

                  },

                ),

              ),

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: _selectedGoal != null && !_loading ? _finish : null,

                  child: _loading

                      ? const SizedBox(

                          width: 22,

                          height: 22,

                          child: CircularProgressIndicator(strokeWidth: 2),

                        )

                      : Text(l10n.continueBtn),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}



class _Goal {

  final String id;

  final IconData icon;



  const _Goal({required this.id, required this.icon});

}


