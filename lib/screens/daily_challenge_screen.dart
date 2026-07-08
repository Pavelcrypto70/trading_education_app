import 'dart:math';



import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';



import '../data/quiz_bank.dart';

import '../models/quiz_question.dart';

import '../services/locale_service.dart';

import '../services/progress_service.dart';

import '../theme.dart';



class DailyChallengeScreen extends StatefulWidget {

  const DailyChallengeScreen({super.key});



  @override

  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();

}



class _DailyChallengeScreenState extends State<DailyChallengeScreen> {

  bool _loading = true;

  bool _done = false;

  int? _score;



  @override

  void initState() {

    super.initState();

    _load();

  }



  Future<void> _load() async {

    final done = await ProgressService.isDailyChallengeDone();

    final score = await ProgressService.getDailyChallengeScore();

    if (!mounted) return;

    setState(() {

      _done = done;

      _score = score;

      _loading = false;

    });

  }



  void _start() {

    final l10n = context.l10n;

    final seed = DateTime.now().day + DateTime.now().month * 31;

    final random = Random(seed);

    final questions = List<QuizQuestion>.from(QuizBank.allQuestions)..shuffle(random);

    final daily = questions.take(5).toList();



    context.push('/quiz-play', extra: {

      'title': l10n.dailyChallenge,

      'questions': daily,

      'isDailyChallenge': true,

    });

  }



  @override

  Widget build(BuildContext context) {

    final l10n = context.l10n;



    if (_loading) {

      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    }



    return Scaffold(

      appBar: AppBar(

        title: Text(l10n.dailyChallenge),

        leading: IconButton(

          icon: const Icon(Icons.arrow_back),

          onPressed: () => context.pop(),

        ),

      ),

      body: Padding(

        padding: const EdgeInsets.all(24),

        child: Column(

          children: [

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(28),

              decoration: AppTheme.heroGradient(),

              child: Column(

                children: [

                  const Icon(Icons.bolt, color: AppTheme.gold, size: 48),

                  const SizedBox(height: 16),

                  Text(

                    l10n.dailyChallengeNew,

                    style: const TextStyle(color: Colors.white70),

                    textAlign: TextAlign.center,

                  ),

                  const SizedBox(height: 8),

                  Text(

                    _done ? l10n.done : l10n.dailyChallenge,

                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),

                    textAlign: TextAlign.center,

                  ),

                  if (_done && _score != null) ...[

                    const SizedBox(height: 8),

                    Text(

                      l10n.dailyChallengeDone(_score!),

                      style: const TextStyle(color: AppTheme.gold, fontSize: 18, fontWeight: FontWeight.w700),

                      textAlign: TextAlign.center,

                    ),

                  ],

                ],

              ),

            ),

            const SizedBox(height: 24),

            Text(

              l10n.dailyChallengeDesc,

              style: const TextStyle(color: Colors.white54, height: 1.5),

              textAlign: TextAlign.center,

            ),

            const Spacer(),

            if (!_done)

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: _start,

                  child: Text(l10n.startTodayChallenge),

                ),

              )

            else ...[

              SizedBox(

                width: double.infinity,

                child: OutlinedButton(

                  onPressed: () => context.go('/quiz'),

                  child: Text(l10n.practiceMoreQuiz),

                ),

              ),

              const SizedBox(height: 12),

              SizedBox(

                width: double.infinity,

                child: TextButton(

                  onPressed: () => context.pop(),

                  child: Text(l10n.backToHome),

                ),

              ),

            ],

          ],

        ),

      ),

    );

  }

}


