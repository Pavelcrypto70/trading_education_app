import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme.dart';
import '_jwidgets.dart';

/// Journey screen 13 · Ворота ступени 1 (чеклист).
class Stage1GatesScreen extends StatelessWidget {
  const Stage1GatesScreen({super.key});

  static const _items = [
    _GateItem('Тесты модулей 1–2', '≥ 80% в приложении', done: true),
    _GateItem('Desk Club Academy', 'Вступить через бота', done: false),
    _GateItem('#intro', 'Представиться в канале', done: false),
    _GateItem('Домашка урока 14', '≥ 7/10 от проверяющего', done: false),
  ];

  @override
  Widget build(BuildContext context) {
    final remaining = _items.where((e) => !e.done).length;
    return JourneyScaffold(
      stepLabel: 'Экран 13',
      title: 'До ключа осталось $remaining шага',
      subtitle:
          'Desk Club Academy — где ментор и выпускники проверяют домашки. Без сигналов и «гарантированной прибыли».',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          for (final item in _items) ...[
            _GateTile(item: item),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 8),
          TmCard(
            child: Text(
              'Все пункты отмечаются автоматически: тесты — здесь, клуб и знакомство — через Telegram-бота, домашка — после тега проверяющего.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
      bottom: TmPrimaryButton(
        label: 'Вступить в Academy',
        onPressed: () => context.push('/academy'),
      ),
    );
  }
}

class _GateItem {
  const _GateItem(this.title, this.subtitle, {required this.done});

  final String title;
  final String subtitle;
  final bool done;
}

class _GateTile extends StatelessWidget {
  const _GateTile({required this.item});

  final _GateItem item;

  @override
  Widget build(BuildContext context) {
    return TmCard(
      child: Row(
        children: [
          Icon(
            item.done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: item.done ? AppTheme.bull : AppTheme.faint,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: item.done ? AppTheme.muted : AppTheme.text,
                    fontWeight: FontWeight.w700,
                    decoration: item.done ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: const TextStyle(color: AppTheme.faint, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Journey screen 14 · Вступить в Desk Club Academy через бота.
class AcademyJoinScreen extends StatelessWidget {
  const AcademyJoinScreen({super.key});

  Future<void> _openBot() async {
    final uri = Uri.parse('https://t.me/DeskClubHubBot?start=demo_token');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return JourneyScaffold(
      stepLabel: 'Экран 14',
      title: 'Desk Club Academy',
      subtitle: 'Telegram-сообщество с ментором, проверкой домашек и каналом #intro.',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: const [
          TmStatRow(
            icon: Icons.smart_toy_outlined,
            title: 'Шаг 1',
            subtitle: 'Откройте бота @DeskClubHubBot и нажмите Start',
          ),
          SizedBox(height: 14),
          TmStatRow(
            icon: Icons.link,
            title: 'Шаг 2',
            subtitle: 'Бот пришлёт персональную ссылку-приглашение в группу',
          ),
          SizedBox(height: 14),
          TmStatRow(
            icon: Icons.sync,
            title: 'Шаг 3',
            subtitle: 'Вернитесь в приложение — пункт «Academy» отметится автоматически',
          ),
          SizedBox(height: 20),
          TmCard(
            accent: true,
            child: Text(
              'Одноразовый токен действует 24 часа. Если истёк — нажмите кнопку снова, бот выдаст новый.',
              style: TextStyle(color: AppTheme.text, height: 1.4, fontSize: 14),
            ),
          ),
        ],
      ),
      bottom: Column(
        children: [
          TmPrimaryButton(
            label: 'Открыть в Telegram',
            onPressed: _openBot,
          ),
          TmGhostButton(
            label: 'Уже вступил — к #intro',
            onPressed: () => context.push('/academy/intro'),
          ),
        ],
      ),
    );
  }
}
