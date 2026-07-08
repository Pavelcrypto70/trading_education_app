import 'package:flutter/material.dart';

import '../models/journal_entry.dart';
import '../services/journal_service.dart';
import '../services/locale_service.dart';
import '../theme.dart';

class JournalScreen extends StatefulWidget {
  final int? prefillLessonId;
  final String? prefillLessonTitle;

  const JournalScreen({
    super.key,
    this.prefillLessonId,
    this.prefillLessonTitle,
  });

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<JournalEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    if (widget.prefillLessonId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openEditor());
    }
  }

  Future<void> _load() async {
    final entries = await JournalService.getEntries();
    if (!mounted) return;
    setState(() {
      _entries = entries;
      _loading = false;
    });
  }

  Future<void> _openEditor([JournalEntry? existing]) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _JournalEditorSheet(
        entry: existing,
        lessonId: widget.prefillLessonId,
        lessonTitle: widget.prefillLessonTitle,
      ),
    );
    if (saved == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.journalTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add),
        label: Text(l10n.journalNewEntry),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.edit_note, size: 64, color: Colors.white24),
                        const SizedBox(height: 16),
                        Text(
                          l10n.journalEmpty,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                  itemCount: _entries.length,
                  itemBuilder: (context, i) {
                    final e = _entries[i];
                    return Card(
                      color: AppTheme.card,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          e.pair.isNotEmpty ? e.pair : (e.lessonTitle ?? l10n.journalTitle),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${e.setup}\n${l10n.journalEntryStop}: ${e.stop} · ${l10n.journalEntryTarget}: ${e.target}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(height: 1.4, color: Colors.white54),
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Colors.white38),
                        onTap: () => _openEditor(e),
                      ),
                    );
                  },
                ),
    );
  }
}

class _JournalEditorSheet extends StatefulWidget {
  final JournalEntry? entry;
  final int? lessonId;
  final String? lessonTitle;

  const _JournalEditorSheet({this.entry, this.lessonId, this.lessonTitle});

  @override
  State<_JournalEditorSheet> createState() => _JournalEditorSheetState();
}

class _JournalEditorSheetState extends State<_JournalEditorSheet> {
  late final TextEditingController _pair;
  late final TextEditingController _setup;
  late final TextEditingController _entry;
  late final TextEditingController _stop;
  late final TextEditingController _target;
  late final TextEditingController _emotion;
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    final e = widget.entry;
    _pair = TextEditingController(text: e?.pair ?? 'BTC/USDT');
    _setup = TextEditingController(
      text: e?.setup ?? (widget.lessonTitle != null ? 'Lesson: ${widget.lessonTitle}' : ''),
    );
    _entry = TextEditingController(text: e?.entry ?? '');
    _stop = TextEditingController(text: e?.stop ?? '');
    _target = TextEditingController(text: e?.target ?? '');
    _emotion = TextEditingController(text: e?.emotion ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
  }

  @override
  void dispose() {
    _pair.dispose();
    _setup.dispose();
    _entry.dispose();
    _stop.dispose();
    _target.dispose();
    _emotion.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final id = widget.entry?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    await JournalService.saveEntry(JournalEntry(
      id: id,
      createdAt: widget.entry?.createdAt ?? DateTime.now(),
      lessonId: widget.entry?.lessonId ?? widget.lessonId,
      lessonTitle: widget.entry?.lessonTitle ?? widget.lessonTitle,
      pair: _pair.text.trim(),
      setup: _setup.text.trim(),
      entry: _entry.text.trim(),
      stop: _stop.text.trim(),
      target: _target.text.trim(),
      emotion: _emotion.text.trim(),
      notes: _notes.text.trim(),
    ));
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.journalNewEntry, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            _field(l10n.journalEntryPair, _pair),
            _field(l10n.journalEntrySetup, _setup),
            _field(l10n.journalEntryEntry, _entry),
            Row(
              children: [
                Expanded(child: _field(l10n.journalEntryStop, _stop)),
                const SizedBox(width: 12),
                Expanded(child: _field(l10n.journalEntryTarget, _target)),
              ],
            ),
            _field(l10n.journalEntryEmotion, _emotion),
            _field(l10n.journalEntryNotes, _notes, maxLines: 3),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _save, child: Text(l10n.journalSave)),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: AppTheme.bg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
