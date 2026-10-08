import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../ui/tm_kit.dart';

class DayReportScreen extends StatefulWidget {
  const DayReportScreen({super.key});

  @override
  State<DayReportScreen> createState() => _DayReportScreenState();
}

class _DayReportScreenState extends State<DayReportScreen> {
  final _pair = TextEditingController(text: 'BTCUSDT');
  final _plan = TextEditingController(text: 'entry 62 600 · stop 61 600 · take 64 800 · risk 0.5%');
  String _result = 'take';
  String _byPlan = 'yes';
  final _lesson = TextEditingController();
  bool _noTrade = false;

  @override
  void dispose() {
    _pair.dispose();
    _plan.dispose();
    _lesson.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Day 8/30',
      title: 'Отчёт дня',
      subtitle: 'Шаблон для #first-30 · минута на заполнение.',
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Сегодня не торговал'),
            value: _noTrade,
            onChanged: (v) => setState(() => _noTrade = v),
          ),
          if (!_noTrade) ...[
            TextField(controller: _pair, decoration: const InputDecoration(labelText: 'Пара · ТФ')),
            const SizedBox(height: 8),
            TextField(controller: _plan, maxLines: 2, decoration: const InputDecoration(labelText: 'Plan')),
            DropdownButtonFormField<String>(
              value: _result,
              decoration: const InputDecoration(labelText: 'Result'),
              items: const [
                DropdownMenuItem(value: 'take', child: Text('take')),
                DropdownMenuItem(value: 'stop', child: Text('stop')),
                DropdownMenuItem(value: 'manual', child: Text('manual')),
              ],
              onChanged: (v) => setState(() => _result = v ?? 'take'),
            ),
            DropdownButtonFormField<String>(
              value: _byPlan,
              decoration: const InputDecoration(labelText: 'By plan?'),
              items: const [
                DropdownMenuItem(value: 'yes', child: Text('yes')),
                DropdownMenuItem(value: 'no', child: Text('no — why')),
              ],
              onChanged: (v) => setState(() => _byPlan = v ?? 'yes'),
            ),
            TextField(
              controller: _lesson,
              decoration: const InputDecoration(labelText: 'Lesson for tomorrow'),
            ),
          ],
        ],
      ),
      bottomBar: Column(
        children: [
          TmPrimaryButton(
            label: 'Скопировать и открыть #first-30',
            onPressed: () => context.push('/30/chat'),
          ),
          const SizedBox(height: 8),
          TmGhostButton(
            label: 'Вернуться к дню 8',
            onPressed: () => context.go('/30/today'),
          ),
        ],
      ),
    );
  }
}
