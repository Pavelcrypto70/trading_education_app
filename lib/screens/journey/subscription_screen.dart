import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '_jwidgets.dart';

/// Journey screen 18 · Подписка / IAP $9.99 в месяц.
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _loading = false;
  String _status = 'Бесплатная ступень 1';

  Future<void> _subscribe() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _status = 'Ожидание подтверждения магазина…';
    });
  }

  Future<void> _refreshStatus() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _status = 'Подписка активна · paid';
    });
    context.push('/key/active');
  }

  @override
  Widget build(BuildContext context) {
    return JourneyScaffold(
      stepLabel: 'Экран 18',
      title: 'Trade Master Pro',
      subtitle:
          'Альтернатива реферальной программе: полный курс ступеней 2–4 без регистрации у брокера. Ступень 5 — отдельно после экзамена.',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          TmCard(
            accent: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '\$9.99',
                      style: TextStyle(
                        color: AppTheme.accent,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        'в месяц',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Статус: $_status',
                  style: const TextStyle(color: AppTheme.muted, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'В подписке',
                  style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10),
                _Bullet('44 урока ступеней 2–4 и модульные тесты'),
                _Bullet('Проверка домашек и разметок'),
                _Bullet('Экзамен, диплом и бумажная торговля'),
                _Bullet('Журнал сделок и реферальная программа не требуется'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Оплата через In-App Purchase (RuStore / App Store). Восстановление покупки доступно на этом экране.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      bottom: Column(
        children: [
          TmPrimaryButton(
            label: 'Оформить подписку \$9.99',
            loading: _loading,
            onPressed: _subscribe,
          ),
          const SizedBox(height: 8),
          TmGhostButton(
            label: 'Обновить статус',
            onPressed: _loading ? () {} : _refreshStatus,
          ),
          TmGhostButton(
            label: 'Бесплатный ключ через брокера',
            onPressed: () => context.push('/key/register'),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppTheme.accent)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppTheme.muted, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
