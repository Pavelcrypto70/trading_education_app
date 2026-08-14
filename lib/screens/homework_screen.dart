import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../config/app_config.dart';
import '../data/lessons_repository.dart';
import '../models/lesson.dart';
import '../services/locale_service.dart';
import '../services/homework_service.dart';
import '../services/progress_service.dart';
import '../theme.dart';
import '../widgets/homework_rubric_card.dart';

class HomeworkScreen extends StatefulWidget {
  final int? initialLessonId;

  const HomeworkScreen({super.key, this.initialLessonId});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  final _sentence = TextEditingController();
  List<Lesson> _lessons = [];
  Map<int, int> _submits = {};
  int? _selectedId;
  bool _loading = true;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _sentence.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final lessons = await LessonsRepository().loadLessons();
    final submits = await ProgressService.getHomeworkSubmitMap();
    if (!mounted) return;
    final preferred = widget.initialLessonId ??
        (lessons.isNotEmpty ? lessons.first.id : null);
    setState(() {
      _lessons = lessons;
      _submits = submits;
      _selectedId = lessons.any((l) => l.id == preferred)
          ? preferred
          : (lessons.isEmpty ? null : lessons.first.id);
      _loading = false;
    });
  }

  Lesson? get _selected {
    final id = _selectedId;
    if (id == null) return null;
    for (final l in _lessons) {
      if (l.id == id) return l;
    }
    return null;
  }

  Future<void> _submit() async {
    final lesson = _selected;
    if (lesson == null || _sending) return;
    setState(() => _sending = true);
    HapticFeedback.lightImpact();
    final ok = await HomeworkService.submitHomework(
      lessonId: lesson.id,
      lessonTitle: lesson.title,
      oneSentence: _sentence.text,
    );
    if (!mounted) return;
    setState(() => _sending = false);
    await _load();
    if (!mounted) return;
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? l10n.homeworkCopied : l10n.homeworkCopiedNoTelegram),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.homeworkTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final submitted = _submits.entries.where((e) => e.value > 0).length;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeworkTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 32 + inset),
        children: [
          Text(
            l10n.homeworkHowTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          _HowRow(index: 1, text: l10n.homeworkHowStep1),
          const SizedBox(height: 8),
          _HowRow(index: 2, text: l10n.homeworkHowStep2),
          const SizedBox(height: 8),
          _HowRow(index: 3, text: l10n.homeworkHowStep3),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.cardDecoration(),
            child: Text(
              l10n.homeworkAccepted(AppConfig.homeworkTopicName),
              style: const TextStyle(color: Colors.white70, height: 1.45),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.homeworkSubmits(submitted),
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.homeworkSelectLesson,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          InputDecorator(
            decoration: const InputDecoration(),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedId,
                isExpanded: true,
                items: _lessons
                    .map(
                      (l) => DropdownMenuItem(
                        value: l.id,
                        child: Text(
                          '${l.id}. ${l.title}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (id) => setState(() => _selectedId = id),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _sentence,
            minLines: 2,
            maxLines: 4,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: l10n.homeworkOneSentenceHint,
            ),
          ),
          if (_selected != null) ...[
            const SizedBox(height: 16),
            HomeworkRubricCard(
              key: ValueKey('${_selected!.id}-${_submits[_selected!.id] ?? 0}'),
              lessonId: _selected!.id,
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _sending ? null : _submit,
            icon: const Icon(Icons.send),
            label: Text(l10n.submitHomework),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.homeworkSubmittedList,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (submitted == 0)
            Text(
              l10n.homeworkEmpty,
              style: const TextStyle(color: Colors.white54),
            )
          else
            ..._lessons.where((l) => (_submits[l.id] ?? 0) > 0).map(
              (l) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.check_circle, color: AppTheme.gold),
                  title: Text('${l.id}. ${l.title}'),
                  subtitle: Text(l10n.homeworkSubmits(_submits[l.id] ?? 0)),
                  onTap: () => context.push('/lesson/${l.id}', extra: l),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HowRow extends StatelessWidget {
  final int index;
  final String text;

  const _HowRow({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Text(
            '$index.',
            style: const TextStyle(
              color: AppTheme.gold,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, height: 1.45),
          ),
        ),
      ],
    );
  }
}
