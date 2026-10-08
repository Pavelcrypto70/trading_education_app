import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme.dart';
import '_jwidgets.dart';

/// Journey screen 19 · Ключ Desk Club (страница сайта в приложении).
class KeyLandingScreen extends StatelessWidget {
  const KeyLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return JourneyScaffold(
      stepLabel: 'Экран 19',
      title: 'Ключ Desk Club',
      showBack: true,
      subtitle:
          'Ступень 1 пройдена · 9 из 10. Откройте курс целиком: ещё 44 урока, домашки с разбором, диплом и программа 30 дней.',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          WebPageChrome(
            urlBar: 'https://desk.club/trade-master/key',
            child: TmCard(
              accent: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.bullSoft,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.bull.withValues(alpha: 0.4)),
                    ),
                    child: const Text(
                      'БЕСПЛАТНО',
                      style: TextStyle(
                        color: AppTheme.bull,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Регистрация на Tiger.com по ссылке Desk Club',
                    style: TextStyle(
                      color: AppTheme.text,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Депозит не нужен до ступени 5. Кэшбэк с комиссий. Мы получаем долю комиссий брокера — это указано честно рядом с кнопкой.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '\$9.99 в месяц — без брокера',
                  style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Если реферальная программа недоступна или UID не находится.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
      bottom: Column(
        children: [
          TmPrimaryButton(
            label: 'Получить ключ',
            onPressed: () => context.push('/key/register'),
          ),
          TmGhostButton(
            label: 'Купить доступ',
            onPressed: () => context.push('/subscribe'),
          ),
        ],
      ),
    );
  }
}

/// Journey screen 20 · Регистрация + User ID.
class KeyRegisterScreen extends StatefulWidget {
  const KeyRegisterScreen({super.key});

  @override
  State<KeyRegisterScreen> createState() => _KeyRegisterScreenState();
}

class _KeyRegisterScreenState extends State<KeyRegisterScreen> {
  final _uidController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _uidController.dispose();
    super.dispose();
  }

  Future<void> _openRefLink() async {
    final uri = Uri.parse('https://tiger.com/signup?ref=DESKCLUB');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _submit() async {
    if (_uidController.text.trim().length < 4) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _loading = false);
    // Demo: even UID -> active, odd -> not found
    final last = _uidController.text.trim().codeUnitAt(_uidController.text.trim().length - 1);
    if (last.isEven) {
      context.push('/key/active');
    } else {
      context.push('/key/not-found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return JourneyScaffold(
      stepLabel: 'Экран 20',
      title: 'User ID и проверка',
      subtitle:
          'KYC пока не нужен — понадобится на ступени 5 вместе с двухфакторной аутентификацией и верификацией личности.',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          WebPageChrome(
            urlBar: 'https://desk.club/trade-master/register',
            child: Column(
              children: const [
                TmStatRow(
                  icon: Icons.open_in_new,
                  title: 'Шаг 1',
                  subtitle: 'Откройте ссылку Desk Club → Sign up в Tiger.com Broker',
                ),
                SizedBox(height: 12),
                TmStatRow(
                  icon: Icons.mail_outline,
                  title: 'Шаг 2',
                  subtitle: 'Почта и пароль → подтвердите письмо',
                ),
                SizedBox(height: 12),
                TmStatRow(
                  icon: Icons.badge_outlined,
                  title: 'Шаг 3',
                  subtitle: 'Профиль → скопируйте User ID',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _uidController,
                  decoration: const InputDecoration(
                    labelText: 'Tiger User ID',
                    hintText: 'Вставьте User ID из профиля',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Статус после отправки: «На проверке» — обычно до 24 часов.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TmCard(
            child: Text(
              'Уже есть аккаунт Tiger? Referral program → код Desk Club → Apply. Если поле закрыто — письмо на broker.support@tiger.com с просьбой привязать реферальную программу.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
      bottom: Column(
        children: [
          TmPrimaryButton(
            label: 'Отправить на проверку',
            loading: _loading,
            onPressed: _submit,
          ),
          TmGhostButton(
            label: 'Открыть ссылку регистрации',
            onPressed: _openRefLink,
          ),
        ],
      ),
    );
  }
}

/// Journey screen 21 · User ID не найден.
class KeyNotFoundScreen extends StatelessWidget {
  const KeyNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return JourneyScaffold(
      stepLabel: 'Экран 21',
      title: 'User ID не найден',
      subtitle:
          'User ID не найден среди рефералов Desk Club. Частая причина — регистрация не по ссылке клуба.',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          TmCard(
            accent: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Три выхода',
                  style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                _ExitTile(
                  title: 'Referral program',
                  subtitle: 'Привяжите код Desk Club в кабинете Tiger',
                ),
                _ExitTile(
                  title: 'Поддержка Tiger',
                  subtitle: 'Шаблон письма с просьбой привязать реферальную программу',
                ),
                _ExitTile(
                  title: 'Опечатка',
                  subtitle: 'Проверьте User ID в профиле и отправьте повторно',
                ),
              ],
            ),
          ),
        ],
      ),
      bottom: Column(
        children: [
          TmPrimaryButton(
            label: 'Отправить повторно',
            onPressed: () => context.push('/key/register'),
          ),
          TmGhostButton(
            label: 'Взять подписку \$9.99',
            onPressed: () => context.push('/subscribe'),
          ),
        ],
      ),
    );
  }
}

class _ExitTile extends StatelessWidget {
  const _ExitTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_forward, color: AppTheme.accent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: AppTheme.text, fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppTheme.muted, fontSize: 13, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Journey screen 22 · Ключ активен.
class KeyActiveScreen extends StatelessWidget {
  const KeyActiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return JourneyScaffold(
      stepLabel: 'Экран 22',
      title: 'Ключ активен',
      subtitle: 'Курс открыт целиком. Ступень 5 «Реальный счёт» — после экзамена и чеклиста.',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          TmCard(
            accent: true,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.bull.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified, color: AppTheme.bull, size: 28),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'access_tier · ref_verified',
                        style: TextStyle(
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Ступени 2–4, бумажная торговля, журнал, домашки с разбором',
                        style: TextStyle(color: AppTheme.text, height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const TmCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Пока закрыто',
                  style: TextStyle(color: AppTheme.muted, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  'Ступень 5 — реальный счёт, верификация личности, двухфакторная аутентификация и программа 30 дней.',
                  style: TextStyle(color: AppTheme.faint, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
      bottom: TmPrimaryButton(
        label: 'Начать ступень 2',
        onPressed: () => context.go('/learning-path'),
      ),
    );
  }
}
