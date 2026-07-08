import 'package:flutter/material.dart';

import '../services/homework_service.dart';
import '../services/locale_service.dart';
import '../services/progress_service.dart';
import '../theme.dart';

class HomeworkRubricCard extends StatefulWidget {
  final int lessonId;

  const HomeworkRubricCard({super.key, required this.lessonId});

  @override
  State<HomeworkRubricCard> createState() => _HomeworkRubricCardState();
}

class _HomeworkRubricCardState extends State<HomeworkRubricCard> {
  List<Map<String, dynamic>>? _criteria;
  String? _instructions;
  int _passScore = 7;
  int _submitCount = 0;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final criteria = await HomeworkService.criteria();
    final instructions = await HomeworkService.instructions();
    final pass = await HomeworkService.passScore();
    final count = await ProgressService.getHomeworkSubmitCount(widget.lessonId);
    if (!mounted) return;
    setState(() {
      _criteria = criteria;
      _instructions = instructions;
      _passScore = pass;
      _submitCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_criteria == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppTheme.cardDecoration(color: Colors.blue.withValues(alpha: 0.06)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                const Icon(Icons.fact_check_outlined, color: Colors.lightBlueAccent, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(l10n.homeworkRubric, style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
                Text(
                  l10n.homeworkSubmits(_submitCount),
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
                Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: Colors.white38),
              ],
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: 10),
            if (_instructions != null)
              Text(_instructions!, style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.45)),
            const SizedBox(height: 10),
            ..._criteria!.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('+${c['weight']}', style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w700, fontSize: 12)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(c['text'] as String, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4))),
                  ],
                ),
              ),
            ),
            Text(l10n.homeworkPassScore(_passScore), style: const TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ],
      ),
    );
  }
}
