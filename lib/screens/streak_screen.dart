import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/club_service.dart';
import '../services/gamification_service.dart';
import '../services/streak_service.dart';
import '../theme.dart';

/// Daily flame: what it is, what it gives, how to light it today.
class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  StreakState? _streak;
  List<({String reason, int points, DateTime at})> _ledger = const [];
  int _points = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await StreakService.load();
    final l = await GamificationService.ledger(limit: 8);
    final p = await GamificationService.getPoints();
    if (!mounted) return;
    setState(() {
      _streak = s;
      _ledger = l;
      _points = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = _streak;
    return Scaffold(
      appBar: AppBar(title: const Text('Огоньки')),
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: AppTheme.heroGradient(),
                  child: Column(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 44),
                      Text('${s.days}', style: AppTheme.display(64, color: Colors.white)),
                      Text(
                        _daysWord(s.days),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        s.litToday
                            ? 'Сегодня огонёк горит'
                            : 'Сегодня ещё не зажжён — пройди 3 шага урока или любое дело ниже',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _WeekRow(week: s.week),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _Tile(value: '×${s.multiplier.toStringAsFixed(1)}', label: 'множитель очков', color: AppTheme.progress),
                    const SizedBox(width: 10),
                    _Tile(value: '${s.freezes}', label: 'заморозки', color: AppTheme.sky),
                    const SizedBox(width: 10),
                    _Tile(value: '${s.best}', label: 'рекорд', color: AppTheme.mint),
                  ],
                ),
                const SizedBox(height: 22),
                Text('Зачем огоньки', style: AppTheme.display(20)),
                const SizedBox(height: 10),
                const _Rule(icon: Icons.bolt_rounded, text: '3 дня подряд — очки ×1.2, 7 дней — ×1.5, 30 дней — ×2.'),
                const _Rule(icon: Icons.groups_rounded, text: 'Серия 7 дней — условие входа в чат учеников, 30 дней — в чат профи.'),
                const _Rule(icon: Icons.ac_unit_rounded, text: 'Каждые 7 дней — заморозка (до 2). Она сама закроет пропущенный день.'),
                const SizedBox(height: 18),
                Text('Как зажечь сегодня', style: AppTheme.display(20)),
                const SizedBox(height: 10),
                _Action(label: '3 шага урока или тест модуля', onTap: () => context.go('/learning')),
                _Action(label: 'Сделка по плану в симуляторе', onTap: () => context.go('/practice')),
                _Action(label: 'Запись в журнале', onTap: () => context.push('/journal')),
                _Action(label: 'Карточки на повторение', onTap: () => context.push('/flashcards')),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Text('Последние очки', style: AppTheme.display(20)),
                    const Spacer(),
                    Text('${ClubService.fmt(_points)} всего', style: const TextStyle(color: AppTheme.muted)),
                  ],
                ),
                const SizedBox(height: 10),
                if (_ledger.isEmpty)
                  const Text('Пока пусто — первые очки дадут за первый урок.', style: TextStyle(color: AppTheme.muted))
                else
                  for (final e in _ledger)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(child: Text(e.reason, style: const TextStyle(fontWeight: FontWeight.w700))),
                          Text(
                            '${e.at.day.toString().padLeft(2, '0')}.${e.at.month.toString().padLeft(2, '0')}',
                            style: const TextStyle(color: AppTheme.faint, fontSize: 12),
                          ),
                          const SizedBox(width: 12),
                          Text('+${e.points}', style: AppTheme.display(16, color: AppTheme.progress)),
                        ],
                      ),
                    ),
              ],
            ),
    );
  }

  static String _daysWord(int n) {
    final m10 = n % 10, m100 = n % 100;
    if (m10 == 1 && m100 != 11) return 'день подряд';
    if (m10 >= 2 && m10 <= 4 && (m100 < 12 || m100 > 14)) return 'дня подряд';
    return 'дней подряд';
  }
}

class _WeekRow extends StatelessWidget {
  const _WeekRow({required this.week});

  final List<bool> week;

  static const _names = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: AppTheme.cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < 7; i++)
            Column(
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  color: week[i] ? AppTheme.accent : AppTheme.surface3,
                  size: 26,
                ),
                const SizedBox(height: 4),
                Text(
                  _names[today.subtract(Duration(days: 6 - i)).weekday - 1],
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: i == 6 ? AppTheme.text : AppTheme.muted,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.value, required this.label, required this.color});

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: AppTheme.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppTheme.display(24, color: color)),
            Text(label, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.accentText),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: AppTheme.textSoft, height: 1.4))),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
                const Icon(Icons.chevron_right_rounded, color: AppTheme.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
