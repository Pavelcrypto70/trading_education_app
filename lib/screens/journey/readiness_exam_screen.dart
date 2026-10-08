import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class ReadinessExamScreen extends StatefulWidget {
  const ReadinessExamScreen({super.key});

  @override
  State<ReadinessExamScreen> createState() => _ReadinessExamScreenState();
}

class _ReadinessExamScreenState extends State<ReadinessExamScreen> {
  int _question = 14;
  String? _answer;

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Экзамен готовности',
      title: 'Вопрос $_question из 20',
      subtitle: 'Депозит 500 USDT, риск 1%, стоп 2% от входа — размер позиции?',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(value: _question / 20),
          const SizedBox(height: 20),
          ...['200 USDT', '250 USDT', '300 USDT', '500 USDT'].map((opt) {
            final selected = _answer == opt;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: selected ? AppTheme.accentDim : AppTheme.surface2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: selected ? AppTheme.accent : AppTheme.lineSoft),
                ),
                child: ListTile(
                  title: Text(opt),
                  trailing: selected ? const Icon(Icons.radio_button_checked, color: AppTheme.accent) : null,
                  onTap: () => setState(() => _answer = opt),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Text(
            'Темы: риск, плечо isolated, ликвидация, скам и ключи, спотовый рынок.',
            style: TmKit.bodyMuted.copyWith(fontSize: 12),
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'Ответить и продолжить',
        onPressed: _answer != null ? () => context.push('/exam/result') : null,
      ),
    );
  }
}
