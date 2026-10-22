import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../config/app_config.dart';
import '../config/build_flags.dart';
import '../config/desk_key_config.dart';
import '../services/backend_service.dart';
import '../services/auth_service.dart';
import '../services/analytics_service.dart';
import '../services/desk_key_service.dart';
import '../l10n/app_localizations.dart';
import '../services/locale_service.dart';
import '../theme.dart';
import '../utils/external_link.dart';

/// Web: recommend Tiger Desk Club registration (pro path). Lessons stay free either way.
class DeskKeyScreen extends StatefulWidget {
  const DeskKeyScreen({super.key});

  @override
  State<DeskKeyScreen> createState() => _DeskKeyScreenState();
}

class _DeskKeyScreenState extends State<DeskKeyScreen> {
  final _uid = TextEditingController();
  final _code = TextEditingController();
  DeskKeyState? _state;
  bool _busy = false;
  bool _editing = false;
  String? _codeError;

  bool get _serverReady => BackendService.isAvailable && AuthService.isSignedIn;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _uid.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final s = await DeskKeyService.load();
    if (!mounted) return;
    setState(() {
      _state = s;
      if (_uid.text.isEmpty && s.uid != null) _uid.text = s.uid!;
    });
  }

  Future<void> _submit() async {
    if (_busy || !DeskKeyService.isValidUid(_uid.text)) return;
    setState(() => _busy = true);
    HapticFeedback.lightImpact();
    final viaServer = await DeskKeyService.submit(_uid.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _editing = false;
    });
    if (!viaServer) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.deskKeyUidCopiedSnack)),
      );
    }
    await _load();
  }

  Future<void> _redeem() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _codeError = null;
    });
    final ok = await DeskKeyService.redeemCode(_code.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (!ok) {
        _codeError = context.l10n.deskKeyCodeBad;
      }
    });
    if (ok) {
      HapticFeedback.mediumImpact();
      AnalyticsService.refVerified();
      await _load();
    }
  }

  void _openReview() {
    final url = DeskKeyConfig.reviewUrl.trim().isNotEmpty ? DeskKeyConfig.reviewUrl : AppConfig.communityTelegramUrl;
    openExternalLinkNow(url);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = _state;
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      appBar: AppBar(
        title: Text(BuildFlags.courseFree ? l10n.deskKeyPathTitle : l10n.deskKeyTitle),
      ),
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 32 + inset),
              children: s.status == DeskKeyStatus.active ? _activeView(l10n) : _requestView(s, l10n),
            ),
    );
  }

  List<Widget> _activeView(AppLocalizations l10n) => [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.cardDecoration(color: AppTheme.bullSoft),
          child: Column(
            children: [
              const Icon(Icons.vpn_key_rounded, color: AppTheme.ok, size: 40),
              const SizedBox(height: 12),
              Text(l10n.deskKeyActiveTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                l10n.deskKeyActiveBody,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textSoft, height: 1.45),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => context.go('/learning'),
          child: Text(l10n.toLessonsBtn),
        ),
      ];

  List<Widget> _requestView(DeskKeyState s, AppLocalizations l10n) {
    final waiting = !_editing && (s.status == DeskKeyStatus.sent || s.status == DeskKeyStatus.pending);
    return [
      Text(
        BuildFlags.courseFree ? l10n.deskKeyIntroFree : l10n.deskKeyIntroSteps,
        style: const TextStyle(fontSize: 15.5, height: 1.45, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 12),
      _Card(
        title: l10n.deskKeyScamTitle,
        children: [
          _Para(l10n.deskKeyScamBody),
          const SizedBox(height: 8),
          _Para(l10n.deskKeyMentorHandleHint),
        ],
      ),
      const SizedBox(height: 12),
      _Card(
        title: l10n.deskKeyFreeTigerTitle,
        children: [
          _Para(l10n.deskKeyTigerExplain),
          const SizedBox(height: 8),
          _Para(l10n.deskKeyNoDepositYet),
          const SizedBox(height: 16),
          _StepTitle(1, l10n.deskKeyStep1Title),
          _Para(l10n.deskKeyStep1Body),
          const SizedBox(height: 10),
          if (DeskKeyConfig.refLink.isNotEmpty)
            OutlinedButton.icon(
              onPressed: () => openExternalLinkNow(DeskKeyConfig.refLink),
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(l10n.deskKeyOpenTiger),
            )
          else ...[
            _Para(l10n.deskKeyLinkFromMentor),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => openExternalLinkNow(AppConfig.communityTelegramUrl),
              icon: const Icon(Icons.telegram, size: 18),
              label: Text(l10n.openCommunityCta),
            ),
          ],
          const SizedBox(height: 18),
          _StepTitle(2, l10n.deskKeyStep2Title),
          _Para(l10n.deskKeyStep2Body),
          const SizedBox(height: 18),
          _StepTitle(3, waiting ? l10n.deskKeyStep3Sent : l10n.deskKeyStep3Send),
          if (s.status == DeskKeyStatus.rejected && !_editing) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: AppTheme.cardDecoration(color: AppTheme.bearSoft),
              child: Text(
                l10n.deskKeyRejected(s.uid ?? '', s.reason ?? ''),
                style: const TextStyle(height: 1.45),
              ),
            ),
          ],
          if (waiting) ..._waitingBlock(s, l10n) else ..._uidForm(l10n),
        ],
      ),
      const SizedBox(height: 12),
      _Card(
        title: l10n.deskKeyAlreadyHaveTitle,
        children: [
          _Para(
            l10n.deskKeyLinkExisting(
              DeskKeyConfig.refCode.isEmpty ? l10n.deskKeyCodeFromMentor : ' ${DeskKeyConfig.refCode}',
            ),
          ),
          const SizedBox(height: 8),
          _Para(l10n.deskKeySupportEmailHint),
          if (DeskKeyConfig.refCode.isNotEmpty) ...[
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                Clipboard.setData(const ClipboardData(
                  text: 'To: ${DeskKeyConfig.tigerSupportEmail}\n'
                      'Please link my account to referral code ${DeskKeyConfig.refCode}.',
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.deskKeyEmailCopied(DeskKeyConfig.tigerSupportEmail))),
                );
              },
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: Text(l10n.deskKeyCopyEmail),
            ),
          ],
        ],
      ),
      if (BuildFlags.courseFree) ...[
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.go('/learning'),
          child: Text(l10n.softRefCtaSecondary),
        ),
      ],
    ];
  }

  List<Widget> _uidForm(AppLocalizations l10n) => [
        TextField(
          controller: _uid,
          keyboardType: TextInputType.text,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: l10n.deskKeyUidLabel,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        _Para(
          _serverReady
              ? l10n.deskKeyUidHintServer
              : DeskKeyConfig.reviewUrl.isNotEmpty
                  ? l10n.deskKeyUidHintDm
                  : l10n.deskKeyUidHintClub,
          muted: true,
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _busy || !DeskKeyService.isValidUid(_uid.text) ? null : _submit,
          child: Text(l10n.deskKeySubmitReview),
        ),
      ];

  List<Widget> _waitingBlock(DeskKeyState s, AppLocalizations l10n) {
    if (s.viaServer) {
      return [
        _Para(l10n.deskKeyPendingServer(s.uid ?? '')),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _busy ? null : _load,
                child: Text(l10n.deskKeyCheckNow),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => setState(() => _editing = true),
              child: Text(l10n.deskKeyFixNumber),
            ),
          ],
        ),
      ];
    }
    return [
      _Para(
        '${l10n.deskKeyCopiedMentor(s.uid ?? '')} ${l10n.deskKeyMentorHandleHint}',
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _openReview,
              icon: const Icon(Icons.telegram, size: 18),
              label: Text(l10n.deskKeyOpenTelegram),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => setState(() => _editing = true),
            child: Text(l10n.deskKeyFixNumber),
          ),
        ],
      ),
      const SizedBox(height: 14),
      TextField(
        controller: _code,
        textCapitalization: TextCapitalization.characters,
        style: const TextStyle(fontSize: 16, letterSpacing: 1.5),
        decoration: InputDecoration(
          labelText: l10n.deskKeyCodeLabel,
          hintText: l10n.deskKeyCodeHint,
          errorText: _codeError,
          errorMaxLines: 3,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onChanged: (_) => setState(() => _codeError = null),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: _busy || _code.text.trim().length < 8 ? null : _redeem,
        child: Text(l10n.deskKeyEnable),
      ),
    ];
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.children, this.highlight = false});

  final String title;
  final List<Widget> children;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(
        border: highlight ? Border.all(color: AppTheme.accent, width: 1.4) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _StepTitle extends StatelessWidget {
  const _StepTitle(this.index, this.text);

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.gold.withValues(alpha: 0.18),
              border: Border.all(color: AppTheme.gold.withValues(alpha: 0.7)),
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

class _Para extends StatelessWidget {
  const _Para(this.text, {this.muted = false});

  final String text;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: muted ? AppTheme.muted : AppTheme.textSoft,
        fontSize: muted ? 13.5 : 14.5,
        height: 1.45,
      ),
    );
  }
}
