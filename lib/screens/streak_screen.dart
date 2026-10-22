import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/club_service.dart';
import '../services/gamification_service.dart';
import '../services/locale_service.dart';
import '../services/streak_service.dart';
import '../theme.dart';
import '../utils/num_format.dart';

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
    final l10n = context.l10n;
    final s = _streak;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.flamesTitle)),
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
                        l10n.daysInARowWord(s.days),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        s.litToday ? l10n.streakLitToday : l10n.streakNotLitToday,
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
                    _Tile(
                      value: '× ${fmtNum(s.multiplier, 1)}',
                      label: l10n.streakMultLabel,
                      color: AppTheme.progress,
                    ),
                    const SizedBox(width: 10),
                    _Tile(value: '${s.freezes}', label: l10n.freezesLabel, color: AppTheme.sky),
                    const SizedBox(width: 10),
                    _Tile(value: '${s.best}', label: l10n.recordLabel, color: AppTheme.mint),
                  ],
                ),
                const SizedBox(height: 22),
                Text(l10n.whyFlamesTitle, style: AppTheme.display(20)),
                const SizedBox(height: 10),
                _Rule(icon: Icons.bolt_rounded, text: l10n.whyFlamesRule1),
                _Rule(icon: Icons.groups_rounded, text: l10n.whyFlamesRule2),
                _Rule(icon: Icons.ac_unit_rounded, text: l10n.whyFlamesRule3),
                const SizedBox(height: 18),
                Text(l10n.howLightTodayTitle, style: AppTheme.display(20)),
                const SizedBox(height: 10),
                _Action(label: l10n.streakActionLesson, onTap: () => context.go('/learning')),
                _Action(label: l10n.streakActionPaper, onTap: () => context.go('/practice')),
                _Action(label: l10n.streakActionJournal, onTap: () => context.push('/journal')),
                _Action(label: l10n.streakActionFlashcards, onTap: () => context.push('/flashcards')),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Text(l10n.recentPointsTitle, style: AppTheme.display(20)),
                    const Spacer(),
                    Text(
                      l10n.pointsTotalLabel(ClubService.fmt(_points)),
                      style: const TextStyle(color: AppTheme.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_ledger.isEmpty)
                  Text(l10n.streakLedgerEmpty, style: const TextStyle(color: AppTheme.muted))
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
}

class _WeekRow extends StatelessWidget {
  const _WeekRow({required this.week});

  final List<bool> week;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final names = [
      l10n.weekdayMon,
      l10n.weekdayTue,
      l10n.weekdayWed,
      l10n.weekdayThu,
      l10n.weekdayFri,
      l10n.weekdaySat,
      l10n.weekdaySun,
    ];
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
                  names[today.subtract(Duration(days: 6 - i)).weekday - 1],
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
