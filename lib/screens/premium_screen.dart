import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';



import '../services/locale_service.dart';

import '../services/progress_service.dart';

import '../theme.dart';



class PremiumScreen extends StatefulWidget {

  const PremiumScreen({super.key});



  @override

  State<PremiumScreen> createState() => _PremiumScreenState();

}



class _PremiumScreenState extends State<PremiumScreen> {

  bool _isPremium = false;

  bool _loading = true;



  @override

  void initState() {

    super.initState();

    _load();

  }



  Future<void> _load() async {

    final premium = await ProgressService.isPremium();

    if (!mounted) return;

    setState(() {

      _isPremium = premium;

      _loading = false;

    });

  }



  Future<void> _activateTrial() async {

    final l10n = context.l10n;

    await ProgressService.setPremium(true);

    if (!mounted) return;

    setState(() => _isPremium = true);

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(content: Text(l10n.premiumActivated)),

    );

  }



  @override

  Widget build(BuildContext context) {

    final l10n = context.l10n;



    if (_loading) {

      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    }



    final features = [

      'All 47 practical lessons',

      'TradingView setup breakdowns',

      'LATAM / Brazil / Mexico market notes',

      'Hands-on practice every lesson',

      'Trade journal prompts',

      'Paper trading simulator',

    ];



    return Scaffold(

      appBar: AppBar(title: Text(l10n.premium)),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            if (_isPremium)

              Container(

                width: double.infinity,

                padding: const EdgeInsets.all(14),

                margin: const EdgeInsets.only(bottom: 16),

                decoration: BoxDecoration(

                  color: AppTheme.gold.withValues(alpha: 0.15),

                  borderRadius: BorderRadius.circular(14),

                  border: Border.all(color: AppTheme.gold.withValues(alpha: 0.4)),

                ),

                child: Row(

                  children: [

                    const Icon(Icons.check_circle, color: AppTheme.gold),

                    const SizedBox(width: 10),

                    Text(l10n.youHavePremium, style: const TextStyle(fontWeight: FontWeight.w600)),

                  ],

                ),

              ),

            Text(

              l10n.premiumTitle,

              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),

            ),

            const SizedBox(height: 8),

            Text(

              l10n.premiumSubtitle,

              style: const TextStyle(color: Colors.white54),

            ),

            const SizedBox(height: 22),

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(22),

              decoration: AppTheme.heroGradient(),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Text(

                    '\$4.99 / month',

                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.gold),

                  ),

                  const Text('7-day free trial · Cancel anytime', style: TextStyle(color: Colors.white54)),

                  const SizedBox(height: 18),

                  ...features.map(

                    (f) => Padding(

                      padding: const EdgeInsets.only(bottom: 10),

                      child: Row(

                        children: [

                          const Icon(Icons.check, color: Colors.greenAccent, size: 20),

                          const SizedBox(width: 10),

                          Expanded(child: Text(f, style: const TextStyle(fontSize: 14))),

                        ],

                      ),

                    ),

                  ),

                ],

              ),

            ),

            const Spacer(),

            if (!_isPremium) ...[

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: _activateTrial,

                  child: Text(l10n.activatePremium),

                ),

              ),

            ] else

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: () => context.pop(),

                  child: Text(l10n.continueLearning),

                ),

              ),

            const SizedBox(height: 8),

            Center(

              child: TextButton(

                onPressed: () => context.pop(),

                child: Text(l10n.cancel),

              ),

            ),

            const SizedBox(height: 8),

            const Text(

              'For store builds: connect in_app_purchase for real billing. '

              'This demo activates premium locally.',

              style: TextStyle(color: Colors.white24, fontSize: 11),

              textAlign: TextAlign.center,

            ),

          ],

        ),

      ),

    );

  }

}


