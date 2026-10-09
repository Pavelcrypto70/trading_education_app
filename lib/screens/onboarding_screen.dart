import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/locale_service.dart';
import '../theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          Positioned(
            top: -180,
            left: -120,
            child: _Glow(color: AppTheme.accent.withValues(alpha: 0.32)),
          ),
          Positioned(
            top: 120,
            right: -180,
            child: _Glow(color: AppTheme.pink.withValues(alpha: 0.18)),
          ),
          Positioned(
            bottom: -220,
            right: -140,
            child: _Glow(color: AppTheme.mint.withValues(alpha: 0.2)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: AppTheme.brandGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accent.withValues(alpha: 0.45),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.show_chart_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    l10n.appName,
                    style: textTheme.labelLarge?.copyWith(
                      color: AppTheme.accent,
                      letterSpacing: 1.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Трейдинг с нуля —\nдо реального счёта',
                    style: AppTheme.display(34).copyWith(height: 1.1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Короткие уроки на графике, очки и огоньки за каждый день, ладер и закрытые чаты Desk Club с ментором.',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppTheme.muted,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'ШАГ 1 ИЗ 2 · ЯЗЫК',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppTheme.faint,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListenableBuilder(
                    listenable: LocaleService.instance,
                    builder: (context, _) => _LanguageGrid(
                      onSelected: (code) => LocaleService.instance
                          .setLanguage(AppLanguage.fromCode(code)),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => context.go('/onboarding/goal'),
                      child: const Text('Дальше'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Без регистрации · 14 уроков бесплатно',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppTheme.faint,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => context.go('/auth'),
                      child: const Text('У меня уже есть аккаунт'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Обучение, не финансовый совет. 18+',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppTheme.faint,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 420,
        height: 420,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _LanguageGrid extends StatelessWidget {
  const _LanguageGrid({required this.onSelected});

  final ValueChanged<String> onSelected;

  static const _langs = [
    ('Русский', 'ru'),
    ('English', 'en'),
    ('Español', 'es'),
    ('Português', 'pt'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = LocaleService.instance.languageCode;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 3.2,
      children: [
        for (final (name, code) in _langs)
          _LangChip(
            name: name,
            code: code.toUpperCase(),
            selected: current == code,
            onTap: () => onSelected(code),
          ),
      ],
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.name,
    required this.code,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String code;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accentDim : AppTheme.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppTheme.accent : AppTheme.lineSoft,
          ),
        ),
        child: Row(
          children: [
            Text(
              name,
              style: TextStyle(
                color: selected ? AppTheme.accent : AppTheme.text,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            Text(
              code,
              style: const TextStyle(
                color: AppTheme.faint,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
