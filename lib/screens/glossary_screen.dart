import 'package:flutter/material.dart';

import '../data/glossary_repository.dart';
import '../services/locale_service.dart';
import '../theme.dart';

class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  late Future<List<GlossaryEntry>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = GlossaryRepository.load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.glossaryTitle)),
      body: FutureBuilder<List<GlossaryEntry>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final filtered = snap.data!.where((e) {
            if (_query.isEmpty) return true;
            final q = _query.toLowerCase();
            return e.term.toLowerCase().contains(q) || e.definition.toLowerCase().contains(q);
          }).toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: l10n.searchLessons,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final e = filtered[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: AppTheme.cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.term, style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.gold)),
                            const SizedBox(height: 6),
                            Text(e.definition, style: const TextStyle(height: 1.5, color: Colors.white70)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
