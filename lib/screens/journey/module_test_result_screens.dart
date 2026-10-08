import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '_jwidgets.dart';

/// Journey screens 11–12 · Тест модуля и результат.
class ModuleTestScreen extends StatefulWidget {
  const ModuleTestScreen({super.key});

  @override
  State<ModuleTestScreen> createState() => _ModuleTestScreenState();
}

class _ModuleTestScreenState extends State<ModuleTestScreen> {
  int _questionIndex = 3;
  int? _selected;

  static const _total = 8;
  static const _question =
      'Вы планируете сделку на биткоин со стопом −1R. Цена ушла против вас и коснулась стоп-лосса. Что засчитывается как «по плану»?';
  static const _options = [
    'Закрыли по стопу до того, как передумали',
    'Переставили стоп дальше и дождались отскока',
    'Убрали стоп, потому что «ещё отскочит»',
    'Вошли без стопа, но с маленьким размером',
  ];
  static const _explanation =
      'План — это стоп и тейк до входа. Перенос или снятие стопа ломает правило риска, даже если сделка закрылась в плюс.';

  void _submit() {
    if (_selected == null) return;
    context.push('/module-test/result');
  }

  @override
  Widget build(BuildContext context) {
    return JourneyScaffold(
      stepLabel: 'Экран 11',
      title: 'Тест модуля',
      subtitle: 'Спотовый и фьючерсный рынок',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          TmProgressLine(
            value: (_questionIndex + 1) / _total,
            label: 'Вопрос ${_questionIndex + 1} из $_total',
          ),
          const SizedBox(height: 20),
          TmCard(
            child: Text(
              _question,
              style: const TextStyle(
                color: AppTheme.text,
                fontWeight: FontWeight.w600,
                height: 1.45,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < _options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AnswerOption(
                label: _options[i],
                selected: _selected == i,
                onTap: () => setState(() => _selected = i),
              ),
            ),
          if (_selected != null) ...[
            const SizedBox(height: 8),
            TmCard(
              accent: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: AppTheme.accent, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _explanation,
                      style: const TextStyle(color: AppTheme.text, height: 1.4, fontSize: 13.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottom: TmPrimaryButton(
        label: _questionIndex + 1 >= _total ? 'Завершить тест' : 'Дальше',
        onPressed: _selected != null ? _submit : null,
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? AppTheme.accentDim : AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppTheme.accent : AppTheme.lineSoft,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppTheme.text : AppTheme.muted,
              height: 1.35,
            ),
          ),
        ),
      ),
    );
  }
}

class ModuleTestResultScreen extends StatelessWidget {
  const ModuleTestResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const score = 88;
    return JourneyScaffold(
      stepLabel: 'Экран 12',
      title: 'Тест пройден',
      subtitle: 'Спотовый и фьючерсный рынок · порог 80%',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          TmCard(
            accent: true,
            child: Column(
              children: [
                Text(
                  '$score%',
                  style: const TextStyle(
                    color: AppTheme.accent,
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '7 из 8 ответов верны',
                  style: TextStyle(color: AppTheme.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Разбор по темам',
            style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 10),
          _TopicRow(title: 'Риск и 1R', percent: 100),
          _TopicRow(title: 'Спотовый рынок', percent: 100),
          _TopicRow(title: 'Стоп-лосс', percent: 75, weak: true),
          const SizedBox(height: 16),
          TmCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.replay, color: AppTheme.warn, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Слабая тема: стоп-лосс',
                        style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Повторите урок 6 — около 3 минут на карточку «Ловушка».',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottom: Column(
        children: [
          TmPrimaryButton(
            label: 'К воротам ступени 1',
            onPressed: () => context.push('/gates'),
          ),
          TmGhostButton(
            label: 'Повторить урок 6',
            onPressed: () => context.push('/lesson/6'),
          ),
        ],
      ),
    );
  }
}

class _TopicRow extends StatelessWidget {
  const _TopicRow({
    required this.title,
    required this.percent,
    this.weak = false,
  });

  final String title;
  final int percent;
  final bool weak;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: weak ? AppTheme.warn : AppTheme.text,
                fontWeight: weak ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            '$percent%',
            style: TextStyle(
              color: weak ? AppTheme.warn : AppTheme.bull,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
