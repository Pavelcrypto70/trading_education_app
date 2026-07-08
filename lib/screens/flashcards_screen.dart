import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';



import '../data/lessons_repository.dart';

import '../models/lesson.dart';

import '../services/locale_service.dart';

import '../services/progress_service.dart';

import '../theme.dart';



class FlashcardsScreen extends StatefulWidget {

  const FlashcardsScreen({super.key});



  @override

  State<FlashcardsScreen> createState() => _FlashcardsScreenState();

}



class _FlashcardsScreenState extends State<FlashcardsScreen> {

  List<Lesson> _lessons = [];

  int _index = 0;

  bool _showAnswer = false;

  bool _loading = true;



  @override

  void initState() {

    super.initState();

    _load();

  }



  Future<void> _load() async {

    final lessons = await LessonsRepository().loadLessons();

    lessons.shuffle();

    if (!mounted) return;

    setState(() {

      _lessons = lessons.take(30).toList();

      _loading = false;

    });

  }



  Lesson? get _current => _lessons.isEmpty ? null : _lessons[_index];



  Future<void> _next({required bool knew}) async {

    await ProgressService.incrementFlashcardsReviewed();

    if (_index < _lessons.length - 1) {

      setState(() {

        _index++;

        _showAnswer = false;

      });

    } else {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(content: Text(context.l10n.flashcardSessionComplete)),

      );

      context.pop();

    }

  }



  @override

  Widget build(BuildContext context) {

    final l10n = context.l10n;



    if (_loading) {

      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    }

    if (_current == null) {

      return Scaffold(

        appBar: AppBar(title: Text(l10n.flashcards)),

        body: Center(child: Text(l10n.noLessonsAvailable)),

      );

    }



    final card = _current!;



    return Scaffold(

      appBar: AppBar(

        title: Text(l10n.flashcards),

        leading: IconButton(

          icon: const Icon(Icons.close),

          onPressed: () => context.pop(),

        ),

      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            Text(

              l10n.cardProgress(_index + 1, _lessons.length),

              style: const TextStyle(color: Colors.white54),

            ),

            const SizedBox(height: 8),

            ClipRRect(

              borderRadius: BorderRadius.circular(4),

              child: LinearProgressIndicator(

                value: (_index + 1) / _lessons.length,

                color: AppTheme.gold,

                backgroundColor: Colors.white12,

              ),

            ),

            const SizedBox(height: 24),

            Expanded(

              child: GestureDetector(

                onTap: () => setState(() => _showAnswer = !_showAnswer),

                child: AnimatedContainer(

                  duration: const Duration(milliseconds: 250),

                  width: double.infinity,

                  padding: const EdgeInsets.all(28),

                  decoration: AppTheme.cardDecoration(

                    color: _showAnswer

                        ? AppTheme.gold.withValues(alpha: 0.1)

                        : AppTheme.card,

                  ),

                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      Container(

                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                        decoration: BoxDecoration(

                          color: Colors.white.withValues(alpha: 0.08),

                          borderRadius: BorderRadius.circular(999),

                        ),

                        child: Text(

                          l10n.moduleName(card.module),

                          style: const TextStyle(fontSize: 12, color: AppTheme.gold),

                        ),

                      ),

                      const SizedBox(height: 20),

                      Text(

                        _showAnswer ? l10n.keyTakeaway : card.title,

                        style: TextStyle(

                          fontSize: 14,

                          color: _showAnswer ? AppTheme.gold : Colors.white54,

                          fontWeight: FontWeight.w600,

                        ),

                      ),

                      const SizedBox(height: 12),

                      Text(

                        _showAnswer ? card.takeaway : card.subtitle,

                        style: const TextStyle(

                          fontSize: 22,

                          fontWeight: FontWeight.w800,

                          height: 1.3,

                        ),

                        textAlign: TextAlign.center,

                      ),

                      const SizedBox(height: 24),

                      Text(

                        l10n.tapToReveal,

                        style: const TextStyle(color: Colors.white38, fontSize: 13),

                      ),

                    ],

                  ),

                ),

              ),

            ),

            const SizedBox(height: 20),

            if (_showAnswer) ...[

              Row(

                children: [

                  Expanded(

                    child: OutlinedButton(

                      onPressed: () => _next(knew: false),

                      child: Text(l10n.studyMore),

                    ),

                  ),

                  const SizedBox(width: 12),

                  Expanded(

                    child: ElevatedButton(

                      onPressed: () => _next(knew: true),

                      child: Text(l10n.knewIt),

                    ),

                  ),

                ],

              ),

            ] else

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: () => setState(() => _showAnswer = true),

                  child: Text(l10n.tapToReveal),

                ),

              ),

          ],

        ),

      ),

    );

  }

}


