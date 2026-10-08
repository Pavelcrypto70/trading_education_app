import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '_jwidgets.dart';

/// Journey screen 15 · #intro в Academy (Telegram-мок).
class AcademyIntroScreen extends StatelessWidget {
  const AcademyIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return JourneyScaffold(
      stepLabel: 'Экран 15',
      title: 'Представьтесь в #intro',
      subtitle:
          'Один короткий пост: откуда вы, чем торгуете сейчас и чего ждёте от Trade Master.',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: TelegramChatMock(
          channelTitle: '#intro',
          messages: const [
            TgMessage(
              author: 'Ментор Desk Club',
              text:
                  'Добро пожаловать в Academy. В #intro — представьтесь: город, опыт, инструмент (спотовый или фьючерсный рынок). Без ссылок на сигналы.',
            ),
            TgMessage(
              author: 'Алексей',
              text:
                  'Москва · торгую биткоин на спотовом рынке полгода · хочу систему риска и проверку домашек',
              outgoing: true,
            ),
            TgMessage(
              author: 'Бот Trade Master',
              text: 'Привязка подтверждена. Пункт «#intro» в воротах обновится в приложении.',
              tag: '#intro ✓',
            ),
          ],
        ),
      ),
      bottom: Column(
        children: [
          TmPrimaryButton(
            label: 'К домашке ступени 1',
            onPressed: () => context.push('/homework/s1'),
          ),
          TmGhostButton(
            label: 'Вернуться к воротам',
            onPressed: () => context.push('/gates'),
          ),
        ],
      ),
    );
  }
}
