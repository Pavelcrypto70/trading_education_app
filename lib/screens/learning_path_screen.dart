import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/lessons_repository.dart';
import '../data/module_quiz_repository.dart';
import '../data/syllabus_repository.dart';
import '../models/lesson.dart';
import '../services/locale_service.dart';
import '../services/progress_service.dart';
import '../theme.dart';

class LearningPathScreen extends StatefulWidget {
  const LearningPathScreen({super.key});

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _modules = [];
  Map<int, Lesson> _lessons = {};
  Set<int> _completed = {};
  Map<String, int?> _moduleScores = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final syllabus = await SyllabusRepository.load();
    final lang = LocaleService.instance.languageCode;
    final modules = List<Map<String, dynamic>>.from(syllabus['modules'] as List? ?? const []);
    modules.sort((a, b) => (a['order'] as int? ?? 0).compareTo(b['order'] as int? ?? 0));
    final allLessons = await LessonsRepository().loadLessons();
    final lessonMap = {for (final l in allLessons) l.id: l};
    final completed = await ProgressService.getCompletedLessons();
    final meta = await ModuleQuizRepository.loadModules();
    final scores = <String, int?>{};
    for (final m in meta) {
      scores[m.moduleId] = await ModuleQuizRepository.getModuleScore(m.moduleId);
    }
    if (!mounted) return;
    setState(() {
      _modules = modules;
      _lessons = lessonMap;
      _completed = completed;
      _moduleScores = scores;
      _loading = false;
    });
  }

  bool _isLocked(Lesson lesson) {
    return lesson.prerequisites.any((id) => !_completed.contains(id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.skillTree),
        actions: [
          IconButton(
            onPressed: () => context.push('/module-quiz'),
            icon: const Icon(Icons.assignment_outlined),
            tooltip: l10n.moduleTests,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        itemCount: _modules.length,
        itemBuilder: (context, moduleIndex) {
          final module = _modules[moduleIndex];
          final moduleId = module['id'] as String;
          final title = SyllabusRepository.text(module['title'] as Map<String, dynamic>?, LocaleService.instance.languageCode);
          final lessonIds = List<int>.from(module['lessonIds'] as List? ?? const []);
          final doneInModule = lessonIds.where((id) => _completed.contains(id)).length;
          final moduleScore = _moduleScores[moduleId];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: AppTheme.heroGradient(),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(
                            l10n.moduleProgress(doneInModule, lessonIds.length),
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (moduleScore != null)
                      const Icon(Icons.verified, color: AppTheme.gold)
                    else if (doneInModule == lessonIds.length)
                      IconButton(
                        onPressed: () => context.push('/module-quiz'),
                        icon: const Icon(Icons.play_arrow_rounded, color: AppTheme.gold),
                        tooltip: l10n.moduleTests,
                      ),
                  ],
                ),
              ),
              ...List.generate(lessonIds.length, (i) {
                final id = lessonIds[i];
                final lesson = _lessons[id];
                if (lesson == null) return const SizedBox.shrink();
                final done = _completed.contains(id);
                final locked = !done && _isLocked(lesson);
                final alignLeft = i.isEven;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: alignLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
                    children: [
                      if (!alignLeft) const Spacer(flex: 1),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.72,
                        child: _PathNode(
                          lesson: lesson,
                          done: done,
                          locked: locked,
                          onTap: locked
                              ? null
                              : () async {
                                  await context.push('/lesson/${lesson.id}', extra: lesson);
                                  _load();
                                },
                        ),
                      ),
                      if (alignLeft) const Spacer(flex: 1),
                    ],
                  ),
                );
              }),
              if (moduleIndex < _modules.length - 1)
                Center(
                  child: Container(
                    width: 2,
                    height: 24,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.white12,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _PathNode extends StatelessWidget {
  final Lesson lesson;
  final bool done;
  final bool locked;
  final VoidCallback? onTap;

  const _PathNode({
    required this.lesson,
    required this.done,
    required this.locked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = done
        ? AppTheme.gold
        : locked
            ? Colors.white24
            : AppTheme.accent;
    return Material(
      color: done ? AppTheme.gold.withValues(alpha: 0.1) : AppTheme.card,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: locked
                      ? const Icon(Icons.lock, size: 18, color: Colors.white38)
                      : done
                          ? const Icon(Icons.check, color: AppTheme.gold, size: 20)
                          : Text('${lesson.id}', style: TextStyle(fontWeight: FontWeight.w800, color: color)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: locked ? Colors.white38 : Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${lesson.durationMin} min',
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (!locked) const Icon(Icons.chevron_right, color: Colors.white24, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
