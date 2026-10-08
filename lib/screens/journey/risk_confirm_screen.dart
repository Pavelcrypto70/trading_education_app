import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '../../ui/tm_kit.dart';

class RiskConfirmScreen extends StatefulWidget {
  const RiskConfirmScreen({super.key});

  @override
  State<RiskConfirmScreen> createState() => _RiskConfirmScreenState();
}

class _RiskConfirmScreenState extends State<RiskConfirmScreen> {
  bool _uploaded = false;

  @override
  Widget build(BuildContext context) {
    return TmScreen(
      stageLabel: 'Подтверждение',
      title: 'Риск-менеджер Tiger',
      subtitle: 'Загрузи скрин страницы Risk manager. Ментор проверит в течение 24 часов.',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton.icon(
            onPressed: () => setState(() => _uploaded = true),
            icon: Icon(_uploaded ? Icons.check : Icons.upload),
            label: Text(_uploaded ? 'Скрин загружен (макет)' : 'Загрузить скрин'),
          ),
          if (_uploaded) ...[
            const SizedBox(height: 16),
            TmCard(
              accent: AppTheme.bull,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Распознано', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  _Check('Лимит ≤ 3% депозита', ok: true),
                  _Check('Фьючерсы USDⓈ-M Binance', ok: true),
                  _Check('Статус: включён', ok: true),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'В команде Desk Club видны события риск-менеджера — для разбора, не для контроля денег.',
              style: TmKit.bodyMuted.copyWith(fontSize: 12),
            ),
          ],
        ],
      ),
      bottomBar: TmPrimaryButton(
        label: 'К первой сделке',
        onPressed: _uploaded ? () => context.push('/real/first-trade') : null,
      ),
    );
  }
}

class _Check extends StatelessWidget {
  final String t;
  final bool ok;

  const _Check(this.t, {required this.ok});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(ok ? Icons.check : Icons.close, size: 16, color: ok ? AppTheme.bull : AppTheme.bear),
        const SizedBox(width: 8),
        Text(t),
      ],
    );
  }
}
