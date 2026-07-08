import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';



import '../services/locale_service.dart';



class HomeShell extends StatelessWidget {

  final Widget child;



  const HomeShell({super.key, required this.child});



  @override

  Widget build(BuildContext context) {

    final location = GoRouterState.of(context).uri.toString();

    final l10n = context.l10n;



    return Scaffold(

      body: child,

      bottomNavigationBar: NavigationBar(

        selectedIndex: _indexFromLocation(location),

        onDestinationSelected: (index) {

          switch (index) {

            case 0:

              context.go('/');

              break;

            case 1:

              context.go('/learning');

              break;

            case 2:

              context.go('/quiz');

              break;

            case 3:

              context.go('/practice');

              break;

            case 4:

              context.go('/profile');

              break;

          }

        },

        destinations: [

          NavigationDestination(

            icon: const Icon(Icons.home_outlined),

            selectedIcon: const Icon(Icons.home),

            label: l10n.navHome,

          ),

          NavigationDestination(

            icon: const Icon(Icons.school_outlined),

            selectedIcon: const Icon(Icons.school),

            label: l10n.navLearn,

          ),

          NavigationDestination(

            icon: const Icon(Icons.quiz_outlined),

            selectedIcon: const Icon(Icons.quiz),

            label: l10n.navQuiz,

          ),

          NavigationDestination(

            icon: const Icon(Icons.candlestick_chart_outlined),

            selectedIcon: const Icon(Icons.candlestick_chart),

            label: l10n.navPractice,

          ),

          NavigationDestination(

            icon: const Icon(Icons.person_outline),

            selectedIcon: const Icon(Icons.person),

            label: l10n.navProfile,

          ),

        ],

      ),

    );

  }



  int _indexFromLocation(String location) {

    if (location.startsWith('/learning')) return 1;

    if (location.startsWith('/quiz')) return 2;

    if (location.startsWith('/practice')) return 3;

    if (location.startsWith('/profile')) return 4;

    return 0;

  }

}

