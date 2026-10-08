import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class MarkupLessonScreen extends StatefulWidget {
  const MarkupLessonScreen({super.key});

  @override
  State<MarkupLessonScreen> createState() => _MarkupLessonScreenState();
}

class _MarkupLessonScreenState extends State<MarkupLessonScreen> {
  final _pairCtrl = TextEditingController(text: 'BTCUSDT');
  final _tfCtrl = TextEditingController(text: '4h');
  final _levelsCtrl = TextEditingController();
  String _verdict = 'живой';
  final _breakCtrl = TextEditingController();
  bool _hasScreenshot = false;

  @override
  void dispose() {
    _pairCtrl.dispose();
    _tfCtrl.dispose();
    _levelsCtrl.dispose();
    _breakCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _hasScreenshot &&
      _levelsCtrl.text.trim().isNotEmpty &&
      _breakCtrl.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Домашка · разметка #s2',
      title: 'Разметка графика',
      subtitle: 'Спотовый рынок или фьючерс — пара, таймфрейм, уровни и вывод с графика.',
      body: Column(
        children: [
          TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Скрин графика', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _hasScreenshot = true),
                  icon: Icon(_hasScreenshot ? Icons.check_circle : Icons.upload_file,
                      color: _hasScreenshot ? AppTheme.bull : null),
                  label: Text(_hasScreenshot ? 'Скрин прикреплён (макет)' : 'Загрузить скрин'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pairCtrl,
            decoration: const InputDecoration(labelText: 'Пара (биткоин / альт)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tfCtrl,
            decoration: const InputDecoration(labelText: 'Таймфрейм'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _levelsCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Уровни и тренд',
              hintText: 'Поддержка 61 800–62 100 · тренд вверх HH/HL',
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _verdict,
            decoration: const InputDecoration(labelText: 'Вывод с графика'),
            items: const [
              DropdownMenuItem(value: 'живой', child: Text('Идея живая')),
              DropdownMenuItem(value: 'сломан', child: Text('Идея сломана')),
              DropdownMenuItem(value: 'рано', child: Text('Рано входить')),
            ],
            onChanged: (v) => setState(() => _verdict = v ?? 'живой'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _breakCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Где идея ломается',
              hintText: 'Закрытие 4h ниже зоны поддержки',
            ),
          ),
        ],
      ),
      bottomBar: Column(
        children: [
          TmPrimaryButton(
            label: 'Отправить на проверку',
            onPressed: _canSubmit ? () => context.push('/markup/grade') : null,
          ),
          const SizedBox(height: 8),
          TmGhostButton(
            label: 'Скопировать и открыть #homework',
            onPressed: _canSubmit ? () {} : null,
          ),
        ],
      ),
    );
  }
}
