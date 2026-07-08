import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';



import '../data/unified_quiz_bank.dart';

import '../models/quiz_question.dart';

import '../services/locale_service.dart';
import '../services/spaced_repetition_service.dart';

import '../theme.dart';



class QuizScreen extends StatefulWidget {

  const QuizScreen({super.key});



  @override

  State<QuizScreen> createState() => _QuizScreenState();

}



class _QuizScreenState extends State<QuizScreen> {
  String selectedCategory = 'All';
  String selectedDifficulty = 'All';
  bool _loading = true;
  int _reviewCount = 0;

  final difficulties = const ['All', 'Easy', 'Medium', 'Hard'];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await UnifiedQuizBank.ensureLoaded();
    final count = await SpacedRepetitionService.getQueueCount();
    if (!mounted) return;
    setState(() {
      _loading = false;
      _reviewCount = count;
    });
  }

  List<QuizQuestion> get _questions => UnifiedQuizBank.filter(

        category: selectedCategory,

        difficulty: selectedDifficulty,

      );



  void _startQuiz(String title, List<QuizQuestion> questions) {

    if (questions.isEmpty) return;

    context.push('/quiz-play', extra: {

      'title': title,

      'questions': questions,

      'isDailyChallenge': false,

    });

  }



  Future<void> _startReview() async {
    final items = await SpacedRepetitionService.getDueItems();
    if (items.isEmpty || !mounted) return;
    final questions = items
        .map(
          (e) => QuizQuestion(
            category: e['category'] as String? ?? 'Basics',
            difficulty: e['difficulty'] as String? ?? 'Easy',
            question: e['question'] as String,
            options: List<String>.from(e['options'] as List),
            correctIndex: e['correctIndex'] as int,
            explanation: e['explanation'] as String? ?? '',
            lessonId: e['lessonId'] as int?,
            showChart: e['lessonId'] != null,
            sourceId: e['id'] as String?,
          ),
        )
        .toList();
    _startQuiz(context.l10n.reviewQueue, questions);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final questions = _questions;



    return Scaffold(

      appBar: AppBar(title: Text(l10n.quizArena)),

      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Container(

                padding: const EdgeInsets.all(18),

                decoration: AppTheme.heroGradient(),

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(

                      l10n.quizArena,

                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),

                    ),

                    const SizedBox(height: 6),

                    Text(

                      '${UnifiedQuizBank.allQuestions.length} questions',

                      style: const TextStyle(color: Colors.white70),

                    ),

                  ],

                ),

              ),

              const SizedBox(height: 20),

              Text(l10n.category, style: const TextStyle(fontWeight: FontWeight.w700)),

              const SizedBox(height: 10),

              Wrap(

                spacing: 8,

                runSpacing: 8,

                children: UnifiedQuizBank.categories.map((cat) {

                  final selected = selectedCategory == cat;

                  return FilterChip(

                    label: Text(l10n.categoryName(cat)),

                    selected: selected,

                    onSelected: (_) => setState(() => selectedCategory = cat),

                  );

                }).toList(),

              ),

              const SizedBox(height: 16),

              Text(l10n.difficulty, style: const TextStyle(fontWeight: FontWeight.w700)),

              const SizedBox(height: 10),

              Wrap(

                spacing: 8,

                runSpacing: 8,

                children: difficulties.map((d) {

                  final selected = selectedDifficulty == d;

                  return FilterChip(

                    label: Text(d == 'All' ? l10n.all : l10n.difficultyName(d)),

                    selected: selected,

                    onSelected: (_) => setState(() => selectedDifficulty = d),

                  );

                }).toList(),

              ),

              const SizedBox(height: 20),

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: questions.isEmpty

                      ? null

                      : () => _startQuiz(l10n.quizArena, questions),

                  child: Text(

                    questions.isEmpty

                        ? l10n.noLessonsFound

                        : '${l10n.quizArena} (${questions.length})',

                  ),

                ),

              ),

              const SizedBox(height: 12),

              if (_reviewCount > 0) ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _startReview,
                    icon: const Icon(Icons.replay),
                    label: Text('${l10n.reviewQueue} ($_reviewCount)'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _startQuiz(
                    l10n.quickDrill,
                    UnifiedQuizBank.allQuestions.take(5).toList(),
                  ),
                  child: Text(l10n.quickDrill),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(

                child: ListView.builder(

                  itemCount: questions.length,

                  itemBuilder: (context, index) {

                    final q = questions[index];

                    return Container(

                      margin: const EdgeInsets.only(bottom: 10),

                      padding: const EdgeInsets.all(14),

                      decoration: AppTheme.cardDecoration(),

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Text(q.question, style: const TextStyle(fontWeight: FontWeight.w600)),

                          const SizedBox(height: 6),

                          Text(

                            '${l10n.categoryName(q.category)} · ${l10n.difficultyName(q.difficulty)}',

                            style: const TextStyle(color: Colors.white54, fontSize: 12),

                          ),

                        ],

                      ),

                    );

                  },

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}


