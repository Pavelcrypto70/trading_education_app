import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';



import '../data/lessons_repository.dart';

import '../models/lesson.dart';

import '../services/locale_service.dart';

import '../services/progress_service.dart';

import '../theme.dart';



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



  @override

  void initState() {

    super.initState();

    _futureLessons = _load();

  }



  Future<List<Lesson>> _load() async {

    _completed = await ProgressService.getCompletedLessons();

    return _repository.loadLessons();

  }



  Future<void> _refresh() async {

    setState(() {

      _futureLessons = _load();

    });

    await _futureLessons;

  }



  @override

  Widget build(BuildContext context) {

    final l10n = context.l10n;



    return Scaffold(

      appBar: AppBar(

        title: Text(l10n.learningPath),

        actions: [

          IconButton(

            onPressed: () => context.push('/flashcards'),

            icon: const Icon(Icons.style_outlined),

            tooltip: l10n.flashcards,

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



          final filtered = allLessons.where((lesson) {

            final moduleOk = _selectedModule == 'All' || lesson.module == _selectedModule;

            final searchOk = _searchQuery.isEmpty ||

                lesson.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||

                lesson.module.toLowerCase().contains(_searchQuery.toLowerCase());

            return moduleOk && searchOk;

          }).toList();



          final completedInView = filtered.where((l) => _completed.contains(l.id)).length;



          return RefreshIndicator(

            onRefresh: _refresh,

            child: CustomScrollView(

              physics: const AlwaysScrollableScrollPhysics(),

              slivers: [

                SliverToBoxAdapter(

                  child: Padding(

                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Container(

                          padding: const EdgeInsets.all(18),

                          decoration: AppTheme.heroGradient(),

                          child: Row(

                            children: [

                              Expanded(

                                child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [

                                    Text(

                                      l10n.completedCount(_completed.length, allLessons.length),

                                      style: const TextStyle(

                                        color: AppTheme.gold,

                                        fontWeight: FontWeight.w700,

                                      ),

                                    ),

                                    const SizedBox(height: 4),

                                    Text(

                                      filtered.isEmpty

                                          ? l10n.noLessonsFound

                                          : l10n.completedCount(completedInView, filtered.length),

                                      style: const TextStyle(color: Colors.white70, fontSize: 13),

                                    ),

                                  ],

                                ),

                              ),

                              SizedBox(

                                width: 56,

                                height: 56,

                                child: CircularProgressIndicator(

                                  value: allLessons.isEmpty

                                      ? 0

                                      : _completed.length / allLessons.length,

                                  strokeWidth: 5,

                                  color: AppTheme.gold,

                                  backgroundColor: Colors.white12,

                                ),

                              ),

                            ],

                          ),

                        ),

                        const SizedBox(height: 16),

                        TextField(

                          onChanged: (v) => setState(() => _searchQuery = v),

                          decoration: InputDecoration(

                            hintText: l10n.searchLessons,

                            prefixIcon: const Icon(Icons.search),

                          ),

                        ),

                        const SizedBox(height: 12),

                        SizedBox(

                          height: 40,

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

                                onSelected: (_) => setState(() => _selectedModule = module),

                              );

                            },

                          ),

                        ),

                        const SizedBox(height: 16),

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

                        final done = _completed.contains(lesson.id);

                        return Padding(

                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),

                          child: InkWell(

                            borderRadius: BorderRadius.circular(18),

                            onTap: () async {

                              await context.push('/lesson/${lesson.id}', extra: lesson);

                              _refresh();

                            },

                            child: Container(

                              padding: const EdgeInsets.all(16),

                              decoration: AppTheme.cardDecoration(

                                color: done ? AppTheme.gold.withValues(alpha: 0.06) : AppTheme.card,

                              ),

                              child: Row(

                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [

                                  Container(

                                    width: 44,

                                    height: 44,

                                    decoration: BoxDecoration(

                                      color: done

                                          ? AppTheme.gold.withValues(alpha: 0.2)

                                          : Colors.white.withValues(alpha: 0.06),

                                      borderRadius: BorderRadius.circular(12),

                                    ),

                                    child: Center(

                                      child: done

                                          ? const Icon(Icons.check, color: AppTheme.gold, size: 20)

                                          : Text('${lesson.id}', style: const TextStyle(fontWeight: FontWeight.w700)),

                                    ),

                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(

                                    child: Column(

                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [

                                        Text(

                                          lesson.title,

                                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),

                                        ),

                                        const SizedBox(height: 4),

                                        Text(

                                          lesson.subtitle,

                                          style: const TextStyle(color: Colors.white54, fontSize: 13),

                                        ),

                                        const SizedBox(height: 8),

                                        Wrap(

                                          spacing: 6,

                                          runSpacing: 6,

                                          children: [

                                            _chip(l10n.moduleName(lesson.module)),

                                            _chip(l10n.difficultyName(lesson.difficulty)),

                                            _chip('${lesson.durationMin} ${l10n.min}'),

                                            if (lesson.hasRichContent) _chip(l10n.interactive, accent: true),

                                          ],

                                        ),

                                      ],

                                    ),

                                  ),

                                  const Icon(Icons.chevron_right, color: Colors.white38),

                                ],

                              ),

                            ),

                          ),

                        );

                      },

                      childCount: filtered.length,

                    ),

                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

              ],

            ),

          );

        },

      ),

    );

  }



  Widget _chip(String text, {bool accent = false}) {

    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      decoration: BoxDecoration(

        color: accent ? AppTheme.accent.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.06),

        borderRadius: BorderRadius.circular(999),

      ),

      child: Text(text, style: TextStyle(fontSize: 11, color: accent ? AppTheme.accent : Colors.white70, fontWeight: accent ? FontWeight.w700 : FontWeight.normal)),

    );

  }

}


