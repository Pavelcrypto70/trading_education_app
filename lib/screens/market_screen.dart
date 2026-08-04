import 'package:flutter/material.dart';

import '../services/locale_service.dart';
import '../theme.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  static const _conceptKeys = [
    _ConceptKey(
      titleEn: 'What moves price?',
      titleRu: 'Что двигает цену?',
      titlePt: 'O que move o preço?',
      titleEs: '¿Qué mueve el precio?',
      bodyEn:
          'Price changes when buyers and sellers disagree on value. More buyers push price up; more sellers push it down.',
      bodyRu:
          'Цена меняется, когда покупатели и продавцы не согласны в оценке. Больше покупателей — цена растёт; больше продавцов — падает.',
      bodyPt:
          'O preço muda quando compradores e vendedores discordam sobre o valor. Mais compradores elevam o preço; mais vendedores o derrubam.',
      bodyEs:
          'El precio cambia cuando compradores y vendedores no coinciden en el valor. Más compradores suben el precio; más vendedores lo bajan.',
      icon: Icons.swap_vert,
    ),
    _ConceptKey(
      titleEn: 'Bull vs Bear market',
      titleRu: 'Бычий vs медвежий рынок',
      titlePt: 'Mercado de alta vs baixa',
      titleEs: 'Mercado alcista vs bajista',
      bodyEn:
          'A bull market trends upward with optimism. A bear market trends downward with pessimism. Most traders adapt strategy to the environment.',
      bodyRu:
          'Бычий рынок растёт на оптимизме. Медвежий — падает на пессимизме. Большинство трейдеров адаптируют стратегию под среду.',
      bodyPt:
          'Um mercado de alta sobe com otimismo. Um de baixa cai com pessimismo. A maioria dos traders adapta a estratégia ao ambiente.',
      bodyEs:
          'Un mercado alcista sube con optimismo. Uno bajista cae con pesimismo. La mayoría adapta la estrategia al entorno.',
      icon: Icons.trending_up,
    ),
    _ConceptKey(
      titleEn: 'Volatility',
      titleRu: 'Волатильность',
      titlePt: 'Volatilidade',
      titleEs: 'Volatilidad',
      bodyEn:
          'Volatility measures how fast and how far price moves. High volatility means bigger swings — more opportunity and more risk.',
      bodyRu:
          'Волатильность показывает, насколько быстро и далеко движется цена. Высокая волатильность — больше возможностей и риска.',
      bodyPt:
          'Volatilidade mede quão rápido e quão longe o preço se move. Alta volatilidade significa maiores oscilações — mais oportunidade e risco.',
      bodyEs:
          'La volatilidad mide qué tan rápido y lejos se mueve el precio. Alta volatilidad = mayores swings: más oportunidad y más riesgo.',
      icon: Icons.show_chart,
    ),
    _ConceptKey(
      titleEn: 'Liquidity',
      titleRu: 'Ликвидность',
      titlePt: 'Liquidez',
      titleEs: 'Liquidez',
      bodyEn:
          'Liquidity is how easily you can buy or sell without moving price. Major markets like EUR/USD or S&P 500 tend to have high liquidity.',
      bodyRu:
          'Ликвидность — насколько легко купить или продать без сдвига цены. Крупные рынки вроде EUR/USD или S&P 500 обычно высоколиквидны.',
      bodyPt:
          'Liquidez é quão facilmente você pode comprar ou vender sem mover o preço. Mercados como EUR/USD ou S&P 500 tendem a ter alta liquidez.',
      bodyEs:
          'La liquidez es qué tan fácil puedes comprar o vender sin mover el precio. Mercados como EUR/USD o S&P 500 suelen ser muy líquidos.',
      icon: Icons.water_drop_outlined,
    ),
    _ConceptKey(
      titleEn: 'Market sessions',
      titleRu: 'Торговые сессии',
      titlePt: 'Sessões de mercado',
      titleEs: 'Sesiones de mercado',
      bodyEn:
          'Asian, European, and US sessions have different activity levels. Volatility often increases when sessions overlap.',
      bodyRu:
          'Азиатская, европейская и американская сессии отличаются активностью. Волатильность часто растёт при их пересечении.',
      bodyPt:
          'Sessões asiática, europeia e americana têm níveis diferentes de atividade. A volatilidade costuma aumentar quando se sobrepõem.',
      bodyEs:
          'Las sesiones asiática, europea y estadounidense tienen distinta actividad. La volatilidad suele subir cuando se solapan.',
      icon: Icons.schedule,
    ),
    _ConceptKey(
      titleEn: 'Spread',
      titleRu: 'Спред',
      titlePt: 'Spread',
      titleEs: 'Spread',
      bodyEn:
          'The spread is the gap between buy and sell price. It is a cost of trading — tighter spreads mean lower friction.',
      bodyRu:
          'Спред — разница между ценой покупки и продажи. Это стоимость торговли — меньший спред означает меньше издержек.',
      bodyPt:
          'O spread é a diferença entre preço de compra e venda. É um custo de trading — spreads menores significam menos atrito.',
      bodyEs:
          'El spread es la diferencia entre compra y venta. Es un costo de trading: spreads más estrechos = menos fricción.',
      icon: Icons.compare_arrows,
    ),
    _ConceptKey(
      titleEn: 'Indices & ETFs',
      titleRu: 'Индексы и ETF',
      titlePt: 'Índices e ETFs',
      titleEs: 'Índices y ETFs',
      bodyEn:
          'Indices track groups of stocks (e.g. S&P 500). ETFs let you trade a basket in one instrument — useful for diversification.',
      bodyRu:
          'Индексы отслеживают группы акций (напр. S&P 500). ETF позволяют торговать корзиной в одном инструменте — удобно для диверсификации.',
      bodyPt:
          'Índices acompanham grupos de ações (ex. S&P 500). ETFs permitem operar uma cesta em um instrumento — útil para diversificação.',
      bodyEs:
          'Los índices siguen grupos de acciones (p. ej. S&P 500). Los ETFs permiten operar una canasta en un instrumento — útiles para diversificar.',
      icon: Icons.pie_chart_outline,
    ),
    _ConceptKey(
      titleEn: 'Forex basics',
      titleRu: 'Основы Forex',
      titlePt: 'Noções de Forex',
      titleEs: 'Conceptos de Forex',
      bodyEn:
          'Forex trades currency pairs like EUR/USD. It is the largest market by volume and operates nearly 24 hours on weekdays.',
      bodyRu:
          'Forex торгует валютными парами вроде EUR/USD. Это крупнейший рынок по объёму, работает почти 24 часа в будни.',
      bodyPt:
          'Forex opera pares de moedas como EUR/USD. É o maior mercado em volume e funciona quase 24 horas nos dias úteis.',
      bodyEs:
          'Forex opera pares de divisas como EUR/USD. Es el mercado más grande por volumen y opera casi 24 horas entre semana.',
      icon: Icons.currency_exchange,
    ),
    _ConceptKey(
      titleEn: 'Risk disclaimer',
      titleRu: 'Предупреждение о рисках',
      titlePt: 'Aviso de risco',
      titleEs: 'Aviso de riesgo',
      bodyEn:
          'Trading involves substantial risk. This app is for education only — never trade with money you cannot afford to lose.',
      bodyRu:
          'Трейдинг связан с существенным риском. Это приложение только для обучения — не торгуйте деньгами, которые не можете потерять.',
      bodyPt:
          'Trading envolve risco substancial. Este app é apenas educacional — nunca opere com dinheiro que não pode perder.',
      bodyEs:
          'El trading implica riesgo sustancial. Esta app es solo educativa — nunca operes con dinero que no puedas perder.',
      icon: Icons.warning_amber_outlined,
    ),
  ];

  String _t(AppLanguage lang, String en, String ru, String pt, String es) {
    switch (lang) {
      case AppLanguage.ru:
        return ru;
      case AppLanguage.pt:
        return pt;
      case AppLanguage.es:
        return es;
      case AppLanguage.en:
        return en;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = LocaleService.instance.language;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.marketConceptsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Text(
            l10n.marketConceptsIntro,
            style: const TextStyle(color: Colors.white70, height: 1.45),
          ),
          const SizedBox(height: 16),
          ..._conceptKeys.map((c) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.cardDecoration(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(c.icon, color: AppTheme.accent, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _t(lang, c.titleEn, c.titleRu, c.titlePt, c.titleEs),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _t(lang, c.bodyEn, c.bodyRu, c.bodyPt, c.bodyEs),
                          style: const TextStyle(
                            color: Colors.white60,
                            height: 1.45,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ConceptKey {
  final String titleEn;
  final String titleRu;
  final String titlePt;
  final String titleEs;
  final String bodyEn;
  final String bodyRu;
  final String bodyPt;
  final String bodyEs;
  final IconData icon;

  const _ConceptKey({
    required this.titleEn,
    required this.titleRu,
    required this.titlePt,
    required this.titleEs,
    required this.bodyEn,
    required this.bodyRu,
    required this.bodyPt,
    required this.bodyEs,
    required this.icon,
  });
}
