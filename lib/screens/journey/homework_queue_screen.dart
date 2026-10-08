import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class HomeworkQueueScreen extends StatefulWidget {
  const HomeworkQueueScreen({super.key});

  @override
  State<HomeworkQueueScreen> createState() => _HomeworkQueueScreenState();
}

class _HomeworkQueueScreenState extends State<HomeworkQueueScreen> {
  int levels = 4;
  int thesis = 3;
  int breakPoint = 1;
  final _comment = TextEditingController(text: 'Зона поддержки читается, уточни точку слома.');

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  int get total => levels + thesis + breakPoint;

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Trusted reviewer',
      title: 'Очередь домашек',
      subtitle: 'Ступени 1–2 · оценка публикуется в #homework от имени Desk Trader.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Разметка #s2 · ученик TM-4821', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                Text('BTCUSDT 4h · поддержка 61 900–62 100 · вывод: живая идея long'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Рубрика', style: TextStyle(fontWeight: FontWeight.w700)),
          _ScoreRow('Уровни зоной', levels, 4, (v) => setState(() => levels = v)),
          _ScoreRow('Вывод с графика', thesis, 4, (v) => setState(() => thesis = v)),
          _ScoreRow('Где идея ломается', breakPoint, 2, (v) => setState(() => breakPoint = v)),
          Text('Итого: $total / 10', style: TmKit.monoValue.copyWith(fontSize: 18)),
          const SizedBox(height: 12),
          TextField(
            controller: _comment,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Комментарий ученику'),
          ),
        ],
      ),
      bottomBar: Column(
        children: [
          TmPrimaryButton(
            label: 'Принять · $total/10',
            onPressed: total >= 7 ? () => context.pop() : null,
          ),
          const SizedBox(height: 8),
          TmGhostButton(
            label: 'На доработку',
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final ValueChanged<int> onChanged;

  const _ScoreRow(this.label, this.value, this.max, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          ...List.generate(max + 1, (i) {
            return IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32),
              icon: Icon(
                i <= value ? Icons.circle : Icons.circle_outlined,
                size: 16,
                color: i <= value ? AppTheme.accent : AppTheme.faint,
              ),
              onPressed: () => onChanged(i),
            );
          }),
        ],
      ),
    );
  }
}
