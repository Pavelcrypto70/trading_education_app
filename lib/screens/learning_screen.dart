import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_config.dart';
import '../data/lessons_repository.dart';
import '../models/lesson.dart';
import '../services/entitlement_service.dart';
import '../services/locale_service.dart';
import '../services/progress_service.dart';
import '../theme.dart';
import '../widgets/community_banner.dart';
import '../widgets/lesson_paywall_sheet.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final _repository = LessonsRepository();
  late Future<List<Lesson>> _futureLessons;
  String _selectedModule = 'All';
  String _searchQuery = '';
  Set<int> _completed = {};
  bool _fullAccess = false;

  @override
  void initState() {
    super.initState();
    _futureLessons = _load();
  }

  Future<List<Lesson>> _load() async {
    _completed = await ProgressService.getCompletedLessons();
    _fullAccess = await EntitlementService.hasFullAccess();
    return _repository.loadLessons();
  }

  Future<void> _refresh() async {
    setState(() => _futureLessons = _load());
    await _futureLessons;
  }

  Future<void> _openLesson(Lesson lesson) async {
    final unlocked = _fullAccess || AppConfig.trialLessonIds.contains(lesson.id);
    if (!unlocked) {
      await showLessonPaywallIfNeeded(context, lesson.id);
      return;
    }
    if (!_fullAccess) {
      final missing = lesson.prerequisites.where((id) => !_completed.contains(id)).toList();
      if (missing.isNotEmpty) {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppTheme.surface,
            title: Text(context.l10n.syllabusTitle),
            content: Text(context.l10n.prerequisitesRequired(missing.join(', '))),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(context.l10n.continueBtn),
              ),
            ],
          ),
        );
        return;
      }
    }
    await context.push('/lesson/${lesson.id}', extra: lesson);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.learningPath,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: AppTheme.text,
              ),
            ),
            const Text(
              'Академия · нумерованный список',
              style: TextStyle(fontSize: 11, color: AppTheme.faint, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home_outlined, size: 18, color: AppTheme.accent),
            label: const Text(
              'Путь',
              style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.accent),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Lesson>>(
        future: _futureLessons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('${l10n.error}: ${snapshot.error}'));
          }

          final allLessons = snapshot.data ?? [];
          final modules = ['All', ..._repository.getModules(allLessons)];
          final courseIndex = <int, int>{
            for (var i = 0; i < allLessons.length; i++) allLessons[i].id: i + 1,
          };

          final filtered = allLessons.where((lesson) {
            final moduleOk = _selectedModule == 'All' || lesson.module == _selectedModule;
            final q = _searchQuery.toLowerCase();
            final searchOk = q.isEmpty ||
                lesson.title.toLowerCase().contains(q) ||
                lesson.module.toLowerCase().contains(q);
            return moduleOk && searchOk;
          }).toList();

          final completedInView = filtered.where((l) => _completed.contains(l.id)).length;
          final currentId = allLessons
              .where((l) => !_completed.contains(l.id))
              .map((l) => l.id)
              .cast<int?>()
              .firstWhere(
                (id) => id != null && (_fullAccess || AppConfig.trialLessonIds.contains(id)),
                orElse: () => null,
              );

          return RefreshIndicator(
            onRefresh: _refresh,
            color: AppTheme.accent,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProgressHero(
                          done: _completed.length,
                          total: allLessons.length,
                          filteredDone: completedInView,
                          filteredTotal: filtered.length,
                          emptyFiltered: filtered.isEmpty,
                        ),
                        const SizedBox(height: 14),
                        const _ToolsStrip(),
                        const SizedBox(height: 14),
                        const CommunityBanner(compact: true),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (v) => setState(() => _searchQuery = v),
                          decoration: InputDecoration(
                            hintText: l10n.searchLessons,
                            prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.muted),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 42,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: modules.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final module = modules[index];
                              final selected = _selectedModule == module;
                              final label = module == 'All' ? l10n.all : l10n.moduleName(module);
                              return FilterChip(
                                label: Text(label),
                                selected: selected,
                                showCheckmark: false,
                                onSelected: (_) => setState(() => _selectedModule = module),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Уроки',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.muted,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                if (filtered.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text(l10n.noLessonsFound)),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final lesson = filtered[index];
                        final number = courseIndex[lesson.id] ?? lesson.id;
                        final done = _completed.contains(lesson.id);
                        final unlocked =
                            _fullAccess || AppConfig.trialLessonIds.contains(lesson.id);
                        final isTrial =
                            !_fullAccess && AppConfig.trialLessonIds.contains(lesson.id);
                        final isCurrent = lesson.id == currentId;
                        final moduleIdx = (modules.indexOf(lesson.module) - 1).clamp(0, 99);
                        final moduleColor =
                            AppTheme.stageColors[moduleIdx % AppTheme.stageColors.length];

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: _LessonCard(
                            color: moduleColor,
                            number: number,
                            title: lesson.title,
                            subtitle: lesson.subtitle,
                            moduleLabel: l10n.moduleName(lesson.module),
                            meta: '${l10n.difficultyName(lesson.difficulty)} · ${lesson.durationMin} ${l10n.min}',
                            done: done,
                            locked: !unlocked,
                            isCurrent: isCurrent,
                            isTrial: isTrial,
                            interactive: lesson.hasRichContent,
                            interactiveLabel: l10n.interactive,
                            trialLabel: l10n.trialBadge,
                            onTap: () => _openLesson(lesson),
                          ),
                        );
                      },
                      childCount: filtered.length,
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProgressHero extends StatelessWidget {
  const _ProgressHero({
    required this.done,
    required this.total,
    required this.filteredDone,
    required this.filteredTotal,
    required this.emptyFiltered,
  });

  final int done;
  final int total;
  final int filteredDone;
  final int filteredTotal;
  final bool emptyFiltered;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final progress = total == 0 ? 0.0 : done / total;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradientColors,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.completedCount(done, total),
                  style: AppTheme.display(21, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  emptyFiltered
                      ? l10n.noLessonsFound
                      : 'В фильтре: ${l10n.completedCount(filteredDone, filteredTotal)}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.82), fontSize: 13, height: 1.35),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    strokeCap: StrokeCap.round,
                    color: Colors.white,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Labeled tool shortcuts — never icon-only in the app bar.
class _ToolsStrip extends StatelessWidget {
  const _ToolsStrip();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      (Icons.account_tree_rounded, l10n.skillTree, '/learning-path', AppTheme.accent),
      (Icons.fact_check_rounded, l10n.moduleTests, '/module-quiz', AppTheme.mint),
      (Icons.school_rounded, l10n.syllabusTitle, '/syllabus', AppTheme.violet),
      (Icons.translate_rounded, l10n.glossaryTitle, '/glossary', AppTheme.sky),
      (Icons.style_rounded, l10n.flashcards, '/flashcards', AppTheme.pink),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final item = items[i];
          return Material(
            color: item.$4.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.push(item.$3),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: item.$4.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.$1, size: 18, color: item.$4),
                    const SizedBox(width: 8),
                    Text(
                      item.$2,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.text,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.color,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.moduleLabel,
    required this.meta,
    required this.done,
    required this.locked,
    required this.isCurrent,
    required this.isTrial,
    required this.interactive,
    required this.interactiveLabel,
    required this.trialLabel,
    required this.onTap,
  });

  final Color color;
  final int number;
  final String title;
  final String subtitle;
  final String moduleLabel;
  final String meta;
  final bool done;
  final bool locked;
  final bool isCurrent;
  final bool isTrial;
  final bool interactive;
  final String interactiveLabel;
  final String trialLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = isCurrent
        ? color
        : done
            ? AppTheme.bull.withValues(alpha: 0.45)
            : color.withValues(alpha: 0.22);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isCurrent ? null : AppTheme.surface,
            gradient: isCurrent ? AppTheme.tintGradient(color) : null,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border, width: isCurrent ? 1.6 : 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NumberBadge(
                color: color,
                number: number,
                done: done,
                locked: locked,
                isCurrent: isCurrent,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15.5,
                              height: 1.3,
                              color: locked && !done ? AppTheme.muted : AppTheme.text,
                            ),
                          ),
                        ),
                        if (isCurrent)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Сейчас',
                              style: TextStyle(
                                color: AppTheme.bg,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          )
                        else if (done)
                          const Icon(Icons.check_circle_rounded, color: AppTheme.bull, size: 20)
                        else if (locked)
                          const Icon(Icons.lock_outline_rounded, color: AppTheme.faint, size: 18),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppTheme.muted, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$moduleLabel · $meta',
                      style: const TextStyle(color: AppTheme.faint, fontSize: 12, height: 1.3),
                    ),
                    if (interactive || isTrial) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (interactive) _MetaPill(interactiveLabel, accent: true),
                          if (isTrial) _MetaPill(trialLabel, accent: true),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({
    required this.color,
    required this.number,
    required this.done,
    required this.locked,
    required this.isCurrent,
  });

  final Color color;
  final int number;
  final bool done;
  final bool locked;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final Color fg;
    final Color bg;
    if (isCurrent) {
      fg = AppTheme.bg;
      bg = color;
    } else if (done) {
      fg = AppTheme.bull;
      bg = AppTheme.bullSoft;
    } else if (locked) {
      fg = color.withValues(alpha: 0.6);
      bg = color.withValues(alpha: 0.08);
    } else {
      fg = color;
      bg = color.withValues(alpha: 0.16);
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$number',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: fg,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'урок',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: fg.withValues(alpha: 0.75),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill(this.text, {this.accent = false});

  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accent ? AppTheme.accent.withValues(alpha: 0.14) : AppTheme.surface3,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: accent ? AppTheme.accent.withValues(alpha: 0.35) : AppTheme.lineSoft,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: accent ? AppTheme.accent : AppTheme.muted,
        ),
      ),
    );
  }
}
