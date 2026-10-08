import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';
import '../ui/tm_kit.dart';

class PathHubScreen extends StatelessWidget {
  const PathHubScreen({super.key});

  static const _steps = <_JourneyStep>[
    _JourneyStep('Быстрый путь · экзамен', 'Экран 03', '/placement', stage: 1, unlocked: true),
    _JourneyStep('Урок 1 · Спотовый рынок', 'Экраны 04–07', '/lesson/1', stage: 1, unlocked: true, current: true),
    _JourneyStep('Сохрани прогресс', 'Экран 08', '/save-progress', stage: 1, unlocked: true),
    _JourneyStep('Путь · ступень 1', 'Экран 09', '/path', stage: 1, unlocked: true),
    _JourneyStep('Язык хаба', 'Экран 10', '/hub-language', stage: 1, unlocked: true),
    _JourneyStep('Тест модуля', 'Экраны 11–12', '/module-test', stage: 1, unlocked: true),
    _JourneyStep('Ворота ступени 1', 'Экран 13', '/gates', stage: 1, unlocked: true),
    _JourneyStep('Вступить в Academy', 'Экран 14', '/academy', stage: 1, unlocked: true),
    _JourneyStep('Знакомство · intro', 'Экран 15', '/academy/intro', stage: 1, unlocked: true),
    _JourneyStep('Домашка ступени 1', 'Экран 16', '/homework/s1', stage: 1, unlocked: true),
    _JourneyStep('Проверка домашки', 'Экран 17', '/homework/review', stage: 1, unlocked: true),
    _JourneyStep('Подписка в приложении', 'Экран 18', '/subscribe', stage: 1, unlocked: true),
    _JourneyStep('Страница ключа', 'Экраны 19–22', '/key', stage: 1, unlocked: true),
    _JourneyStep('Ступень 2 · Читаю график', 'Экран 23', '/path/2', stage: 2, unlocked: true),
    _JourneyStep('Разметка · домашка', 'Экраны 24–25', '/markup', stage: 2, unlocked: true),
    _JourneyStep('Оценка разметки', 'Экран 26', '/markup/grade', stage: 2, unlocked: true),
    _JourneyStep('Отчёт недели', 'Экран 27', '/weekly-report', stage: 2, unlocked: true),
    _JourneyStep('Практика · ворота', 'Экран 28', '/practice/gates', stage: 3, unlocked: true),
    _JourneyStep('План сделки', 'Экран 29', '/trade/plan', stage: 3, unlocked: true),
    _JourneyStep('Сделка открыта', 'Экран 30', '/trade/open', stage: 3, unlocked: true),
    _JourneyStep('Разбор + журнал', 'Экран 31', '/trade/review', stage: 3, unlocked: true),
    _JourneyStep('Сделка не засчитана', 'Экран 32', '/trade/rejected', stage: 3, unlocked: true),
    _JourneyStep('Журнал сделок', 'Экран 33', '/journal', stage: 3, unlocked: true),
    _JourneyStep('Экзамен готовности', 'Экраны 34–35', '/exam', stage: 4, unlocked: true),
    _JourneyStep('Чеклист готовности', 'Экран 36', '/checklist', stage: 4, unlocked: true),
    _JourneyStep('Диплом', 'Экран 37', '/diploma', stage: 4, unlocked: true),
    _JourneyStep('Допуск в основной хаб', 'Экран 38', '/hub-admit', stage: 4, unlocked: true),
    _JourneyStep('Риск-менеджер Tiger', 'Экран 39', '/real/lesson', stage: 5, unlocked: true),
    _JourneyStep('Реальный счёт', 'Экран 40', '/real/checklist', stage: 5, unlocked: true),
    _JourneyStep('Подтверждение риск-менеджера', 'Экран 41', '/real/risk', stage: 5, unlocked: true),
    _JourneyStep('Первая сделка', 'Экран 42', '/real/first-trade', stage: 5, unlocked: true),
    _JourneyStep('30 дней · сегодня', 'Экран 43', '/30/today', stage: 5, unlocked: true),
    _JourneyStep('Отчёт дня', 'Экран 44', '/30/report', stage: 5, unlocked: true),
    _JourneyStep('Стоп-день', 'Экран 45', '/30/stop', stage: 5, unlocked: true),
    _JourneyStep('Неделя на бумаге', 'Экран 46', '/30/paper', stage: 5, unlocked: true),
    _JourneyStep('Чат first-30', 'Экран 47', '/30/chat', stage: 5, unlocked: true),
    _JourneyStep('Выпуск Desk Trader', 'Экран 48', '/30/done', stage: 6, unlocked: true),
    _JourneyStep('Путь Desk Trader', 'Экран 49', '/desk', stage: 6, unlocked: true),
    _JourneyStep('Проверка домашек', 'Экран 50', '/desk/review', stage: 6, unlocked: true),
    _JourneyStep('Клуб', 'Экран 51', '/club', stage: 6, unlocked: true),
    _JourneyStep('Профиль', 'Экран 52', '/profile', stage: 6, unlocked: true),
  ];

  @override
  Widget build(BuildContext context) {
    final current = _steps.firstWhere((s) => s.current, orElse: () => _steps.first);
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('Путь Trade Master'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: () => context.push('/learning'),
          ),
        ],
      ),
      body: ListView(
        padding: TmKit.screenPadding,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.heroGradient(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Следующий шаг', style: TmKit.bodyMuted.copyWith(fontSize: 12, color: AppTheme.faint)),
                const SizedBox(height: 6),
                Text(current.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                Text(current.subtitle, style: TmKit.bodyMuted),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.push(current.route),
                  child: const Text('Продолжить'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Ступень ${current.stage} · шаги пути', style: TmKit.stageLabel),
          const SizedBox(height: 12),
          ..._steps.map((s) => _StepTile(step: s)),
        ],
      ),
    );
  }
}

class _JourneyStep {
  final String title;
  final String subtitle;
  final String route;
  final int stage;
  final bool unlocked;
  final bool current;

  const _JourneyStep(
    this.title,
    this.subtitle,
    this.route, {
    required this.stage,
    this.unlocked = false,
    this.current = false,
  });
}

class _StepTile extends StatelessWidget {
  final _JourneyStep step;

  const _StepTile({required this.step});

  @override
  Widget build(BuildContext context) {
    final enabled = step.unlocked;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: step.current ? AppTheme.accentDim : AppTheme.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          side: BorderSide(
            color: step.current ? AppTheme.accent : AppTheme.lineSoft,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          enabled: enabled,
          leading: Icon(
            enabled ? Icons.lock_open : Icons.lock,
            color: enabled ? AppTheme.accent : AppTheme.faint,
          ),
          title: Text(step.title, style: TextStyle(fontWeight: step.current ? FontWeight.w800 : FontWeight.w600)),
          subtitle: Text('${step.subtitle} · ступень ${step.stage}'),
          trailing: const Icon(Icons.chevron_right, color: AppTheme.faint),
          onTap: enabled ? () => context.push(step.route) : null,
        ),
      ),
    );
  }
}
