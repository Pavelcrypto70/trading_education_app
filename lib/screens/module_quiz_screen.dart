import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/module_quiz_repository.dart';
import '../data/unified_quiz_bank.dart';
import '../models/quiz_question.dart';
import '../services/locale_service.dart';
import '../services/progress_service.dart';
import '../theme.dart';

class ModuleQuizScreen extends StatefulWidget {
  const ModuleQuizScreen({super.key});

  @override
  State<ModuleQuizScreen> createState() => _ModuleQuizScreenState();
}

class _ModuleQuizScreenState extends State<ModuleQuizScreen> {
  List<ModuleQuizMeta>? _modules;
  Map<String, int?> _scores = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await UnifiedQuizBank.ensureLoaded();
    final modules = await ModuleQuizRepository.loadModules();
    final scores = <String, int?>{};
    for (final m in modules) {
      scores[m.moduleId] = await ModuleQuizRepository.getModuleScore(m.moduleId);
    }
    if (!mounted) return;
    setState(() {
      _modules = modules;
      _scores = scores;
      _loading = false;
    });
  }

  Future<void> _start(ModuleQuizMeta module) async {
    final completed = await ProgressService.getCompletedLessons();
    final missing = module.lessonIds.where((id) => !completed.contains(id)).toList();
    if (missing.isNotEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.prerequisitesRequired(missing.take(5).join(', ')))),
      );
      return;
    }
    final questions = await ModuleQuizRepository.questionsForModule(module);
    if (!mounted || questions.isEmpty) return;
    await context.push('/quiz-play', extra: {
      'title': module.title,
      'questions': questions,
      'isDailyChallenge': false,
      'moduleId': module.moduleId,
      'passPercent': module.passPercent,
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final modules = _modules ?? [];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moduleTests)),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: modules.length,
        itemBuilder: (context, i) {
          final m = modules[i];
          final score = _scores[m.moduleId];
          final passed = score != null;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: AppTheme.cardDecoration(
              color: passed ? AppTheme.gold.withValues(alpha: 0.06) : AppTheme.card,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: passed
                    ? AppTheme.gold.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.08),
                child: Icon(
                  passed ? Icons.verified : Icons.quiz_outlined,
                  color: passed ? AppTheme.gold : Colors.white54,
                ),
              ),
              title: Text(m.title, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(
                l10n.moduleTestMeta(m.questionCount, m.timeMin, m.lessonIds.length),
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              trailing: passed
                  ? Text('$score/${m.questionCount}', style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w700))
                  : const Icon(Icons.chevron_right),
              onTap: () => _start(m),
            ),
          );
        },
      ),
    );
  }
}
