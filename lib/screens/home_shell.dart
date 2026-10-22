import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/locale_service.dart';
import '../theme.dart';

class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final location = GoRouterState.of(context).uri.toString();
    final index = _indexFromLocation(location);
    final tabs = [
      _Tab('/', l10n.navPath, Icons.route_outlined, Icons.route, AppTheme.accent),
      _Tab('/learning', l10n.navLessons, Icons.menu_book_outlined, Icons.menu_book, AppTheme.mint),
      _Tab('/practice', l10n.navPractice, Icons.candlestick_chart_outlined, Icons.candlestick_chart, AppTheme.orange),
      _Tab('/club', l10n.navClub, Icons.forum_outlined, Icons.forum, AppTheme.sky),
      _Tab('/profile', l10n.navProfile, Icons.person_outline, Icons.person, AppTheme.pink),
    ];

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.bg2,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Row(
              children: [
                for (var i = 0; i < tabs.length; i++)
                  _NavItem(
                    tab: tabs[i],
                    selected: index == i,
                    onTap: () => context.go(tabs[i].route),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _indexFromLocation(String location) {
    if (location.startsWith('/learning')) return 1;
    if (location.startsWith('/practice')) return 2;
    if (location.startsWith('/club')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }
}

class _Tab {
  const _Tab(this.route, this.label, this.icon, this.selectedIcon, this.color);

  final String route;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Color color;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _Tab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : AppTheme.muted;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: tab.label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: selected
                ? AppTheme.claySquare(AppTheme.accent, radius: 16)
                : const BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(selected ? tab.selectedIcon : tab.icon, size: 23, color: color),
                const SizedBox(height: 4),
                Text(
                  tab.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
