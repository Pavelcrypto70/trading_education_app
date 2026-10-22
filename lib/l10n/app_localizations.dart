import '../services/locale_service.dart';
import '../utils/num_format.dart';

class AppLocalizations {
  final AppLanguage locale;

  AppLocalizations(this.locale);

  // ── Navigation ──
  String get navHome => _t(
        'Home',
        'Главная',
        'Início',
        'Inicio',
      );
  String get navPath => _t(
        'Path',
        'Путь',
        'Caminho',
        'Camino',
      );
  String get navLearn => _t(
        'Learn',
        'Обучение',
        'Aprender',
        'Aprender',
      );
  String get navLessons => _t(
        'Lessons',
        'Уроки',
        'Aulas',
        'Lecciones',
      );
  String get navQuiz => _t(
        'Quiz',
        'Тесты',
        'Quiz',
        'Quiz',
      );
  String get navPractice => _t(
        'Practice',
        'Практика',
        'Prática',
        'Práctica',
      );
  String get navClub => _t(
        'Club',
        'Клуб',
        'Clube',
        'Club',
      );
  String get navProfile => _t(
        'Profile',
        'Профиль',
        'Perfil',
        'Perfil',
      );

  // ── Common ──
  String get appName => 'Trade Master';
  String get cancel => _t(
        'Cancel',
        'Отмена',
        'Cancelar',
        'Cancelar',
      );
  String get continueBtn => _t(
        'Continue',
        'Продолжить',
        'Continuar',
        'Continuar',
      );
  String get reset => _t(
        'Reset',
        'Сбросить',
        'Redefinir',
        'Restablecer',
      );
  String get all => _t(
        'All',
        'Все',
        'Todos',
        'Todos',
      );
  String get error => _t(
        'Error',
        'Ошибка',
        'Erro',
        'Error',
      );
  String get done => _t(
        'Done',
        'Готово',
        'Feito',
        'Listo',
      );
  String get newBadge => _t(
        'New',
        'Новое',
        'Novo',
        'Nuevo',
      );
  String get min => _t(
        'min',
        'мин',
        'min',
        'mín.',
      );
  String get days => _t(
        'days',
        'дн.',
        'dias',
        'días',
      );
  String get dayShort => _t(
        'd',
        'д',
        'd',
        'd',
      );

  // ── Home ──
  String get keepBuildingEdge => _t(
        'Keep building your edge',
        'Развивай своё преимущество',
        'Continue construindo sua vantagem',
        'Sigue construyendo tu ventaja',
      );
  String percentComplete(int p) => _t(
        '$p% complete',
        '$p% пройдено',
        '$p% concluído',
        '$p% completado',
      );
  String lessonsCompleted(int done, int total) =>
      _t(
        '$done of $total lessons completed',
        '$done из $total уроков пройдено',
        '$done de $total aulas concluídas',
        '\$hecho de $total de lecciones completadas',
      );
  String get streak => _t(
        'Streak',
        'Серия',
        'Sequência',
        'Racha',
      );
  String get lessons => _t(
        'Lessons',
        'Уроки',
        'Aulas',
        'Lecciones',
      );
  String get continueLearning => _t(
        'Continue learning',
        'Продолжить обучение',
        'Continuar aprendendo',
        'Continuar aprendiendo',
      );
  String get interactiveTraining => _t(
        'Interactive training',
        'Интерактивное обучение',
        'Treinamento interativo',
        'Entrenamiento interactivo',
      );
  String get dailyChallenge => _t(
        'Daily Challenge',
        'Задание дня',
        'Desafio Diário',
        'Desafío diario',
      );
  String dailyChallengeDone(int score) =>
      _t(
        'Completed today — $score/5 correct',
        'Сегодня пройдено — верных ответов: $score из 5',
        'Concluído hoje — $score/5 corretas',
        'Completado hoy: $score/5 correcto',
      );
  String get dailyChallengeNew => _t(
        '5 questions · test yourself today',
        '5 вопросов · проверь себя',
        '5 perguntas · teste-se hoje',
        '5 preguntas · ponte a prueba hoy',
      );
  String get flashcards => _t(
        'Flashcards',
        'Карточки',
        'Cartões Flash',
        'Tarjetas didácticas',
      );
  String get flashcardsSubtitle => _t(
        'Review key takeaways from lessons',
        'Повтори ключевые выводы из уроков',
        'Revise os pontos-chave das aulas',
        'Revise las conclusiones clave de las lecciones',
      );
  String get paperTrading => _t(
        'Paper Trading',
        'Учебная биржа',
        'Trading Simulado',
        'Trading simulado',
      );
  String get paperTradingSubtitle => _t(
        'Practice buy & sell with virtual money',
        'Тренируйся покупать и продавать на учебные деньги',
        'Pratique compra e venda com dinheiro virtual',
        'Practica compra y venta con dinero virtual',
      );
  String get explore => _t(
        'Explore',
        'Изучить',
        'Explorar',
        'Explorar',
      );
  String get marketConcepts => _t(
        'Market concepts',
        'Как устроен рынок',
        'Conceitos de mercado',
        'Conceptos de mercado',
      );
  String get marketConceptsSubtitle => _t(
        'Learn how markets work',
        'Узнай, как работают рынки',
        'Aprenda como os mercados funcionam',
        'Aprenda cómo funcionan los mercados',
      );
  String get learningActivity => _t(
        'Learning activity',
        'Активность обучения',
        'Atividade de aprendizado',
        'Actividad de aprendizaje',
      );
  String get weeklyMomentum => _t(
        'Your weekly momentum',
        'Твоя учёба за неделю',
        'Seu momentum semanal',
        'Tu impulso semanal',
      );
  String get yourTradingJourney => _t(
        'Your trading journey',
        'Твой торговый путь',
        'Sua jornada de trading',
        'Su viaje comercial',
      );
  String get learningFromScratch => _t(
        'Learning from scratch',
        'Обучение с нуля',
        'Aprendendo do zero',
        'Aprendiendo desde cero',
      );
  String get demoTradingFocus => _t(
        'Demo trading focus',
        'Упор на учебные сделки',
        'Foco de negociação de demonstração',
        'Enfoque comercial de demostración',
      );
  String get knowledgeTesting => _t(
        'Knowledge testing',
        'Проверка знаний',
        'Teste de conhecimento',
        'Pruebas de conocimiento',
      );
  String get buildingDiscipline => _t(
        'Building discipline',
        'Развитие дисциплины',
        'Construindo disciplina',
        'Construyendo disciplina',
      );

  // ── Learning ──
  String get learningPath => _t(
        'Learning path',
        'Путь обучения',
        'Trilha de aprendizado',
        'Camino de aprendizaje',
      );
  String lessonsInOrder(int n) => _t(
        '$n lessons in order',
        '$n уроков по порядку',
        '$n aulas em ordem',
        '$n lecciones en orden',
      );
  String completedCount(int done, int total) =>
      _t(
        '$done/$total completed',
        'пройдено $done из $total',
        '$done/$total concluído',
        '\$hecho/$total completado',
      );
  String get searchLessons => _t(
        'Search lessons...',
        'Поиск уроков...',
        'Buscar aulas...',
        'Buscar lecciones...',
      );
  String get noLessonsFound => _t(
        'No lessons found',
        'Уроки не найдены',
        'Nenhuma aula encontrada',
        'No se encontraron lecciones',
      );
  String lessonNumber(int id) => _t(
        'Lesson $id',
        'Урок $id',
        'Aula $id',
        'Lección $id',
      );

  // ── Lesson ──
  String get lessonNotFound => _t(
        'Lesson not found',
        'Урок не найден',
        'Aula não encontrada',
        'Lección no encontrada',
      );
  String get whatYouWillLearn => _t(
        'What you will learn',
        'Что ты узнаешь',
        'O que você vai aprender',
        'lo que aprenderás',
      );
  String get lessonContent => _t(
        'Lesson content',
        'Содержание урока',
        'Conteúdo da aula',
        'Contenido de la lección',
      );
  String get keyTakeaway => _t(
        'In one sentence',
        'Запомни',
        'Em uma frase',
        'En una frase',
      );
  String get markComplete => _t(
        'Mark as complete',
        'Отметить как пройденный',
        'Marcar como concluída',
        'Marcar como completo',
      );
  String get nextLesson => _t(
        'Next lesson',
        'Следующий урок',
        'Próxima aula',
        'Próxima lección',
      );
  String get completeAndContinue => _t(
        'Complete & continue',
        'Завершить и продолжить',
        'Concluir e continuar',
        'Completar y continuar',
      );
  String get reviewFlashcards => _t(
        'Review flashcards',
        'Повторить карточки',
        'Revisar flashcards',
        'Revisar tarjetas didácticas',
      );
  String get lessonMarkedComplete => _t(
        'Lesson marked as complete',
        'Урок отмечен как пройденный',
        'Aula marcada como concluída',
        'Lección marcada como completa',
      );
  String get sectionIntroduction => _t(
        'Introduction',
        'Введение',
        'Introdução',
        'Introducción',
      );
  String get sectionCoreConcept => _t(
        'Core concept',
        'Главная мысль',
        'Conceito principal',
        'Concepto central',
      );
  String get sectionChartExample => _t(
        'Chart example',
        'Пример на графике',
        'Exemplo no gráfico',
        'Ejemplo de gráfico',
      );
  String get visualExampleTitle => _t(
        'What this looks like',
        'Как это выглядит',
        'Como isso aparece',
        '¿Cómo se ve esto?',
      );
  String get visualExampleCaption => _t(
        'Visual example for this lesson — look at the shape before you read on.',
        'Визуальный пример этого урока — сначала смотрите фигуру, потом читайте дальше.',
        'Exemplo visual desta aula — veja a figura antes de continuar a ler.',
        'Ejemplo visual para esta lección: observe la forma antes de seguir leyendo.',
      );
  String get sectionPracticalScenario => _t(
        'Practical scenario',
        'Практический сценарий',
        'Cenário prático',
        'Escenario práctico',
      );
  String get sectionKeyPoints => _t(
        'Key points to remember',
        'Ключевые моменты',
        'Pontos-chave para lembrar',
        'Puntos clave para recordar',
      );
  String get sectionProTip => _t(
        'Pro tip',
        'Полезный совет',
        'Dica profissional',
        'Consejo profesional',
      );
  String get sectionExample => _t(
        'Example',
        'Пример',
        'Exemplo',
        'Ejemplo',
      );
  String get sectionTradingView => _t(
        'TradingView setup',
        'Разбор в TradingView',
        'Setup no TradingView',
        'Configuración de TradingView',
      );
  String get sectionPractice => _t(
        'Hands-on practice',
        'Практика',
        'Prática guiada',
        'Práctica práctica',
      );
  String get sectionJournal => _t(
        'Trade journal',
        'Запись в журнал',
        'Diário de trades',
        'Diario de trades',
      );
  String get openTradingView => _t(
        'Open chart in TradingView',
        'Открыть график в TradingView',
        'Abrir gráfico no TradingView',
        'Abrir gráfico en TradingView',
      );
  String get tradingViewOpenError => _t(
        'Could not open TradingView',
        'Не удалось открыть TradingView',
        'Não foi possível abrir o TradingView',
        'No se pudo abrir TradingView',
      );
  String get marketBrazil => _t(
        'Brazil · LATAM',
        'Бразилия · Латинская Америка',
        'Brasil · LATAM',
        'Brasil · LATAM',
      );
  String get marketMexico => _t(
        'Mexico · LATAM',
        'Мексика · Латинская Америка',
        'México · LATAM',
        'México · LATAM',
      );
  String get marketLatam => _t(
        'LATAM focus',
        'Латинская Америка',
        'Foco na América Latina',
        'Enfoque latinoamericano',
      );
  String get marketRussia => _t(
        'Russia · CIS',
        'Россия · СНГ',
        'Rússia · CEI',
        'Rusia · CEI',
      );
  String get marketGlobal => _t(
        'Global markets',
        'Мировые рынки',
        'Mercados globais',
        'Mercados globales',
      );

  // ── Interactive lessons ──
  String get next => _t(
        'Next',
        'Дальше',
        'Próximo',
        'Próximo',
      );
  String get back => _t(
        'Back',
        'Назад',
        'Voltar',
        'Atrás',
      );
  String stepOf(int current, int total) => _t(
        'Step $current of $total',
        'Шаг $current из $total',
        'Passo $current de $total',
        'Paso $current de $total',
      );
  String get tapToExplore => _t(
        'Tap chart',
        'Нажми',
        'Toque',
        'Toque gráfico',
      );
  String get tapEachPoint => _t(
        'Tap each card to reveal',
        'Нажми на карточку',
        'Toque em cada carta para revelar',
        'Toca cada carta para revelar',
      );
  String get interactiveDemo => _t(
        'Try it yourself',
        'Попробуй сам',
        'Experimente',
        'Pruébalo tú mismo',
      );
  String get zoneSupport => _t(
        'Near SUPPORT — buyers active',
        'У поддержки — покупатели',
        'Perto de SUPORTE – compradores ativos',
        'Cerca de SOPORTE: compradores activos',
      );
  String get zoneResistance => _t(
        'Near RESISTANCE — sellers active',
        'У сопротивления — продавцы',
        'Perto da RESISTÊNCIA – vendedores ativos',
        'Cerca de RESISTENCIA - vendedores activos',
      );
  String get zoneNeutral => _t(
        'Mid-range — no clear edge',
        'В середине — непонятно, кто сильнее',
        'Intervalo médio – sem limites claros',
        'Rango medio: sin ventaja clara',
      );
  String get checkpointTitle => _t(
        'Quick check',
        'Тест урока',
        'Verificação rápida',
        'Comprobación rápida',
      );
  String checkpointProgress(int c, int t) => _t(
        'Question $c of $t',
        'Вопрос $c из $t',
        'Pergunta $c de $t',
        'Pregunta $c de $t',
      );
  String get checkpointQuestion1 => _t(
        'Which statement is most accurate?',
        'Какое утверждение вернее?',
        'Qual afirmação é mais precisa?',
        '¿Qué afirmación es más precisa?',
      );
  String checkpointQuestion2(String title) => _t(
        'In one sentence, "$title" is…',
        'Главное в уроке «$title» — это…',
        'Em uma frase, "$title" é…',
        'En una frase, "$title" es…',
      );
  String get checkpointComplete => _t(
        'Passed! Complete lesson',
        'Сдал! Завершить',
        'Passou! Concluir',
        '¡Aprobado! lección completa',
      );
  String get checkpointRetry => _t(
        'Review and retry',
        'Повтори урок',
        'Revisar e tentar',
        'Revisar y volver a intentar',
      );
  String get lessonComplete => _t(
        'Lesson complete!',
        'Урок пройден!',
        'Aula concluída!',
        '¡Lección completa!',
      );
  String xpEarned(int xp) => _t(
        '+$xp points',
        '+$xp ${pointsWord(xp)}',
        '+$xp pontos',
        '+$xp puntos',
      );
  String get startPractice => _t(
        'Practice now',
        'Попрактикуйся',
        'Praticar agora',
        'Practica ahora',
      );
  String get shareApp => _t(
        'Invite friends',
        'Пригласить друзей',
        'Convidar amigos',
        'invitar amigos',
      );
  String get shareMessage => _t(
        'Trade Master — real trading lessons, TradingView setups & practice. Not signals. Join me!',
        'Trade Master — короткие уроки трейдинга с графиками и учебная биржа. Здесь не дают готовых советов, что купить. Присоединяйся!',
        'Trade Master — aulas reais de negociação, configurações e práticas do TradingView. Não sinais. Junte-se a mim!',
        'Trade Master: lecciones comerciales reales, configuraciones y práctica de TradingView. No señales. ¡Únete a mí!',
      );
  String get linkCopied => _t(
        'Invite link copied!',
        'Ссылка и код скопированы!',
        'Link e código copiados!',
        '¡Enlace de invitación copiado!',
      );
  String get journalTitle => _t(
        'Trade journal',
        'Журнал сделок',
        'Diário de trades',
        'Diario de trades',
      );
  String get journalNewEntry => _t(
        'New entry',
        'Новая запись',
        'Nova entrada',
        'Nueva entrada',
      );
  String get journalEmpty => _t(
        'No entries yet. Log your setups from lessons.',
        'Пока пусто. Записывай сюда планы сделок из уроков.',
        'Nenhuma entrada ainda. Registre suas configurações das aulas.',
        'Aún no hay entradas. Registre sus configuraciones de las lecciones.',
      );
  String get journalSave => _t(
        'Save entry',
        'Сохранить',
        'Salvar',
        'Guardar entrada',
      );
  String get journalWriteEntry => _t(
        'Write to journal',
        'Записать в журнал',
        'Escrever no diário',
        'Escribir en el diario',
      );
  String get journalEntryPair => _t(
        'Pair',
        'Пара',
        'Par',
        'Par',
      );
  String get journalEntrySetup => _t(
        'Setup',
        'Что увидел на графике',
        'Configurar',
        'Configuración',
      );
  String get journalEntryEntry => _t(
        'Entry',
        'Вход',
        'Entrada',
        'Entrada',
      );
  String get journalEntryStop => _t(
        'Stop',
        'Стоп',
        'Parar',
        'Detener',
      );
  String get journalEntryTarget => _t(
        'Target',
        'Тейк (цель)',
        'Alvo',
        'Objetivo',
      );
  String get journalEntryEmotion => _t(
        'Emotion',
        'Эмоция',
        'Emoção',
        'Emoción',
      );
  String get journalEntryNotes => _t(
        'Notes',
        'Заметки',
        'Notas',
        'Notas',
      );
  String get referralTitle => _t(
        'Invite friends',
        'Пригласить друзей',
        'Convidar amigos',
        'invitar amigos',
      );
  String get referralYourCode => _t(
        'Your code',
        'Твой код',
        'Seu código',
        'tu codigo',
      );
  String get referralEnterCode => _t(
        'Enter friend\'s code',
        'Ввести код друга',
        'Código do amigo',
        'Introduce el código de amigo',
      );
  String get referralRedeem => _t(
        'Redeem',
        'Активировать',
        'Ativar',
        'Canjear',
      );
  String referralInvites(int n) => _t(
        '$n friends joined',
        '$n друзей присоединились',
        '$n amigos entraram',
        '$n amigos se unieron',
      );
  String get referralXpInfo => _t(
        'Learn together — points are earned only by studying',
        'Учитесь вместе — очки даются только за обучение',
        'Aprendam juntos — pontos só por estudar',
        'Aprended juntos — puntos solo por estudiar',
      );
  String get referralErrorEmpty => _t(
        'Enter a code',
        'Введи код',
        'Digite o código',
        'Introduce un código',
      );
  String get referralErrorOwn => _t(
        'That\'s your own code',
        'Это твой код',
        'Esse é o seu próprio código',
        'Ese es tu propio código',
      );
  String get referralErrorAlready => _t(
        'Code already used',
        'Код уже использован',
        'Código já usado',
        'Código ya usado',
      );
  String get referralErrorInvalid => _t(
        'Invalid code',
        'Неверный код',
        'Código inválido',
        'código no válido',
      );
  String get referralSuccess => _t(
        'Code applied!',
        'Код принят!',
        'Código aplicado!',
        '¡Código aplicado!',
      );
  String practiceLessonSetup(int id) => _t(
        'Open simulator for lesson $id',
        'Открыть учебную биржу · урок $id',
        'Abrir simulador · aula $id',
        'Abrir simulador · lección $id',
      );
  String get practiceWhatToDo => _t(
        'What to do now',
        'Как сделать',
        'O que fazer agora',
        'Qué hacer ahora',
      );
  String get practiceTermsTitle => _t(
        'Words you need (plain language)',
        'Слова простым языком',
        'Palavras em linguagem simples',
        'Palabras en lenguaje sencillo',
      );
  String get practiceFillFromPrice => _t(
        'Use current price',
        'Подставить текущую цену',
        'Usar preço atual',
        'Usar precio actual',
      );
  String get practiceClosedByStop => _t(
        'Closed by stop-loss (protection)',
        'Закрыто по стоп-лоссу (страховка)',
        'Fechado pelo stop-loss',
        'Cerrado por stop-loss',
      );
  String get practiceClosedByTarget => _t(
        'Closed by take-profit (target)',
        'Закрыто по тейку — цель достигнута',
        'Fechado pelo take-profit',
        'Cerrado por take-profit',
      );
  String get practiceZoomHint => _t(
        'Pinch or use + / − to zoom the chart. Drag to move.',
        'Кнопки + и − меняют масштаб. Потяни график вправо — увидишь прошлые свечи.',
        'Pinça ou + / − para zoom. Arraste para mover.',
        'Pellizca o + / − para zoom. Arrastra para mover.',
      );
  String lessonPracticeStarted(int id) => _t(
        'Lesson $id practice started',
        'Практика урока $id',
        'Prática aula $id iniciada',
        'Práctica de la lección $id iniciada',
      );
  String practiceLessonBanner(int id, String title) => _t(
        'Lesson $id: $title',
        'Урок $id: $title',
        'Aula $id: $title',
        'Lección $id: $title',
      );
  String lessonPracticeComplete(int id) => _t(
        'Lesson $id practice done!',
        'Практика урока $id завершена!',
        'Aula $id prática concluída!',
        '¡Práctica de la lección $id terminada!',
      );
  String get level => _t(
        'League',
        'Лига',
        'Nível',
        'Nivel',
      );
  String get xp => _t(
        'Points',
        'Очки',
        'Pontos',
        'Puntos',
      );
  String levelProgress(int current, int needed) => _t(
        '$current / $needed',
        '$current из $needed',
        '$current / $needed',
        '$current / $needed',
      );
  String get practiceAfterLesson => _t(
        'Apply in Paper Trading',
        'Попробуй на учебной бирже',
        'Inscreva-se na negociação de papel',
        'Aplicar en el comercio de papel',
      );
  String chartCaptionDefault(String pair) => _t(
        'Study how price behaves on $pair. Mark support, resistance, and where you would enter with a stop loss.',
        'Изучи поведение цены на $pair. Отметь поддержку, сопротивление и точку входа со стоп-лоссом.',
        'Estude o comportamento do preço em $pair. Marque suporte, resistência e entrada com stop loss.',
        'Estudie cómo se comporta el precio en $pair. Marque el soporte, la resistencia y dónde entraría con un stop loss.',
      );
  String get tradingViewStyleNote => _t(
        'TradingView-style chart · crypto market',
        'График как на сайте TradingView · рынок криптовалют',
        'Gráfico estilo TradingView · mercado cripto',
        'Gráfico estilo TradingView · mercado criptográfico',
      );
  String scenarioOnChart(String pair) => _t(
        '$pair — real scenario on chart',
        '$pair — сценарий на графике',
        '$pair — cenário no gráfico',
        '$pair: escenario real en el gráfico',
      );
  String get readThenStudyChart => _t(
        'Read the theory, then study the chart below',
        'Прочитай теорию, затем изучи график ниже',
        'Leia a teoria, depois estude o gráfico abaixo',
        'Lea la teoría, luego estudie el cuadro a continuación.',
      );
  String get chartConceptMarketBalance => _t(
        'Buyers vs sellers — how price moves',
        'Покупатели и продавцы — как движется цена',
        'Compradores vs vendedores — como o preço se move',
        'Compradores versus vendedores: cómo se mueve el precio',
      );
  String get chartConceptOrderBook => _t(
        'Order book — bids and asks',
        'Стакан — заявки на покупку и продажу',
        'Livro de ordens — bids e asks',
        'Libro de pedidos: ofertas y demandas',
      );
  String get chartConceptSessions => _t(
    'Trading sessions (24h crypto)',
    'Торговые сессии (криптовалютой торгуют круглосуточно)',
    'Sessões de trading (cripto 24h)',
  );
  String get chartConceptCorrelation => _t(
        'How two assets move together',
        'Как цены двух монет движутся вместе',
        'Como dois ativos se movem juntos',
        'Cómo se mueven dos activos juntos',
      );
  String get chartExplainCaption => _t(
        'Read the explanation below the diagram — it connects directly to this lesson.',
        'Прочитай пояснение под схемой — оно связано с темой урока.',
        'Leia a explicação abaixo do diagrama — ela se conecta à aula.',
        'Lea la explicación debajo del diagrama; se conecta directamente con esta lección.',
      );
  String get interactive => _t(
        'Interactive',
        'С заданиями',
        'Interativo',
        'Interactivo',
      );

  // ── Flashcards ──
  String get flashcardSessionComplete => _t(
        'Flashcard session complete!',
        'Карточки пройдены!',
        'Sessão de flashcards concluída!',
        '¡Sesión de tarjetas didácticas completada!',
      );
  String get noLessonsAvailable => _t(
        'No lessons available',
        'Нет доступных уроков',
        'Nenhuma aula disponível',
        'No hay lecciones disponibles',
      );
  String get tapToReveal => _t(
        'Tap to reveal answer',
        'Нажми, чтобы увидеть ответ',
        'Toque para revelar a resposta',
        'Toca para revelar la respuesta',
      );
  String get knewIt => _t(
        'Knew it',
        'Знал',
        'Sabia',
        'lo sabia',
      );
  String get studyMore => _t(
        'Study more',
        'Нужно повторить',
        'Preciso estudar',
        'Estudiar más',
      );
  String cardProgress(int current, int total) =>
      _t(
        'Card $current of $total',
        'Карточка $current из $total',
        'Cartão $current de $total',
        'Tarjeta $current de $total',
      );

  // ── Quiz ──
  String get quizArena => _t(
        'Quiz Arena',
        'Тесты',
        'Arena de Quiz',
        'Arena de concursos',
      );
  String get category => _t(
        'Category',
        'Категория',
        'Categoria',
        'Categoría',
      );
  String get difficulty => _t(
        'Difficulty',
        'Сложность',
        'Dificuldade',
        'Dificultad',
      );
  String get quickDrill => _t(
        'Quick 5-question drill',
        'Быстрый тест из 5 вопросов',
        'Teste rápido de 5 perguntas',
        'Ejercicio rápido de 5 preguntas',
      );
  String get backToQuizArena => _t(
        'Back to Quiz Arena',
        'К тестам',
        'Voltar para a Arena de Quiz',
        'Volver a Quiz Arena',
      );
  String get goHome => _t(
        'Go home',
        'На главную',
        'Ir para início',
        'Ir a casa',
      );
  String get reviewLessons => _t(
        'Review lessons',
        'Повторить уроки',
        'Revisar aulas',
        'Repasar lecciones',
      );
  String get nextQuestion => _t(
        'Next question',
        'Следующий вопрос',
        'Próxima pergunta',
        'Siguiente pregunta',
      );
  String get seeResults => _t(
        'See results',
        'Результаты',
        'Ver resultados',
        'Ver resultados',
      );
  String get questionOf => _t(
        'Question',
        'Вопрос',
        'Pergunta',
        'Pregunta',
      );
  String scoreResult(int score, int total) =>
      _t(
        'You scored $score out of $total',
        'Верных ответов: $score из $total',
        'Você marcou $score de $total',
        'Obtuviste $score sobre $total',
      );
  String get greatJob => _t(
        'Great job! Keep it up.',
        'Отлично! Так держать.',
        'Ótimo trabalho! Continue assim.',
        '¡Buen trabajo! Avanza.',
      );
  String get keepPracticing => _t(
        'Keep practicing — review the lessons.',
        'Продолжай практику — повтори уроки.',
        'Continue praticando — revise as aulas.',
        'Sigue practicando: revisa las lecciones.',
      );

  // ── Daily challenge ──
  String get startTodayChallenge => _t(
        'Start today\'s challenge',
        'Начать задание дня',
        'Iniciar desafio de hoje',
        'Comienza el desafío de hoy',
      );
  String get practiceMoreQuiz => _t(
        'Practice more in Quiz Arena',
        'Больше тестов для практики',
        'Pratique mais na Arena de Quiz',
        'Practica más en Quiz Arena',
      );
  String get backToHome => _t(
        'Back to home',
        'На главную',
        'Voltar ao início',
        'De vuelta a casa',
      );
  String get alreadyCompletedToday => _t(
        'Already completed today!',
        'Уже пройдено сегодня!',
        'Já concluído hoje!',
        '¡Ya completado hoy!',
      );
  String get dailyChallengeDesc =>
      _t(
        '5 random questions from across all topics. One attempt per day.',
        '5 случайных вопросов по всем темам. Одна попытка в день.',
        '5 perguntas aleatórias de todos os tópicos. Uma tentativa por dia.',
        '5 preguntas aleatorias de todos los temas. Un intento por día.',
      );

  // ── Trading ──
  String get portfolioEquity => _t(
        'Portfolio equity',
        'Капитал портфеля',
        'Patrimônio do portfólio',
        'Patrimonio de la cartera',
      );
  String get buy => _t(
        'BUY',
        'КУПИТЬ',
        'COMPRAR',
        'COMPRAR',
      );
  String get sell => _t(
        'SELL',
        'ПРОДАТЬ',
        'VENDER',
        'VENDER',
      );
  String get close => _t(
        'Close',
        'Закрыть',
        'Fechar',
        'Cerca',
      );
  String get howItWorks => _t(
        'How it works',
        'Как это работает',
        'Como funciona',
        'como funciona',
      );
  String get tradingHowItWorks => _t(
        'Live demo market with candlesticks. Chart updates automatically — open long or short, set size, and track P&L. No real money.',
        'Учебная биржа со свечами. График обновляется сам — открывай лонг или шорт, выбирай сумму и следи за прибылью и убытком. Деньги учебные, не настоящие.',
        'Mercado demo ao vivo com candlesticks. O gráfico atualiza sozinho — abra long/short, defina o tamanho e acompanhe o P&L. Sem dinheiro real.',
        'Mercado de demostración en vivo con velas japonesas. Los gráficos se actualizan automáticamente: abra en largo o en corto, establezca el tamaño y realice un seguimiento de las pérdidas y ganancias. Sin dinero real.',
      );
  String homeworkPointsNote(int min) => _t(
        '+100 points for the first send per lesson (answer from $min characters). The grade comes from the mentor in Telegram.',
        '+100 очков за первую отправку по уроку (ответ не короче $min знаков). Оценку ставит наставник в Telegram.',
        '+100 pontos pelo primeiro envio por aula (resposta a partir de $min caracteres). A nota vem do mentor no Telegram.',
        '+100 puntos por el primer envío por lección (respuesta desde $min caracteres). La nota la pone el mentor en Telegram.',
      );
  String get live => _t(
        'DEMO',
        'УЧЕБНЫЙ СЧЁТ',
        'DEMO',
        'DEMO',
      );
  String get demoMarketNote => _t(
        'simulated data',
        'симуляция',
        'dados simulados',
        'datos simulados',
      );
  String get positionSize => _t(
        'Position size',
        'Размер позиции',
        'Tamanho da posição',
        'Tamaño de posición',
      );
  String get marginRequired => _t(
        'Margin',
        'Маржа',
        'Margem',
        'Margen',
      );
  String get insufficientBalance => _t(
        'Insufficient balance',
        'Недостаточно средств',
        'Saldo insuficiente',
        'Saldo insuficiente',
      );
  String get resetAccount => _t(
        'Reset account',
        'Сбросить счёт',
        'Redefinir conta',
        'Restablecer cuenta',
      );
  String get resetAccountBody => _t(
        'Reset virtual balance to \$10,000 and clear open positions? Chart history will restart.',
        'Сбросить виртуальный баланс до \$10,000 и закрыть позиции? История графика начнётся заново.',
        'Redefinir saldo virtual para \$10.000 e limpar posições? O histórico do gráfico será reiniciado.',
        '¿Restablecer el saldo virtual a \$10,000 y borrar posiciones abiertas? El historial del gráfico se reiniciará.',
      );
  String get accountReset => _t(
        'Account reset',
        'Счёт сброшен',
        'Conta redefinida',
        'Restablecer cuenta',
      );
  String get positionOpened => _t(
        'Position opened',
        'Позиция открыта',
        'Posição aberta',
        'Posición abierta',
      );
  String get positionClosed => _t(
        'Position closed',
        'Позиция закрыта',
        'Posição fechada',
        'Posición cerrada',
      );
  String get noOpenPosition => _t(
        'No open position',
        'Нет открытых позиций',
        'Nenhuma posição aberta',
        'Ninguna posición abierta',
      );

  // ── Profile ──
  String get profile => _t(
        'Profile',
        'Профиль',
        'Perfil',
        'Perfil',
      );
  String get trader => _t(
        'Trader',
        'Трейдер',
        'Comerciante',
        'Comerciante',
      );
  String get premiumMember => _t(
        'Full access',
        'Полный доступ открыт',
        'Acesso completo',
        'Acceso completo',
      );
  String get cards => _t(
        'Cards',
        'Карточки',
        'Cartões',
        'Tarjetas',
      );
  String get recentQuizResults => _t(
        'Recent quiz results',
        'Последние результаты тестов',
        'Resultados recentes de quiz',
        'Resultados recientes del cuestionario',
      );
  String get noQuizzesYet => _t(
        'No quizzes yet. Head to Quiz Arena!',
        'Тестов пока нет. Пройди первый тест!',
        'Nenhum quiz ainda. Vá para a Arena!',
        'Aún no hay pruebas. ¡Dirígete a Quiz Arena!',
      );
  String get upgradePremium => _t(
        'Upgrade to Premium',
        'Открыть полный доступ',
        'Upgrade para Premium',
        'Actualizar a Premium',
      );
  String get replayOnboarding => _t(
        'Replay onboarding',
        'Пройти первые экраны приложения заново',
        'Refazer onboarding',
        'Incorporación de repetición',
      );
  String get resetAllProgress => _t(
        'Reset all progress',
        'Сбросить весь прогресс',
        'Redefinir todo o progresso',
        'Restablecer todo el progreso',
      );
  String get exportMyData => _t(
        'Export my data',
        'Экспорт моих данных',
        'Exportar meus dados',
        'Exportar mis datos',
      );
  String get exportMyDataDone => _t(
        'Data copied to clipboard (JSON)',
        'Данные скопированы. Их можно вставить в письмо или файл.',
        'Dados copiados para a área de transferência (JSON)',
        'Datos copiados al portapapeles (JSON)',
      );
  String get deleteAccount => _t(
        'Delete account',
        'Удалить аккаунт',
        'Excluir conta',
        'Eliminar cuenta',
      );
  String get deleteAccountBody => _t(
        'This permanently deletes your Trade Master account, cloud progress, and local data on this device. Type DELETE to confirm.',
        'Это навсегда удалит аккаунт Trade Master, прогресс на сервере и данные на этом устройстве. Чтобы подтвердить, введи слово DELETE.',
        'Isso apaga permanentemente sua conta Trade Master, progresso na nuvem e dados locais neste dispositivo. Digite DELETE para confirmar.',
        'Esto elimina permanentemente tu cuenta Trade Master, el progreso en la nube y los datos locales en este dispositivo. Escribe DELETE para confirmar.',
      );
  String get deleteAccountConfirmHint => _t(
        'Type DELETE',
        'Введи DELETE',
        'Digite DELETE',
        'Escribe DELETE',
      );
  String get deleteAccountDone => _t(
        'Account deleted',
        'Аккаунт удалён',
        'Conta excluída',
        'Cuenta eliminada',
      );
  String get deleteAccountFailed => _t(
        'Could not delete account. Check connection and try again.',
        'Не удалось удалить аккаунт. Проверь интернет и попробуй снова.',
        'Não foi possível excluir a conta. Verifique a conexão e tente de novo.',
        'No se pudo eliminar la cuenta. Revisa la conexión e inténtalo de nuevo.',
      );
  String get resetProgressTitle => _t(
        'Reset all progress?',
        'Сбросить весь прогресс?',
        'Redefinir todo o progresso?',
        '¿Restablecer todo el progreso?',
      );
  String get resetProgressBody => _t(
        'This clears lessons, tests, points, flames and the demo balance. Your club ID, name and passed cutoffs stay.',
        'Удалятся уроки, тесты, очки, огоньки и учебный счёт. ID в клубе, имя и пройденные пороги для входа в чаты останутся.',
        'Apaga aulas, testes, pontos, chamas e saldo demo. Seu ID do clube, nome e cortes alcançados ficam.',
        'Borra lecciones, pruebas, puntos, llamas y saldo demo. Tu ID del club, nombre y cortes superados se quedan.',
      );
  String get progressReset => _t(
        'Progress reset',
        'Прогресс сброшен',
        'Progresso redefinido',
        'Restablecer progreso',
      );
  String get appDisclaimer => _t(
        'Trade Master v1.0.0\nEducational app — not financial advice.',
        'Trade Master v1.0.0\nЭто обучение, а не совет, что покупать.',
        'Trade Master v1.0.0\nApp educacional — não é recomendação financeira.',
        'Maestro de Comercio v1.0.0\nAplicación educativa, no asesoramiento financiero.',
      );
  String get language => _t(
        'Language',
        'Язык',
        'Idioma',
        'Idioma',
      );
  String get selectLanguage => _t(
        'Select language',
        'Выбери язык',
        'Selecionar idioma',
        'Seleccionar idioma',
      );

  // ── Goals ──
  String get yourGoal => _t(
        'Your goal',
        'Ваша цель',
        'Seu objetivo',
        'Tu objetivo',
      );
  String get goalQuestion => _t(
        'What brings you to Trade Master?',
        'Зачем вы здесь?',
        'O que te traz ao Trade Master?',
        '¿Qué te trae a Trade Master?',
      );
  String get goalSubtitle => _t(
        'We\'ll personalize your experience',
        'Мы настроим приложение под вас',
        'Personalizaremos sua experiência',
        'Personalizaremos tu experiencia',
      );
  String get goalLearnTrading => _t(
        'Learn trading from scratch',
        'Изучить трейдинг с нуля',
        'Aprender trading do zero',
        'Aprenda a operar desde cero',
      );
  String get goalLearnTradingSub => _t(
        'Start with basics and build a solid foundation',
        'Начните с основ и постройте фундамент',
        'Comece com o básico e construa uma base sólida',
        'Comience con lo básico y construya una base sólida',
      );
  String get goalDemoPractice => _t(
        'Practice with demo trading',
        'Практика на учебной бирже',
        'Pratique com negociação de demonstração',
        'Practique con el comercio de demostración',
      );
  String get goalDemoPracticeSub => _t(
        'Train in a risk-free simulator',
        'Тренируйтесь без риска',
        'Treine em um simulador sem risco',
        'Entrena en un simulador sin riesgos',
      );
  String get goalTestKnowledge => _t(
        'Test my knowledge',
        'Проверить знания',
        'Testar meu conhecimento',
        'Pon a prueba mis conocimientos',
      );
  String get goalTestKnowledgeSub => _t(
        'Quizzes, flashcards, and daily challenges',
        'Тесты, карточки и задания дня',
        'Quizzes, flashcards e desafios diários',
        'Cuestionarios, tarjetas didácticas y desafíos diarios',
      );
  String get goalBuildDiscipline => _t(
        'Build trading discipline',
        'Развить дисциплину',
        'Construir disciplina de trading',
        'Desarrollar disciplina comercial',
      );
  String get goalBuildDisciplineSub => _t(
        'Streaks, routines, and structured learning',
        'Серии, рутины и структурированное обучение',
        'Sequências, rotinas e aprendizado estruturado',
        'Rachas, rutinas y aprendizaje estructurado',
      );
  String goalLabel(String? goal) {
    switch (goal) {
      case 'learn_trading':
        return _t(
        'Goal: Learn trading',
        'Цель: изучить трейдинг',
        'Meta: Aprender trading',
        'Objetivo: aprender a operar',
      );
      case 'practice_demo':
        return _t(
        'Goal: Demo practice',
        'Цель: практика на учебной бирже',
        'Objetivo: prática de demonstração',
        'Objetivo: práctica de demostración',
      );
      case 'pass_quiz':
        return _t(
        'Goal: Test knowledge',
        'Цель: проверить знания',
        'Meta: Testar conhecimento',
        'Objetivo: probar conocimientos',
      );
      case 'build_discipline':
        return _t(
        'Goal: Build discipline',
        'Цель: научиться торговать по правилам',
        'Meta: Construir disciplina',
        'Objetivo: desarrollar disciplina',
      );
      default:
        return _t(
        'Trading learner',
        'Ученик',
        'Aprendiz de trading',
        'aprendiz de comercio',
      );
    }
  }

  // ── Onboarding ──
  String get welcomeTitle => _t(
        'Welcome to Trade Master',
        'Добро пожаловать в Trade Master',
        'Bem-vindo ao Trade Master',
        'Bienvenido a Trade Master',
      );
  String get welcomeSubtitle => _t(
        'One short lesson on a chart. Then you try.',
        'Один короткий урок на графике. Потом пробуешь сам.',
        'Una lección corta en el gráfico. Luego lo pruebas.',
        'Uma aula curta no gráfico. Depois você tenta.',
      );
  String get getStarted => _t(
        'Get started',
        'Начать',
        'Começar',
        'Empezar',
      );

  // ── Premium ──
  String get premium => _t(
        'Full access',
        'Полный доступ',
        'Acesso completo',
        'Acceso completo',
      );
  String get premiumActivated => _t(
        'Premium activated!',
        'Полный доступ открыт!',
        'Premium ativado!',
        '¡Premium activado!',
      );
  String get youHavePremium => _t(
        'You have Premium access',
        'У тебя полный доступ',
        'Você tem acesso Premium',
        'Tienes acceso Premium',
      );
  String get premiumTitle => _t(
        'Unlock your full potential',
        'Раскрой полный потенциал',
        'Desbloqueie todo o potencial',
        'Libera todo tu potencial',
      );
  String get premiumSubtitle => _t(
        'One-time unlock of lessons 15–58. Same course as with the Desk Club key.',
        'Разовая оплата открывает уроки 15–58. Тот же курс, что и с ключом Desk Club.',
        'Pagamento único libera as aulas 15–58. O mesmo curso que com a chave Desk Club.',
        'Un pago único abre las lecciones 15–58. El mismo curso que con la clave Desk Club.',
      );
  String get activatePremium => _t('Activate Premium (Demo)', 'Активировать Premium (Демо)', 'Ativar Premium (Demo)');

  // ── Market concepts ──
  String get marketConceptsTitle => _t(
        'Market Concepts',
        'Как устроен рынок',
        'Conceitos de Mercado',
        'Conceptos de mercado',
      );
  String get marketConceptsIntro => _t(
        'Essential concepts every trader should understand before risking capital.',
        'Главное, что нужно понимать о рынке, прежде чем рисковать деньгами.',
        'Conceitos essenciais que todo trader deve entender antes de arriscar capital.',
        'Conceptos esenciales que todo trader debería entender antes de arriesgar capital.',
      );

  // ── Modules ──
  String moduleName(String module) {
    switch (module) {
      case 'Basics':
        return _t(
        'Basics',
        'Основы',
        'Fundamentos',
        'Lo esencial',
      );
      case 'Price Action':
        return _t(
        'Price Action',
        'Движение цены',
        'Ação de preço',
        'Acción del precio',
      );
      case 'Risk':
        return _t(
        'Risk',
        'Риск',
        'Risco',
        'Riesgo',
      );
      case 'Psychology':
        return _t(
        'Psychology',
        'Психология',
        'Psicologia',
        'Psicología',
      );
      case 'Strategy':
        return _t(
        'Strategy',
        'Стратегия',
        'Estratégia',
        'Estrategia',
      );
      case 'Execution':
        return _t(
        'Execution',
        'Исполнение',
        'Execução',
        'Ejecución',
      );
      case 'Review':
        return _t(
        'Review',
        'Разбор',
        'Revisão',
        'Revisar',
      );
      case 'Advanced':
        return _t(
        'Advanced',
        'Продвинутый',
        'Avançado',
        'Avanzado',
      );
      default:
        return module;
    }
  }

  String difficultyName(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return _t(
        'Beginner',
        'Начальный',
        'Iniciante',
        'Principiante',
      );
      case 'Intermediate':
        return _t(
        'Intermediate',
        'Средний',
        'Intermediário',
        'Intermedio',
      );
      case 'Advanced':
        return _t(
        'Advanced',
        'Продвинутый',
        'Avançado',
        'Avanzado',
      );
      case 'Easy':
        return _t(
        'Easy',
        'Лёгкий',
        'Fácil',
        'Fácil',
      );
      case 'Medium':
        return _t(
        'Medium',
        'Средний',
        'Médio',
        'Medio',
      );
      case 'Hard':
        return _t(
        'Hard',
        'Сложный',
        'Difícil',
        'Duro',
      );
      default:
        return difficulty;
    }
  }

  String categoryName(String category) {
    switch (category) {
      case 'All':
        return all;
      case 'Basics':
        return _t(
        'Basics',
        'Основы',
        'Fundamentos',
        'Lo esencial',
      );
      case 'Risk':
        return _t(
        'Risk',
        'Риск',
        'Risco',
        'Riesgo',
      );
      case 'Psychology':
        return _t(
        'Psychology',
        'Психология',
        'Psicologia',
        'Psicología',
      );
      case 'Charts':
        return _t(
        'Charts',
        'Графики',
        'Gráficos',
        'Gráficos',
      );
      case 'Habits':
        return _t(
        'Habits',
        'Привычки',
        'Hábitos',
        'Hábitos',
      );
      default:
        return category;
    }
  }

  String translateSectionHeading(String heading) {
    switch (heading) {
      case 'Introduction':
        return sectionIntroduction;
      case 'Core concept':
        return sectionCoreConcept;
      case 'Chart example':
        return sectionChartExample;
      case 'Practical scenario':
        return sectionPracticalScenario;
      case 'Key points to remember':
        return sectionKeyPoints;
      default:
        return heading;
    }
  }

  // ── University track ──
  String get backToLearning => _t(
        'Back to learning',
        'К обучению',
        'Voltar ao aprendizado',
        'volver al aprendizaje',
      );
  String backToLesson(int id) => _t(
        'Back to lesson $id',
        'Вернуться к уроку $id',
        'Voltar à aula $id',
        'Volver a la lección $id',
      );
  String resumeLessonStep(int step) => _t(
        'Continuing from step $step',
        'Продолжи с шага $step',
        'Continuando do passo $step',
        'Continuamos desde el paso $step',
      );
  String get choiceCorrect => _t(
        'Right. Lock that sentence.',
        'Верно. Запомни эту фразу.',
        'Certo. Guarde essa frase.',
        'Correcto. Quédate con esa frase.',
      );
  String get choiceWrong => _t(
        'Not that one. Look at the green option.',
        'Неверно. Верный ответ отмечен зелёным.',
        'Não essa. Olhe a opção verde.',
        'No esa. Mira la opción verde.',
      );
  String get sectionReferences => _t(
        'References',
        'Источники',
        'Referências',
        'Referencias',
      );
  String get submitHomework => _t(
        'Copy homework and open Telegram',
        'Скопировать ответ и открыть Desk Club',
        'Copiar a tarefa e abrir o Telegram',
        'Copiar la tarea y abrir Telegram',
      );
  String get homeworkCopied => _t(
        'Copied. Paste it in the homework topic.',
        'Скопировано. Вставь в раздел «Домашние задания» в чате Desk Club в Telegram.',
        'Copiado. Cole no tópico homework.',
        'Copiado. Pégalo en el tema homework.',
      );
  String get homeworkBody => _t(
        'Write in one sentence, then send it to the Desk Club homework topic.',
        'Напиши ответ одной фразой и отправь в раздел «Домашние задания» в чате Desk Club в Telegram.',
        'Escreva em uma frase e envie no tópico homework do Desk Club.',
        'Escribe en una frase y envíalo al tema homework de Desk Club.',
      );
  String get homeworkOpenError => _t(
        'Could not open Telegram',
        'Не удалось открыть Telegram',
        'Não foi possível abrir o Telegram',
        'No se pudo abrir Telegram',
      );
  String get syllabusTitle => _t(
        'Course syllabus',
        'Программа курса',
        'Programa do curso',
        'Programa del curso',
      );
  String get glossaryTitle => _t(
        'Glossary',
        'Словарь',
        'Glossário',
        'Glosario',
      );
  String get certificateTitle => _t(
        'Certificate',
        'Сертификат',
        'Certificado',
        'Certificado',
      );
  String get exportCertificate => _t(
        'Export progress',
        'Экспорт прогресса',
        'Exportar progresso',
        'Exportar progreso',
      );
  String get moduleTests => _t(
        'Module tests',
        'Тесты по разделам',
        'Testes por módulo',
        'Pruebas del módulo',
      );
  String get caseStudies => _t(
        'Case studies',
        'Разборы примеров',
        'Estudos de caso',
        'Estudios de caso',
      );
  String prerequisitesRequired(String ids) =>
      _t(
        'Complete lessons $ids first',
        'Сначала пройди уроки $ids',
        'Conclua as aulas $ids primeiro',
        'Complete las lecciones $ids primero',
      );
  String get checkpointPassHint =>
      _t('Pass the checkpoint (70%+) to complete the lesson', 'Пройди тест урока (не меньше 70% верных ответов), чтобы завершить урок', 'Passe no checkpoint (70%+) para concluir a lição');
  String get skillTree => _t(
        'Skill tree',
        'Дерево навыков',
        'Árvore de habilidades',
        'árbol de habilidades',
      );
  String moduleProgress(int done, int total) =>
      _t(
        '$done/$total lessons',
        'уроков: $done из $total',
        '$done/$total aulas',
        '$done/$total totales',
      );
  String moduleTestMeta(int questions, int minutes, int lessons) =>
      _t(
        '$questions Q · ~$minutes min · $lessons lessons',
        'вопросов: $questions · около $minutes мин · уроков: $lessons',
        '$questions perg. · ~$minutes min · $lessons aulas',
        '$questions P · ~$minutes min · $lessons clases',
      );
  String get reviewQueue => _t(
        'Review mistakes',
        'Повтор ошибок',
        'Revisar erros',
        'Errores de revisión',
      );
  String get homeworkRubric => _t(
        'Homework rubric',
        'Как оценят домашнее задание',
        'Rubrica da tarefa',
        'Rúbrica de tarea',
      );
  String homeworkSubmits(int n) => _t(
        'Submitted: $n',
        'Отправлено: $n',
        'Enviado: $n',
        'Enviado: $n',
      );
  String homeworkPassScore(int s) => _t(
        'Pass score: $s/10',
        'Задание засчитают от $s баллов из 10',
        'Nota mínima: $s/10',
        'Puntaje de aprobación: $s/10',
      );
  String get tradePlanTitle => _t(
        'Trade plan',
        'План сделки',
        'Plano de trade',
        'plan comercial',
      );
  String get tradePlanRequired => _t(
        'Plan required before trade',
        'План обязателен до сделки',
        'Plano obrigatório antes do trade',
        'Plan requerido antes del comercio',
      );
  String get planEntry => _t(
        'Entry',
        'Вход',
        'Entrada',
        'Entrada',
      );
  String get planStop => _t(
        'Stop',
        'Стоп',
        'Parar',
        'Detener',
      );
  String get planTarget => _t(
        'Target',
        'Тейк',
        'Alvo',
        'Objetivo',
      );
  String get planRisk => _t(
        'Risk %',
        'Риск %',
        'Risco %',
        'Riesgo %',
      );
  String planRR(String rr) => _t(
        'R:R 1:$rr',
        'Риск к прибыли 1 к $rr',
        'R:R 1:$rr',
        'R:R 1:$rr',
      );
  String get saveTradePlan => _t(
        'Save plan',
        'Сохранить план',
        'Salvar plano',
        'Guardar plan',
      );
  String get planErrorLevels => _t(
        'Enter valid entry, stop and target',
        'Укажи вход, стоп и тейк',
        'Informe entrada, stop e alvo',
        'Introduzca una entrada, una parada y un objetivo válidos',
      );
  String get planErrorRisk => _t(
        'Risk must be 0.25–3%',
        'Риск — от 0,25 до 3%',
        'O risco deve ser de 0,25–3%',
        'El riesgo debe ser del 0,25 al 3 %.',
      );
  String get planErrorStopLong => _t(
        'Long: stop must be below entry',
        'Лонг: стоп ниже входа',
        'Longo: o stop deve estar abaixo da entrada',
        'Largo: la parada debe estar debajo de la entrada',
      );
  String get planErrorTargetLong => _t(
        'Long: target above entry',
        'Лонг: тейк выше входа',
        'Long: alvo acima da entrada',
        'Largo: objetivo por encima de la entrada',
      );
  String get planErrorStopShort => _t(
        'Short: stop above entry',
        'Шорт: стоп выше входа',
        'Short: stop acima da entrada',
        'Breve: detenerse encima de la entrada',
      );
  String get planErrorTargetShort => _t(
        'Short: target below entry',
        'Шорт: тейк ниже входа',
        'Short: alvo abaixo da entrada',
        'Breve: objetivo debajo de la entrada',
      );
  String get planErrorRR => _t(
        'Minimum R:R 1:1.5 required',
        'Риск к прибыли должен быть не хуже 1 к 1,5',
        'Mínimo R:R 1:1.5',
        'Se requiere R:R 1:1,5 mínimo',
      );
  String get planRequiredMsg => _t(
        'Save a valid trade plan first',
        'Сначала сохрани план',
        'Salve um plano válido primeiro',
        'Guarde primero un plan comercial válido',
      );
  String get certificateHash => _t(
        'Verification ID',
        'Номер для проверки',
        'ID de verificação',
        'ID de verificación',
      );
  String get copyHash => _t(
        'Copy verification ID',
        'Скопировать ID',
        'Copiar ID de verificação',
        'Copiar ID de verificación',
      );
  String get watchVideo => _t(
        'Watch video',
        'Смотреть видео',
        'Assistir vídeo',
        'Ver vídeo',
      );
  String get videoOpenError => _t(
        'Could not open video',
        'Не удалось открыть видео',
        'Não foi possível abrir o vídeo',
        'No se pudo abrir el video',
      );
  String get videoOpensYouTube => _t('Opens in YouTube (new tab)', 'Откроется в YouTube (новая вкладка)', 'Abre no YouTube (nova aba)');
  String get openInYouTube => _t(
        'Open in YouTube',
        'Открыть в YouTube',
        'Abrir no YouTube',
        'Abrir en YouTube',
      );
  String get videoPlaysInline => _t(
        'Video plays below. If it does not load, use the link.',
        'Видео ниже. Если оно не загружается, нажми на ссылку.',
        'O vídeo toca abaixo. Se não carregar, use o link.',
        'El vídeo se reproduce a continuación. Si no se carga, utilice el enlace.',
      );
  String readingPart(int n, int total) => _t(
        'Part $n of $total',
        'Часть $n из $total',
        'Parte $n de $total',
        'Parte $n del $total',
      );
  String get textBlockAnalogy => _t(
        'Think of it like this',
        'Представь',
        'Imagine assim',
        'Piénsalo así',
      );
  String get textBlockWarning => _t(
        'Important',
        'Важно',
        'Importante',
        'Importante',
      );
  String get textBlockMyth => _t(
        'Myth',
        'Миф',
        'Mito',
        'Mito',
      );
  String get textBlockCompare => _t(
        'Compare',
        'Сравнение',
        'Comparar',
        'Comparar',
      );

  // ── Order book diagram ──
  String get obHeaderClassic => _t(
        'Order book · Binance style',
        'Стакан заявок · как на настоящей бирже',
        'Livro de ofertas · estilo Binance',
        'Libro de órdenes · estilo Binance',
      );
  String get obHeaderSpread => _t(
        'Look at the spread',
        'Смотрим на спред — разницу цен',
        'Observe o spread',
        'Mira el spread',
      );
  String get obHeaderAskWall => _t(
        'Ask wall (sellers)',
        'Стена на продажу',
        'Parede de venda',
        'Muro de venta',
      );
  String get obHeaderBidWall => _t(
        'Bid wall (buyers)',
        'Стена на покупку',
        'Parede de compra',
        'Muro de compra',
      );
  String get obHeaderSpoof => _t(
        'Possible spoof wall',
        'Возможно, ложная стена',
        'Possível parede falsa',
        'Posible muro falso',
      );
  String get obColPrice => _t('Price (USDT)', 'Цена (USDT)', 'Preço (USDT)', 'Precio (USDT)');
  String obColAmount(String base) => _t('Amount ($base)', 'Объём ($base)', 'Qtd. ($base)', 'Cantidad ($base)');
  String get obColTotal => _t('Total', 'Сумма', 'Total', 'Total');
  String get obWall => _t('WALL', 'СТЕНА', 'PAREDE', 'MURO');
  String get obSpread => _t('Spread', 'Спред', 'Spread', 'Spread');
  String get obCalloutClassic => _t(
        'Binance layout: asks (red) on top, bids (green) below. Trades happen in the middle.',
        'Как на настоящей бирже: заявки продавцов (красные) сверху, заявки покупателей (зелёные) снизу. Сделки проходят посередине.',
        'Layout da Binance: vendas (vermelho) em cima, compras (verde) embaixo. Os negócios acontecem no meio.',
        'Diseño de Binance: ventas (rojo) arriba, compras (verde) abajo. Las operaciones ocurren en el medio.',
      );
  String obCalloutSpread(String spread) => _t(
        'Wide spread (~$spread USDT). A market order will burn several levels — expensive on thin alts.',
        'Большой спред: самая дешёвая цена продажи и самая дорогая цена покупки отличаются примерно на $spread USDT. Рыночный ордер (сделка по текущей цене) соберёт заявки по нескольким ценам подряд. У малоизвестных монет, где мало заявок, это дорого.',
        'Spread largo (~$spread USDT). Uma ordem a mercado vai consumir vários níveis — caro em altcoins de baixa liquidez.',
        'Spread amplio (~$spread USDT). Una orden de mercado consumirá varios niveles — caro en altcoins poco líquidas.',
      );
  String obCalloutAskWall(String size, String base, String price) => _t(
        'Ask wall ~$size $base at $price — dense sellers. Do not short “from the wall” without the tape.',
        'Стена — очень большая заявка. Здесь примерно $size $base на продажу по цене $price: много продавцов. Не открывай шорт только из-за стены — сначала посмотри, как идут сделки.',
        'Parede de venda ~$size $base em $price — vendedores densos. Não venda “da parede” sem olhar o fluxo.',
        'Muro de venta ~$size $base en $price — vendedores densos. No vendas “desde el muro” sin mirar la cinta.',
      );
  String obCalloutBidWall(String size, String base) => _t(
        'Bid wall ~$size $base — buyers in queue. May hold price… or cancel when price approaches.',
        'Стена примерно $size $base на покупку — много покупателей ждут. Она может удержать цену, а может исчезнуть, когда цена подойдёт.',
        'Parede de compra ~$size $base — compradores na fila. Pode segurar o preço… ou sumir quando o preço chegar.',
        'Muro de compra ~$size $base — compradores en cola. Puede sostener el precio… o cancelarse cuando el precio se acerque.',
      );
  String get obCalloutSpoof => _t(
        'Huge wall far from mid + empty tape = spoofing risk. Wait for reaction — do not enter “because of the wall”.',
        'Огромная стена далеко от цены, а сделок почти нет — возможно, заявку поставили для обмана и скоро уберут. Дождись, как поведёт себя цена. Не входи в сделку только из-за стены.',
        'Parede enorme longe do preço + fluxo vazio = risco de spoofing. Espere a reação — não entre “por causa da parede”.',
        'Muro enorme lejos del precio + cinta vacía = riesgo de spoofing. Espera la reacción — no entres “por el muro”.',
      );
  String get textBlockSteps => _t(
        'Steps',
        'Шаги',
        'Passos',
        'Pasos',
      );
  String get reflectPrompt => _t(
        'Pause: can you explain this in one sentence?',
        'Пауза: объясни это одним предложением',
        'Pausa: você pode explicar isso em uma frase?',
        'Pausa: ¿puedes explicar esto en una frase?',
      );

  // ── Auth, trial, community, pricing ──
  String get signIn => _t(
        'Sign in',
        'Войти',
        'Entrar',
        'Iniciar sesión',
      );
  String get signInSubtitle => _t(
        'Sign in with email to sync your progress across devices.',
        'Войди по почте, чтобы прогресс был на всех твоих устройствах.',
        'Entre com e-mail para sincronizar o progresso em todos os dispositivos.',
        'Inicia sesión con correo para sincronizar el progreso en todos tus dispositivos.',
      );
  String get signInApple => _t(
        'Continue with Apple',
        'Войти через Apple',
        'Continuar com Apple',
        'Continuar con Apple',
      );
  String get signInGoogle => _t(
        'Continue with Google',
        'Войти через Google',
        'Continuar com Google',
        'Continuar con Google',
      );
  String get orEmail => _t(
        'or email',
        'или почта',
        'ou e-mail',
        'o correo electrónico',
      );
  String get email => _t(
        'Email',
        'Почта',
        'E-mail',
        'Correo electrónico',
      );
  String get continueWithEmail => _t(
        'Continue with email',
        'Продолжить с почтой',
        'Continuar com e-mail',
        'Continuar con el correo electrónico',
      );
  String get authInvalidEmail => _t(
        'Enter a valid email',
        'Введи правильный адрес почты',
        'Informe um e-mail válido',
        'Introduce un correo electrónico válido',
      );
  String authComingSoon(String p) => _t(
        '$p sign-in — coming soon',
        'Вход через $p — скоро',
        'Login $p — em breve',
        'Inicio de sesión con $p: próximamente',
      );
  String get adminAccessGranted => _t(
        'Admin access: full course unlocked',
        'Администратор: полный доступ открыт',
        'Acesso de administrador: curso completo desbloqueado',
        'Acceso de administrador: curso completo desbloqueado',
      );
  String get adminBadge => _t(
        'Administrator',
        'Администратор',
        'Administrador',
        'Administrador',
      );
  String get signOut => _t(
        'Sign out',
        'Выйти',
        'Sair',
        'desconectar',
      );
  String get trialBadge => _t(
        'Free trial',
        'Бесплатно',
        'Grátis',
        'Prueba gratuita',
      );
  String get premiumBadge => _t(
        'Full course',
        'Полный курс',
        'Curso completo',
        'curso completo',
      );
  String get communityTitle => _t(
        'Join the community',
        'Вступить в сообщество',
        'Entrar na comunidade',
        'Únete a la comunidad',
      );
  String get communitySubtitle => _t(
        'Desk Club: practice, structure, academy & homework',
        'Desk Club — сообщество учеников в Telegram: практика, разборы и домашние задания',
        'Desk Club: prática, estrutura, academia e tarefas',
        'Desk Club: práctica, estructura, academia y tareas',
      );
  String get communityOpenError => _t(
        'Could not open Telegram',
        'Не удалось открыть Telegram',
        'Não foi possível abrir o Telegram',
        'No se pudo abrir Telegram',
      );
  String get communityFullAccessTitle => _t(
        'Full course via community',
        'Уроки 15–58 открывает ключ Desk Club',
        'Curso completo pela comunidade',
        'Curso completo vía comunidad',
      );
  String get communityFullAccessBody => _t(
        'This free build has trial lessons. Join the Telegram community for the full program, homework, and live chat.',
        'Desk Club — чат учеников этого курса в Telegram. Там наставник проверяет домашние задания и рассказывает, как получить ключ.',
        'Nesta versão grátis há aulas de teste. Curso completo, tarefas e chat ao vivo — na comunidade Telegram.',
        'Esta versión gratuita tiene lecciones de prueba. Únase a la comunidad de Telegram para ver el programa completo, las tareas y el chat en vivo.',
      );
  String get openCommunityCta => _t(
        'Open Telegram community',
        'Открыть чат Desk Club',
        'Abrir comunidade Telegram',
        'Comunidad abierta de Telegram',
      );
  String get paywallLessonTitle => _t(
        'This lesson is in the full course',
        'Этот урок — в полном курсе',
        'Esta aula está no curso completo',
        'Esta lección está en el curso completo.',
      );
  String paywallLessonBody(int n) => _t(
        'Lessons 1–$n are free. Unlock all 58 lessons with a one-time purchase.',
        'Уроки 1–$n бесплатны. Все 58 уроков открываются разовой покупкой.',
        'As aulas 1–$n são gratuitas. Desbloqueie todas as 58 aulas com uma compra única.',
        'Las lecciones 1–$n son gratuitas. Desbloquea las 58 lecciones con una compra única.',
      );
  String paywallLessonBodyCommunity(int n) => _t(
        'Lessons 1–$n are free. Join the Desk Club community for the full course and mentor support.',
        'Уроки 1–$n бесплатны. Полный курс и поддержка наставника — в сообществе Desk Club (кнопка ниже).',
        'As aulas 1–$n são gratuitas. Entre na comunidade Desk Club para o curso completo e apoio do mentor.',
        'Las lecciones 1–$n son gratuitas. Únete a la comunidad Desk Club para el curso completo y apoyo del mentor.',
      );
  String get paywallTrialLessons => _t(
        'Free: stage 1 — spot, futures, chart and candles',
        'Бесплатно: основы, график, свечи и первая учебная сделка',
        'Grátis: etapa 1 — spot, futuros, gráfico e velas',
        'Gratis: etapa 1 — spot, futuros, gráfico y velas',
      );
  String get unlockFullCourse => _t(
        'Unlock full course',
        'Открыть полный курс',
        'Desbloquear curso completo',
        'Desbloquear curso completo',
      );
  String get lifetimePurchase => _t(
        'Lifetime access',
        'Полный доступ навсегда',
        'Acesso vitalício',
        'Acceso de por vida',
      );
  String get priceBelowMarket => _t(
        '20% below market',
        'На 20% ниже рынка',
        '20% abaixo do mercado',
        '20% por debajo del mercado',
      );
  String get restorePurchases => _t(
        'Restore purchases',
        'Восстановить покупки',
        'Restaurar compras',
        'Restaurar compras',
      );
  String get purchaseFullCourse => _t(
        'Buy full course',
        'Купить полный курс',
        'Comprar curso completo',
        'Comprar curso completo',
      );
  String get premiumFeatureAllLessons => _t(
        'All 58 lessons unlocked',
        'Все 58 уроков',
        'Todas as 58 aulas desbloqueadas',
        'Las 58 lecciones desbloqueadas',
      );
  String get premiumFeatureVideo => _t(
        'Chart practice on every step',
        'Практика на графиках в каждом блоке',
        'Prática com gráficos em cada bloco',
        'Práctica con gráficos en cada bloque',
      );
  String get premiumFeatureHomework => _t(
        'Module tests and readiness exam',
        'Тесты разделов и экзамен готовности',
        'Testes dos módulos e exame de prontidão',
        'Tests de módulos y examen de preparación',
      );
  String get premiumFeatureJournal => _t(
        'Unlimited trade journal',
        'Журнал сделок без ограничений',
        'Diário ilimitado',
        'Diario comercial ilimitado',
      );
  String get premiumFeatureCertificate => _t(
        'Course diploma',
        'Диплом курса',
        'Diploma do curso',
        'Diploma del curso',
      );
  String get premiumFeaturePractice => _t(
        'Paper trading simulator',
        'Учебная биржа',
        'Simulador de negociação de papel',
        'Simulador de comercio de papel',
      );

  String get otpSent => _t(
        'Check your email for the code',
        'Проверь почту — мы отправили код',
        'Verifique seu e-mail para o código',
        'Revisa tu correo electrónico para ver el código.',
      );
  String get enterOtpCode => _t(
        'Enter 6-digit code',
        'Введи код из 6 цифр',
        'Digite o código de 6 dígitos',
        'Ingrese el código de 6 dígitos',
      );
  String get verifyCode => _t(
        'Verify code',
        'Подтвердить код',
        'Verificar código',
        'Verificar código',
      );
  String get authError => _t(
        'Sign-in failed. Try again.',
        'Не получилось войти. Попробуй снова.',
        'Falha no login. Tente novamente.',
        'Error al iniciar sesión. Intentar otra vez.',
      );
  String get backendNotConfigured => _t(
        'Cloud sync is not configured. Contact support.',
        'Сохранение на сервере не настроено. Напиши в поддержку.',
        'A sincronização na nuvem não está configurada. Entre em contato com o suporte.',
        'La sincronización en la nube no está configurada. Póngase en contacto con el soporte.',
      );
  String get signInRequiredForPurchase => _t(
        'Sign in before purchasing',
        'Перед покупкой войди в аккаунт',
        'Entre antes de comprar',
        'Inicia sesión antes de comprar',
      );
  String get purchaseNotAvailable => _t(
        'Store not available on this device',
        'Магазин недоступен на этом устройстве',
        'Loja indisponível neste dispositivo',
        'Tienda no disponible en este dispositivo',
      );
  String get purchaseCancelled => _t(
        'Purchase cancelled',
        'Покупка отменена',
        'Compra cancelada',
        'Compra cancelada',
      );
  String get purchasesRestored => _t(
        'Purchases restored',
        'Покупки восстановлены',
        'Compras restauradas',
        'Compras restauradas',
      );
  String get webCheckoutOpened => _t(
        'Checkout opened in a new tab',
        'Оплата открыта в новой вкладке',
        'Checkout aberto em nova aba',
        'Pagar abierto en una nueva pestaña',
      );
  String get syncActive => _t(
        'Cloud sync active',
        'Прогресс сохраняется на сервере',
        'Sincronização na nuvem',
        'Sincronización en la nube activa',
      );

  String programDayTitle(int day, int total) =>
      _t(
        'Day $day of $total',
        'День $day из $total',
        'Dia $day de $total',
        'Día $day de $total',
      );
  String programDaySubtitle(int done, int expected, int totalLessons) => _t(
        'Progress: $done lessons (target by today: $expected of $totalLessons)',
        'Пройдено уроков: $done (по плану к сегодняшнему дню: $expected из $totalLessons)',
        'Progresso: $done aulas (meta hoje: $expected de $totalLessons)',
        'Progreso: $done clases (meta de hoy: $expected de $totalLessons)',
      );
  String get certificateReady => _t(
        'Certificate unlocked!',
        'Сертификат открыт!',
        'Certificado desbloqueado!',
        '¡Certificado desbloqueado!',
      );
  String certificateReqLessons(int pct, int min) => _t(
        'Complete $min% of lessons ($pct%)',
        'Пройти $min% уроков ($pct%)',
        'Concluir $min% das aulas ($pct%)',
        'Completar $min% de las clases ($pct%)',
      );
  String certificateReqJournal(int n, int min) => _t(
        'Journal entries: $n / $min',
        'Записей в журнале: $n из $min',
        'Entradas no diário: $n / $min',
        'Entradas de diario: $n / $min',
      );
  String certificateReqModules(int n, int min) => _t(
        'Module tests passed: $n / $min',
        'Тестов разделов сдано: $n из $min',
        'Testes de módulo: $n / $min',
        'Pruebas del módulo superadas: $n / $min',
      );
  String certificateReqLessonsCount(int done, int total) => _t(
        'Lessons completed: $done / $total',
        'Пройдено уроков: $done из $total',
        'Aulas concluídas: $done / $total',
        'Lecciones completadas: $done / $total',
      );
  String certificateReqHomework(int n, int min) => _t(
        'Homework sent: $n / $min lessons',
        'Уроков с отправленным домашним заданием: $n из $min',
        'Tarefa enviada: $n / $min aulas',
        'Tarea enviada: $n / $min lecciones',
      );
  String get homeworkTitle => _t(
        'Homework',
        'Домашние задания',
        'Tarefa',
        'Tarea',
      );
  String get homeworkDesk => _t(
        'Open homework desk',
        'Открыть экран домашних заданий',
        'Abrir a mesa de tarefa',
        'Abrir el escritorio de tarea',
      );
  String get homeworkHowTitle => _t(
        'How to submit',
        'Как сдавать',
        'Como enviar',
        'Cómo entregar',
      );
  String get homeworkHowStep1 => _t(
        'Write one sentence: what you did on this lesson.',
        'Заполни поля ниже: о чём был урок, что получилось в задании и что осталось непонятным.',
        'Escreva em uma frase: o que fez nesta aula.',
        'Escribe en una frase: qué hiciste en esta lección.',
      );
  String get homeworkHowStep2 => _t(
        'Copy the template. It names the lesson and the homework topic.',
        'Нажми кнопку внизу: ответ скопируется вместе с номером урока, и откроется Telegram.',
        'Copie o modelo. Ele indica a aula e o tópico homework.',
        'Copia la plantilla. Incluye la lección y el tema homework.',
      );
  String get homeworkHowStep3 => _t(
        'Paste it in Desk Club → topic homework. Wait for a reply there.',
        'Вставь ответ в раздел «Домашние задания» в чате Desk Club и отправь. Ответ наставника придёт туда же.',
        'Cole no Desk Club → tópico homework. A resposta chega lá.',
        'Pégalo en Desk Club → tema homework. La respuesta llega allí.',
      );
  String homeworkAccepted(String topic) => _t(
        'Accepted means a human reply in the $topic topic — not an in-app grade. The app counts that you sent it.',
        'Задание принято, когда наставник ответит тебе в разделе «Домашние задания» в чате Desk Club. Приложение видит только, что ответ отправлен.',
        'Aceito = resposta humana no tópico $topic, não uma nota no app. O app conta que você enviou.',
        'Aceptado = respuesta humana en el tema $topic, no una nota en la app. La app cuenta que lo enviaste.',
      );
  String get homeworkOneSentenceHint => _t(
        'The lesson in one sentence',
        'О чём был урок, одной фразой',
        'A aula em uma frase',
        'La lección en una frase',
      );
  String get homeworkResultHint => _t(
        'What you got in the task (numbers, if there was a calculation)',
        'Что получилось в задании (цифры, если был расчёт)',
        'O que saiu na tarefa (números, se houve cálculo)',
        'Qué salió en la tarea (números, si hubo cálculo)',
      );
  String get homeworkUnclearHint => _t(
        'What is still unclear (or “all clear so far”)',
        'Что осталось непонятным (можно „пока всё понятно“)',
        'O que ainda não ficou claro (ou “tudo claro por enquanto”)',
        'Qué aún no está claro (o “todo claro por ahora”)',
      );
  String get homeworkScreenshotNote => _t(
        'If the task needs a screenshot, attach it in Telegram with the paperclip to your message.',
        'Если в задании нужен снимок экрана, прикрепи его в Telegram скрепкой к своему сообщению.',
        'Se a tarefa pede uma captura de tela, anexe no Telegram com o clipe à sua mensagem.',
        'Si la tarea pide una captura de pantalla, adjúntala en Telegram con el clip a tu mensaje.',
      );
  String get homeworkSelectLesson => _t(
        'Lesson',
        'Урок',
        'Aula',
        'Lección',
      );
  String get homeworkEmpty => _t(
        'Nothing sent yet. Submit from this screen after a lesson.',
        'Пока ничего не отправлено. После урока отправь домашнее задание с этого экрана.',
        'Nada enviado ainda. Envie por esta tela depois da aula.',
        'Aún no hay envíos. Entrega desde esta pantalla después de la lección.',
      );
  String get homeworkSubmittedList => _t(
        'Sent from this device',
        'Отправлено с этого устройства',
        'Enviado neste dispositivo',
        'Enviado desde este dispositivo',
      );
  String get homeworkCopiedNoTelegram => _t(
        'Copied. Open Desk Club and paste in the homework topic.',
        'Скопировано. Открой чат Desk Club в Telegram и вставь в раздел «Домашние задания».',
        'Copiado. Abra o Desk Club e cole no tópico homework.',
        'Copiado. Abre Desk Club y pégalo en el tema homework.',
      );
  String get homeworkHomeSubtitle => _t(
        'Desk Club topic',
        'Раздел в чате Desk Club',
        'Tópico Desk Club',
        'Tema Desk Club',
      );
  String get certificateHomeSubtitle => _t(
        'Course diploma',
        'Диплом курса',
        'Diploma do curso',
        'Diploma del curso',
      );
  String get certificateLocked => _t(
        'Finish the course, module tests, journal, and homework to issue the diploma.',
        'Пройди курс, тесты разделов, журнал и домашние задания — затем получи диплом.',
        'Conclua o curso, testes de módulo, diário e tarefa para emitir o diploma.',
        'Termina el curso, tests de módulo, diario y tarea para emitir el diploma.',
      );
  String get certificateIssueCta => _t(
        'Issue certificate',
        'Получить сертификат',
        'Emitir certificado',
        'Emitir certificado',
      );
  String get certificateHolderHint => _t(
        'Name on the certificate',
        'Имя на сертификате',
        'Nome no certificado',
        'Nombre en el certificado',
      );
  String get certificateIssueNeedName => _t(
        'Enter the name to print on the certificate.',
        'Введи имя, которое будет на сертификате.',
        'Digite o nome para imprimir no certificado.',
        'Escribe el nombre que irá en el certificado.',
      );
  String certificateIssuedOn(String date) => _t(
        'Issued $date',
        'Выдан $date',
        'Emitido $date',
        'Emitido $date',
      );
  String get shareCertificate => _t(
        'Copy certificate text',
        'Скопировать текст сертификата',
        'Copiar texto do certificado',
        'Copiar texto del certificado',
      );
  String get certificateShareCopied => _t(
        'Copied. Paste it in Telegram or email.',
        'Скопировано. Вставь в Telegram или письмо.',
        'Copiado. Cole no Telegram ou no e-mail.',
        'Copiado. Pégalo en Telegram o en un correo.',
      );

  // ── Partner offers (post-certificate) ──
  String get partnerOffersTitle => _t(
        'Next step: exchanges & terminals',
        'Следующий шаг: биржи и торговые программы',
        'Próximo passo: exchanges e terminais',
        'Siguiente paso: exchanges y terminales',
      );
  String get partnerOffersSubtitle => _t(
        'Certificate unlocked. Here are our partner links to open an account and move from paper to live — with risk limits from the course.',
        'Сертификат открыт. Ниже партнёрские ссылки: по ним можно открыть настоящий счёт и перейти от учебных сделок к настоящим — с ограничениями риска из курса.',
        'Certificado desbloqueado. Abaixo estão nossos links de parceiros para abrir conta e sair do paper para live — com os limites de risco do curso.',
        'Certificado desbloqueado. Aquí están nuestros enlaces de partners para abrir cuenta y pasar de paper a live — con los límites de riesgo del curso.',
      );
  String get partnerDisclosure => _t(
        'Partner / affiliate links. Educational product — not financial advice. Trading involves risk of loss.',
        'Это партнёрские ссылки: если зарегистрируешься по ним, биржа платит нам вознаграждение. Это обучение, а не совет, что покупать. В торговле можно потерять деньги.',
        'Links de parceiros / afiliados. Produto educacional — não é recomendação financeira. Trading envolve risco de perda.',
        'Enlaces de partners / afiliados. Producto educativo — no es asesoría financiera. El trading implica riesgo de pérdida.',
      );
  String get partnerExchanges => _t(
        'Exchanges',
        'Биржи',
        'Exchanges',
        'Exchanges',
      );
  String get partnerTerminals => _t(
        'Terminals',
        'Торговые программы',
        'Terminais',
        'Terminales',
      );
  String get partnerOpen => _t(
        'Open link',
        'Открыть',
        'Abrir link',
        'Abrir enlace',
      );
  String get partnerLinksEmpty => _t(
        'Partner links will appear here once configured.',
        'Партнёрские ссылки появятся здесь позже.',
        'Os links de parceiros aparecerão aqui após configurar as URLs.',
        'Los enlaces de partners aparecerán aquí tras configurar las URLs.',
      );
  String get partnerOpenError => _t(
        'Could not open link',
        'Не удалось открыть ссылку',
        'Não foi possível abrir o link',
        'No se pudo abrir el enlace',
      );
  String partnerName(String id) {
    switch (id) {
      case 'binance':
        return 'Binance';
      case 'bybit':
        return 'Bybit';
      case 'bitso':
        return 'Bitso';
      case 'mercado_bitcoin':
        return _t('Mercado Bitcoin', 'Mercado Bitcoin', 'Mercado Bitcoin', 'Mercado Bitcoin');
      case 'tiger':
        return 'Tiger.Trade';
      case 'vataga':
        return 'Vataga';
      default:
        return id;
    }
  }

  String partnerBlurb(String id) {
    switch (id) {
      case 'binance':
        return _t(
          'Main CEX for spot & futures after the course.',
          'Основная биржа для спота и фьючерсов после курса.',
          'CEX principal para spot e futuros após o curso.',
          'CEX principal para spot y futuros después del curso.',
        );
      case 'bybit':
        return _t(
          'Alternative exchange for futures and live practice.',
          'Другая биржа для фьючерсов и торговли на настоящем счёте.',
          'Exchange alternativa para futuros e prática ao vivo.',
          'Exchange alternativa para futuros y práctica en vivo.',
        );
      case 'bitso':
        return _t(
          'LATAM-friendly on-ramp (Mexico and region).',
          'Удобная биржа для Мексики и соседних стран Латинской Америки.',
          'On-ramp amigável para LATAM (México e região).',
          'On-ramp amigable para LATAM (México y región).',
        );
      case 'mercado_bitcoin':
        return _t(
          'Brazil-focused exchange for local onboarding.',
          'Биржа с фокусом на Бразилию.',
          'Exchange com foco no Brasil para onboarding local.',
          'Exchange con foco en Brasil para onboarding local.',
        );
      case 'tiger':
        return _t(
          'Pro terminal via API — execution speed, not a strategy.',
          'Программа для опытных: подключается к бирже и быстрее отправляет заявки. Стратегию она не заменяет.',
          'Terminal pro via API — velocidade de execução, não estratégia.',
          'Terminal pro vía API — velocidad de ejecución, no estrategia.',
        );
      case 'vataga':
        return _t(
          'Order-flow terminal for advanced practice.',
          'Программа, которая показывает поток заявок на бирже. Для опытных учеников.',
          'Terminal de order flow para prática avançada.',
          'Terminal de order flow para práctica avanzada.',
        );
      default:
        return '';
    }
  }

  String get privacyPolicy => _t(
        'Privacy Policy',
        'Политика конфиденциальности',
        'Política de Privacidade',
        'Política de privacidad',
      );
  String get termsOfService => _t(
        'Terms of Service',
        'Условия использования',
        'Termos de Uso',
        'Términos del servicio',
      );
  String get legalSection => _t(
        'Legal',
        'Правовая информация',
        'Jurídico',
        'Legal',
      );

  // ── Path hub (home) ──
  String get pathTraderTitle => _t(
        'Your trader path',
        'Твой путь трейдера',
        'Seu caminho de trader',
        'Tu camino de trader',
      );
  String get greetingNight => _t('Good night', 'Доброй ночи', 'Boa noite', 'Buenas noches');
  String get greetingMorning => _t('Good morning', 'Доброе утро', 'Bom dia', 'Buenos días');
  String get greetingAfternoon => _t('Good afternoon', 'Добрый день', 'Boa tarde', 'Buenas tardes');
  String get greetingEvening => _t('Good evening', 'Добрый вечер', 'Boa noite', 'Buenas noches');
  String get streakLitTooltip => _t(
        'Streak is lit today',
        'Огонёк сегодня горит',
        'Sequência acesa hoje',
        'Racha encendida hoy',
      );
  String get streakUnlitTooltip => _t(
        'Streak not lit today',
        'Огонёк сегодня не зажжён',
        'Sequência apagada hoje',
        'Racha apagada hoy',
      );
  String get pointsLadderTooltip => _t(
        'Points · club student ladder',
        'Очки · рейтинг учеников клуба',
        'Pontos · ranking do clube',
        'Puntos · ranking del club',
      );
  String streakBannerFreeze(int days) => _t(
        'No lesson or test yet today. Streak: $days days. You have a freeze that can save the streak if you skip — freezes come every 7 days; better use a lesson instead.',
        'Сегодня ещё нет урока или теста. Дней подряд: $days. Есть заморозка: она спасёт серию, если сегодня пропустишь. Заморозку дают за каждые 7 дней подряд, лучше её не тратить и пройти урок',
        'Ainda sem aula ou teste hoje. Sequência: $days dias. Você tem um freeze que salva a sequência se pular — freezes a cada 7 dias; melhor fazer uma aula.',
        'Aún no hay lección o test hoy. Racha: $days días. Tienes un freeze que salva la racha si saltas — freeze cada 7 días; mejor haz una lección.',
      );
  String streakBannerSimple(int days) => _t(
        'No lesson or test yet today. Do one to keep the streak. Days in a row: $days',
        'Сегодня ещё нет урока или теста. Пройди один — и серия сохранится. Дней подряд: $days',
        'Ainda sem aula ou teste hoje. Faça um para manter a sequência. Dias seguidos: $days',
        'Aún no hay lección o test hoy. Haz uno para mantener la racha. Días seguidos: $days',
      );
  String get softRefBannerTitle => _t(
        'We recommend the Desk Club path',
        'Рекомендуем путь Desk Club',
        'Recomendamos o caminho Desk Club',
        'Recomendamos el camino Desk Club',
      );
  String get softRefBannerBody => _t(
        'Lessons already open · pro chat and live path optional',
        'Уроки уже открыты · профи-чат и реал — по желанию',
        'Aulas já abertas · chat pro e conta real opcionais',
        'Lecciones ya abiertas · chat pro y cuenta real opcionales',
      );
  String get quickActions => _t(
        'Quick actions',
        'Быстрые действия',
        'Ações rápidas',
        'Acciones rápidas',
      );
  String get learningPlan => _t(
        'Learning plan',
        'План обучения',
        'Plano de estudo',
        'Plan de aprendizaje',
      );
  String stageOf(int n) => _t(
        'Stage $n of 6',
        'Ступень $n из 6',
        'Etapa $n de 6',
        'Etapa $n de 6',
      );
  String get learningPlanHint => _t(
        'Step by step: from the first lesson to trades by plan. Tap a stage to see its steps.',
        'Шаг за шагом: от первого урока до сделок по плану. Нажми на ступень, чтобы увидеть шаги.',
        'Passo a passo: da primeira aula às operações com plano. Toque numa etapa para ver os passos.',
        'Paso a paso: de la primera lección a operaciones con plan. Toca una etapa para ver los pasos.',
      );
  String get badgeNow => _t('Now', 'Сейчас', 'Agora', 'Ahora');
  String get courseComplete => _t(
        'Course complete',
        'Курс пройден',
        'Curso concluído',
        'Curso completado',
      );
  String nextLessonLabel(int n) => _t(
        'Next · lesson $n',
        'Следующий · урок $n',
        'Próxima · aula $n',
        'Siguiente · lección $n',
      );
  String lessonOnStep(int n, int step) => _t(
        'Lesson $n · you are on step $step',
        'Урок $n · ты на шаге $step',
        'Aula $n · você está no passo $step',
        'Lección $n · estás en el paso $step',
      );
  String get allLessonsDone => _t(
        'All lessons done',
        'Все уроки пройдены',
        'Todas as aulas feitas',
        'Todas las lecciones hechas',
      );
  String lessonsProgress(int done, int total) => _t(
        '$done of $total lessons done',
        'Пройдено $done из $total уроков',
        '$done de $total aulas feitas',
        '$done de $total lecciones hechas',
      );
  String get repeatBtn => _t('Review', 'Повторить', 'Revisar', 'Repasar');
  String get allLessonsBtn => _t('All lessons', 'Все уроки', 'Todas as aulas', 'Todas las lecciones');
  String get quickModuleTests => _t('Section tests', 'Тесты разделов', 'Testes por seção', 'Tests por sección');
  String get quickModuleTestsSub => _t(
        'Required to open the next stage',
        'Без них не откроется следующая ступень',
        'Precisam abrir a próxima etapa',
        'Hacen falta para abrir la siguiente etapa',
      );
  String get quickJournal => _t('Journal', 'Журнал', 'Diário', 'Diario');
  String get quickJournalSub => _t('Notes and takeaways', 'Записи и выводы', 'Notas e conclusões', 'Notas y conclusiones');
  String get quickCards => _t('Flashcards', 'Карточки', 'Cartões', 'Tarjetas');
  String get quickCardsSub => _t('Review', 'Повторение', 'Revisão', 'Repaso');
  String get quickGlossary => _t('Glossary', 'Словарь', 'Glossário', 'Glosario');
  String get quickGlossarySub => _t('Terms', 'Термины', 'Termos', 'Términos');

  String get stage1Title => _t('Start', 'Старт', 'Início', 'Inicio');
  String get stage1Desc => _t(
        'Lessons 1–14, section tests, first homework',
        'Уроки 1–14, тесты разделов, первое домашнее задание',
        'Aulas 1–14, testes por seção, primeira tarefa',
        'Lecciones 1–14, tests por sección, primera tarea',
      );
  String get stage1StepLessons => _t('Stage 1 lessons', 'Уроки ступени 1', 'Aulas da etapa 1', 'Lecciones de la etapa 1');
  String get stage1StepLessonsSub => _t(
        'Basics, chart, candles and first practice trade',
        'Основы, график, свечи и первая учебная сделка',
        'Bases, gráfico, velas e primeira operação de prática',
        'Bases, gráfico, velas y primera operación de práctica',
      );
  String get stage1StepTests => _t('Section tests', 'Тесты разделов', 'Testes por seção', 'Tests por sección');
  String get stage1StepTestsSub => _t(
        'Short tests on what you learned · need 70% correct',
        'Короткие тесты по пройденному · нужно 70% верных ответов',
        'Testes curtos do que você estudou · precisa de 70% certos',
        'Tests cortos de lo estudiado · necesitas 70% correctos',
      );
  String get stage1StepHw => _t('First homework', 'Первое домашнее задание', 'Primeira tarefa', 'Primera tarea');
  String get stage1StepHwSub => _t(
        'A mentor reviews your answer · +100 points',
        'Ответ проверяет наставник · +100 очков',
        'Um mentor revisa sua resposta · +100 pontos',
        'Un mentor revisa tu respuesta · +100 puntos',
      );
  String get stage1StepAuth => _t('Save progress', 'Сохрани прогресс', 'Salvar progresso', 'Guardar progreso');
  String get stage1StepAuthSub => _t(
        'Sign in so you don’t lose completed lessons',
        'Войди, чтобы не потерять пройденные уроки',
        'Entre para não perder as aulas concluídas',
        'Entra para no perder las lecciones hechas',
      );
  String get stage1StepChat => _t('Students chat', 'Чат учеников', 'Chat de alunos', 'Chat de alumnos');
  String get stage1StepChatSub => _t(
        'Opens at 1,400 points, stage 1 done and 7-day streak',
        'Откроется за 1 400 очков, пройденную ступень 1 и 7 дней учёбы подряд',
        'Abre com 1.400 pontos, etapa 1 feita e 7 dias seguidos',
        'Se abre con 1.400 puntos, etapa 1 hecha y 7 días seguidos',
      );

  String get stage2Title => _t('Reading the chart', 'Чтение графика', 'Leitura do gráfico', 'Lectura del gráfico');
  String get stage2Desc => _t(
        'Trend, levels, volume and patterns · lessons already open',
        'Тренд, уровни, объём и фигуры на графике · уроки уже открыты',
        'Tendência, níveis, volume e padrões · aulas já abertas',
        'Tendencia, niveles, volumen y figuras · lecciones ya abiertas',
      );
  String get stage2SoftRef => _t(
        'We recommend the Desk Club path',
        'Рекомендуем путь Desk Club',
        'Recomendamos o caminho Desk Club',
        'Recomendamos el camino Desk Club',
      );
  String get stage2SoftRefSub => _t(
        'Not required for lessons · opens pro chat and the live-account path',
        'Не обязателен для уроков · открывает профи-чат и путь к реальному счёту',
        'Não obrigatório para aulas · abre o chat pro e o caminho à conta real',
        'No obligatorio para lecciones · abre el chat pro y el camino a cuenta real',
      );
  String get stage2StepLessons => _t('Stage 2 lessons', 'Уроки ступени 2', 'Aulas da etapa 2', 'Lecciones de la etapa 2');
  String get stage2StepLessonsSub => _t(
        'Lessons 15–36: how to read price movement',
        'Уроки 15–36: как читать движение цены',
        'Aulas 15–36: como ler o movimento do preço',
        'Lecciones 15–36: cómo leer el movimiento del precio',
      );
  String get stage2StepHw => _t('Chart homework', 'Домашнее задание с графиком', 'Tarefa com gráfico', 'Tarea con gráfico');
  String get stage2StepHwSub => _t(
        'Find levels, write their prices and send for review',
        'Находишь уровни, записываешь их цены и отправляешь на проверку',
        'Ache níveis, anote os preços e envie para revisão',
        'Encuentra niveles, anota precios y envía a revisión',
      );
  String get stage2StepStreak => _t('Day streak', 'Серия дней', 'Sequência de dias', 'Racha de días');
  String get stage2StepStreakSub => _t(
        'How many days in a row you study and the points bonus',
        'Сколько дней подряд ты учишься и бонус к очкам за это',
        'Quantos dias seguidos você estuda e o bônus de pontos',
        'Cuántos días seguidos estudias y el bonus de puntos',
      );

  String get stage3Title => _t('Practice', 'Практика', 'Prática', 'Práctica');
  String get stage3Desc => _t(
        'Lessons 37–58: practice trades with plan, stop and journal',
        'Уроки 37–58: учебные сделки с планом, стопом и журналом',
        'Aulas 37–58: operações de prática com plano, stop e diário',
        'Lecciones 37–58: operaciones de práctica con plan, stop y diario',
      );
  String get stage3StepLessons => _t('Stage 3 lessons', 'Уроки ступени 3', 'Aulas da etapa 3', 'Lecciones de la etapa 3');
  String get stage3StepLessonsSub => _t(
        'Lessons 37–58: risk, trade plan, futures and safety',
        'Уроки 37–58: риск, план сделки, фьючерсы и безопасность',
        'Aulas 37–58: risco, plano, futuros e segurança',
        'Lecciones 37–58: riesgo, plan, futuros y seguridad',
      );
  String get stage3StepTrade => _t('Trade by plan', 'Сделка по плану', 'Operação com plano', 'Operación con plan');
  String get stage3StepTradeSub => _t(
        'Entry, stop and take — before you tap · +80 points',
        'Цена входа, стоп и тейк — до нажатия кнопки · +80 очков',
        'Entrada, stop e take — antes de clicar · +80 pontos',
        'Entrada, stop y take — antes de pulsar · +80 puntos',
      );
  String get stage3StepJournal => _t('Trade journal', 'Журнал сделок', 'Diário de trades', 'Diario de trades');
  String get stage3StepJournalSub => _t(
        'Notes and takeaways · +20 points per day',
        'Записи и выводы · +20 очков в день',
        'Notas e conclusões · +20 pontos por dia',
        'Notas y conclusiones · +20 puntos al día',
      );
  String get stage3StepCards => _t('Flashcards', 'Карточки', 'Cartões', 'Tarjetas');
  String get stage3StepCardsSub => _t(
        'Review terms',
        'Повторение терминов',
        'Revisão de termos',
        'Repaso de términos',
      );

  String get stage4Title => _t('Diploma', 'Диплом', 'Diploma', 'Diploma');
  String get stage4Desc => _t(
        'Lessons, all section tests, journal and homework',
        'Уроки, все тесты разделов, журнал и домашние задания',
        'Aulas, todos os testes, diário e tarefas',
        'Lecciones, todos los tests, diario y tareas',
      );
  String get stage4StepDiploma => _t('Diploma', 'Диплом', 'Diploma', 'Diploma');
  String get stage4StepDiplomaSub => _t(
        'Check requirements and issue · +200 points',
        'Проверка условий и выдача · +200 очков',
        'Checar requisitos e emitir · +200 pontos',
        'Comprobar requisitos y emitir · +200 puntos',
      );
  String get stage4StepProChat => _t('Pro chat', 'Чат профи', 'Chat pro', 'Chat pro');
  String get stage4StepProChatSub => _t(
        'Opens at 6,900 points, diploma, 8 plan trades and 30-day streak',
        'Откроется за 6 900 очков, диплом, 8 сделок по плану и 30 дней учёбы подряд',
        'Abre com 6.900 pontos, diploma, 8 trades com plano e 30 dias seguidos',
        'Se abre con 6.900 puntos, diploma, 8 trades con plan y 30 días seguidos',
      );

  String get stage5Title => _t('Live account', 'Настоящий счёт', 'Conta real', 'Cuenta real');
  String get stage5Desc => _t(
        'First 30 days with a mentor · after diploma',
        'Первые 30 дней с наставником · после диплома',
        'Primeiros 30 dias com mentor · após o diploma',
        'Primeros 30 días con mentor · tras el diploma',
      );
  String get stage5StepInside => _t(
        'What’s inside and how to join',
        'Что внутри и как попасть',
        'O que tem e como entrar',
        'Qué hay dentro y cómo entrar',
      );
  String get stage5StepInsideSub => _t(
        'Risk rules, readiness checklist and 30 days of reports in the pro chat',
        'Правила риска, чеклист готовности и 30 дней отчётов в чате профи',
        'Regras de risco, checklist e 30 dias de relatórios no chat pro',
        'Reglas de riesgo, checklist y 30 días de informes en el chat pro',
      );

  String get stage6Title => _t('Graduate', 'Выпускник', 'Formado', 'Egresado');
  String get stage6Desc => _t(
        'You help new students and review their homework',
        'Помогаешь новым ученикам и проверяешь их домашние задания',
        'Você ajuda novos alunos e revisa as tarefas deles',
        'Ayudas a nuevos alumnos y revisas sus tareas',
      );
  String get stage6StepInsideSub => _t(
        'Graduation and reviewing homework',
        'Выпуск и проверка домашних заданий',
        'Formatura e revisão de tarefas',
        'Graduación y revisión de tareas',
      );

  String leagueProDone(String name) => _t(
        'League “$name” · pro chat conditions met',
        'Ступень «$name» · условия чата профи выполнены',
        'Liga “$name” · condições do chat pro ok',
        'Liga “$name” · condiciones del chat pro cumplidas',
      );
  String leaguePointsToUnlock(int n, String word, String unlock) => _t(
        '$n $word left to unlock: “$unlock”',
        'Осталось $n $word до порога: «$unlock»',
        'Faltam $n $word para: “$unlock”',
        'Quedan $n $word para: “$unlock”',
      );
  String leaguePointsToNext(int n, String word, String name) => _t(
        '$n $word to league “$name”',
        'До ступени «$name» — $n $word',
        '$n $word até a liga “$name”',
        '$n $word hasta la liga “$name”',
      );

  String leagueName(String id) {
    switch (id) {
      case 'novice':
        return _t('Novice', 'Новичок', 'Iniciante', 'Novato');
      case 'student':
        return _t('Student', 'Ученик', 'Aluno', 'Alumno');
      case 'practitioner':
        return _t('Practitioner', 'Практик', 'Praticante', 'Practicante');
      case 'trader':
        return _t('Trader', 'Трейдер', 'Trader', 'Trader');
      case 'pro':
        return _t('Pro', 'Профи', 'Pro', 'Pro');
      default:
        return id;
    }
  }

  String leagueUnlock(String? id) {
    switch (id) {
      case 'students_chat':
        return _t('Students chat', 'Чат учеников', 'Chat de alunos', 'Chat de alumnos');
      case 'pro_chat':
        return _t('Pro chat', 'Чат профи', 'Chat pro', 'Chat pro');
      default:
        return id ?? '';
    }
  }

  // ── Stage soon (5–6) ──
  String stageNumberTitle(int n) => _t('Stage $n', 'Ступень $n', 'Etapa $n', 'Etapa $n');
  String get stageGraduateClubTitle => _t(
        'Club graduate',
        'Выпускник клуба',
        'Formado do clube',
        'Egresado del club',
      );
  String get stage5HeroBody => _t(
        'After the diploma a mentor leads this stage in pro chat. The app has no broker account opening and no external payments — only learning and entry conditions.',
        'После диплома ступень ведёт наставник в чате профи. В приложении нет открытия брокерского счёта и нет внешних платежей — только обучение и условия входа.',
        'Após o diploma um mentor conduz esta etapa no chat pro. O app não abre conta de corretora nem pagamentos externos — só aprendizado e condições de entrada.',
        'Tras el diploma un mentor guía esta etapa en el chat pro. La app no abre cuenta de bróker ni pagos externos — solo aprendizaje y condiciones de entrada.',
      );
  String get stage6HeroBody => _t(
        'This stage is done with a mentor in pro chat. In the app it opens after the diploma.',
        'Эту ступень проходят с наставником в чате профи. В приложении она откроется после диплома.',
        'Esta etapa é feita com um mentor no chat pro. No app abre após o diploma.',
        'Esta etapa se hace con un mentor en el chat pro. En la app se abre tras el diploma.',
      );
  String get whatsInside => _t("What's inside", 'Что внутри', 'O que tem dentro', 'Qué hay dentro');
  String get howToJoin => _t('How to join', 'Как попасть', 'Como entrar', 'Cómo entrar');
  String get proChatAndTerms => _t(
        'Pro chat and requirements',
        'Чат профи и условия',
        'Chat pro e requisitos',
        'Chat pro y requisitos',
      );
  String get backToLessons => _t(
        'Back to lessons',
        'Вернуться к урокам',
        'Voltar às aulas',
        'Volver a las lecciones',
      );
  String get stage5Point1 => _t(
        'Risk rules and daily loss limit — with a mentor',
        'Правила риска и дневной лимит убытка — с наставником',
        'Regras de risco e limite diário de perda — com mentor',
        'Reglas de riesgo y límite diario de pérdida — con mentor',
      );
  String get stage5Point2 => _t(
        'Readiness checklist before any live trades',
        'Чеклист готовности перед любыми реальными сделками',
        'Checklist de prontidão antes de qualquer trade real',
        'Checklist de preparación antes de cualquier trade real',
      );
  String get stage5Point3 => _t(
        'First practice trade with a full plan (entry, stop, take)',
        'Первая учебная сделка по полному плану (вход, стоп, тейк)',
        'Primeira operação de prática com plano completo (entrada, stop, take)',
        'Primera operación de práctica con plan completo (entrada, stop, take)',
      );
  String get stage5Point4 => _t(
        '30 days of daily reports in pro chat',
        '30 дней ежедневных отчётов в чате профи',
        '30 dias de relatórios diários no chat pro',
        '30 días de informes diarios en el chat pro',
      );
  String get stage6Point1 => _t(
        'Graduation after 30 days of discipline by club rules',
        'Выпуск после 30 дней дисциплины по правилам клуба',
        'Formatura após 30 dias de disciplina pelas regras do clube',
        'Graduación tras 30 días de disciplina según reglas del club',
      );
  String get stage6Point2 => _t(
        'Reviewing beginners’ homework',
        'Проверка домашних заданий новичков',
        'Revisar tarefas de iniciantes',
        'Revisar tareas de novatos',
      );
  String get stage6Point3 => _t(
        'Trade reviews for stages 1–3',
        'Разборы сделок для ступеней 1–3',
        'Revisões de trades para etapas 1–3',
        'Revisiones de trades para etapas 1–3',
      );
  String get leagueLabel => _t('League', 'Лига', 'Liga', 'Liga');
  String leagueWithPoints(String name, String points, String word) => _t(
        'League “$name” · $points $word',
        'Лига «$name» · $points $word',
        'Liga “$name” · $points $word',
        'Liga “$name” · $points $word',
      );
  String get lessonWordShort => _t('lesson', 'урок', 'aula', 'lección');
  String get lessonStillLocked => _t(
        'Lesson still locked',
        'Урок пока закрыт',
        'Aula ainda bloqueada',
        'Lección aún bloqueada',
      );
  String get gotIt => _t('Got it', 'Понятно', 'Entendi', 'Entendido');
  String openLessonN(int n) => _t(
        'Open lesson $n',
        'Открыть урок $n',
        'Abrir aula $n',
        'Abrir lección $n',
      );

  // ── Soft ref screen ──
  String get softRefTitle => _t('Next on your path', 'Дальше по пути', 'Próximo no caminho', 'Siguiente en el camino');
  String get softRefHero => softRefBannerTitle;
  String get softRefHeroBody => _t(
        'All lessons are already open. Club-link registration is optional for learning — it opens pro chat, reviews and the live-account path later.',
        'Все уроки уже открыты. Регистрация по ссылке клуба не обязательна для учёбы — она открывает профи-чат, разборы и путь к реальному счёту позже.',
        'Todas as aulas já estão abertas. Registrar pelo link do clube é opcional para estudar — abre chat pro, revisões e o caminho à conta real depois.',
        'Todas las lecciones ya están abiertas. Registrarse con el enlace del club es opcional para estudiar — abre chat pro, revisiones y el camino a cuenta real después.',
      );
  String get softRefBenefitsTitle => _t(
        'What the recommended path gives you',
        'Что даёт рекомендуемый путь',
        'O que o caminho recomendado oferece',
        'Qué te da el camino recomendado',
      );
  String get softRefBenefit1 => _t(
        'Club status for pro chat (detects and reviews)',
        'Статус в клубе для чата профи (детекты и разборы)',
        'Status no clube para o chat pro (detects e revisões)',
        'Estado en el club para el chat pro (detects y revisiones)',
      );
  String get softRefBenefit2 => _t(
        'Support on the “live account” stage after diploma',
        'Сопровождение на ступени «настоящий счёт» после диплома',
        'Acompanhamento na etapa “conta real” após o diploma',
        'Acompañamiento en la etapa “cuenta real” tras el diploma',
      );
  String get softRefBenefit3 => _t(
        'Club partner terms (cashback) — with disclosure on the next screen',
        'Условия партнёра клуба (кэшбэк) — с раскрытием на следующем экране',
        'Termos do parceiro do clube (cashback) — com divulgação na próxima tela',
        'Condiciones del socio del club (cashback) — con divulgación en la siguiente pantalla',
      );
  String get softRefWithoutNote => _t(
        'Without this path you still get all lessons, homework, ladder and the students chat.',
        'Без этого пути ты по-прежнему проходишь все уроки, домашки, ладер и ученический чат.',
        'Sem esse caminho você continua com todas as aulas, tarefas, ranking e o chat de alunos.',
        'Sin este camino sigues con todas las lecciones, tareas, ranking y el chat de alumnos.',
      );
  String get softRefCtaPrimary => _t(
        'Recommended: Desk Club path',
        'Рекомендуем: путь Desk Club',
        'Recomendado: caminho Desk Club',
        'Recomendado: camino Desk Club',
      );
  String get softRefCtaSecondary => _t(
        'Continue learning without this',
        'Продолжить обучение без этого',
        'Continuar estudando sem isso',
        'Seguir aprendiendo sin esto',
      );

  // ── Paper trading gate ──
  String get paperExchangeTitle => paperTrading;
  String paperExchangeOpensAfter(int n) => _t(
        'Paper exchange opens after lesson $n',
        'Учебная биржа откроется после урока $n',
        'A bolsa de treino abre após a aula $n',
        'La bolsa de práctica se abre tras la lección $n',
      );
  String get paperExchangeLockedBody => _t(
        'Here you’ll buy and sell with practice money. First finish the lessons on charts, stop, take and trade plan.',
        'Здесь ты будешь покупать и продавать на учебные деньги. Чтобы это было понятно, сначала пройди уроки про график, стоп, тейк и план сделки.',
        'Aqui você compra e vende com dinheiro de treino. Antes, faça as aulas sobre gráfico, stop, take e plano de trade.',
        'Aquí comprarás y venderás con dinero de práctica. Antes completa las lecciones de gráfico, stop, take y plan de trade.',
      );
  String get toLessonsBtn => _t('To lessons', 'К урокам', 'Ir às aulas', 'A las lecciones');
  String get backToLessonTooltip => _t('Back to lesson', 'Назад к уроку', 'Voltar à aula', 'Volver a la lección');
  String get resetPaperAccount => _t(
        'Reset practice account',
        'Сбросить учебный счёт',
        'Zerar conta de treino',
        'Reiniciar cuenta de práctica',
      );

  // ── Paper trading UI ──
  String lessonTitleWithId(int id, String title) => _t(
        'Lesson $id · $title',
        'Урок $id · $title',
        'Aula $id · $title',
        'Lección $id · $title',
      );
  String get freePracticeTitle => _t(
        'Free practice',
        'Свободная практика',
        'Prática livre',
        'Práctica libre',
      );
  String get freePracticeIdea => _t(
        'Paper exchange: practice money, the program draws the price. Plan first, then the button.',
        'Учебная биржа: деньги учебные, цену рисует программа. Сначала план, потом кнопка.',
        'Bolsa de treino: dinheiro de prática, o programa desenha o preço. Plano primeiro, depois o botão.',
        'Bolsa de práctica: dinero de práctica, el programa dibuja el precio. Primero el plan, luego el botón.',
      );
  String get freePracticeStep1 => _t(
        'Tap “Set stop and take from the current price”. Entry always equals the current price.',
        'Нажми «Поставить стоп и тейк от текущей цены». Вход всегда равен текущей цене.',
        'Toque em “Definir stop e take pelo preço atual”. A entrada sempre é o preço atual.',
        'Toca “Poner stop y take desde el precio actual”. La entrada siempre es el precio actual.',
      );
  String get freePracticeStep2 => _t(
        'Check the numbers under the plan: how much you lose on the stop and make on the take.',
        'Проверь цифры внизу плана: сколько потеряешь на стопе и заработаешь на тейке.',
        'Confira os números sob o plano: quanto perde no stop e ganha no take.',
        'Revisa los números bajo el plan: cuánto pierdes en el stop y ganas en el take.',
      );
  String get freePracticeStep3 => _t(
        'Tap the trade button.',
        'Нажми кнопку сделки.',
        'Toque no botão de trade.',
        'Toca el botón de trade.',
      );
  String get freePracticeStep4 => _t(
        'Wait for the stop or take. The trade closes on its own and goes into history.',
        'Дождись, пока сработает стоп или тейк. Сделка закроется сама и попадёт в историю.',
        'Espere o stop ou o take. O trade fecha sozinho e vai para o histórico.',
        'Espera el stop o el take. El trade se cierra solo y pasa al historial.',
      );
  String get freePracticeHowToFinish => _t(
        'The trade ends on its own when the price reaches the stop or take.',
        'Сделка закончится сама, когда цена дойдёт до стопа или тейка.',
        'O trade termina sozinho quando o preço chega ao stop ou take.',
        'El trade termina solo cuando el precio llega al stop o take.',
      );
  String get legacyPracticeStep1 => _t(
        'Tap “Set stop and take from the current price”.',
        'Нажми «Поставить стоп и тейк от текущей цены».',
        'Toque em “Definir stop e take pelo preço atual”.',
        'Toca “Poner stop y take desde el precio actual”.',
      );
  String get legacyPracticeStep2 => _t(
        'Check the rows “If stop hits” and “If take hits”.',
        'Проверь строки «Если сработает стоп» и «Если сработает тейк».',
        'Confira as linhas “Se o stop bater” e “Se o take bater”.',
        'Revisa las filas “Si salta el stop” y “Si salta el take”.',
      );
  String get legacyPracticeStep3 => freePracticeStep3;
  String get legacyPracticeStep4 => _t(
        'Wait for the stop or take. The trade closes on its own and goes into history.',
        'Дождись стопа или тейка. Сделка закроется сама и попадёт в историю.',
        'Espere o stop ou o take. O trade fecha sozinho e vai para o histórico.',
        'Espera el stop o el take. El trade se cierra solo y pasa al historial.',
      );

  String get planFillStopTake => _t(
        'Fill in the “Stop” and “Take” fields.',
        'Заполни поля «Стоп» и «Тейк».',
        'Preencha os campos “Stop” e “Take”.',
        'Rellena los campos “Stop” y “Take”.',
      );
  String get planStopBelowEntry => _t(
        'Stop must be below entry: it closes the trade if the price falls.',
        'Стоп должен быть ниже входа: он закроет сделку, если цена упадёт.',
        'O stop deve ficar abaixo da entrada: fecha o trade se o preço cair.',
        'El stop debe estar debajo de la entrada: cierra el trade si el precio baja.',
      );
  String get planTakeAboveEntry => _t(
        'Take must be above entry: it closes the trade when the price rises.',
        'Тейк должен быть выше входа: он закроет сделку, когда цена вырастет.',
        'O take deve ficar acima da entrada: fecha o trade quando o preço subir.',
        'El take debe estar encima de la entrada: cierra el trade cuando el precio sube.',
      );
  String get planStopAboveEntryShort => _t(
        'In a short, stop must be above entry.',
        'В шорте стоп должен быть выше входа.',
        'No short, o stop deve ficar acima da entrada.',
        'En un short, el stop debe estar encima de la entrada.',
      );
  String get planTakeBelowEntryShort => _t(
        'In a short, take must be below entry.',
        'В шорте тейк должен быть ниже входа.',
        'No short, o take deve ficar abaixo da entrada.',
        'En un short, el take debe estar debajo de la entrada.',
      );
  String get planMinBuyAmount => _t(
        'Buy amount — at least 10 USDT.',
        'Сумма покупки — минимум 10 USDT.',
        'Valor da compra — mínimo 10 USDT.',
        'Importe de compra — mínimo 10 USDT.',
      );
  String get planRiskRange => _t(
        'Risk per trade — from 0.25% to 1% of the account.',
        'Риск на сделку — от 0,25 до 1% счёта.',
        'Risco por trade — de 0,25% a 1% da conta.',
        'Riesgo por trade — del 0,25% al 1% de la cuenta.',
      );
  String get planLeverageRange => _t(
        'Leverage in the course — from 1 to 3.',
        'Плечо в курсе — от 1 до 3.',
        'Alavancagem no curso — de 1 a 3.',
        'Apalancamiento en el curso — de 1 a 3.',
      );
  String planRrNeed(String shown, String need) => _t(
        'Risk to reward is now 1 to $shown, but you need at least 1 to $need: take must be $need times farther from entry than the stop.',
        'Риск к прибыли сейчас 1 к $shown, а нужно хотя бы 1 к $need: тейк должен быть в $need раза дальше от входа, чем стоп.',
        'Risco/retorno agora é 1 para $shown, mas precisa de pelo menos 1 para $need: o take deve ficar $need vezes mais longe da entrada que o stop.',
        'Riesgo/beneficio ahora es 1 a $shown, pero necesitas al menos 1 a $need: el take debe quedar $need veces más lejos de la entrada que el stop.',
      );
  String get planStopPastLiq => _t(
        'Stop must trigger before the liquidation price.',
        'Стоп должен сработать раньше цены ликвидации.',
        'O stop deve disparar antes do preço de liquidação.',
        'El stop debe saltar antes del precio de liquidación.',
      );
  String get planStopTooFarForLev => _t(
        'Stop is too far for this leverage. Move the stop closer or use lower leverage.',
        'Стоп слишком далеко для такого плеча. Поставь стоп ближе или плечо меньше.',
        'Stop longe demais para esta alavancagem. Aproxime o stop ou use menos alavancagem.',
        'El stop está demasiado lejos para este apalancamiento. Acerca el stop o baja el apalancamiento.',
      );
  String paperBalanceOnly(String amount) => _t(
        'The practice account has only $amount USDT.',
        'На учебном счёте только $amount USDT.',
        'A conta de treino tem só $amount USDT.',
        'La cuenta de práctica solo tiene $amount USDT.',
      );

  String get fillStopTakeFirst => _t(
        'Fill in “Stop” and “Take” first. What’s wrong is written under the plan.',
        'Сначала заполни поля «Стоп» и «Тейк». Что не так, написано под планом.',
        'Preencha “Stop” e “Take” primeiro. O erro está escrito sob o plano.',
        'Rellena “Stop” y “Take” primero. Lo que falla está bajo el plan.',
      );
  String get planIsShortPickLong => _t(
        'The plan is set to “Short”. Pick “Long” in the plan.',
        'В плане выбран «Шорт». Выбери в плане «Лонг».',
        'O plano está em “Short”. Escolha “Long” no plano.',
        'El plan está en “Short”. Elige “Long” en el plan.',
      );
  String get planIsLongPickShort => _t(
        'The plan is set to “Long”. Pick “Short” in the plan.',
        'В плане выбран «Лонг». Выбери в плане «Шорт».',
        'O plano está em “Long”. Escolha “Short” no plano.',
        'El plan está en “Long”. Elige “Short” en el plan.',
      );
  String get tradeAlreadyOpen => _t(
        'A trade is already open. Wait for the stop or take, or close it.',
        'Сделка уже открыта. Дождись стопа или тейка либо закрой её.',
        'Já há um trade aberto. Espere o stop ou take, ou feche-o.',
        'Ya hay un trade abierto. Espera el stop o take, o ciérralo.',
      );
  String get stopDaySnack => _t(
        'Stop-day today: two losses in a row. New trades tomorrow.',
        'Сегодня стоп-день: было два убытка подряд. Новые сделки — завтра.',
        'Hoje é stop-day: duas perdas seguidas. Novos trades amanhã.',
        'Hoy es stop-day: dos pérdidas seguidas. Nuevos trades mañana.',
      );
  String priceNowWithErr(String price, String err) => _t(
        'Price now $price. $err',
        'Цена сейчас $price. $err',
        'Preço agora $price. $err',
        'Precio ahora $price. $err',
      );
  String get notEnoughPaperMoney => _t(
        'Not enough practice money. Lower the amount or the risk.',
        'Не хватает учебных денег. Уменьши сумму или риск.',
        'Dinheiro de treino insuficiente. Diminua o valor ou o risco.',
        'No hay suficiente dinero de práctica. Baja el importe o el riesgo.',
      );
  String boughtSol(String coins) => _t(
        'Bought $coins SOL',
        'Куплено $coins SOL',
        'Comprado $coins SOL',
        'Comprado $coins SOL',
      );
  String openedLongContract(String coins) => _t(
        'Opened long: contract on $coins SOL',
        'Открыт лонг: контракт на $coins SOL',
        'Long aberto: contrato de $coins SOL',
        'Long abierto: contrato de $coins SOL',
      );
  String openedShortContract(String coins) => _t(
        'Opened short: contract on $coins SOL',
        'Открыт шорт: контракт на $coins SOL',
        'Short aberto: contrato de $coins SOL',
        'Short abierto: contrato de $coins SOL',
      );
  String openTradeSnack(String what, String price, String stop, String take, String feePart) => _t(
        '$what at $price. Stop $stop, take $take$feePart.',
        '$what по $price. Стоп $stop, тейк $take$feePart.',
        '$what a $price. Stop $stop, take $take$feePart.',
        '$what a $price. Stop $stop, take $take$feePart.',
      );
  String feePartUsdt(String fee) => _t(
        '. Fee $fee USDT',
        '. Комиссия $fee USDT',
        '. Taxa $fee USDT',
        '. Comisión $fee USDT',
      );
  String get moveStopHalfwayOnly => _t(
        'You can move the stop to entry when the price has covered half the way to the take.',
        'Перенести стоп на цену входа можно, когда цена прошла половину пути до тейка.',
        'Dá para mover o stop para a entrada quando o preço cobriu metade do caminho até o take.',
        'Puedes mover el stop a la entrada cuando el precio haya cubierto la mitad del camino al take.',
      );
  String stopMovedToEntry(String price) => _t(
        'Stop moved to entry $price: if price returns here, the trade closes with no price loss.',
        'Стоп перенесён на цену входа $price: если цена вернётся сюда, сделка закроется без убытка от цены.',
        'Stop movido para a entrada $price: se o preço voltar aqui, o trade fecha sem perda de preço.',
        'Stop movido a la entrada $price: si el precio vuelve aquí, el trade cierra sin pérdida de precio.',
      );
  String get sideBuy => _t('Buy', 'Покупка', 'Compra', 'Compra');
  String get sideLong => _t('Long', 'Лонг', 'Long', 'Long');
  String get sideShort => _t('Short', 'Шорт', 'Short', 'Short');
  String get paperTradeSetup => _t(
        'Practice trade',
        'Учебная сделка',
        'Trade de treino',
        'Trade de práctica',
      );
  String tradeNotesLine(String side, String entry, String exit, String reason) => _t(
        '$side: entry $entry, exit $exit · $reason',
        '$side: вход $entry, выход $exit · $reason',
        '$side: entrada $entry, saída $exit · $reason',
        '$side: entrada $entry, salida $exit · $reason',
      );
  String pointsForPlanTrade(int n, String word) => _t(
        ' · +$n $word for a trade by plan',
        ' · +$n $word за сделку по плану',
        ' · +$n $word por trade com plano',
        ' · +$n $word por trade con plan',
      );
  String get stopTooCloseNoPoints => _t(
        ' · Stop was too close to entry, under 0.5% of price. This trade does not count; no points',
        ' · Стоп стоял слишком близко к входу, меньше 0,5% от цены. Такая сделка не засчитывается, очков за неё нет',
        ' · Stop estava perto demais da entrada, menos de 0,5% do preço. Este trade não conta; sem pontos',
        ' · El stop estaba demasiado cerca de la entrada, menos del 0,5% del precio. Este trade no cuenta; sin puntos',
      );
  String get lessonTaskDone => _t(
        ' · Lesson task done',
        ' · Задание урока выполнено',
        ' · Tarefa da aula concluída',
        ' · Tarea de la lección hecha',
      );
  String get openNewFartherStop => _t(
        '. Open a new trade with a farther stop',
        '. Открой новую сделку со стопом подальше',
        '. Abra um novo trade com stop mais longe',
        '. Abre un trade nuevo con el stop más lejos',
      );
  String get taskNotCountedOpenNew => _t(
        ' · Task not counted: the trade must close by stop or take. Open a new one',
        ' · Задание не засчитано: сделка должна закрыться по стопу или тейку. Открой новую',
        ' · Tarefa não contada: o trade deve fechar por stop ou take. Abra um novo',
        ' · Tarea no contada: el trade debe cerrar por stop o take. Abre uno nuevo',
      );
  String closeSnack(String reason, String pnl, String extra) => _t(
        '$reason: $pnl USDT$extra',
        '$reason: $pnl USDT$extra',
        '$reason: $pnl USDT$extra',
        '$reason: $pnl USDT$extra',
      );
  String get reasonStopHit => _t('Stop hit', 'Сработал стоп', 'Stop ativado', 'Saltó el stop');
  String get reasonBreakevenHit => _t(
        'Stop at entry hit',
        'Сработал стоп на цене входа',
        'Stop na entrada ativado',
        'Saltó el stop en la entrada',
      );
  String get reasonTakeHit => _t('Take hit', 'Сработал тейк', 'Take ativado', 'Saltó el take');
  String get reasonLiquidation => _t(
        'Liquidation: margin lost',
        'Ликвидация: залог потерян',
        'Liquidação: margem perdida',
        'Liquidación: margen perdido',
      );
  String get reasonManualClose => _t(
        'Trade closed manually',
        'Сделка закрыта вручную',
        'Trade fechado manualmente',
        'Trade cerrado manualmente',
      );
  String get resetPaperTitle => _t(
        'Start over?',
        'Начать заново?',
        'Começar de novo?',
        '¿Empezar de nuevo?',
      );
  String get resetPaperBody => _t(
        'The practice account will be 10 000 USDT again; any open trade will close.',
        'Учебный счёт снова станет 10 000 USDT, открытая сделка закроется.',
        'A conta de treino volta a 10 000 USDT; o trade aberto será fechado.',
        'La cuenta de práctica volverá a 10 000 USDT; el trade abierto se cerrará.',
      );
  String get paperAccountLabel => _t(
        'Practice account',
        'Учебный счёт',
        'Conta de treino',
        'Cuenta de práctica',
      );
  String freeBalanceLabel(String amount) => _t(
        'Free $amount',
        'Свободно $amount',
        'Livre $amount',
        'Libre $amount',
      );
  String onTradePnl(String pnl) => _t(
        'On trade $pnl USDT',
        'По сделке $pnl USDT',
        'No trade $pnl USDT',
        'En el trade $pnl USDT',
      );
  String get priceNowLabel => _t(
        'Price now ',
        'Цена сейчас ',
        'Preço agora ',
        'Precio ahora ',
      );
  String priceDisclaimer(String candle) => _t(
        'The program invents the price: it looks like a real one, but it is not the real SOL price. It does not adapt to you. One candle here is $candle, not an hour. When you leave this screen, the price freezes and continues from the same place.',
        'Цену придумывает программа: она похожа на настоящую, но это не настоящая цена SOL. Под тебя она не подстраивается. Одна свеча здесь — $candle, а не час. Когда уходишь с этого экрана, цена замирает и продолжит с того же места.',
        'O programa inventa o preço: parece real, mas não é o preço real do SOL. Não se adapta a você. Uma vela aqui é $candle, não uma hora. Ao sair desta tela, o preço congela e continua do mesmo lugar.',
        'El programa inventa el precio: parece real, pero no es el precio real de SOL. No se adapta a ti. Una vela aquí es $candle, no una hora. Al salir de esta pantalla, el precio se congela y sigue desde el mismo sitio.',
      );
  String get candleAbout17s => _t('about 17 seconds', 'около 17 секунд', 'cerca de 17 segundos', 'unos 17 segundos');
  String get candleAbout4s => _t('about 4 seconds', 'около 4 секунд', 'cerca de 4 segundos', 'unos 4 segundos');
  String get normalCandles => _t('Normal candles', 'Обычные свечи', 'Velas normais', 'Velas normales');
  String get bigCandles => _t('Large candles', 'Крупные свечи', 'Velas grandes', 'Velas grandes');
  String get bigCandleHint => _t(
        'A large candle is made of 4 normal ones. That is how you look at a higher timeframe.',
        'Крупная свеча собрана из 4 обычных. Так ты смотришь старший таймфрейм.',
        'Uma vela grande junta 4 normais. Assim você olha o timeframe maior.',
        'Una vela grande junta 4 normales. Así miras el timeframe mayor.',
      );
  String get stopDayBanner => _t(
        'Stop-day today: two losses in a row. By your rule, new trades only tomorrow. Better calmly write down what went wrong.',
        'Сегодня стоп-день: два убытка подряд. По твоему правилу новые сделки — только завтра. Сейчас лучше спокойно записать, что пошло не так.',
        'Hoje é stop-day: duas perdas seguidas. Pela sua regra, novos trades só amanhã. Melhor anotar com calma o que deu errado.',
        'Hoy es stop-day: dos pérdidas seguidas. Por tu regla, nuevos trades solo mañana. Mejor anota con calma qué falló.',
      );
  String get openLongBtn => _t('Open long', 'Открыть лонг', 'Abrir long', 'Abrir long');
  String get openShortBtn => _t('Open short', 'Открыть шорт', 'Abrir short', 'Abrir short');
  String get buyBtn => _t('Buy', 'Купить', 'Comprar', 'Comprar');
  String get tradeHistoryTitle => _t(
        'Trade history',
        'История сделок',
        'Histórico de trades',
        'Historial de trades',
      );
  String get tradeHistoryEmpty => _t(
        'The result of each closed trade will show up here.',
        'Здесь появится результат каждой закрытой сделки.',
        'O resultado de cada trade fechado aparece aqui.',
        'Aquí aparecerá el resultado de cada trade cerrado.',
      );
  String get resultCommentTarget => _t(
        'Price reached the take — trade closed by plan.',
        'Цена дошла до тейка — сделка закрыта по плану.',
        'Preço chegou ao take — trade fechado pelo plano.',
        'El precio llegó al take — trade cerrado según el plan.',
      );
  String get resultCommentStop => _t(
        'Loss was capped in advance, as in the plan. That is a normal outcome.',
        'Убыток ограничен заранее, как в плане. Это нормальный итог.',
        'A perda foi limitada de antemão, como no plano. Resultado normal.',
        'La pérdida se limitó de antemano, como en el plan. Es un resultado normal.',
      );
  String get resultCommentBreakevenFee => _t(
        'Stop was at entry: price returned to entry. The small minus is the exchange fee, not a price loss.',
        'Стоп стоял на цене входа: цена вернулась к цене входа. Небольшой минус — это комиссия биржи, а не убыток от цены.',
        'Stop estava na entrada: o preço voltou à entrada. O pequeno menos é a taxa da bolsa, não perda de preço.',
        'El stop estaba en la entrada: el precio volvió a la entrada. El pequeño menos es la comisión del exchange, no pérdida de precio.',
      );
  String get resultCommentBreakevenFlat => _t(
        'Stop was at entry: trade closed with no profit and no loss.',
        'Стоп стоял на цене входа: сделка закрыта без прибыли и без убытка.',
        'Stop estava na entrada: trade fechado sem lucro e sem prejuízo.',
        'El stop estaba en la entrada: trade cerrado sin beneficio ni pérdida.',
      );
  String get resultCommentLiq => _t(
        'Stop was too far or leverage was too high. That should not happen.',
        'Стоп стоял слишком далеко или плечо было слишком большим. Так быть не должно.',
        'Stop longe demais ou alavancagem alta demais. Isso não deveria acontecer.',
        'El stop estaba demasiado lejos o el apalancamiento era demasiado alto. Eso no debería pasar.',
      );
  String get resultCommentManual => _t(
        'Trade closed manually, not by plan. Write down why.',
        'Сделка закрыта вручную, не по плану. Запиши, почему.',
        'Trade fechado manualmente, não pelo plano. Anote o porquê.',
        'Trade cerrado a mano, no según el plan. Anota el porqué.',
      );
  String get resultInHistoryBelow => _t(
        'The outcome is in trade history below.',
        'Итог есть в истории сделок ниже.',
        'O resultado está no histórico abaixo.',
        'El resultado está en el historial abajo.',
      );
  String get positionOpenBuy => _t(
        'Trade open: buy',
        'Сделка открыта: покупка',
        'Trade aberto: compra',
        'Trade abierto: compra',
      );
  String get positionOpenLong => _t('Long open', 'Открыт лонг', 'Long aberto', 'Long abierto');
  String get positionOpenShort => _t('Short open', 'Открыт шорт', 'Short aberto', 'Short abierto');
  String contractOnSol(String coins, String entry) => _t(
        'Contract on $coins SOL · entry $entry',
        'Контракт на $coins SOL · вход $entry',
        'Contrato de $coins SOL · entrada $entry',
        'Contrato de $coins SOL · entrada $entry',
      );
  String spotPositionLine(String coins, String entry) => _t(
        '$coins SOL · entry $entry',
        '$coins SOL · вход $entry',
        '$coins SOL · entrada $entry',
        '$coins SOL · entrada $entry',
      );
  String stopAtEntryLine(String stop) => _t(
        'Stop $stop — at entry: trade closes with no price loss',
        'Стоп $stop — на цене входа: сделка закроется без убытка от цены',
        'Stop $stop — na entrada: o trade fecha sem perda de preço',
        'Stop $stop — en la entrada: el trade cierra sin pérdida de precio',
      );
  String stopWillCloseLoss(String stop) => _t(
        'Stop $stop — will close the trade itself with the loss calculated in the plan',
        'Стоп $stop — закроет сделку сам с убытком, посчитанным в плане',
        'Stop $stop — fecha o trade sozinho com a perda calculada no plano',
        'Stop $stop — cerrará el trade solo con la pérdida del plan',
      );
  String takeWillCloseProfit(String take) => _t(
        'Take $take — will close the trade itself with a profit',
        'Тейк $take — закроет сделку сам с прибылью',
        'Take $take — fecha o trade sozinho com lucro',
        'Take $take — cerrará el trade solo con beneficio',
      );
  String pnlNowLine(String pnl) => _t(
        'On the trade now: $pnl USDT',
        'Сейчас по сделке: $pnl USDT',
        'Agora no trade: $pnl USDT',
        'Ahora en el trade: $pnl USDT',
      );
  String get waitForStopTakeHint => _t(
        'Just wait: the trade will close on its own by stop or take. Use “Close trade now” only if you need to exit earlier.',
        'Просто жди: сделка закроется сама по стопу или тейку. Кнопку «Закрыть сделку сейчас» нажимай, только если нужно выйти раньше.',
        'Só espere: o trade fecha sozinho por stop ou take. Use “Fechar trade agora” só se precisar sair antes.',
        'Solo espera: el trade se cierra solo por stop o take. Usa “Cerrar trade ahora” solo si necesitas salir antes.',
      );
  String get moveStopToEntryBtn => _t(
        'Move stop to entry',
        'Перенести стоп на цену входа',
        'Mover stop para a entrada',
        'Mover stop a la entrada',
      );
  String get breakevenBtnReady => _t(
        'The button works when the price has covered half the way to the take.',
        'Кнопка работает, когда цена прошла половину пути до тейка.',
        'O botão funciona quando o preço cobriu metade do caminho até o take.',
        'El botón funciona cuando el precio ha cubierto la mitad del camino al take.',
      );
  String get breakevenBtnLocked => _t(
        'The button unlocks when the price has covered half the way to the take.',
        'Кнопка станет доступна, когда цена пройдёт половину пути до тейка.',
        'O botão libera quando o preço cobrir metade do caminho até o take.',
        'El botón se activa cuando el precio cubra la mitad del camino al take.',
      );
  String get closeTradeNowBtn => _t(
        'Close trade now',
        'Закрыть сделку сейчас',
        'Fechar trade agora',
        'Cerrar trade ahora',
      );
  String taskDoneTitle(String title) => _t(
        '$title · task done',
        '$title · задание выполнено',
        '$title · tarefa concluída',
        '$title · tarea hecha',
      );
  String get collapseTaskTooltip => _t('Collapse task', 'Свернуть задание', 'Recolher tarefa', 'Plegar tarea');
  String get showTaskTooltip => _t('Show task', 'Показать задание', 'Mostrar tarefa', 'Mostrar tarea');
  String get whatToDoLabel => _t('What to do', 'Что делать', 'O que fazer', 'Qué hacer');
  String get returnToLessonBtn => _t(
        'Back to lesson',
        'Вернуться к уроку',
        'Voltar à aula',
        'Volver a la lección',
      );

  String get tradePlanIntro => _t(
        'The trade opens at the price when you tap, so entry always equals the current price. The button below sets stop and take from the current price and moves them with it. If you type your own numbers, they stay put.',
        'Сделка откроется по цене в момент нажатия, поэтому вход всегда равен текущей цене. Кнопка ниже ставит стоп и тейк от текущей цены и двигает их вместе с ней. Если впишешь свои числа, они останутся на месте.',
        'O trade abre no preço do toque, então a entrada sempre é o preço atual. O botão abaixo define stop e take pelo preço atual e os move com ele. Se digitar seus números, eles ficam.',
        'El trade abre al precio del toque, así que la entrada siempre es el precio actual. El botón abajo pone stop y take desde el precio actual y los mueve con él. Si escribes tus números, se quedan.',
      );
  String get setStopTakeFromPrice => _t(
        'Set stop and take from the current price',
        'Поставить стоп и тейк от текущей цены',
        'Definir stop e take pelo preço atual',
        'Poner stop y take desde el precio actual',
      );
  String get longHint => _t(
        'Long: profit if price rises; loss if it falls.',
        'Лонг: прибыль, если цена вырастет; убыток, если упадёт.',
        'Long: lucro se o preço subir; prejuízo se cair.',
        'Long: beneficio si el precio sube; pérdida si baja.',
      );
  String get shortHint => _t(
        'Short: profit if price falls; loss if it rises.',
        'Шорт: прибыль, если цена упадёт; убыток, если вырастет.',
        'Short: lucro se o preço cair; prejuízo se subir.',
        'Short: beneficio si el precio baja; pérdida si sube.',
      );
  String get entryCurrentPrice => _t(
        'Entry — current price',
        'Вход — текущая цена',
        'Entrada — preço atual',
        'Entrada — precio actual',
      );
  String get stopHintLong => _t(
        'below entry: closes the trade at a loss; loss amount is under the plan',
        'ниже входа: закроет сделку с убытком, сумма убытка — под планом',
        'abaixo da entrada: fecha o trade com prejuízo; o valor está sob o plano',
        'debajo de la entrada: cierra el trade con pérdida; el importe está bajo el plan',
      );
  String get stopHintShort => _t(
        'above entry: closes the trade at a loss; loss amount is under the plan',
        'выше входа: закроет сделку с убытком, сумма убытка — под планом',
        'acima da entrada: fecha o trade com prejuízo; o valor está sob o plano',
        'encima de la entrada: cierra el trade con pérdida; el importe está bajo el plan',
      );
  String get takeHintLong => _t(
        'above entry: closes the trade with a profit',
        'выше входа: закроет сделку с прибылью',
        'acima da entrada: fecha o trade com lucro',
        'encima de la entrada: cierra el trade con beneficio',
      );
  String get takeHintShort => _t(
        'below entry: closes the trade with a profit',
        'ниже входа: закроет сделку с прибылью',
        'abaixo da entrada: fecha o trade com lucro',
        'debajo de la entrada: cierra el trade con beneficio',
      );
  String get riskPerTradeLabel => _t(
        'Risk per trade, %',
        'Риск на сделку, %',
        'Risco por trade, %',
        'Riesgo por trade, %',
      );
  String get riskPerTradeHint => _t(
        'from 0.25 to 1% of the account',
        'от 0,25 до 1% счёта',
        'de 0,25 a 1% da conta',
        'del 0,25 al 1% de la cuenta',
      );
  String get buyAmountLabel => _t(
        'Buy amount, USDT',
        'Сумма покупки, USDT',
        'Valor da compra, USDT',
        'Importe de compra, USDT',
      );
  String get buyAmountHint => _t(
        'how much practice money to spend',
        'сколько учебных денег потратить',
        'quanto dinheiro de treino gastar',
        'cuánto dinero de práctica gastar',
      );
  String get leverageLabel => _t('Leverage', 'Плечо', 'Alavancagem', 'Apalancamiento');
  String get leverage1Hint => _t(
        'Leverage 1 — margin equals the trade size.',
        'Плечо 1 — залог равен сумме сделки.',
        'Alavancagem 1 — a margem é igual ao tamanho do trade.',
        'Apalancamiento 1 — el margen es igual al tamaño del trade.',
      );
  String leverageNHint(int n) => _t(
        'Leverage $n — margin is $n times smaller than the trade size. Loss at the stop is the same.',
        'Плечо $n — залог в $n раза меньше суммы сделки. Убыток на стопе тот же.',
        'Alavancagem $n — a margem é $n vezes menor que o trade. A perda no stop é a mesma.',
        'Apalancamiento $n — el margen es $n veces menor que el trade. La pérdida en el stop es la misma.',
      );
  String get isolatedMarginHint => _t(
        'Isolated margin: only this trade’s margin is at risk.',
        'Изолированная маржа: под риском только залог этой сделки.',
        'Margem isolada: só a margem deste trade está em risco.',
        'Margen aislado: solo el margen de este trade está en riesgo.',
      );
  String contractRow(String coins, String cost) => _t(
        '$coins SOL, size $cost USDT',
        '$coins SOL, сумма $cost USDT',
        '$coins SOL, tamanho $cost USDT',
        '$coins SOL, tamaño $cost USDT',
      );
  String get contractLabel => _t('Contract', 'Контракт', 'Contrato', 'Contrato');
  String willBuyRow(String coins, String cost) => _t(
        '$coins SOL for $cost USDT',
        '$coins SOL на $cost USDT',
        '$coins SOL por $cost USDT',
        '$coins SOL por $cost USDT',
      );
  String get willBuyLabel => _t('You buy', 'Купишь', 'Você compra', 'Compras');
  String get marginLabel => _t('Margin', 'Залог', 'Margem', 'Margen');
  String get ifStopHits => _t('If stop hits', 'Если сработает стоп', 'Se o stop bater', 'Si salta el stop');
  String get ifTakeHits => _t('If take hits', 'Если сработает тейк', 'Se o take bater', 'Si salta el take');
  String get riskToRewardLabel => _t('Risk to reward', 'Риск к прибыли', 'Risco/retorno', 'Riesgo/beneficio');
  String riskRewardValue(String ratio) => _t('1 to $ratio', '1 к $ratio', '1 para $ratio', '1 a $ratio');
  String rrNeedHint(String ratio) => _t(
        'You need at least 1 to $ratio. Entry equals the current price, so the ratio moves with it. Tap “Set stop and take from the current price” or type a take farther from entry.',
        'Нужно хотя бы 1 к $ratio. Вход равен текущей цене, поэтому соотношение меняется вместе с ней. Нажми «Поставить стоп и тейк от текущей цены» или впиши в поле «Тейк» цену дальше от входа.',
        'Precisa de pelo menos 1 para $ratio. A entrada é o preço atual, então a razão muda com ele. Toque em “Definir stop e take pelo preço atual” ou digite um take mais longe da entrada.',
        'Necesitas al menos 1 a $ratio. La entrada es el precio actual, así que el ratio se mueve con él. Toca “Poner stop y take desde el precio actual” o escribe un take más lejos de la entrada.',
      );
  String get liqPriceApprox => _t(
        'Liquidation price, approx.',
        'Цена ликвидации, примерно',
        'Preço de liquidação, aprox.',
        'Precio de liquidación, aprox.',
      );
  String get planReady => _t(
        'Plan ready. You can tap the trade button below.',
        'План готов. Теперь можно нажать кнопку сделки ниже.',
        'Plano pronto. Pode tocar no botão de trade abaixo.',
        'Plan listo. Ya puedes tocar el botón de trade abajo.',
      );

  String get chartZoomOut => _t('Zoom out', 'Отдалить', 'Afastar', 'Alejar');
  String get chartZoomIn => _t('Zoom in', 'Приблизить', 'Aproximar', 'Acercar');
  String get chartResetView => _t(
        'Back to current price',
        'Вернуться к текущей цене',
        'Voltar ao preço atual',
        'Volver al precio actual',
      );
  String get chartLabelTake => _t('Take', 'Тейк', 'Take', 'Take');
  String get chartLabelEntry => _t('Entry', 'Вход', 'Entrada', 'Entrada');
  String get chartLabelStop => _t('Stop', 'Стоп', 'Stop', 'Stop');
  String get chartLabelLiq => _t('Liquidation', 'Ликвидация', 'Liquidação', 'Liquidación');
  String chartLiqOff(String price, String where) => _t(
        'Liquidation $price — $where the chart',
        'Ликвидация $price — $where графика',
        'Liquidação $price — $where do gráfico',
        'Liquidación $price — $where del gráfico',
      );
  String get chartBelow => _t('below', 'ниже', 'abaixo', 'debajo');
  String get chartAbove => _t('above', 'выше', 'acima', 'encima');
  String get chartPastCandlesHint => _t(
        'These are past candles. The crosshair button returns to the current price',
        'Это прошлые свечи. Кнопка с прицелом вернёт к текущей цене',
        'Estas são velas passadas. O botão da mira volta ao preço atual',
        'Estas son velas pasadas. El botón de la mira vuelve al precio actual',
      );

  // ── Lesson chart factory overlays ──
  String get chartAnnCandles => _t('Candles', 'Свечи', 'Velas', 'Velas');
  String get chartAnnGreen => _t('Green', 'Зелёная', 'Verde', 'Verde');
  String get chartAnnRed => _t('Red', 'Красная', 'Vermelha', 'Roja');
  String get chartAnnBodyWicks => _t('Body and wicks', 'Тело и хвосты', 'Corpo e pavios', 'Cuerpo y mechas');
  String get chartAnnSpotYours => _t('Spot · the coin is yours', 'Спот · монета твоя', 'Spot · a moeda é sua', 'Spot · la moneda es tuya');
  String get chartAnnNoLiq => _t('No liquidation', 'Без ликвидации', 'Sem liquidação', 'Sin liquidación');
  String get chartAnnCoinStays => _t('Coin stays', 'Монета на месте', 'Moeda permanece', 'La moneda permanece');
  String get chartAnnHold => _t('Holding', 'Удержание', 'Manutenção', 'Mantener');
  String get chartAnnBought => _t('Bought', 'Купил', 'Comprei', 'Compré');
  String get chartAnnFuturesContract => _t(
        'Futures — a contract with the exchange, not the coin',
        'Фьючерс — контракт с биржей, не монета',
        'Futuros — contrato com a bolsa, não a moeda',
        'Futuros — contrato con el exchange, no la moneda',
      );
  String get chartAnnLeverageRisk => _t(
        'Leverage increases both upside and risk',
        'Плечо увеличивает и плюс, и риск',
        'Alavancagem aumenta o ganho e o risco',
        'El apalancamiento aumenta ganancia y riesgo',
      );
  String get chartAnnLiqZone => _t(
        'Liquidation zone — the exchange closes it for you',
        'Зона ликвидации — биржа закроет сама',
        'Zona de liquidação — a bolsa fecha sozinha',
        'Zona de liquidación — el exchange la cierra solo',
      );
  String get chartAnnStopBeforeLiq => _t(
        'Your stop — BEFORE the liquidation zone',
        'Твой стоп — ДО зоны ликвидации',
        'Seu stop — ANTES da zona de liquidação',
        'Tu stop — ANTES de la zona de liquidación',
      );
  String get chartAnnContractOnly => _t(
        'Contract position (no coin)',
        'Позиция по контракту (монеты нет)',
        'Posição por contrato (sem moeda)',
        'Posición por contrato (sin moneda)',
      );
  String get chartAnnOpenedPosition => _t('Opened position', 'Открыл позицию', 'Abri posição', 'Abrí posición');
  String get chartAnnZoneNotLine => _t('A zone, not a line', 'Зона, не линия', 'Zona, não linha', 'Zona, no línea');
  String get chartAnnBreakout => _t('Breakout', 'Пробой', 'Rompimento', 'Ruptura');
  String get chartAnnPatternTop => _t('Top of pattern', 'Верх фигуры', 'Topo da figura', 'Techo de la figura');
  String get chartAnnPatternBottom => _t('Bottom of pattern', 'Низ фигуры', 'Fundo da figura', 'Suelo de la figura');
  String get chartAnnPatternOnChart => _t('Pattern on the chart', 'Фигура на графике', 'Figura no gráfico', 'Figura en el gráfico');
  String get chartAnnLookHere => _t('Look here', 'Смотри сюда', 'Olhe aqui', 'Mira aquí');
  String get chartAnnCheckRr => _t(
        'Check risk to reward before you tap',
        'Риск к прибыли проверяй до нажатия кнопки',
        'Cheque risco/retorno antes de tocar',
        'Revisa riesgo/beneficio antes de pulsar',
      );
  String get chartAnnStopTakeOnExchange => _t(
        'Stop and take on the exchange',
        'Стоп и тейк на бирже',
        'Stop e take na corretora',
        'Stop y take en el exchange',
      );
  String get chartAnnMarketNow => _t(
        'What is happening in the market',
        'Что происходит на рынке',
        'O que acontece no mercado',
        'Qué pasa en el mercado',
      );
  String get chartAnnAvgPrice => _t('Average price', 'Средняя цена', 'Preço médio', 'Precio medio');
  String get chartAnnSharpDrop => _t(
        'Sharp drop after news',
        'Резкое падение после новости',
        'Queda forte após notícia',
        'Caída brusca tras una noticia',
      );
  String get chartAnnPlanCancelled => _t(
        'Plan is cancelled here',
        'Здесь план отменяется',
        'Aqui o plano se cancela',
        'Aquí se cancela el plan',
      );
  String get chartAnnRiskFirst => _t('Risk first', 'Риск сначала', 'Risco primeiro', 'Riesgo primero');
  String get chartAnnJournalAfter => _t(
        'Journal after the trade',
        'Журнал после сделки',
        'Diário após o trade',
        'Diario tras el trade',
      );
  String get chartAnnNotHere => _t('Not here', 'Не сюда', 'Não aqui', 'No aquí');

  String get depositCalcDefaultTitle => _t(
        'How much money to put in one order',
        'Сколько денег вкладывать в одну заявку',
        'Quanto dinheiro colocar em uma ordem',
        'Cuánto dinero poner en una orden',
      );
  String get depositCalcBalanceLabel => _t(
        'Account balance, USDT',
        'Сумма на счёте, USDT',
        'Saldo da conta, USDT',
        'Saldo de la cuenta, USDT',
      );
  String depositCalcShareLabel(String pct) => _t(
        'Share of one order from the account: $pct%',
        'Доля одной заявки (ордера) от счёта: $pct%',
        'Parcela de uma ordem da conta: $pct%',
        'Parte de una orden de la cuenta: $pct%',
      );
  String get depositCalcOrderSum => _t(
        'One order amount',
        'Сумма одной заявки',
        'Valor de uma ordem',
        'Importe de una orden',
      );
  String depositCalcRange(String minP, String maxP, String minO, String maxO) => _t(
        'Range $minP–$maxP%: $minO – $maxO USDT',
        'Диапазон $minP–$maxP%: $minO – $maxO USDT',
        'Faixa $minP–$maxP%: $minO – $maxO USDT',
        'Rango $minP–$maxP%: $minO – $maxO USDT',
      );

  // ── Club screen ──
  String get clubSubtitle => _t(
        'Study points raise you in the student ladder and unlock club chats in Telegram',
        'Очки за учёбу поднимают тебя в рейтинге учеников и открывают чаты клуба в Telegram',
        'Pontos de estudo sobem no ranking e abrem os chats do clube no Telegram',
        'Los puntos de estudio suben en el ranking y abren los chats del club en Telegram',
      );
  String get clubTabLadder => _t('Ladder', 'Рейтинг', 'Ranking', 'Ranking');
  String get clubTabChats => _t('Chats', 'Чаты', 'Chats', 'Chats');
  String get clubWeek => _t('Week', 'Неделя', 'Semana', 'Semana');
  String get clubAllTime => _t('All time', 'Всё время', 'Todo o tempo', 'Todo el tiempo');
  String get clubNameDialogTitle => _t('Name on the ladder', 'Имя в рейтинге', 'Nome no ranking', 'Nombre en el ranking');
  String get clubNameDialogBody => _t(
        'Others will see it on the ladder and in chats. Your ID does not change.',
        'Его увидят ребята в рейтинге и в чатах. ID не меняется.',
        'Os outros verão no ranking e nos chats. Seu ID não muda.',
        'Los demás lo verán en el ranking y en los chats. Tu ID no cambia.',
      );
  String get clubNameHint => _t('e.g. Pavel', 'Например, Павел', 'Ex.: Pavel', 'Ej.: Pavel');
  String get saveBtn => _t('Save', 'Сохранить', 'Salvar', 'Guardar');
  String get setNameForLadder => _t(
        'Set a name for the ladder',
        'Укажи имя для рейтинга',
        'Defina um nome para o ranking',
        'Pon un nombre para el ranking',
      );
  String studentDefaultName(String id) => _t('Student $id', 'Ученик $id', 'Aluno $id', 'Alumno $id');
  String leagueWithId(String name) => _t('league “$name”', 'лига «$name»', 'liga “$name”', 'liga “$name”');
  String pointsTotalLabel(String word) => _t('$word total', '$word всего', '$word no total', '$word en total');
  String get perWeekLabel => _t('this week', 'за неделю', 'esta semana', 'esta semana');
  String get daysInARow => _t('days in a row', 'дней подряд', 'dias seguidos', 'días seguidos');
  String daysInARowMult(String mult) => _t(
        'days in a row · points × $mult',
        'дней подряд · очки × $mult',
        'dias seguidos · pontos × $mult',
        'días seguidos · puntos × $mult',
      );
  String remainingOf(String left, String word, String value, String total) => _t(
        '$left $word left · $value of $total',
        'Осталось $left $word · $value из $total',
        'Faltam $left $word · $value de $total',
        'Quedan $left $word · $value de $total',
      );
  String unlockAndLeague(String unlock, String league) => _t(
        '$unlock · league “$league”',
        '$unlock · лига «$league»',
        '$unlock · liga “$league”',
        '$unlock · liga “$league”',
      );
  String get clubPointsRules => _t(
        'Points only for lessons, tests, homework, plan trades and journal. No points for profit, volume or account size.',
        'Очки дают только за уроки, тесты, домашние задания, сделки по плану и журнал. За прибыль, объём сделок или сумму на счёте очков нет.',
        'Pontos só por aulas, testes, tarefas, trades com plano e diário. Sem pontos por lucro, volume ou saldo.',
        'Puntos solo por lecciones, tests, tareas, trades con plan y diario. Sin puntos por beneficio, volumen o saldo.',
      );
  String get cutoffProLine => _t(
        'pro chat entry · 6,900 points',
        'порог входа в чат профи · 6 900 очков',
        'entrada no chat pro · 6.900 pontos',
        'entrada al chat pro · 6.900 puntos',
      );
  String get cutoffStudentsLine => _t(
        'students chat entry · 1,400 points',
        'порог входа в чат учеников · 1 400 очков',
        'entrada no chat de alunos · 1.400 pontos',
        'entrada al chat de alumnos · 1.400 puntos',
      );
  String ladderServerCap(String server, String local) => _t(
        'Ladder counted $server of $local: the server accepts up to 800 points a day; the rest lands on later days.',
        'В рейтинге засчитано $server из $local: сервер принимает до 800 очков в день, остальные засчитаются в следующие дни.',
        'O ranking contou $server de $local: o servidor aceita até 800 pontos/dia; o resto entra nos dias seguintes.',
        'El ranking contó $server de $local: el servidor acepta hasta 800 puntos/día; el resto entra en días siguientes.',
      );
  String get ladderEmptyNote => _t(
        'Nobody on the ladder for this period yet. Finish a lesson step — you’ll be first.',
        'В рейтинге пока никого за этот период. Пройди шаг урока — и ты первый.',
        'Ninguém no ranking neste período. Faça um passo de aula — você será o primeiro.',
        'Nadie en el ranking en este período. Haz un paso de lección — serás el primero.',
      );
  String get youSuffix => _t('you', 'ты', 'você', 'tú');
  String get studentsChatTitle => _t('Students chat', 'Чат учеников', 'Chat de alunos', 'Chat de alumnos');
  String get studentsChatSub => _t(
        'Stage 1 · questions, homework, mistake reviews',
        'Ступень 1 · вопросы, домашние задания, разборы ошибок',
        'Etapa 1 · perguntas, tarefas, revisão de erros',
        'Etapa 1 · preguntas, tareas, revisión de errores',
      );
  String get proChatTitle => _t('Pro chat', 'Чат профи', 'Chat pro', 'Chat pro');
  String get proChatSub => _t(
        'Diploma · plan trades · 30-day study streak',
        'Диплом · сделки по плану · 30 дней учёбы подряд',
        'Diploma · trades com plano · 30 dias seguidos',
        'Diploma · trades con plan · 30 días seguidos',
      );
  String get openChannelTitle => _t('Public channel', 'Открытый канал', 'Canal aberto', 'Canal abierto');
  String get openChannelBody => _t(
        'Club news, live sessions and schedule. Open to everyone — no points gate.',
        'Новости клуба, прямые эфиры и расписание. Доступен всем, без порога по очкам.',
        'Notícias do clube, lives e agenda. Aberto a todos — sem ponto mínimo.',
        'Noticias del club, lives y agenda. Abierto a todos — sin umbral de puntos.',
      );
  String get openChannelBtn => _t('Open channel', 'Открыть канал', 'Abrir canal', 'Abrir canal');
  String get weekInClub => _t('Week in the club', 'Неделя в клубе', 'Semana no clube', 'Semana en el club');
  String get clubSafetyNote => _t(
        'Club admins never message first and never ask for money. Exchange links only in pinned club messages.',
        'Администраторы клуба никогда не пишут первыми и не просят деньги. Ссылки на биржу — только в закреплённых сообщениях клуба.',
        'Admins do clube nunca escrevem primeiro nem pedem dinheiro. Links de corretora só nas mensagens fixadas.',
        'Los admins del club nunca escriben primero ni piden dinero. Enlaces de exchange solo en mensajes fijados.',
      );
  String inChatCount(int n) => _t('In chat: $n', 'В чате $n', 'No chat: $n', 'En el chat: $n');
  String get applyToChatBtn => _t('Apply to join chat', 'Подать заявку в чат', 'Pedir entrada no chat', 'Pedir entrada al chat');
  String get todayLabel => _t('Today', 'Сегодня', 'Hoje', 'Hoy');
  String get weekdayMon => _t('Mon', 'Пн', 'Seg', 'Lun');
  String get weekdayTue => _t('Tue', 'Вт', 'Ter', 'Mar');
  String get weekdayWed => _t('Wed', 'Ср', 'Qua', 'Mié');
  String get weekdayThu => _t('Thu', 'Чт', 'Qui', 'Jue');
  String get weekdayFri => _t('Fri', 'Пт', 'Sex', 'Vie');
  String get weekdaySat => _t('Sat', 'Сб', 'Sáb', 'Sáb');
  String get weekdaySun => _t('Sun', 'Вс', 'Dom', 'Dom');
  String get weekMonPlan => _t('Week plan from mentor', 'План недели от наставника', 'Plano da semana do mentor', 'Plan de la semana del mentor');
  String get weekTueLive => _t('Week lesson live', 'Урок недели в прямом эфире', 'Aula da semana ao vivo', 'Lección de la semana en vivo');
  String get weekWedHw => _t('Homework review', 'Разбор домашних заданий', 'Revisão de tarefas', 'Revisión de tareas');
  String get weekThuQa => _t('Q&A: exchange account and ID check', 'Вопросы и ответы: счёт на бирже и проверка личности', 'Perguntas: conta na corretora e verificação', 'Preguntas: cuenta en el exchange y verificación');
  String get weekFriPractice => _t('Free practice', 'Свободная практика', 'Prática livre', 'Práctica libre');
  String get weekSatOff => _t('Day off', 'Выходной', 'Folga', 'Descanso');
  String get weekSunReview => _t('First 30 days review', 'Разбор первых 30 дней', 'Revisão dos primeiros 30 dias', 'Revisión de los primeros 30 días');

  String checkPointsLabel(String n) => _t('$n points', '$n очков', '$n pontos', '$n puntos');
  String checkYouHave(String n) => _t('you have $n', 'у тебя $n', 'você tem $n', 'tienes $n');
  String get checkStage1Done => _t('Stage 1 complete', 'Ступень 1 пройдена', 'Etapa 1 concluída', 'Etapa 1 hecha');
  String checkLessonsTests(int lessons, int total, int tests) => _t(
        'lessons $lessons of $total · tests $tests of 2',
        'уроки $lessons из $total · тесты $tests из 2',
        'aulas $lessons de $total · testes $tests de 2',
        'lecciones $lessons de $total · tests $tests de 2',
      );
  String checkStreakDays(int n) => _t(
        '$n days of study in a row',
        'Учёба $n дней подряд',
        '$n dias de estudo seguidos',
        '$n días de estudio seguidos',
      );
  String checkNowDays(int n) => _t('now $n', 'сейчас $n', 'agora $n', 'ahora $n');
  String get checkDiplomaStage4 => _t('Diploma · stage 4', 'Диплом · ступень 4', 'Diploma · etapa 4', 'Diploma · etapa 4');
  String get checkHave => _t('yes', 'есть', 'sim', 'sí');
  String get checkNotYet => _t('not yet', 'ещё нет', 'ainda não', 'aún no');
  String checkPlanTrades(int n) => _t('$n plan trades', '$n сделок по плану', '$n trades com plano', '$n trades con plan');
  String checkOf(int a, int b) => _t('$a of $b', '$a из $b', '$a de $b', '$a de $b');
  String applicationText(String chat, String name, String id, String points, String word, int streak) => _t(
        'Application to “$chat” · $name · $id · $points $word · study streak: $streak. Check me on the Trade Master student ladder.',
        'Заявка в «$chat» · $name · $id · $points $word · дней учёбы подряд: $streak. Проверь меня в рейтинге учеников Trade Master.',
        'Pedido para “$chat” · $name · $id · $points $word · sequência: $streak. Confira-me no ranking Trade Master.',
        'Solicitud a “$chat” · $name · $id · $points $word · racha: $streak. Compruébame en el ranking Trade Master.',
      );
  String get ladderKeepLocal => _t(
        'Your points stay on this device and will not disappear.',
        'Твои очки считаются на устройстве и не пропадут.',
        'Seus pontos ficam neste aparelho e não somem.',
        'Tus puntos están en este dispositivo y no desaparecen.',
      );
  String get ladderUnavailableBuild => _t(
        'Shared ladder unavailable in this build.',
        'Общий рейтинг недоступен в этой сборке.',
        'Ranking compartilhado indisponível nesta build.',
        'Ranking compartido no disponible en esta build.',
      );
  String get ladderUpsertFailed => _t(
        'Ladder server did not accept the write.',
        'Сервер рейтинга не принял запись.',
        'O servidor do ranking não aceitou o registro.',
        'El servidor del ranking no aceptó el registro.',
      );
  String get ladderComingSoon => _t(
        'Shared ladder is turning on — all students will show up soon.',
        'Общий рейтинг включается — скоро тут появятся все ученики.',
        'O ranking compartilhado está ligando — logo todos os alunos aparecem.',
        'El ranking compartido se está activando — pronto aparecerán todos.',
      );
  String get ladderLoadFailed => _t(
        'Shared ladder did not load — pull down to refresh.',
        'Общий рейтинг сейчас не загрузился — потяни экран вниз.',
        'O ranking não carregou — puxe a tela para baixo.',
        'El ranking no cargó — tira hacia abajo para actualizar.',
      );
  String get ladderTemporarilyDown => _t(
        'Shared ladder is unavailable — try later or pull down to refresh.',
        'Общий рейтинг сейчас недоступен — загляни позже или потяни экран вниз.',
        'Ranking indisponível agora — tente depois ou puxe para atualizar.',
        'Ranking no disponible — prueba luego o tira para actualizar.',
      );
  String get applyCopiedTitle => _t('Application copied', 'Заявка скопирована', 'Pedido copiado', 'Solicitud copiada');
  String get applyCopiedBody => _t(
        'Open the club in Telegram and paste the text as a message. A club admin will match your ID to the student ladder and send a chat invite.',
        'Открой клуб в Telegram и вставь текст сообщением. Администратор клуба сверит твой ID с рейтингом учеников и пришлёт приглашение в чат.',
        'Abra o clube no Telegram e cole o texto. Um admin confere seu ID no ranking e envia o convite.',
        'Abre el club en Telegram y pega el texto. Un admin comprobará tu ID en el ranking y enviará la invitación.',
      );
  String get laterBtn => _t('Later', 'Позже', 'Depois', 'Después');
  String get openClubBtn => _t('Open club', 'Открыть клуб', 'Abrir clube', 'Abrir club');

  // ── Misc leftovers ──
  String hoursWord(num n) {
    final a = n.abs().toInt() % 100;
    final b = a % 10;
    switch (locale) {
      case AppLanguage.ru:
        if (a >= 11 && a <= 14) return 'часов';
        if (b == 1) return 'час';
        if (b >= 2 && b <= 4) return 'часа';
        return 'часов';
      case AppLanguage.pt:
        return a == 1 ? 'hora' : 'horas';
      case AppLanguage.es:
        return a == 1 ? 'hora' : 'horas';
      case AppLanguage.en:
        return a == 1 ? 'hour' : 'hours';
    }
  }
  String syllabusHoursLessons(num hours, int lessons) => _t(
        '$hours ${hoursWord(hours)} · $lessons lessons',
        '$hours ${hoursWord(hours)} · $lessons уроков',
        '$hours ${hoursWord(hours)} · $lessons aulas',
        '$hours ${hoursWord(hours)} · $lessons lecciones',
      );
  String syllabusModuleMeta(String hours, Object first, Object last) => _t(
        'About $hours h · lessons $first–$last',
        'Около $hours ч · уроки $first–$last',
        'Cerca de $hours h · aulas $first–$last',
        'Unas $hours h · lecciones $first–$last',
      );
  String get closeBtn => _t('Close', 'Закрыть', 'Fechar', 'Cerrar');
  String get openBtn => _t('Open', 'Открыть', 'Abrir', 'Abrir');
  String get linkLabel => _t('Link', 'Ссылка', 'Link', 'Enlace');
  String get chartZoomHint => _t(
        'Chart. Tap to enlarge',
        'График. Нажми, чтобы увеличить',
        'Gráfico. Toque para ampliar',
        'Gráfico. Toca para ampliar',
      );
  String get zoomIn => _t('Enlarge', 'Увеличить', 'Ampliar', 'Ampliar');
  String get volumeLabel => _t('Volume', 'Объём', 'Volume', 'Volumen');
  String inFilterProgress(String completed) => _t(
        'In filter: $completed',
        'В фильтре: $completed',
        'No filtro: $completed',
        'En el filtro: $completed',
      );
  String lessonFallback(int id) => _t('Lesson $id', 'Урок $id', 'Aula $id', 'Lección $id');
  String get ownerUnlocking => _t(
        'Unlocking all lessons…',
        'Открываю все уроки…',
        'Abrindo todas as aulas…',
        'Abriendo todas las lecciones…',
      );
  String get ownerUnlockFailed => _t(
        'Could not unlock access. Message the chat.',
        'Не удалось открыть доступ. Напиши в чат.',
        'Não foi possível liberar o acesso. Escreva no chat.',
        'No se pudo abrir el acceso. Escribe en el chat.',
      );
  String get ownerUnlockDone => _t(
        'Done. All lessons are open.',
        'Готово. Все уроки открыты.',
        'Pronto. Todas as aulas estão abertas.',
        'Listo. Todas las lecciones están abiertas.',
      );
  String deskKeyRequestMessage(String tigerUid, String tmId) => _t(
        'Desk Club key\nTiger.com account number (User ID): $tigerUid\nMy Trade Master ID: $tmId',
        'Ключ Desk Club\nНомер аккаунта Tiger.com (User ID): $tigerUid\nМой номер в Trade Master: $tmId',
        'Chave Desk Club\nNúmero da conta Tiger.com (User ID): $tigerUid\nMeu ID no Trade Master: $tmId',
        'Clave Desk Club\nNúmero de cuenta Tiger.com (User ID): $tigerUid\nMi ID en Trade Master: $tmId',
      );

  // ── Desk Club key screen (Tiger referral) ──
  String get deskKeyPathTitle => _t('Desk Club path', 'Путь Desk Club', 'Caminho Desk Club', 'Camino Desk Club');
  String get deskKeyTitle => _t('Desk Club key', 'Ключ Desk Club', 'Chave Desk Club', 'Clave Desk Club');
  String get deskKeyActiveTitle => _t('Key is on', 'Ключ включён', 'Chave ativada', 'Clave activada');
  String get deskKeyActiveBody => _t(
        'Lessons 15–58 are open. Keep studying in order from the next unfinished lesson.',
        'Уроки 15–58 открыты. Учёба продолжается по порядку, со следующего непройденного урока.',
        'As aulas 15–58 estão abertas. Continue na ordem a partir da próxima aula incompleta.',
        'Las lecciones 15–58 están abiertas. Sigue en orden desde la siguiente lección incompleta.',
      );
  String get deskKeyIntroFree => _t(
        'All lessons are already free. An account via the Desk Club link is the recommended path: pro chat, reviews and the “live account” stage. You can study without it.',
        'Все уроки уже бесплатны. Аккаунт по ссылке Desk Club — рекомендуемый путь: профи-чат, разборы и ступень «настоящий счёт». Учиться без этого можно.',
        'Todas as aulas já são grátis. Conta pelo link Desk Club é o caminho recomendado: chat pro, revisões e etapa “conta real”. Dá para estudar sem isso.',
        'Todas las lecciones ya son gratis. La cuenta con el enlace Desk Club es el camino recomendado: chat pro, revisiones y etapa “cuenta real”. Puedes estudiar sin eso.',
      );
  String get deskKeyIntroBilling => _t(
        'A Tiger.com account key opens lessons 15–58. Another option is a one-time purchase (price on the payment screen).',
        'Ключ за аккаунт на Tiger.com открывает уроки 15–58. Другой способ — разовая оплата (цена на экране оплаты).',
        'A chave por conta Tiger.com abre as aulas 15–58. Outra opção é compra única (preço na tela de pagamento).',
        'La clave por cuenta Tiger.com abre las lecciones 15–58. Otra opción es compra única (precio en la pantalla de pago).',
      );
  String get deskKeyIntroSteps => _t(
        'A Tiger.com account key opens lessons 15–58. You need three steps.',
        'Ключ за аккаунт на Tiger.com открывает уроки 15–58. Нужно сделать три шага.',
        'A chave por conta Tiger.com abre as aulas 15–58. São três passos.',
        'La clave por cuenta Tiger.com abre las lecciones 15–58. Son tres pasos.',
      );
  String get deskKeyScamTitle => _t('Watch out: scammers', 'Осторожно: мошенники', 'Cuidado: golpistas', 'Cuidado: estafadores');
  String get deskKeyScamBody => _t(
        'A mentor never asks for your Tiger.com password, email or SMS codes, money “for verification”, or phone-screen access. The key is only a code like 4F2A-9C1D (eight characters with a hyphen), or the “key is on” check on this screen.',
        'Наставник никогда не просит пароль от Tiger.com, коды из почты или СМС, деньги «за проверку» и доступ к экрану телефона. Ключ — это только код вида 4F2A-9C1D (восемь символов через дефис), либо галочка «ключ включён» на этом экране.',
        'O mentor nunca pede senha do Tiger.com, códigos de e-mail ou SMS, dinheiro “pela verificação” nem acesso à tela do celular. A chave é só um código tipo 4F2A-9C1D (oito caracteres com hífen), ou o visto “chave ativada” nesta tela.',
        'El mentor nunca pide la contraseña de Tiger.com, códigos de correo o SMS, dinero “por verificación” ni acceso a la pantalla del teléfono. La clave es solo un código tipo 4F2A-9C1D (ocho caracteres con guion), o la marca “clave activada” en esta pantalla.',
      );
  String get deskKeyMentorHandleHint => _t(
        'The mentor’s Telegram handle is in the Desk Club chat pin and on the screen after you send your account number. Accept a key only from that handle.',
        'Ник наставника в Telegram пишут в закрепе чата Desk Club и на экране после отправки номера. Принимай ключ только от этого ника.',
        'O @ do mentor no Telegram está no pin do chat Desk Club e na tela após enviar o número. Aceite a chave só desse @.',
        'El usuario de Telegram del mentor está en el pin del chat Desk Club y en la pantalla tras enviar el número. Acepta la clave solo de ese usuario.',
      );
  String get deskKeyFreeTigerTitle => _t(
        'Free: Tiger.com account',
        'Бесплатно: аккаунт на Tiger.com',
        'Grátis: conta Tiger.com',
        'Gratis: cuenta Tiger.com',
      );
  String get deskKeyTigerExplain => _t(
        'Tiger.com is a service for trading on major exchanges such as Binance and Bybit. When a student registers via the Desk Club link, Tiger.com shares with Desk Club part of the fee it takes from the student’s trades. The more the student later trades through that account, the more Desk Club receives. That is why the key is free for you.',
        'Tiger.com — сервис для торговли на крупных биржах, например Binance и Bybit. Когда ученик регистрируется по ссылке Desk Club, Tiger.com отдаёт Desk Club часть платы, которую берёт с ученика за его сделки. Чем больше ученик потом торгует через этот аккаунт, тем больше получает Desk Club. Поэтому ключ для тебя бесплатный.',
        'Tiger.com é um serviço para operar em grandes corretoras, como Binance e Bybit. Quando o aluno se registra pelo link Desk Club, a Tiger.com divide com o Desk Club parte da taxa das operações do aluno. Quanto mais ele operar depois por essa conta, mais o Desk Club recebe. Por isso a chave é grátis para você.',
        'Tiger.com es un servicio para operar en exchanges grandes como Binance y Bybit. Cuando el alumno se registra con el enlace Desk Club, Tiger.com comparte con Desk Club parte de la comisión de sus operaciones. Cuanto más opere después con esa cuenta, más recibe Desk Club. Por eso la clave es gratis para ti.',
      );
  String get deskKeyNoDepositYet => _t(
        'You do not need to fund a Tiger.com account now. Real money is only needed after the exam at the end of the course, and only if you choose to trade. Funds on Tiger.com stay with the service, not at home: like any broker, there is a risk of blocks and country limits. Before signing up, check that Tiger.com is available in your country.',
        'Пополнять счёт на Tiger.com сейчас не нужно. Настоящие деньги понадобятся только после экзамена в конце курса, и только если решишь торговать. Деньги на Tiger.com хранятся у сервиса, не у тебя дома: как у любого брокера, есть риск блокировок и ограничений по стране. Перед регистрацией проверь, что Tiger.com доступен в твоей стране.',
        'Não precisa depositar na Tiger.com agora. Dinheiro real só depois do exame no fim do curso, e só se quiser operar. Os fundos ficam no serviço, não em casa: como qualquer corretora, há risco de bloqueios e limites por país. Antes de se registrar, confira se a Tiger.com está disponível no seu país.',
        'No hace falta depositar en Tiger.com ahora. El dinero real solo hace falta tras el examen al final del curso, y solo si decides operar. Los fondos están en el servicio, no en casa: como cualquier bróker, hay riesgo de bloqueos y límites por país. Antes de registrarte, comprueba que Tiger.com esté disponible en tu país.',
      );
  String get deskKeyStep1Title => _t(
        'Sign up via the Desk Club link',
        'Зарегистрируйся по ссылке Desk Club',
        'Cadastre-se pelo link Desk Club',
        'Regístrate con el enlace Desk Club',
      );
  String get deskKeyStep1Body => _t(
        'Enter email and password, then confirm email from the link in the message. Tiger.com may later ask for documents (passport and a selfie with the passport) for identity checks. Upload them only on the Tiger.com site — never in chat and never “to the mentor in DM”.',
        'Укажи почту и пароль, затем подтверди почту по ссылке из письма. Документы (паспорт и селфи с паспортом) Tiger.com может попросить позже для проверки личности. Загружай их только на сайте Tiger.com, никогда в чат и никогда «наставнику в личку».',
        'Informe e-mail e senha e confirme o e-mail pelo link da mensagem. A Tiger.com pode pedir documentos depois (passaporte e selfie com o passaporte) para verificar identidade. Envie só no site da Tiger.com — nunca no chat e nunca “pro mentor no privado”.',
        'Indica correo y contraseña y confirma el correo con el enlace del mensaje. Tiger.com puede pedir documentos después (pasaporte y selfie con el pasaporte) para verificar identidad. Súbelos solo en el sitio de Tiger.com — nunca en el chat ni “al mentor por privado”.',
      );
  String get deskKeyOpenTiger => _t('Open Tiger.com', 'Открыть Tiger.com', 'Abrir Tiger.com', 'Abrir Tiger.com');
  String get deskKeyLinkFromMentor => _t(
        'The mentor will give the sign-up link in direct messages or in the Desk Club chat pin.',
        'Ссылку на регистрацию даст наставник в личных сообщениях или в закрепе чата Desk Club.',
        'O mentor envia o link de cadastro no privado ou no pin do chat Desk Club.',
        'El mentor da el enlace de registro en mensajes directos o en el pin del chat Desk Club.',
      );
  String get deskKeyStep2Title => _t(
        'Copy your account number',
        'Скопируй номер аккаунта',
        'Copie o número da conta',
        'Copia el número de cuenta',
      );
  String get deskKeyStep2Body => _t(
        'In Tiger.com open your profile. The account number is labeled User ID (English for “account number” — digits and letters in the profile).',
        'В Tiger.com открой профиль. Номер аккаунта подписан словами User ID (это «номер аккаунта» на английском — цифры и буквы в профиле).',
        'Na Tiger.com abra o perfil. O número da conta aparece como User ID (em inglês: dígitos e letras no perfil).',
        'En Tiger.com abre el perfil. El número de cuenta aparece como User ID (en inglés: dígitos y letras en el perfil).',
      );
  String get deskKeyStep3Sent => _t('Number sent', 'Номер отправлен', 'Número enviado', 'Número enviado');
  String get deskKeyStep3Send => _t(
        'Send the number for review',
        'Отправь номер на проверку',
        'Envie o número para revisão',
        'Envía el número a revisión',
      );
  String deskKeyRejected(String uid, String reason) => _t(
        'Number $uid was not found among accounts created via the Desk Club link.'
        '${reason.isEmpty ? '' : ' Mentor note: $reason.'}'
        ' Check the number for a typo or link the account to Desk Club as described below, then send again.',
        'Номер $uid не нашёлся среди аккаунтов, созданных по ссылке Desk Club.'
        '${reason.isEmpty ? '' : ' Наставник пишет: $reason.'}'
        ' Проверь номер на опечатку или привяжи аккаунт к Desk Club, как описано ниже, и отправь снова.',
        'O número $uid não foi encontrado entre as contas criadas pelo link Desk Club.'
        '${reason.isEmpty ? '' : ' Nota do mentor: $reason.'}'
        ' Confira o número ou vincule a conta ao Desk Club como abaixo e envie de novo.',
        'El número $uid no aparece entre las cuentas creadas con el enlace Desk Club.'
        '${reason.isEmpty ? '' : ' Nota del mentor: $reason.'}'
        ' Revisa el número o vincula la cuenta a Desk Club como abajo y envía de nuevo.',
      );
  String get deskKeyAlreadyHaveTitle => _t(
        'Already have a Tiger.com account?',
        'Уже есть аккаунт на Tiger.com?',
        'Já tem conta na Tiger.com?',
        '¿Ya tienes cuenta en Tiger.com?',
      );
  String deskKeyLinkExisting(String codeNote) => _t(
        'The key is only for an account linked to Desk Club. Link yours like this: in Tiger.com open “Referral program”, enter the Desk Club code$codeNote and tap Apply.',
        'Ключ дают только за аккаунт, привязанный к Desk Club. Привязать свой аккаунт можно так: в Tiger.com открой раздел «Реферальная программа» (на сайте часто написано Referral program), впиши код Desk Club$codeNote и нажми «Применить» (на сайте — Apply).',
        'A chave é só para conta vinculada ao Desk Club. Vincule assim: na Tiger.com abra “Referral program”, digite o código Desk Club$codeNote e toque em Apply.',
        'La clave solo vale para una cuenta vinculada a Desk Club. Vincúlala así: en Tiger.com abre “Referral program”, escribe el código Desk Club$codeNote y pulsa Apply.',
      );
  String get deskKeyCodeFromMentor => _t(
        ' (the mentor will give it)',
        ' (его даст наставник)',
        ' (o mentor informa)',
        ' (lo da el mentor)',
      );
  String get deskKeySupportEmailHint => _t(
        'If the code field does not open, write to Tiger.com support from the email used for the account. Write in English — the button below copies a ready text.',
        'Если поле для кода не открывается, напиши в поддержку Tiger.com с почты, на которую создан аккаунт. Письмо пишут на английском — готовый текст копирует кнопка ниже.',
        'Se o campo do código não abrir, escreva ao suporte Tiger.com pelo e-mail da conta. Em inglês — o botão abaixo copia um texto pronto.',
        'Si el campo del código no abre, escribe al soporte de Tiger.com desde el correo de la cuenta. En inglés — el botón de abajo copia un texto listo.',
      );
  String deskKeyEmailCopied(String email) => _t(
        'Email copied. Support address: $email',
        'Письмо скопировано. Адрес поддержки: $email',
        'E-mail copiado. Suporte: $email',
        'Correo copiado. Soporte: $email',
      );
  String get deskKeyCopyEmail => _t('Copy email', 'Скопировать письмо', 'Copiar e-mail', 'Copiar correo');
  String get deskKeyPayOnceTitle => _t(
        'Without Tiger.com: one-time payment',
        'Без Tiger.com: разовая оплата',
        'Sem Tiger.com: pagamento único',
        'Sin Tiger.com: pago único',
      );
  String get deskKeyPayOnceBody => _t(
        'Lessons 15–58 unlock forever with one payment. No Tiger.com sign-up needed. Exact price is on the next screen.',
        'Уроки 15–58 открываются навсегда одной оплатой. Регистрироваться на Tiger.com не нужно. Точную цену увидишь на следующем экране.',
        'As aulas 15–58 liberam para sempre com um pagamento. Não precisa se cadastrar na Tiger.com. O preço exato está na próxima tela.',
        'Las lecciones 15–58 se abren para siempre con un pago. No hace falta registrarse en Tiger.com. El precio exacto está en la siguiente pantalla.',
      );
  String get deskKeyGoToPayment => _t('Go to payment', 'Перейти к оплате', 'Ir ao pagamento', 'Ir al pago');
  String get deskKeyUidLabel => _t(
        'Account number (User ID)',
        'Номер аккаунта (User ID)',
        'Número da conta (User ID)',
        'Número de cuenta (User ID)',
      );
  String get deskKeyUidHintServer => _t(
        'The mentor will match the number to the Desk Club account list. Usually within 24 hours. The key will bind to this device and browser. To keep progress on another phone — sign in to Trade Master before sending.',
        'Наставник сверит номер со списком аккаунтов Desk Club. Обычно это занимает до 24 часов. Ключ привяжется к этому устройству и браузеру. Чтобы не потерять прогресс на другом телефоне — войди в аккаунт Trade Master перед отправкой.',
        'O mentor confere o número na lista Desk Club. Em geral até 24 horas. A chave fica neste aparelho e navegador. Para não perder progresso noutro telefone — entre na conta Trade Master antes de enviar.',
        'El mentor comprobará el número en la lista Desk Club. Suele ser hasta 24 horas. La clave se vincula a este dispositivo y navegador. Para no perder progreso en otro teléfono — inicia sesión en Trade Master antes de enviar.',
      );
  String get deskKeyUidHintDm => _t(
        'The button copies a message with the number and opens a private Telegram chat with the mentor. Paste and send. Do not post the number in the public chat — everyone can see it. The key then binds to this device and browser — better sign in to Trade Master first.',
        'Кнопка скопирует сообщение с номером и откроет личный чат с наставником в Telegram. Вставь сообщение и отправь. В общий чат номер не пиши: его увидят все участники. Ключ затем привяжется к этому устройству и браузеру — лучше сначала войти в аккаунт Trade Master.',
        'O botão copia a mensagem com o número e abre o chat privado com o mentor no Telegram. Cole e envie. Não poste o número no chat geral. A chave fica neste aparelho e navegador — melhor entrar na conta Trade Master antes.',
        'El botón copia el mensaje con el número y abre el chat privado con el mentor en Telegram. Pega y envía. No publiques el número en el chat general. La clave se vincula a este dispositivo y navegador — mejor inicia sesión en Trade Master primero.',
      );
  String get deskKeyUidHintClub => _t(
        'The button copies a message with the number and opens the Desk Club Telegram chat. Write that you are waiting for the key, and the mentor will DM you. Send the number only to them: in the public chat everyone can see it. The key binds to this device and browser.',
        'Кнопка скопирует сообщение с номером и откроет чат Desk Club в Telegram. Напиши там, что ждёшь ключ, и наставник сам напишет тебе в личные сообщения. Номер отправь только ему: в общем чате его увидят все. Ключ привяжется к этому устройству и браузеру.',
        'O botão copia a mensagem com o número e abre o chat Desk Club no Telegram. Escreva que espera a chave; o mentor fala no privado. Envie o número só a ele. A chave fica neste aparelho e navegador.',
        'El botón copia el mensaje con el número y abre el chat Desk Club en Telegram. Escribe que esperas la clave; el mentor te escribirá por privado. Envía el número solo a él. La clave se vincula a este dispositivo y navegador.',
      );
  String get deskKeySubmitReview => _t(
        'Send for review',
        'Отправить на проверку',
        'Enviar para revisão',
        'Enviar a revisión',
      );
  String deskKeyPendingServer(String uid) => _t(
        'Number $uid is under review. Usually within 24 hours. The key will turn on by itself on this device — check this screen later.',
        'Номер $uid на проверке. Обычно это занимает до 24 часов. Ключ включится сам на этом устройстве — загляни на этот экран позже.',
        'Número $uid em revisão. Em geral até 24 horas. A chave ativa sozinha neste aparelho — volte a esta tela depois.',
        'Número $uid en revisión. Suele ser hasta 24 horas. La clave se activará sola en este dispositivo — vuelve a esta pantalla luego.',
      );
  String get deskKeyCheckNow => _t('Check now', 'Проверить сейчас', 'Verificar agora', 'Comprobar ahora');
  String get deskKeyFixNumber => _t('Fix number', 'Исправить номер', 'Corrigir número', 'Corregir número');
  String deskKeyCopiedMentor(String uid) => _t(
        'Message with number $uid is copied. Send it to the mentor in Telegram DMs. The mentor will check the number and send a key code like 4F2A-9C1D, usually within 24 hours.',
        'Сообщение с номером $uid скопировано. Отправь его наставнику в личные сообщения Telegram. Наставник проверит номер и пришлёт код ключа вида 4F2A-9C1D, обычно в течение 24 часов.',
        'Mensagem com o número $uid copiada. Envie ao mentor no privado do Telegram. Ele confere e manda um código tipo 4F2A-9C1D, em geral em até 24 horas.',
        'Mensaje con el número $uid copiado. Envíalo al mentor por privado en Telegram. Comprobará el número y enviará un código tipo 4F2A-9C1D, suele ser en 24 horas.',
      );
  String get deskKeyOpenTelegram => _t('Open Telegram', 'Открыть Telegram', 'Abrir Telegram', 'Abrir Telegram');
  String get deskKeyCodeLabel => _t(
        'Key code from mentor',
        'Код ключа от наставника',
        'Código da chave do mentor',
        'Código de clave del mentor',
      );
  String get deskKeyCodeHint => _t('e.g. 4F2A-9C1D', 'Например, 4F2A-9C1D', 'Ex.: 4F2A-9C1D', 'Ej.: 4F2A-9C1D');
  String get deskKeyEnable => _t('Turn key on', 'Включить ключ', 'Ativar chave', 'Activar clave');
  String get deskKeyUidCopiedSnack => _t(
        'Message with the number is copied. Paste it in a private message to the mentor',
        'Сообщение с номером скопировано. Вставь его в личные сообщения наставнику',
        'Mensagem com o número copiada. Cole no privado do mentor',
        'Mensaje con el número copiado. Pégalo en un mensaje privado al mentor',
      );
  String get deskKeyCodeBad => _t(
        'Code did not work. Check letters and digits. The code only works on the same device and browser that sent the request.',
        'Код не подошёл. Проверь буквы и цифры. Код работает только на том устройстве и в том браузере, с которого ушла заявка.',
        'Código inválido. Confira letras e dígitos. Só funciona no mesmo aparelho e navegador da solicitação.',
        'Código no válido. Revisa letras y dígitos. Solo funciona en el mismo dispositivo y navegador de la solicitud.',
      );

  // ── Cutoff celebration ──
  String get cutoffPassedTitle => _t('Cutoff passed', 'Порог пройден', 'Limite alcançado', 'Umbral superado');
  String get cutoffCanApplyPro => _t(
        'You can apply to the pro chat',
        'Можно подать заявку в чат профи',
        'Pode pedir entrada no chat pro',
        'Puedes solicitar entrada al chat pro',
      );
  String get cutoffCanApplyStudents => _t(
        'You can apply to the students chat',
        'Можно подать заявку в чат учеников',
        'Pode pedir entrada no chat de alunos',
        'Puedes solicitar entrada al chat de alumnos',
      );
  String get cutoffPassedBody => _t(
        'A cutoff is a set of conditions to enter a club chat. You have met them all.',
        'Порог — набор условий для входа в чат клуба. Ты выполнил их все.',
        'Um limite é o conjunto de condições para entrar no chat do clube. Você cumpriu todas.',
        'Un umbral es el conjunto de condiciones para entrar al chat del club. Las cumpliste todas.',
      );
  String cutoffSeenAs(String id) => _t(
        'How you appear in chat · ID $id',
        'Как тебя видят в чате · ID $id',
        'Como você aparece no chat · ID $id',
        'Cómo te ven en el chat · ID $id',
      );
  String get yourNameHint => _t('Your name', 'Твоё имя', 'Seu nome', 'Tu nombre');
  String get applyToProChatBtn => _t(
        'Apply to pro chat',
        'Подать заявку в чат профи',
        'Pedir entrada no chat pro',
        'Solicitar entrada al chat pro',
      );
  String get laterOpenLadder => _t(
        'Later · open ladder',
        'Позже · открыть рейтинг',
        'Depois · abrir ranking',
        'Después · abrir ranking',
      );

  // ── Streak / flames screen ──
  String get flamesTitle => _t('Flames', 'Огоньки', 'Chamas', 'Llamas');
  String get streakLitToday => _t(
        'Flame is lit today',
        'Сегодня огонёк горит',
        'Chama acesa hoje',
        'Llama encendida hoy',
      );
  String get streakNotLitToday => _t(
        'Not lit yet today — finish 3 lesson steps or any action below',
        'Сегодня ещё не зажжён — пройди 3 шага урока или любое дело ниже',
        'Ainda apagada hoje — faça 3 passos de aula ou qualquer ação abaixo',
        'Aún apagada hoy — haz 3 pasos de lección o cualquier acción abajo',
      );
  String get streakMultLabel => _t(
        'points multiply by this',
        'на столько умножаются очки',
        'pontos multiplicam por isto',
        'los puntos se multiplican por esto',
      );
  String get freezesLabel => _t('freezes', 'заморозки', 'freezes', 'congelaciones');
  String get recordLabel => _t('best', 'рекорд', 'recorde', 'récord');
  String get whyFlamesTitle => _t('Why flames', 'Зачем огоньки', 'Para que servem as chamas', 'Para qué sirven las llamas');
  String get whyFlamesRule1 => _t(
        'Study 3 days in a row — points × 1.2 (× means “multiply”). 7 days in a row — × 1.5, 30 days in a row — × 2.',
        'Учишься 3 дня подряд — очки умножаются на 1,2 (× значит «умножить»). 7 дней подряд — × 1,5, 30 дней подряд — × 2.',
        'Estude 3 dias seguidos — pontos × 1,2 (× = multiplicar). 7 dias — × 1,5, 30 dias — × 2.',
        'Estudia 3 días seguidos — puntos × 1,2 (× = multiplicar). 7 días — × 1,5, 30 días — × 2.',
      );
  String get whyFlamesRule2 => _t(
        '7 days in a row is one condition for the students chat; 30 days in a row for the pro chat.',
        '7 дней подряд — одно из условий входа в чат учеников, 30 дней подряд — в чат профи.',
        '7 dias seguidos é uma condição do chat de alunos; 30 dias seguidos, do chat pro.',
        '7 días seguidos es una condición del chat de alumnos; 30 días seguidos, del chat pro.',
      );
  String get whyFlamesRule3 => _t(
        'Every 7 days in a row you get a freeze (max 2 stored). If you skip a day, a freeze keeps the streak.',
        'За каждые 7 дней подряд даём заморозку (хранится не больше 2). Если пропустишь день, заморозка сама сохранит серию дней.',
        'A cada 7 dias seguidos ganhamos um freeze (máx. 2). Se pular um dia, o freeze mantém a sequência.',
        'Cada 7 días seguidos ganas un freeze (máx. 2). Si saltas un día, el freeze mantiene la racha.',
      );
  String get howLightTodayTitle => _t('How to light today', 'Как зажечь сегодня', 'Como acender hoje', 'Cómo encender hoy');
  String get streakActionLesson => _t(
        '3 lesson steps or a module test',
        '3 шага урока или тест раздела',
        '3 passos de aula ou teste do módulo',
        '3 pasos de lección o test del módulo',
      );
  String get streakActionPaper => _t(
        'Plan trade on the practice exchange',
        'Сделка по плану на учебной бирже',
        'Trade com plano na bolsa de treino',
        'Trade con plan en la bolsa de práctica',
      );
  String get streakActionJournal => _t(
        'Journal entry',
        'Запись в журнале',
        'Registro no diário',
        'Entrada en el diario',
      );
  String get streakActionFlashcards => _t(
        'Review flashcards',
        'Карточки на повторение',
        'Flashcards de revisão',
        'Tarjetas de repaso',
      );
  String get recentPointsTitle => _t('Recent points', 'Последние очки', 'Pontos recentes', 'Puntos recientes');
  String get streakLedgerEmpty => _t(
        'Empty for now — first points come from the first lesson.',
        'Пока пусто — первые очки дадут за первый урок.',
        'Vazio por enquanto — os primeiros pontos vêm da primeira aula.',
        'Vacío por ahora — los primeros puntos llegan con la primera lección.',
      );
  String daysInARowWord(int n) {
    final d = dayWord(n);
    return _t('$d in a row', '$d подряд', '$d seguidos', '$d seguidos');
  }

  String dayWord(int n) {
    switch (locale) {
      case AppLanguage.ru:
        final m10 = n % 10, m100 = n % 100;
        if (m10 == 1 && m100 != 11) return 'день';
        if (m10 >= 2 && m10 <= 4 && (m100 < 12 || m100 > 14)) return 'дня';
        return 'дней';
      case AppLanguage.pt:
        return n == 1 ? 'dia' : 'dias';
      case AppLanguage.es:
        return n == 1 ? 'día' : 'días';
      case AppLanguage.en:
        return n == 1 ? 'day' : 'days';
    }
  }

  // ── Streak event messages (services) ──
  String streakLitEvent(int days) => _t(
        'Flame lit · $days ${dayWord(days)} in a row',
        'Огонёк зажжён · $days ${dayWord(days)} подряд',
        'Chama acesa · $days ${dayWord(days)} seguidos',
        'Llama encendida · $days ${dayWord(days)} seguidos',
      );
  String get streakFreezeUsedPart => _t(
        'missed day covered by a freeze, streak saved',
        'пропущенный день закрыт заморозкой, серия сохранена',
        'dia perdido coberto por freeze, sequência salva',
        'día perdido cubierto con freeze, racha guardada',
      );
  String get streakFreezeEarnedPart => _t(
        '+1 freeze: keeps the streak if you skip a day',
        '+1 заморозка: сохранит серию, если пропустишь день',
        '+1 freeze: mantém a sequência se pular um dia',
        '+1 freeze: mantiene la racha si saltas un día',
      );
  String streakPointsMultPart(String mult) => _t(
        'points × $mult',
        'очки × $mult',
        'pontos × $mult',
        'puntos × $mult',
      );

  // ── Points reason labels ──
  String get pointsReasonLesson => _t('Lesson done', 'Урок пройден', 'Aula concluída', 'Lección hecha');
  String get pointsReasonLessonQuiz => _t('Lesson quiz', 'Тест урока', 'Quiz da aula', 'Test de lección');
  String get pointsReasonModuleTest => _t('Module test', 'Тест раздела', 'Teste do módulo', 'Test del módulo');
  String get pointsReasonHomework => _t('Homework', 'Домашнее задание', 'Tarefa', 'Tarea');
  String get pointsReasonPaperTrade => _t('Plan trade', 'Сделка по плану', 'Trade com plano', 'Trade con plan');
  String get pointsReasonExam => _t('Diploma', 'Диплом', 'Diploma', 'Diploma');
  String get pointsReasonJournal => _t('Journal entry', 'Запись в журнале', 'Registro no diário', 'Entrada en el diario');
  String get pointsReasonFlashcard => _t('Flashcards', 'Карточки', 'Flashcards', 'Tarjetas');

  // ── Lesson key paywall sheet ──
  String get keyPaywallTitle => _t(
        'Lessons 15–58 open with a Desk Club key',
        'Уроки 15–58 открывает ключ Desk Club',
        'As aulas 15–58 abrem com a chave Desk Club',
        'Las lecciones 15–58 se abren con la clave Desk Club',
      );
  String keyPaywallBody(int n, {required bool billing}) => _t(
        'Lessons 1–$n are free. The rest can also unlock for free: you need a Tiger.com account created via the Desk Club link.'
        '${billing ? ' Another option is a one-time payment.' : ''}'
        ' All steps are on the next screen.',
        'Уроки 1–$n бесплатны. Ключ к остальным тоже можно получить бесплатно: нужен аккаунт на Tiger.com, созданный по ссылке Desk Club.'
        '${billing ? ' Другой способ — разовая оплата.' : ''}'
        ' Все шаги — на следующем экране.',
        'As aulas 1–$n são grátis. O resto também pode liberar de graça: precisa de conta Tiger.com pelo link Desk Club.'
        '${billing ? ' Outra opção é pagamento único.' : ''}'
        ' Todos os passos estão na próxima tela.',
        'Las lecciones 1–$n son gratis. El resto también puede abrirse gratis: hace falta una cuenta Tiger.com con el enlace Desk Club.'
        '${billing ? ' Otra opción es un pago único.' : ''}'
        ' Todos los pasos están en la siguiente pantalla.',
      );
  String get howToGetKeyBtn => _t(
        'How to get the key',
        'Как получить ключ',
        'Como obter a chave',
        'Cómo obtener la clave',
      );

  // ── Onboarding / lesson / quiz flow (owned screens) ──
  String get onboardingHeroTitle => _t(
        'Trading from scratch:\nrisk first, then trades',
        'Трейдинг с нуля:\nсначала риск, потом сделки',
        'Trading do zero:\nrisco primeiro, depois trades',
        'Trading desde cero:\nprimero riesgo, luego operaciones',
      );
  String get onboardingHeroSubtitle => _t(
        'Short lessons with charts, a paper exchange with no real money, and Desk Club chat where a mentor answers students.',
        'Короткие уроки с графиками, учебная биржа без настоящих денег и чат Desk Club, где ученикам отвечает наставник.',
        'Aulas curtas com gráficos, corretora simulada sem dinheiro real e chat Desk Club, onde um mentor responde aos alunos.',
        'Lecciones cortas con gráficos, bolsa de práctica sin dinero real y chat Desk Club, donde un mentor responde a los alumnos.',
      );
  String get onboardingStep1Language => _t(
        'STEP 1 OF 2 · LANGUAGE',
        'ШАГ 1 ИЗ 2 · ЯЗЫК',
        'PASSO 1 DE 2 · IDIOMA',
        'PASO 1 DE 2 · IDIOMA',
      );
  String get onboardingNoSignupAllFree => _t(
        'No sign-up · all 58 lessons free',
        'Без регистрации · все 58 уроков бесплатно',
        'Sem cadastro · todas as 58 aulas grátis',
        'Sin registro · las 58 lecciones gratis',
      );
  String get onboardingNoSignupAllFreeDesk => _t(
        'No sign-up · all 58 lessons free. We recommend the Desk Club path later — for pro chat, not for lessons',
        'Без регистрации · все 58 уроков бесплатно. Путь Desk Club рекомендуем позже — для профи-чата, не для уроков',
        'Sem cadastro · todas as 58 aulas grátis. O caminho Desk Club recomendamos depois — para o chat pro, não para as aulas',
        'Sin registro · las 58 lecciones gratis. El camino Desk Club lo recomendamos después — para el chat pro, no para las lecciones',
      );
  String get onboardingNoSignup14DeskOrPay => _t(
        'No sign-up · lessons 1–14 free, lessons 15–58 — Desk Club key or one-time purchase',
        'Без регистрации · уроки 1–14 бесплатно, уроки 15–58 — ключ Desk Club или разовая оплата',
        'Sem cadastro · aulas 1–14 grátis, aulas 15–58 — chave Desk Club ou compra única',
        'Sin registro · lecciones 1–14 gratis, lecciones 15–58 — clave Desk Club o compra única',
      );
  String get onboardingNoSignup14Desk => _t(
        'No sign-up · lessons 1–14 free, lessons 15–58 open with the Desk Club key',
        'Без регистрации · уроки 1–14 бесплатно, уроки 15–58 открывает ключ Desk Club',
        'Sem cadastro · aulas 1–14 grátis, aulas 15–58 abrem com a chave Desk Club',
        'Sin registro · lecciones 1–14 gratis, lecciones 15–58 se abren con la clave Desk Club',
      );
  String get onboardingNoSignup14Pay => _t(
        'No sign-up · lessons 1–14 free, lessons 15–58 open with a one-time purchase',
        'Без регистрации · уроки 1–14 бесплатно, уроки 15–58 открываются разовой покупкой',
        'Sem cadastro · aulas 1–14 grátis, aulas 15–58 abrem com compra única',
        'Sin registro · lecciones 1–14 gratis, lecciones 15–58 se abren con compra única',
      );
  String get onboardingNoSignup14Free => _t(
        'No sign-up · lessons 1–14 free',
        'Без регистрации · уроки 1–14 бесплатно',
        'Sem cadastro · aulas 1–14 grátis',
        'Sin registro · lecciones 1–14 gratis',
      );
  String get onboardingAlreadyLearning => _t(
        'I already study here — sign in',
        'Я уже учусь здесь, войти',
        'Já estudo aqui — entrar',
        'Ya estudio aquí — iniciar sesión',
      );
  String get onboardingRiskNote => _t(
        'This is education, not advice on what to buy. You can lose money on the exchange. 18+',
        'Это обучение, а не совет, что покупать. На бирже можно потерять вложенные деньги. 18+',
        'Isto é educação, não conselho do que comprar. Na corretora você pode perder o dinheiro investido. 18+',
        'Esto es formación, no consejo de qué comprar. En la bolsa puedes perder el dinero invertido. 18+',
      );

  String get onboardingStep2of2 => _t(
        'Step 2 of 2',
        'Шаг 2 из 2',
        'Passo 2 de 2',
        'Paso 2 de 2',
      );
  String get onboardingWhereStart => _t(
        'Where are you starting from?',
        'С чего ты начинаешь?',
        'De onde você começa?',
        '¿Desde dónde empiezas?',
      );
  String get goalFromZeroTitle => _t(
        'From scratch',
        'С нуля',
        'Do zero',
        'Desde cero',
      );
  String get goalFromZeroSub => _t(
        'Never traded — I want to learn the basics',
        'Никогда не торговал, хочу понять основы',
        'Nunca operei — quero entender o básico',
        'Nunca operé — quiero entender lo básico',
      );
  String get goalLostBeforeTitle => _t(
        'Tried and lost money',
        'Пробовал и потерял деньги',
        'Tentei e perdi dinheiro',
        'Intenté y perdí dinero',
      );
  String get goalLostBeforeSub => _t(
        'You’ll take the module 1 test: weak topics to review, the rest we mark done',
        'Пройдёшь тест модуля 1: слабые темы повторишь, остальное засчитаем',
        'Você fará o teste do módulo 1: revisa temas fracos, o resto contamos como feito',
        'Harás el test del módulo 1: repites temas débiles, el resto lo contamos hecho',
      );
  String get goalAlreadyTradingTitle => _t(
        'I already trade',
        'Уже торгую',
        'Já opero',
        'Ya opero',
      );
  String get goalAlreadyTradingSub => _t(
        'I want to check myself with section tests',
        'Хочу проверить себя тестами по разделам',
        'Quero me testar com testes por seção',
        'Quiero comprobarme con tests por sección',
      );
  String get timePerDayLabel => _t(
        'TIME PER DAY',
        'СКОЛЬКО ВРЕМЕНИ В ДЕНЬ',
        'TEMPO POR DIA',
        'TIEMPO AL DÍA',
      );
  String minutesLabel(int m) => _t('$m min', '$m мин', '$m min', '$m min');

  String weekWord(int n) {
    final abs = n.abs();
    switch (locale) {
      case AppLanguage.ru:
        final a = abs % 100;
        final b = a % 10;
        if (a >= 11 && a <= 14) return 'недель';
        if (b == 1) return 'неделю';
        if (b >= 2 && b <= 4) return 'недели';
        return 'недель';
      case AppLanguage.pt:
        return abs == 1 ? 'semana' : 'semanas';
      case AppLanguage.es:
        return abs == 1 ? 'semana' : 'semanas';
      case AppLanguage.en:
        return abs == 1 ? 'week' : 'weeks';
    }
  }

  String goalEtaHint(int minutes, int studentsDays, int proWeeks) => _t(
        'If you study $minutes min a day, the students chat opens in about $studentsDays ${dayWord(studentsDays)}, diploma and pro chat in about $proWeeks ${weekWord(proWeeks)}. Faster is not possible: chats need 7 and 30 days of study in a row.',
        'Если учиться $minutes мин в день, чат учеников откроется примерно через $studentsDays ${dayWord(studentsDays)}, диплом и чат профи — примерно через $proWeeks ${weekWord(proWeeks)}. Быстрее не получится: для чатов нужно учиться 7 и 30 дней подряд.',
        'Se estudar $minutes min por dia, o chat de alunos abre em cerca de $studentsDays ${dayWord(studentsDays)}, diploma e chat pro em cerca de $proWeeks ${weekWord(proWeeks)}. Mais rápido não dá: os chats pedem 7 e 30 dias seguidos de estudo.',
        'Si estudias $minutes min al día, el chat de alumnos se abre en unos $studentsDays ${dayWord(studentsDays)}, el diploma y el chat pro en unas $proWeeks ${weekWord(proWeeks)}. Más rápido no es posible: los chats piden 7 y 30 días seguidos de estudio.',
      );
  String get ctaToModuleTests => _t(
        'To section tests',
        'К тестам разделов',
        'Para os testes de seção',
        'A los tests de sección',
      );
  String get ctaToModule1Test => _t(
        'To module 1 test',
        'К тесту модуля 1',
        'Para o teste do módulo 1',
        'Al test del módulo 1',
      );
  String get ctaStartLesson1 => _t(
        'Start lesson 1',
        'Начать урок 1',
        'Começar aula 1',
        'Empezar lección 1',
      );

  String get placementAppBar => _t(
        'Knowledge check',
        'Проверка знаний',
        'Verificação de conhecimento',
        'Comprobación de conocimientos',
      );
  String get placementHero => _t(
        'You’ve tried before — let’s check the Basics module',
        'Ты уже пробовал — проверим модуль «Основы»',
        'Você já tentou — vamos checar o módulo Fundamentos',
        'Ya lo intentaste — revisemos el módulo Lo esencial',
      );
  String get placementBody => _t(
        'A short test on lessons 1–8. If you miss a question, we’ll suggest reviewing that lesson. Other module lessons are marked complete so you don’t redo them.',
        'Короткий тест по урокам 1–8. Если ошибёшься в вопросе — посоветуем повторить именно тот урок. Остальные уроки модуля отметим как пройденные, чтобы не проходить их заново.',
        'Um teste curto das aulas 1–8. Se errar uma pergunta, sugerimos revisar aquela aula. As outras aulas do módulo ficam concluídas para você não refazer.',
        'Un test corto de las lecciones 1–8. Si fallas una pregunta, te sugerimos repasar esa lección. Las demás del módulo se marcan hechas para no repetirlas.',
      );
  String get placementNote => _t(
        'This is not an exam or a grade. The goal is to find gaps and save time on what you already understand.',
        'Это не экзамен и не оценка. Цель — найти пробелы и сэкономить время на том, что ты уже понимаешь.',
        'Isto não é exame nem nota. O objetivo é achar lacunas e poupar tempo no que você já entende.',
        'Esto no es un examen ni una nota. El objetivo es hallar huecos y ahorrar tiempo en lo que ya entiendes.',
      );
  String get placementStartBtn => _t(
        'Take module 1 test',
        'Пройти тест модуля 1',
        'Fazer o teste do módulo 1',
        'Hacer el test del módulo 1',
      );
  String get placementPreferLesson1 => _t(
        'Better start with lesson 1',
        'Лучше начать с урока 1',
        'Melhor começar pela aula 1',
        'Mejor empezar por la lección 1',
      );
  String get placementUnavailable => _t(
        'Module test is not available yet. Start with lesson 1.',
        'Тест модуля пока недоступен. Начни с урока 1.',
        'O teste do módulo ainda não está disponível. Comece pela aula 1.',
        'El test del módulo aún no está disponible. Empieza por la lección 1.',
      );
  String get placementNoQuestions => _t(
        'No questions in this test. Start with lesson 1.',
        'В тесте нет вопросов. Начни с урока 1.',
        'Não há perguntas neste teste. Comece pela aula 1.',
        'No hay preguntas en este test. Empieza por la lección 1.',
      );
  String get placementOpenFailed => _t(
        'Could not open the test. Start with lesson 1.',
        'Не удалось открыть тест. Начни с урока 1.',
        'Não foi possível abrir o teste. Comece pela aula 1.',
        'No se pudo abrir el test. Empieza por la lección 1.',
      );
  String placementCheckTitle(String module) => _t(
        'Check: $module',
        'Проверка: $module',
        'Verificação: $module',
        'Comprobación: $module',
      );

  String get placementResultTitle => _t(
        'Check result',
        'Результат проверки',
        'Resultado da verificação',
        'Resultado de la comprobación',
      );
  String moduleTestCounted(String pts) => _t(
        '$pts · section test counted',
        '$pts · тест раздела засчитан',
        '$pts · teste de seção contado',
        '$pts · test de sección contado',
      );
  String get placementNoGaps => _t(
        'No gaps in the Basics module. Lessons 1–8 are marked complete — you can continue the course.',
        'По модулю «Основы» пробелов не видно. Уроки 1–8 отмечены пройденными — можно идти дальше по курсу.',
        'Sem lacunas no módulo Fundamentos. Aulas 1–8 marcadas como feitas — pode seguir o curso.',
        'Sin huecos en el módulo Lo esencial. Lecciones 1–8 marcadas hechas — puedes seguir el curso.',
      );
  String get placementOneGap => _t(
        'One weak spot. Review that lesson — other module lessons are already marked complete.',
        'Ошибка в одном месте. Повтори этот урок — остальные уроки модуля уже отмечены пройденными.',
        'Uma falha. Revise essa aula — as outras do módulo já estão concluídas.',
        'Un punto débil. Repasa esa lección — las demás del módulo ya están hechas.',
      );
  String placementManyGaps(int n) => _t(
        'Gaps in $n topics. Review these lessons — other module lessons are already marked complete.',
        'Ошибки в $n темах. Повтори эти уроки — остальные уроки модуля уже отмечены пройденными.',
        'Falhas em $n temas. Revise essas aulas — as outras do módulo já estão concluídas.',
        'Huecos en $n temas. Repasa estas lecciones — las demás del módulo ya están hechas.',
      );
  String get reviewThese => _t(
        'Review:',
        'Повтори:',
        'Revise:',
        'Repasa:',
      );
  String lessonIdTitle(int id, String title) => _t(
        'Lesson $id: $title',
        'Урок $id: $title',
        'Aula $id: $title',
        'Lección $id: $title',
      );
  String repeatLessonBtn(int id) => _t(
        'Review lesson $id',
        'Повторить урок $id',
        'Revisar aula $id',
        'Repasar lección $id',
      );
  String get continueToLessons => _t(
        'Continue to lessons',
        'К урокам дальше',
        'Seguir para as aulas',
        'Seguir a las lecciones',
      );

  String get lessonPassedShort => _t(
        'Lesson passed',
        'Урок пройден',
        'Aula concluída',
        'Lección superada',
      );
  String get pointsAlreadyAwarded => _t(
        'Points for this lesson already awarded',
        'Очки за этот урок уже начислены',
        'Pontos desta aula já foram dados',
        'Puntos de esta lección ya otorgados',
      );
  String streakPointsMult(int days, String mult) => _t(
        'Study streak: $days days, so points are multiplied by $mult',
        'Дней учёбы подряд: $days, поэтому очки умножены на $mult',
        'Sequência de estudo: $days dias, então pontos × $mult',
        'Racha de estudio: $days días, así que puntos × $mult',
      );
  String totalPointsProLeague(String total, String word) => _t(
        'Total $total $word · league “Pro”',
        'Всего $total $word · лига «Профи»',
        'Total $total $word · liga “Pro”',
        'Total $total $word · liga “Pro”',
      );
  String totalPointsToLeague(String total, String word, String league, String left) => _t(
        'Total points: $total · $left more to league “$league”',
        'Всего очков: $total · до лиги «$league» ещё $left',
        'Total de pontos: $total · faltam $left até a liga “$league”',
        'Total de puntos: $total · faltan $left hasta la liga “$league”',
      );
  String get backToLearningLessonsList => _t(
        'Back to learning · lesson list',
        'К обучению · список уроков',
        'Voltar ao aprendizado · lista de aulas',
        'Volver al aprendizaje · lista de lecciones',
      );
  String get findCorrectToContinue => _t(
        'Find the right answer to continue',
        'Найди верный ответ, чтобы идти дальше',
        'Ache a resposta certa para continuar',
        'Encuentra la respuesta correcta para seguir',
      );
  String get checkYourself => _t(
        'Check yourself',
        'Проверь себя',
        'Teste-se',
        'Compruébate',
      );
  String get answerThenReveal => _t(
        'Answer in your head first, then reveal and compare.',
        'Сначала ответь мысленно, потом открой ответ и сравни.',
        'Responda mentalmente primeiro, depois revele e compare.',
        'Responde primero mentalmente, luego revela y compara.',
      );
  String get showAnswer => _t(
        'Show answer',
        'Показать ответ',
        'Mostrar resposta',
        'Mostrar respuesta',
      );
  String answerOptionHint(Object n) => _t(
        'Answer option $n',
        'Вариант ответа $n',
        'Opção de resposta $n',
        'Opción de respuesta $n',
      );

  String get deskClubSupportTitle => _t(
        'Desk Club support',
        'Поддержка Desk Club',
        'Apoio Desk Club',
        'Apoyo Desk Club',
      );
  String get courseFreeSupportBody => _t(
        'All 58 lessons are free. One-time support is optional; the Desk Club path on the site opens pro chat.',
        'Все 58 уроков бесплатны. Разовая поддержка — по желанию; путь Desk Club на сайте открывает профи-чат.',
        'Todas as 58 aulas são grátis. Apoio único é opcional; o caminho Desk Club no site abre o chat pro.',
        'Las 58 lecciones son gratis. El apoyo único es opcional; el camino Desk Club en el sitio abre el chat pro.',
      );
  String get courseNotLockedNote => _t(
        'The course is not locked. You don’t need to pay to learn.',
        'Курс не запирается. Оплата не нужна, чтобы учиться.',
        'O curso não fica trancado. Não precisa pagar para estudar.',
        'El curso no se bloquea. No hace falta pagar para estudiar.',
      );
  String get recommendDeskPathLessonsFree => _t(
        'Recommended: Desk Club path (lessons already free)',
        'Рекомендуем: путь Desk Club (уроки уже бесплатны)',
        'Recomendado: caminho Desk Club (aulas já grátis)',
        'Recomendado: camino Desk Club (lecciones ya gratis)',
      );
  String get freeDeskKeyViaTiger => _t(
        'Free: Desk Club key via Tiger.com',
        'Бесплатно: ключ Desk Club через Tiger.com',
        'Grátis: chave Desk Club via Tiger.com',
        'Gratis: clave Desk Club vía Tiger.com',
      );

  String get afterLessonYouCan => _t(
        'After this lesson you will be able to',
        'После урока ты сможешь',
        'Depois desta aula você poderá',
        'Después de la lección podrás',
      );
  String get newWordsInLesson => _t(
        'New words in this lesson',
        'Новые слова в этом уроке',
        'Palavras novas nesta aula',
        'Palabras nuevas en esta lección',
      );
  String get eachWordExplained => _t(
        'You’ll see each word in this lesson with an example.',
        'Каждое слово ты разберёшь в этом уроке на примере.',
        'Você verá cada palavra nesta aula com um exemplo.',
        'Verás cada palabra en esta lección con un ejemplo.',
      );
  String get correctShort => _t('Correct', 'Верно', 'Correto', 'Correcto');
  String get incorrectReadExplain => _t(
        'Incorrect. Read the explanation.',
        'Неверно. Прочитай пояснение.',
        'Incorreto. Leia a explicação.',
        'Incorrecto. Lee la explicación.',
      );
  String get incorrectPickAnother => _t(
        'Incorrect. Read the explanation and pick another answer.',
        'Неверно. Прочитай пояснение и выбери другой ответ.',
        'Incorreto. Leia a explicação e escolha outra resposta.',
        'Incorrecto. Lee la explicación y elige otra respuesta.',
      );
  String get paperPracticeDefaultTitle => _t(
        'Practice on the paper exchange',
        'Практика на учебной бирже',
        'Prática na corretora simulada',
        'Práctica en la bolsa de práctica',
      );
  String get assignmentDone => _t(
        'Assignment done',
        'Задание выполнено',
        'Tarefa concluída',
        'Tarea hecha',
      );
  String get paperMoneyRealHabits => _t(
        'Money here is practice money, but habits stick for real. Treat every trade as if it were yours.',
        'Деньги здесь учебные, но привычки закрепляются настоящие. Делай каждую сделку так, будто деньги твои.',
        'O dinheiro aqui é de treino, mas os hábitos ficam de verdade. Faça cada trade como se o dinheiro fosse seu.',
        'El dinero aquí es de práctica, pero los hábitos se quedan de verdad. Haz cada trade como si el dinero fuera tuyo.',
      );
  String get assignmentTitle => _t('Assignment', 'Задание', 'Tarefa', 'Tarea');
  String get howToDo => _t('How to do it', 'Как сделать', 'Como fazer', 'Cómo hacerlo');
  String get openPaperExchange => _t(
        'Open paper exchange',
        'Открыть учебную биржу',
        'Abrir corretora simulada',
        'Abrir bolsa de práctica',
      );
  String get openPaperExchangeAgain => _t(
        'Open paper exchange again',
        'Открыть учебную биржу ещё раз',
        'Abrir corretora simulada de novo',
        'Abrir bolsa de práctica otra vez',
      );
  String get assignmentCountsOnClose => _t(
        'The assignment counts when the trade closes on stop or take. You can do it now or after the lesson: at the end there will be a “Try on the paper exchange” button.',
        'Задание засчитается, когда сделка закроется по стопу или тейку. Можно сделать сейчас или после урока: в конце урока будет кнопка «Попробуй на учебной бирже».',
        'A tarefa conta quando o trade fecha no stop ou take. Pode fazer agora ou depois da aula: no fim haverá o botão “Experimente na corretora simulada”.',
        'La tarea cuenta cuando el trade cierra en stop o take. Puedes hacerlo ahora o después: al final habrá el botón “Prueba en la bolsa de práctica”.',
      );

  String correctOfTotal(int correct, int total) => _t(
        'Correct: $correct of $total',
        'Верных ответов: $correct из $total',
        'Acertos: $correct de $total',
        'Correctas: $correct de $total',
      );
  String get needAllCorrectHint => _t(
        'to pass the lesson, answer every question correctly',
        'чтобы пройти урок, нужно ответить верно на все вопросы',
        'para passar a aula, acerte todas as perguntas',
        'para superar la lección, responde bien todas las preguntas',
      );
  String get seeResultAtEnd => _t(
        'Right or wrong — you’ll see at the end of the test.',
        'Верно или нет — увидишь в конце теста.',
        'Certo ou errado — você verá no fim do teste.',
        'Bien o mal — lo verás al final del test.',
      );
  String get answerAndNext => _t(
        'Answer and continue',
        'Ответить и дальше',
        'Responder e seguir',
        'Responder y seguir',
      );
  String get answerAndSeeResult => _t(
        'Answer and see result',
        'Ответить и узнать итог',
        'Responder e ver o resultado',
        'Responder y ver el resultado',
      );
  String get allCorrectLessonPassed => _t(
        'All answers correct — lesson passed.',
        'Все ответы верные — урок пройден.',
        'Todas certas — aula concluída.',
        'Todas correctas — lección superada.',
      );
  String failNamedOne(int n) => _t(
        'Error in question $n. Reread the lesson or try again: answer options will shuffle.',
        'Ошибка в вопросе $n. Перечитай урок или попробуй ещё раз: варианты ответов перемешаются.',
        'Erro na pergunta $n. Releia a aula ou tente de novo: as opções serão embaralhadas.',
        'Error en la pregunta $n. Relee la lección o inténtalo de nuevo: las opciones se mezclarán.',
      );
  String failNamedMany(String list) => _t(
        'Errors in questions $list. Reread the lesson or try again: answer options will shuffle.',
        'Ошибка в вопросах $list. Перечитай урок или попробуй ещё раз: варианты ответов перемешаются.',
        'Erros nas perguntas $list. Releia a aula ou tente de novo: as opções serão embaralhadas.',
        'Errores en las preguntas $list. Relee la lección o inténtalo de nuevo: las opciones se mezclarán.',
      );
  String get failAnonymous => _t(
        'There’s a mistake. Which question — the test will show if you miss again. Reread the lesson or try again: answer options will shuffle.',
        'Есть ошибка. В каком вопросе, тест покажет, если ошибёшься ещё раз. Перечитай урок или попробуй ещё раз: варианты ответов перемешаются.',
        'Há um erro. Em qual pergunta, o teste mostra se errar de novo. Releia a aula ou tente de novo: as opções serão embaralhadas.',
        'Hay un error. En qué pregunta, el test lo mostrará si fallas otra vez. Relee la lección o inténtalo de nuevo: las opciones se mezclarán.',
      );
  String get retakeCheckpoint => _t(
        'Retake the test',
        'Пройти тест ещё раз',
        'Refazer o teste',
        'Repetir el test',
      );
  String get returnToLesson => _t(
        'Back to the lesson',
        'Вернуться к уроку',
        'Voltar à aula',
        'Volver a la lección',
      );
  String answerLetter(int i) {
    const en = ['A', 'B', 'C', 'D', 'E'];
    const ru = ['А', 'Б', 'В', 'Г', 'Д'];
    final letters = locale == AppLanguage.ru ? ru : en;
    return letters[i.clamp(0, letters.length - 1)];
  }

  String andJoin(String a, String b) => _t('$a and $b', '$a и $b', '$a e $b', '$a y $b');

  String get patternLabelSupport => _t('Support', 'Поддержка', 'Suporte', 'Soporte');
  String get patternLabelResistance => _t('Resistance', 'Сопротивление', 'Resistência', 'Resistencia');
  String get patternAscTriangle => _t(
        'Ascending triangle',
        'Восходящий треугольник',
        'Triângulo ascendente',
        'Triángulo ascendente',
      );
  String get patternDescTriangle => _t(
        'Descending triangle',
        'Нисходящий треугольник',
        'Triângulo descendente',
        'Triángulo descendente',
      );
  String get patternSymTriangle => _t(
        'Symmetric triangle',
        'Симметричный треугольник',
        'Triângulo simétrico',
        'Triángulo simétrico',
      );
  String get patternNeckline => _t('Neckline', 'Линия шеи', 'Linha do pescoço', 'Línea de cuello');
  String get patternNeck => _t('Neck', 'Шея', 'Pescoço', 'Cuello');
  String get patternHeadShoulders => _t(
        'Head and shoulders',
        'Голова и плечи',
        'Cabeça e ombros',
        'Cabeza y hombros',
      );
  String get patternInvHeadShoulders => _t(
        'Inverse head and shoulders',
        'Перевёрнутая голова и плечи',
        'Cabeça e ombros invertidos',
        'Cabeza y hombros invertidos',
      );
  String get patternChannel => _t('Price channel', 'Ценовой канал', 'Canal de preço', 'Canal de precio');
  String get patternRisingWedge => _t('Rising wedge', 'Восходящий клин', 'Cunha ascendente', 'Cuña ascendente');
  String get patternFallingWedge => _t('Falling wedge', 'Нисходящий клин', 'Cunha descendente', 'Cuña descendente');
  String get patternFibRetracement => _t(
        'Fibonacci retracement',
        'Коррекция по Фибоначчи',
        'Retração de Fibonacci',
        'Retroceso de Fibonacci',
      );
  String get patternDoubleTop => _t('Double top', 'Двойная вершина', 'Topo duplo', 'Doble techo');
  String get patternDoubleBottom => _t('Double bottom', 'Двойное дно', 'Fundo duplo', 'Doble suelo');

  String get hwLabelLesson => _t('Lesson', 'Урок', 'Aula', 'Lección');
  String get hwLabelAbout => _t(
        'In one sentence',
        'О чём был урок',
        'Em uma frase',
        'En una frase',
      );
  String get hwLabelResult => _t(
        'What I did',
        'Что получилось в задании',
        'O que fiz',
        'Qué hice',
      );
  String get hwLabelUnclear => _t(
        'Still unclear',
        'Что ещё не ясно',
        'O que ainda não ficou claro',
        'Qué aún no está claro',
      );
  String get hwLabelTopic => _t('Topic', 'Раздел чата', 'Tópico', 'Tema');
  String get mythDefaultLabel => _t('Myth', 'Миф', 'Mito', 'Mito');

  String _t(String en, String ru, String pt, [String? es]) {
    switch (locale) {
      case AppLanguage.ru:
        return ru;
      case AppLanguage.pt:
        return pt;
      case AppLanguage.es:
        return es ?? en;
      case AppLanguage.en:
        return en;
    }
  }
}

