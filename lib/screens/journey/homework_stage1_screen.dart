import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '_jwidgets.dart';

/// Journey screen 16 · Домашка ступени 1 (шаблон).
class HomeworkStage1Screen extends StatefulWidget {
  const HomeworkStage1Screen({super.key});

  @override
  State<HomeworkStage1Screen> createState() => _HomeworkStage1ScreenState();
}

class _HomeworkStage1ScreenState extends State<HomeworkStage1Screen> {
  final _unclearController = TextEditingController();

  static const _phrase =
      'Свеча показывает борьбу покупателей и продавцов за период — смотрю на закрытие, а не на фитиль.';
  static const _action = 'На учебном графике: тренд вверх, откат к зоне — ответ «да, по плану стоп ниже зоны».';

  @override
  void dispose() {
    _unclearController.dispose();
    super.dispose();
  }

  String get _template => '''
TM · L14 · #s1

Одной фразой (из урока):
$_phrase

Сделай (с графика):
$_action

Что неясно:
${_unclearController.text.isEmpty ? '…' : _unclearController.text}
''';

  Future<void> _copyAndOpen() async {
    await Clipboard.setData(ClipboardData(text: _template));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Шаблон скопирован — вставьте в #homework')),
    );
    context.push('/homework/review');
  }

  @override
  Widget build(BuildContext context) {
    return JourneyScaffold(
      stepLabel: 'Экран 16',
      title: 'Домашка · урок 14',
      subtitle: 'Проходной балл 7/10. Рубрика: фраза — 4, ответ с графика — 4, честно «что неясно» — 2.',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RoField(label: 'Одной фразой', value: _phrase),
                const SizedBox(height: 14),
                _RoField(label: 'Сделай', value: _action),
                const SizedBox(height: 14),
                TextField(
                  controller: _unclearController,
                  maxLines: 3,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Что неясно',
                    hintText: 'Например: не понял разницу маркет и лимит',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TmCard(
            accent: true,
            child: Text(
              _template,
              style: const TextStyle(
                color: AppTheme.text,
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
      bottom: TmPrimaryButton(
        label: 'Скопировать и открыть #homework',
        onPressed: _copyAndOpen,
      ),
    );
  }
}

class _RoField extends StatelessWidget {
  const _RoField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(color: AppTheme.text, height: 1.4),
        ),
      ],
    );
  }
}
