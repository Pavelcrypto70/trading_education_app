import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class TradeReviewScreen extends StatefulWidget {
  const TradeReviewScreen({super.key});

  @override
  State<TradeReviewScreen> createState() => _TradeReviewScreenState();
}

class _TradeReviewScreenState extends State<TradeReviewScreen> {
  final _whyCtrl = TextEditingController();
  final _nextCtrl = TextEditingController();

  @override
  void dispose() {
    _whyCtrl.dispose();
    _nextCtrl.dispose();
    super.dispose();
  }

  bool get _ok => _whyCtrl.text.trim().isNotEmpty && _nextCtrl.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Разбор + журнал',
      title: 'Сделка №8 засчитана',
      subtitle: 'Тейк сработал · +\$220 · +2.2R · по плану 3/3.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TmCard(
            accent: AppTheme.bull,
            child: Row(
              children: [
                const Icon(Icons.verified, color: AppTheme.bull),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Стоп и тейк до входа · риск ≤ 1% · закрытие по плану',
                    style: TmKit.bodyMuted.copyWith(color: AppTheme.text),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _whyCtrl,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Почему вошёл'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nextCtrl,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Что сделаю иначе'),
          ),
          const SizedBox(height: 16),
          TmGhostButton(
            label: 'Отправить план в #homework (#s3)',
            onPressed: _ok ? () {} : null,
          ),
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'Сохранить в журнал',
        onPressed: _ok ? () => context.push('/journal') : null,
      ),
    );
  }
}
