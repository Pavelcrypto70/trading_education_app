import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '_jwidgets.dart';

/// Journey screen 17 · #homework · проверка (Telegram-мок).
class HomeworkReviewScreen extends StatelessWidget {
  const HomeworkReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return JourneyScaffold(
      stepLabel: 'Экран 17',
      title: 'Домашка проверена',
      subtitle: 'Ступень 1 закрыта — в приложении откроется ключ Desk Club.',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: TelegramChatMock(
          channelTitle: '#homework',
          messages: const [
            TgMessage(
              author: 'Вы',
              text:
                  'TM · L14 · #s1\n\nОдной фразой: свеча — борьба за период, смотрю на закрытие.\n\nСделай: тренд вверх, откат — да, стоп ниже зоны.',
              outgoing: true,
            ),
            TgMessage(
              author: 'Desk Trader · Маша',
              text:
                  'Фраза своими словами — ок. На графике верно отметили зону. Добавьте в следующий раз размер 1R в пунктах.',
              tag: '#hw-passed 9/10',
            ),
            TgMessage(
              author: 'Бот Trade Master',
              text:
                  'Домашка принята. Ступень 1 пройдена — откройте ключ в приложении.',
            ),
          ],
        ),
      ),
      bottom: Column(
        children: [
          TmPrimaryButton(
            label: 'Получить ключ Desk Club',
            onPressed: () => context.push('/key'),
          ),
          TmGhostButton(
            label: 'Платный доступ без брокера',
            onPressed: () => context.push('/subscribe'),
          ),
        ],
      ),
    );
  }
}
