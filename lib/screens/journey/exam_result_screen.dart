import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class ExamResultScreen extends StatelessWidget {
  const ExamResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Результат экзамена',
      title: '90% · 18 из 20',
      subtitle: 'Порог сдачи — 85%. Можно переходить к чеклисту готовности.',
      body: Column(
        children: [
          TmCard(
            accent: AppTheme.bull,
            child: Column(
              children: [
                _TopicRow('Риск и размер позиции', '5/5'),
                _TopicRow('Плечо и ликвидация', '4/5'),
                _TopicRow('Безопасность и скам', '3/5'),
                _TopicRow('Спотовый рынок', '6/5'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const TmTeacherLine(
            message: 'Подтяни тему «Скам, переводы, ключи» — урок 54. Остальное уверенно.',
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'Чеклист готовности',
        onPressed: () => context.push('/checklist'),
      ),
    );
  }
}

class _TopicRow extends StatelessWidget {
  final String t;
  final String s;

  const _TopicRow(this.t, this.s);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(t)),
          Text(s, style: TmKit.monoValue),
        ],
      ),
    );
  }
}
