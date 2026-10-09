import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/club_service.dart';
import '../theme.dart';
import '../widgets/club_apply.dart';

/// Shown once when the user passes a ladder cutoff.
class CutoffScreen extends StatefulWidget {
  const CutoffScreen({super.key, required this.chat});

  final ClubChat chat;

  @override
  State<CutoffScreen> createState() => _CutoffScreenState();
}

class _CutoffScreenState extends State<CutoffScreen> {
  ClubStatus? _status;
  final _name = TextEditingController();

  bool get _pro => widget.chat == ClubChat.pro;

  @override
  void initState() {
    super.initState();
    ClubService.markCelebrated(widget.chat);
    ClubService.status().then((s) {
      if (!mounted) return;
      _name.text = s.displayName ?? '';
      setState(() => _status = s);
    });
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    if (_name.text.trim().isNotEmpty) await ClubService.setDisplayName(_name.text);
  }

  @override
  Widget build(BuildContext context) {
    final s = _status;
    final checks = s == null ? const <CutoffCheck>[] : (_pro ? s.proChecks : s.studentsChecks);
    final color = _pro ? AppTheme.lavender : AppTheme.mint;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          children: [
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: AppTheme.claySquare(color, radius: 30),
                child: Icon(
                  _pro ? Icons.workspace_premium_rounded : Icons.groups_rounded,
                  size: 52,
                  color: AppTheme.onPastel,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Отсечка пройдена',
              textAlign: TextAlign.center,
              style: AppTheme.display(30),
            ),
            const SizedBox(height: 8),
            Text(
              _pro ? 'Можно подать заявку в чат профи' : 'Можно подать заявку в чат учеников',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.accentText, fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.cardDecoration(),
              child: Column(
                children: [
                  for (final c in checks)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppTheme.ok, size: 20),
                          const SizedBox(width: 10),
                          Expanded(child: Text(c.label, style: const TextStyle(fontWeight: FontWeight.w700))),
                          Text(c.detail, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (s != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.cardDecoration(color: AppTheme.surface2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Как тебя видят в чате · ID ${s.publicId}',
                      style: const TextStyle(color: AppTheme.muted, fontSize: 12.5),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _name,
                      maxLength: 24,
                      decoration: const InputDecoration(hintText: 'Твоё имя', counterText: ''),
                      onSubmitted: (v) => ClubService.setDisplayName(v),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await _saveName();
                final fresh = await ClubService.status();
                if (context.mounted) await applyToClubChat(context, fresh, widget.chat);
              },
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Подать заявку в чат'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                await _saveName();
                if (context.mounted) context.go('/club');
              },
              child: const Text('Позже · открыть ладер'),
            ),
          ],
        ),
      ),
    );
  }
}
