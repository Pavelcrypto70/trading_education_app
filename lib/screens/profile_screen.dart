import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';



import '../services/gamification_service.dart';
import '../services/journal_service.dart';
import '../services/locale_service.dart';
import '../services/onboarding_service.dart';
import '../services/progress_service.dart';
import '../services/referral_service.dart';

import '../theme.dart';



class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});



  @override

  State<ProfileScreen> createState() => _ProfileScreenState();

}



class _ProfileScreenState extends State<ProfileScreen> {

  int _completed = 0;

  int _streak = 0;

  int _flashcards = 0;

  bool _premium = false;

  String? _goal;

  List<Map<String, dynamic>> _quizHistory = [];

  String _referralCode = '';

  int _inviteCount = 0;

  int _journalCount = 0;

  bool _loading = true;



  @override

  void initState() {

    super.initState();

    _load();

  }



  Future<void> _load() async {

    final completed = await ProgressService.getCompletedCount();

    final streak = await ProgressService.getStreak();

    final flashcards = await ProgressService.getFlashcardsReviewed();

    final premium = await ProgressService.isPremium();

    final goal = await OnboardingService.getGoal();

    final history = await ProgressService.getQuizHistory();

    await ReferralService.syncInviteRewards();

    final code = await ReferralService.getMyCode();

    final invites = await ReferralService.getInviteCount();

    final journalCount = await JournalService.getCount();



    if (!mounted) return;

    setState(() {

      _completed = completed;

      _streak = streak;

      _flashcards = flashcards;

      _premium = premium;

      _goal = goal;

      _quizHistory = history;

      _referralCode = code;

      _inviteCount = invites;

      _journalCount = journalCount;

      _loading = false;

    });

  }



  Future<void> _redeemReferral() async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    final err = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(l10n.referralEnterCode),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(hintText: 'TM-XXXXXX'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, 'cancel'), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () async {
              final result = await ReferralService.redeemCode(controller.text);
              if (ctx.mounted) Navigator.pop(ctx, result ?? 'ok');
            },
            child: Text(l10n.referralRedeem),
          ),
        ],
      ),
    );
    if (!mounted || err == null || err == 'cancel') return;
    if (err == 'ok') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.referralSuccess)));
      _load();
    } else {
      final msg = switch (err) {
        'empty' => l10n.referralErrorEmpty,
        'own' => l10n.referralErrorOwn,
        'already' => l10n.referralErrorAlready,
        'invalid' => l10n.referralErrorInvalid,
        _ => err,
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _copyReferralCode() async {
    await Clipboard.setData(ClipboardData(text: _referralCode));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.linkCopied)),
      );
    }
  }



  Future<void> _resetOnboarding() async {

    await OnboardingService.reset();

    if (!mounted) return;

    context.go('/onboarding');

  }



  Future<void> _resetProgress() async {

    final l10n = context.l10n;

    final confirmed = await showDialog<bool>(

      context: context,

      builder: (ctx) => AlertDialog(

        title: Text(l10n.resetProgressTitle),

        content: Text(l10n.resetProgressBody),

        actions: [

          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),

          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.reset)),

        ],

      ),

    );

    if (confirmed != true) return;

    await ProgressService.resetAll();

    await OnboardingService.markCompleted();

    await _load();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(content: Text(l10n.progressReset)),

    );

  }



  Future<void> _showLanguagePicker() async {

    final l10n = context.l10n;

    await showModalBottomSheet<void>(

      context: context,

      backgroundColor: AppTheme.surface,

      shape: const RoundedRectangleBorder(

        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),

      ),

      builder: (ctx) {

        return SafeArea(

          child: Padding(

            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),

            child: Column(

              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(l10n.selectLanguage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),

                const SizedBox(height: 16),

                ...AppLanguage.values.map((lang) {

                  final selected = LocaleService.instance.language == lang;

                  return Padding(

                    padding: const EdgeInsets.only(bottom: 8),

                    child: Material(

                      color: selected ? AppTheme.gold.withValues(alpha: 0.1) : AppTheme.card,

                      shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(20),

                        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),

                      ),

                      clipBehavior: Clip.antiAlias,

                      child: ListTile(

                      leading: Text(lang.flag, style: const TextStyle(fontSize: 24)),

                      title: Text(lang.label, style: TextStyle(

                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,

                        color: selected ? AppTheme.gold : null,

                      )),

                      trailing: selected ? const Icon(Icons.check_circle, color: AppTheme.gold) : null,

                      onTap: () async {

                        await LocaleService.instance.setLanguage(lang);

                        if (ctx.mounted) Navigator.pop(ctx);

                      },

                    ),

                    ),

                  );

                }),

              ],

            ),

          ),

        );

      },

    );

  }



  @override

  Widget build(BuildContext context) {

    final l10n = context.l10n;



    if (_loading) {

      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    }



    final currentLang = LocaleService.instance.language;



    return Scaffold(

      appBar: AppBar(

        title: Text(l10n.profile),

        actions: [

          IconButton(

            onPressed: () => context.push('/premium'),

            icon: Icon(

              _premium ? Icons.workspace_premium : Icons.workspace_premium_outlined,

              color: AppTheme.gold,

            ),

          ),

        ],

      ),

      body: ListView(

        padding: const EdgeInsets.all(20),

        children: [

          Container(

            padding: const EdgeInsets.all(22),

            decoration: AppTheme.heroGradient(),

            child: Row(

              children: [

                CircleAvatar(

                  radius: 32,

                  backgroundColor: AppTheme.gold.withValues(alpha: 0.2),

                  child: const Icon(Icons.person, color: AppTheme.gold, size: 32),

                ),

                const SizedBox(width: 16),

                Expanded(

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(l10n.trader, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),

                      Text(l10n.goalLabel(_goal), style: const TextStyle(color: Colors.white54, fontSize: 13)),

                      if (_premium)

                        Padding(

                          padding: const EdgeInsets.only(top: 6),

                          child: Text(l10n.premiumMember, style: const TextStyle(color: AppTheme.gold, fontSize: 12)),

                        ),

                    ],

                  ),

                ),

              ],

            ),

          ),

          const SizedBox(height: 20),

          Row(

            children: [

              Expanded(child: _StatCard(label: l10n.lessons, value: '$_completed')),

              const SizedBox(width: 10),

              Expanded(child: _StatCard(label: l10n.streak, value: '$_streak ${l10n.dayShort}')),

              const SizedBox(width: 10),

              Expanded(child: _StatCard(label: l10n.cards, value: '$_flashcards')),

            ],

          ),

          const SizedBox(height: 24),

          Text(l10n.recentQuizResults, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),

          const SizedBox(height: 12),

          if (_quizHistory.isEmpty)

            Container(

              padding: const EdgeInsets.all(18),

              decoration: AppTheme.cardDecoration(),

              child: Text(l10n.noQuizzesYet, style: const TextStyle(color: Colors.white54)),

            )

          else

            ..._quizHistory.take(5).map((entry) {

              final score = entry['score'] as int;

              final total = entry['total'] as int;

              final title = entry['title'] as String;

              return Container(

                margin: const EdgeInsets.only(bottom: 10),

                padding: const EdgeInsets.all(14),

                decoration: AppTheme.cardDecoration(),

                child: Row(

                  children: [

                    Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),

                    Text('$score/$total', style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w700)),

                  ],

                ),

              );

            }),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: AppTheme.cardDecoration(color: AppTheme.accent.withValues(alpha: 0.08)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.referralTitle, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 8),
                Text(l10n.referralXpInfo, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(l10n.referralYourCode, style: const TextStyle(color: Colors.white54)),
                    const SizedBox(width: 8),
                    Text(_referralCode, style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w800)),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: _copyReferralCode,
                    ),
                  ],
                ),
                Text(l10n.referralInvites(_inviteCount), style: const TextStyle(color: Colors.white54, fontSize: 13)),
                const SizedBox(height: 10),
                OutlinedButton(onPressed: _redeemReferral, child: Text(l10n.referralEnterCode)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _SettingsTile(
            icon: Icons.edit_note,
            title: l10n.journalTitle,
            subtitle: '$_journalCount',
            onTap: () => context.push('/journal'),
          ),

          _SettingsTile(
            icon: Icons.assignment_outlined,
            title: l10n.moduleTests,
            onTap: () => context.push('/module-quiz'),
          ),

          _SettingsTile(
            icon: Icons.verified_outlined,
            title: l10n.certificateTitle,
            subtitle: l10n.exportCertificate,
            onTap: () => context.push('/certificate'),
          ),

          _SettingsTile(
            icon: Icons.school_outlined,
            title: l10n.syllabusTitle,
            onTap: () => context.push('/syllabus'),
          ),

          _SettingsTile(
            icon: Icons.language,
            title: l10n.language,
            subtitle: '${currentLang.flag} ${currentLang.label}',
            onTap: _showLanguagePicker,
          ),

          _SettingsTile(

            icon: Icons.workspace_premium_outlined,

            title: l10n.upgradePremium,

            onTap: () => context.push('/premium'),

          ),

          _SettingsTile(

            icon: Icons.replay,

            title: l10n.replayOnboarding,

            onTap: _resetOnboarding,

          ),

          _SettingsTile(

            icon: Icons.delete_outline,

            title: l10n.resetAllProgress,

            onTap: _resetProgress,

            destructive: true,

          ),

          const SizedBox(height: 24),

          Text(

            l10n.appDisclaimer,

            style: const TextStyle(color: Colors.white38, fontSize: 12, height: 1.5),

            textAlign: TextAlign.center,

          ),

        ],

      ),

    );

  }

}



class _StatCard extends StatelessWidget {

  final String label;

  final String value;



  const _StatCard({required this.label, required this.value});



  @override

  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(14),

      decoration: AppTheme.cardDecoration(),

      child: Column(

        children: [

          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppTheme.gold)),

          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),

        ],

      ),

    );

  }

}



class _SettingsTile extends StatelessWidget {

  final IconData icon;

  final String title;

  final String? subtitle;

  final VoidCallback onTap;

  final bool destructive;



  const _SettingsTile({

    required this.icon,

    required this.title,

    this.subtitle,

    required this.onTap,

    this.destructive = false,

  });



  @override

  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 10),

      child: Material(

        color: AppTheme.card,

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(20),

          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),

        ),

        clipBehavior: Clip.antiAlias,

        child: ListTile(

        leading: Icon(icon, color: destructive ? Colors.redAccent : Colors.white70),

        title: Text(title, style: TextStyle(color: destructive ? Colors.redAccent : null)),

        subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(color: Colors.white38, fontSize: 12)) : null,

        trailing: const Icon(Icons.chevron_right, color: Colors.white38),

        onTap: onTap,

        ),

      ),

    );

  }

}


