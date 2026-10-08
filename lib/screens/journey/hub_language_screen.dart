import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';
import '_jwidgets.dart';

/// Journey screen 10 · Язык хаба (словарь терминов Desk Club).
class HubLanguageScreen extends StatefulWidget {
  const HubLanguageScreen({super.key});

  @override
  State<HubLanguageScreen> createState() => _HubLanguageScreenState();
}

class _HubLanguageScreenState extends State<HubLanguageScreen> {
  String? _expanded;

  static const _terms = [
    _HubTerm(
      id: 'retest',
      title: 'Retest',
      short: 'Повторная проверка после доработки',
      body:
          'Если домашку вернули с тегом revision, вы исправляете текст и отправляете снова в #homework. Retest — это повторная проверка по той же рубрике, без штрафа к попыткам теста.',
    ),
    _HubTerm(
      id: '1r',
      title: '1R',
      short: 'Единица риска на сделку',
      body:
          '1R — сумма, которую вы готовы потерять, если сработает стоп-лосс. Если риск 1% от счёта \$10 000, то 1R = \$100. Прибыль +2R значит, что тейк в два раза больше риска.',
    ),
    _HubTerm(
      id: 'sl',
      title: 'SL',
      short: 'Stop Loss · стоп-лосс',
      body:
          'Уровень, на котором вы закрываете убыточную позицию по плану. SL задаётся до входа. Сделка без стопа не засчитывается в воротах, даже если закрылась в плюс.',
    ),
    _HubTerm(
      id: 'fomo',
      title: 'FOMO',
      short: 'Fear of missing out',
      body:
          'Страх упустить движение. В хабе FOMO — сигнал проверить план: есть ли вход, стоп и размер позиции, или это импульс после новости.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return JourneyScaffold(
      stepLabel: 'Экран 10',
      title: 'Язык хаба',
      subtitle:
          'Короткий словарь Desk Club — чтобы читать разборы ментора и теги в Telegram без догадок.',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          TmCard(
            accent: true,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.menu_book_outlined, color: AppTheme.accent),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Перед тестом модуля полезно знать эти четыре термина — они встречаются в вопросах и в #general.',
                    style: TextStyle(color: AppTheme.text, height: 1.4, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final term in _terms) ...[
            _TermCard(
              term: term,
              expanded: _expanded == term.id,
              onTap: () => setState(() {
                _expanded = _expanded == term.id ? null : term.id;
              }),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
      bottom: TmPrimaryButton(
        label: 'К тесту модуля',
        onPressed: () => context.push('/module-test'),
      ),
    );
  }
}

class _HubTerm {
  const _HubTerm({
    required this.id,
    required this.title,
    required this.short,
    required this.body,
  });

  final String id;
  final String title;
  final String short;
  final String body;
}

class _TermCard extends StatelessWidget {
  const _TermCard({
    required this.term,
    required this.expanded,
    required this.onTap,
  });

  final _HubTerm term;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: TmCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    term.title,
                    style: const TextStyle(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppTheme.muted,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                term.short,
                style: const TextStyle(color: AppTheme.muted, fontSize: 13.5),
              ),
              if (expanded) ...[
                const SizedBox(height: 12),
                Text(
                  term.body,
                  style: const TextStyle(color: AppTheme.text, height: 1.45, fontSize: 14),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
