import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/module_quiz_repository.dart';
import '../data/unified_quiz_bank.dart';
import '../services/locale_service.dart';
import '../services/quiz_session.dart';
import '../theme.dart';

/// Diagnostic test for “tried and lost money”: module 1 only.
/// Wrong answers → recommend those lessons; the rest are marked complete.
class PlacementScreen extends StatefulWidget {
  const PlacementScreen({super.key});

  @override
  State<PlacementScreen> createState() => _PlacementScreenState();
}

class _PlacementScreenState extends State<PlacementScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _start() async {
    final l10n = context.l10n;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await UnifiedQuizBank.ensureLoaded();
      final modules = await ModuleQuizRepository.loadModules();
      ModuleQuizMeta? module;
      for (final m in modules) {
        if (m.moduleId == 'basics') {
          module = m;
          break;
        }
      }
      module ??= modules.isEmpty ? null : modules.first;
      if (module == null) {
        setState(() {
          _loading = false;
          _error = l10n.placementUnavailable;
        });
        return;
      }
      final questions = await ModuleQuizRepository.questionsForPlacement(module);
      if (!mounted) return;
      if (questions.isEmpty) {
        setState(() {
          _loading = false;
          _error = l10n.placementNoQuestions;
        });
        return;
      }
      setState(() => _loading = false);
      QuizSession.set(
        title: l10n.placementCheckTitle(module.title),
        questions: questions,
        moduleId: module.moduleId,
        passPercent: module.passPercent,
        isPlacement: true,
        placementLessonIds: module.lessonIds,
      );
      // go — not push+await: after the quiz we must not force /learning
      // (that was skipping the test / wiping the result screen).
      context.go('/quiz-play');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = l10n.placementOpenFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.placementAppBar)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.placementHero, style: AppTheme.display(26)),
              const SizedBox(height: 12),
              Text(
                l10n.placementBody,
                style: const TextStyle(color: AppTheme.textSoft, height: 1.45, fontSize: 15.5),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: AppTheme.cardDecoration(color: AppTheme.accentDim),
                child: Text(
                  l10n.placementNote,
                  style: const TextStyle(height: 1.4),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: const TextStyle(color: AppTheme.bear)),
              ],
              const Spacer(),
              ElevatedButton(
                onPressed: _loading ? null : _start,
                child: _loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.placementStartBtn),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _loading ? null : () => context.go('/lesson/1'),
                child: Text(l10n.placementPreferLesson1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
