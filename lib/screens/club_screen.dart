import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/club_service.dart';
import '../services/gamification_service.dart';
import '../theme.dart';
import '../widgets/club_apply.dart';

class ClubScreen extends StatefulWidget {
  const ClubScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  static const _publicUrl = ClubService.clubUrl;

  late int _tab = widget.initialTab;
  bool _week = false;
  ClubStatus? _status;
  LadderResult? _ladder;
  List<LadderRow> _studentsMembers = const [];
  List<LadderRow> _proMembers = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await ClubService.status();
    if (!mounted) return;
    setState(() => _status = s);
    final l = await ClubService.ladder(week: _week);
    final sm = s.students ? await ClubService.members(ClubChat.students) : const <LadderRow>[];
    final pm = s.pro ? await ClubService.members(ClubChat.pro) : const <LadderRow>[];
    if (!mounted) return;
    setState(() {
      _status = s;
      _ladder = l;
      _studentsMembers = sm;
      _proMembers = pm;
    });
  }

  Future<void> _open(String url) => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  Future<void> _editName() async {
    final ctrl = TextEditingController(text: _status?.displayName ?? '');
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Имя в ладере'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Его увидят ребята в рейтинге и в чатах. ID не меняется.',
              style: TextStyle(color: AppTheme.muted, fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              autofocus: true,
              maxLength: 24,
              decoration: const InputDecoration(hintText: 'Например, Павел'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, ctrl.text), child: const Text('Сохранить')),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty) return;
    await ClubService.setDisplayName(name);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final s = _status;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: s == null
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  children: [
                    Text('Desk Club', style: AppTheme.display(28)),
                    const SizedBox(height: 4),
                    const Text(
                      'Очки за обучение → ладер → закрытые чаты',
                      style: TextStyle(color: AppTheme.muted, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    _Segmented(
                      labels: const ['Ладер', 'Чаты'],
                      index: _tab,
                      onChanged: (i) => setState(() => _tab = i),
                    ),
                    const SizedBox(height: 16),
                    if (_tab == 0) ..._ladderTab(s) else ..._chatsTab(s),
                  ],
                ),
              ),
      ),
    );
  }

  List<Widget> _ladderTab(ClubStatus s) {
    final l = _ladder;
    final next = GamificationService.nextLeague(s.points);
    return [
      _MeCard(status: s, rank: l?.myRank, onEditName: _editName),
      const SizedBox(height: 12),
      if (next != null)
        _ProgressCard(
          title: next.unlocks != null ? '${next.unlocks} · лига «${next.name}»' : 'Лига «${next.name}»',
          from: GamificationService.leagueFor(s.points).minPoints,
          to: next.minPoints,
          value: s.points,
          color: next.color,
        ),
      const SizedBox(height: 20),
      Row(
        children: [
          Text('Рейтинг', style: AppTheme.display(20)),
          const Spacer(),
          _Chip(label: 'Неделя', selected: _week, onTap: () {
            setState(() => _week = true);
            _load();
          }),
          const SizedBox(width: 6),
          _Chip(label: 'Всё время', selected: !_week, onTap: () {
            setState(() => _week = false);
            _load();
          }),
        ],
      ),
      const SizedBox(height: 12),
      if (l == null)
        const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        )
      else
        ..._ladderRows(l),
      if (l != null && !l.live && l.note != null) _Note(l.note!),
      if (l != null && l.live && l.serverPoints != null && l.serverPoints! < s.points)
        _Note(
          'В рейтинге засчитано ${ClubService.fmt(l.serverPoints!)} из ${ClubService.fmt(s.points)}: '
          'сервер принимает до 800 очков в день, остальное подтянется в следующие дни.',
        ),
      const SizedBox(height: 16),
      const Text(
        'Очки дают только уроки, квизы, тесты, домашки, сделки по плану и журнал. За прибыль, объём или депозит очков нет.',
        style: TextStyle(color: AppTheme.faint, fontSize: 12, height: 1.45),
      ),
    ];
  }

  List<Widget> _ladderRows(LadderResult l) {
    final out = <Widget>[];
    var proLine = false, studentsLine = false;
    for (final r in l.rows) {
      if (!_week && !proLine && r.points < GamificationService.cutoffPro) {
        proLine = true;
        out.add(const _CutLine(label: 'отсечка · чат профи · 6 900'));
      }
      if (!_week && !studentsLine && r.points < GamificationService.cutoffStudents) {
        studentsLine = true;
        out.add(const _CutLine(label: 'отсечка · чат учеников · 1 400'));
      }
      out.add(_LadderTile(row: r));
    }
    if (l.live && !l.rows.any((r) => r.isMe) && _status != null) {
      final s = _status!;
      out
        ..add(const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Center(child: Text('· · ·', style: TextStyle(color: AppTheme.faint))),
        ))
        ..add(_LadderTile(
          row: LadderRow(
            rank: l.myRank ?? 0,
            name: s.shownName,
            publicId: s.publicId,
            points: l.serverPoints ?? (_week ? s.weekPoints : s.points),
            isMe: true,
          ),
        ));
    }
    if (l.live && l.rows.isEmpty) {
      out.add(const _Note('В рейтинге пока никого за этот период. Пройди шаг урока — и ты первый.'));
    }
    return out;
  }

  List<Widget> _chatsTab(ClubStatus s) {
    return [
      _ChatCard(
        title: 'Чат учеников',
        subtitle: 'Ступень 1 · вопросы, домашки, разборы',
        color: AppTheme.mint,
        open: s.students,
        checks: s.studentsChecks,
        members: _studentsMembers,
        onOpen: () => applyToClubChat(context, s, ClubChat.students),
      ),
      const SizedBox(height: 12),
      _ChatCard(
        title: 'Чат профи',
        subtitle: 'Диплом · сделки по плану · серия 30 дней',
        color: AppTheme.lavender,
        open: s.pro,
        checks: s.proChecks,
        members: _proMembers,
        onOpen: () => applyToClubChat(context, s, ClubChat.pro),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: AppTheme.heroGradient(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Открытый канал', style: AppTheme.display(20, color: Colors.white)),
            const SizedBox(height: 6),
            Text(
              'Новости клуба, эфиры и расписание. Доступен всем, без отсечки.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.9), height: 1.4),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.onPastel,
              ),
              onPressed: () => _open(_publicUrl),
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Открыть канал'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Text('Неделя в клубе', style: AppTheme.display(20)),
      const SizedBox(height: 10),
      const _WeekSchedule(),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppTheme.warnSoft, borderRadius: BorderRadius.circular(16)),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.shield_rounded, color: AppTheme.warn, size: 22),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Админы никогда не пишут первыми и не просят деньги. Ссылки на биржу — только в закреплённых сообщениях клуба.',
                style: TextStyle(color: AppTheme.textSoft, fontSize: 13, height: 1.45),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration(color: AppTheme.surface2),
      child: Text(text, style: const TextStyle(color: AppTheme.textSoft, fontSize: 13, height: 1.45)),
    );
  }
}

class _Segmented extends StatelessWidget {
  const _Segmented({required this.labels, required this.index, required this.onChanged});

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppTheme.bg2, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: i == index ? AppTheme.claySquare(AppTheme.accent, radius: 14) : null,
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: i == index ? Colors.white : AppTheme.muted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppTheme.surface3 : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? AppTheme.line : AppTheme.lineSoft),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: selected ? AppTheme.text : AppTheme.muted,
          ),
        ),
      ),
    );
  }
}

class _MeCard extends StatelessWidget {
  const _MeCard({required this.status, required this.rank, required this.onEditName});

  final ClubStatus status;
  final int? rank;
  final VoidCallback onEditName;

  @override
  Widget build(BuildContext context) {
    final s = status;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: AppTheme.claySquare(s.league.color),
                child: Text(
                  s.shownName.characters.first.toUpperCase(),
                  style: AppTheme.display(22, color: AppTheme.onPastel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: onEditName,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              s.shownName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.edit_rounded, size: 16, color: AppTheme.muted),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID ${s.publicId} · лига «${s.league.name}»',
                      style: const TextStyle(color: AppTheme.muted, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              if (rank != null)
                Text('#$rank', style: AppTheme.display(24, color: AppTheme.progress)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Stat(value: ClubService.fmt(s.points), label: 'очков всего'),
              _Stat(value: ClubService.fmt(s.weekPoints), label: 'за неделю'),
              _Stat(
                value: '${s.streak.days}',
                label: s.streak.multiplier > 1 ? 'дн. · ×${s.streak.multiplier.toStringAsFixed(1)}' : 'дн. серия',
                color: AppTheme.accentText,
              ),
            ],
          ),
          if (s.displayName == null || s.displayName!.isEmpty) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onEditName,
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: const Text('Укажи имя для рейтинга'),
            ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.color = AppTheme.text});

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTheme.display(22, color: color)),
          Text(label, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.title,
    required this.from,
    required this.to,
    required this.value,
    required this.color,
  });

  final String title;
  final int from;
  final int to;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final p = ((value - from) / (to - from)).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(color: AppTheme.surface2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: p,
              minHeight: 10,
              backgroundColor: AppTheme.bg2,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Осталось ${ClubService.fmt(to - value)} очков · ${ClubService.fmt(value)} из ${ClubService.fmt(to)}',
            style: const TextStyle(color: AppTheme.muted, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

class _CutLine extends StatelessWidget {
  const _CutLine({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppTheme.accent, thickness: 1.5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              label,
              style: const TextStyle(color: AppTheme.accentText, fontSize: 11.5, fontWeight: FontWeight.w800),
            ),
          ),
          const Expanded(child: Divider(color: AppTheme.accent, thickness: 1.5)),
        ],
      ),
    );
  }
}

class _LadderTile extends StatelessWidget {
  const _LadderTile({required this.row});

  final LadderRow row;

  @override
  Widget build(BuildContext context) {
    final r = row;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: r.isMe ? AppTheme.surfaceNow : AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: r.isMe ? Border.all(color: AppTheme.accent, width: 1.5) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              r.rank > 0 ? '${r.rank}' : '—',
              style: AppTheme.display(17, color: AppTheme.muted),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.isMe ? '${r.name} · ты' : r.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(r.publicId, style: const TextStyle(color: AppTheme.faint, fontSize: 11.5)),
              ],
            ),
          ),
          Text(ClubService.fmt(r.points), style: AppTheme.display(17)),
        ],
      ),
    );
  }
}

class _ChatCard extends StatelessWidget {
  const _ChatCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.open,
    required this.checks,
    required this.members,
    required this.onOpen,
  });

  final String title;
  final String subtitle;
  final Color color;
  final bool open;
  final List<CutoffCheck> checks;
  final List<LadderRow> members;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(color: open ? AppTheme.surface : AppTheme.surfaceLocked),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: AppTheme.claySquare(open ? color : AppTheme.surface3),
                child: Icon(
                  open ? Icons.forum_rounded : Icons.lock_rounded,
                  color: open ? AppTheme.onPastel : AppTheme.muted,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTheme.display(19)),
                    Text(subtitle, style: const TextStyle(color: AppTheme.muted, fontSize: 12.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (open) ...[
            if (members.isNotEmpty) ...[
              Text('В чате ${members.length}', style: const TextStyle(color: AppTheme.muted, fontSize: 12.5)),
              const SizedBox(height: 6),
              for (final m in members.take(5))
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${m.name} · ${m.publicId}${m.isMe ? ' · ты' : ''}',
                    style: const TextStyle(color: AppTheme.textSoft, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onOpen,
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text('Подать заявку в чат'),
              ),
            ),
          ] else
            for (final c in checks) CheckRow(check: c),
        ],
      ),
    );
  }
}

class _WeekSchedule extends StatelessWidget {
  const _WeekSchedule();

  static const _week = [
    ('Пн', 'План недели от ментора'),
    ('Вт', 'Урок недели в прямом эфире'),
    ('Ср', 'Разбор домашек'),
    ('Чт', 'Вопросы и ответы: счёт и верификация'),
    ('Пт', 'Свободная практика'),
    ('Сб', 'Выходной'),
    ('Вс', 'Разбор первых 30 дней'),
  ];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().weekday - 1;
    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          for (var i = 0; i < _week.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == today ? AppTheme.accent : AppTheme.surface2,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      _week[i].$1,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                        color: i == today ? Colors.white : AppTheme.muted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _week[i].$2,
                      style: TextStyle(
                        color: i == today ? AppTheme.text : AppTheme.textSoft,
                        fontWeight: i == today ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ),
                  if (i == today)
                    const Text(
                      'Сегодня',
                      style: TextStyle(color: AppTheme.accentText, fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
