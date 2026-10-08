import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../config/partner_links.dart';
import '../data/lessons_repository.dart';
import '../data/syllabus_repository.dart';
import '../l10n/app_localizations.dart';
import '../services/certificate_service.dart';
import '../services/locale_service.dart';
import '../services/progress_service.dart';
import '../theme.dart';
import '../utils/external_link.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final _name = TextEditingController();
  bool _loading = true;
  bool _issuing = false;
  Set<int> _completed = {};
  int _total = 0;
  String _version = '1';
  String _course = 'Trade Master';
  CertificateStatus? _status;
  IssuedCertificate? _issued;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final completed = await ProgressService.getCompletedLessons();
    final lessons = await LessonsRepository().loadLessons();
    final syllabus = await SyllabusRepository.load();
    final lang = LocaleService.instance.languageCode;
    final course = SyllabusRepository.text(
      syllabus['course'] as Map<String, dynamic>?,
      lang,
    );
    final status = await CertificateService.evaluate(lessons.length);
    final issued = await CertificateService.loadIssued();
    final suggested = await CertificateService.suggestedHolderName();
    if (!mounted) return;
    setState(() {
      _completed = completed;
      _total = lessons.length;
      _version = syllabus['version']?.toString() ?? '1';
      _course = course;
      _status = status;
      _issued = issued;
      if (_name.text.trim().isEmpty && suggested.isNotEmpty) {
        _name.text = suggested;
      }
      _loading = false;
    });
  }

  Future<void> _issue() async {
    final status = _status;
    if (status == null || !status.isReady || _issuing) return;
    setState(() => _issuing = true);
    HapticFeedback.mediumImpact();
    final cert = await CertificateService.issue(
      holderName: _name.text,
      completed: _completed,
      totalLessons: _total,
      version: _version,
    );
    if (!mounted) return;
    setState(() {
      _issuing = false;
      _issued = cert;
    });
    if (cert == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.certificateIssueNeedName)),
      );
    }
  }

  Future<void> _copyShare(IssuedCertificate cert) async {
    final text = CertificateService.shareText(cert: cert, courseName: _course);
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.certificateShareCopied)),
    );
  }

  Future<void> _openPartner(PartnerOffer offer, AppLocalizations l10n) async {
    final ok = await openExternalLink(offer.url);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.partnerOpenError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.certificateTitle)),
      body: _loading || _status == null
          ? const Center(child: CircularProgressIndicator())
          : _body(l10n, _status!),
    );
  }

  Widget _body(AppLocalizations l10n, CertificateStatus status) {
    final ready = status.isReady;
    final issued = _issued;
    final showDiploma = ready && issued != null;
    final partners = PartnerLinks.configured;
    final exchanges = PartnerLinks.exchanges;
    final terminals = PartnerLinks.terminals;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        if (showDiploma)
          _DiplomaCard(cert: issued, course: _course, l10n: l10n)
        else
          _ProgressHero(status: status, l10n: l10n),
        const SizedBox(height: 16),
        _RequirementRow(
          done: status.lessonsOk,
          label: l10n.certificateReqLessonsCount(
            status.completedLessons,
            status.totalLessons,
          ),
        ),
        _RequirementRow(
          done: status.modulesOk,
          label: l10n.certificateReqModules(
            status.modulesPassed,
            status.totalModules,
          ),
        ),
        _RequirementRow(
          done: status.journalOk,
          label: l10n.certificateReqJournal(
            status.journalEntries,
            CertificateService.minJournalEntries,
          ),
        ),
        _RequirementRow(
          done: status.homeworkOk,
          label: l10n.certificateReqHomework(
            status.homeworkLessons,
            CertificateService.minHomeworkLessons,
          ),
        ),
        if (!status.lessonsOk) ...[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.go('/learning'),
            child: Text(l10n.navLearn),
          ),
        ],
        if (!status.modulesOk) ...[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.push('/module-quiz'),
            child: Text(l10n.moduleTests),
          ),
        ],
        if (!status.journalOk) ...[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.push('/journal/lesson'),
            child: Text(l10n.journalTitle),
          ),
        ],
        if (!status.homeworkOk) ...[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.push('/homework'),
            child: Text(l10n.homeworkTitle),
          ),
        ],
        if (ready && issued == null) ...[
          const SizedBox(height: 24),
          Text(
            l10n.certificateHolderHint,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(hintText: l10n.certificateHolderHint),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _issuing ? null : _issue,
            icon: const Icon(Icons.verified),
            label: Text(l10n.certificateIssueCta),
          ),
        ],
        if (showDiploma) ...[
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: 'TM-${issued.hash}'));
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.copyHash)),
                );
              }
            },
            icon: const Icon(Icons.fingerprint),
            label: Text(l10n.copyHash),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _copyShare(issued),
            icon: const Icon(Icons.copy),
            label: Text(l10n.shareCertificate),
          ),
          const SizedBox(height: 28),
          Text(
            l10n.partnerOffersTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.partnerOffersSubtitle,
            style: const TextStyle(color: Colors.white70, height: 1.45),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.partnerDisclosure,
            style: const TextStyle(color: Colors.white38, fontSize: 12, height: 1.4),
          ),
          if (partners.isEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.partnerLinksEmpty,
              style: const TextStyle(color: Colors.white54),
            ),
          ] else ...[
            if (exchanges.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                l10n.partnerExchanges,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.gold,
                ),
              ),
              const SizedBox(height: 10),
              ...exchanges.map(
                (o) => _PartnerCard(
                  title: l10n.partnerName(o.id),
                  blurb: l10n.partnerBlurb(o.id),
                  cta: l10n.partnerOpen,
                  onOpen: () => _openPartner(o, l10n),
                ),
              ),
            ],
            if (terminals.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.partnerTerminals,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.gold,
                ),
              ),
              const SizedBox(height: 10),
              ...terminals.map(
                (o) => _PartnerCard(
                  title: l10n.partnerName(o.id),
                  blurb: l10n.partnerBlurb(o.id),
                  cta: l10n.partnerOpen,
                  onOpen: () => _openPartner(o, l10n),
                ),
              ),
            ],
          ],
        ],
      ],
    );
  }
}

class _ProgressHero extends StatelessWidget {
  final CertificateStatus status;
  final AppLocalizations l10n;

  const _ProgressHero({required this.status, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.heroGradient(),
      child: Column(
        children: [
          const Icon(Icons.school_outlined, size: 56, color: AppTheme.gold),
          const SizedBox(height: 12),
          Text(
            '${status.lessonPercent}%',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppTheme.gold,
            ),
          ),
          Text(
            l10n.certificateLocked,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DiplomaCard extends StatelessWidget {
  final IssuedCertificate cert;
  final String course;
  final AppLocalizations l10n;

  const _DiplomaCard({
    required this.cert,
    required this.course,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.55), width: 2),
      ),
      child: Column(
        children: [
          Text(
            l10n.appName.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.gold,
              letterSpacing: 3,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.certificateReady,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            cert.holderName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.gold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            course,
            style: const TextStyle(color: Colors.white70, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.certificateIssuedOn(cert.issuedAt),
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.completedCount(cert.completedLessons, cert.totalLessons),
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Text(
            '${l10n.certificateHash}: TM-${cert.hash}',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final bool done;
  final String label;

  const _RequirementRow({required this.done, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? Colors.greenAccent : Colors.white38,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: done ? Colors.white : Colors.white54),
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerCard extends StatelessWidget {
  final String title;
  final String blurb;
  final String cta;
  final VoidCallback onOpen;

  const _PartnerCard({
    required this.title,
    required this.blurb,
    required this.cta,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 6),
          Text(blurb, style: const TextStyle(color: Colors.white60, height: 1.4, fontSize: 13)),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onOpen,
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(cta),
            ),
          ),
        ],
      ),
    );
  }
}
