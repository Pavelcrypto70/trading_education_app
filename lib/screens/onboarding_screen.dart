import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';



import '../services/locale_service.dart';

import '../theme.dart';



class OnboardingScreen extends StatelessWidget {

  const OnboardingScreen({super.key});



  @override

  Widget build(BuildContext context) {

    final l10n = context.l10n;



    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

            colors: [Color(0xFF0B0D12), Color(0xFF1B1F29), Color(0xFF2D1B69)],

          ),

        ),

        child: SafeArea(

          child: Padding(

            padding: const EdgeInsets.all(24),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 32),

                Container(

                  width: 72,

                  height: 72,

                  decoration: BoxDecoration(

                    color: AppTheme.gold.withValues(alpha: 0.15),

                    borderRadius: BorderRadius.circular(22),

                    border: Border.all(color: AppTheme.gold.withValues(alpha: 0.4)),

                  ),

                  child: const Icon(Icons.trending_up, color: AppTheme.gold, size: 38),

                ),

                const Spacer(),

                Text(

                  l10n.appName,

                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(

                        color: AppTheme.gold,

                        fontWeight: FontWeight.w700,

                      ),

                ),

                const SizedBox(height: 12),

                Text(

                  l10n.welcomeTitle,

                  style: Theme.of(context).textTheme.displaySmall?.copyWith(

                        fontWeight: FontWeight.w800,

                        height: 1.1,

                      ),

                ),

                const SizedBox(height: 16),

                Text(

                  l10n.welcomeSubtitle,

                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(

                        color: Colors.white70,

                        height: 1.5,

                      ),

                ),

                const Spacer(),

                SizedBox(

                  width: double.infinity,

                  child: ElevatedButton(

                    onPressed: () => context.go('/onboarding/goal'),

                    child: Text(l10n.getStarted),

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


