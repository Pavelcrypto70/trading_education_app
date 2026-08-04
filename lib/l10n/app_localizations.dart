import '../services/locale_service.dart';

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
  String get navLearn => _t(
        'Learn',
        'Обучение',
        'Aprender',
        'Aprender',
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
        'Ежедневный челлендж',
        'Desafio Diário',
        'Desafío diario',
      );
  String dailyChallengeDone(int score) =>
      _t(
        'Completed today — $score/5 correct',
        'Сегодня пройдено — $score/5 верно',
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
        'Бумажная торговля',
        'Trading Simulado',
        'Trading simulado',
      );
  String get paperTradingSubtitle => _t(
        'Practice buy & sell with virtual money',
        'Тренируйся покупать и продавать',
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
        'Рыночные концепции',
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
        'Твоя недельная динамика',
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
        'Фокус на демо-торговлю',
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
  String completedCount(int done, int total) =>
      _t(
        '$done/$total completed',
        '$done/$total пройдено',
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
        'Что вы изучите',
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
        'Key takeaway',
        'Главный вывод',
        'Conclusão principal',
        'Conclusión clave',
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
        'Основная концепция',
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
        'Совет профи',
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
        'Бразилия · LATAM',
        'Brasil · LATAM',
        'Brasil · LATAM',
      );
  String get marketMexico => _t(
        'Mexico · LATAM',
        'Мексика · LATAM',
        'México · LATAM',
        'México · LATAM',
      );
  String get marketLatam => _t(
        'LATAM focus',
        'Фокус LATAM',
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
        'Далее',
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
        'У SUPPORT — покупатели',
        'Perto de SUPORTE – compradores ativos',
        'Cerca de SOPORTE: compradores activos',
      );
  String get zoneResistance => _t(
        'Near RESISTANCE — sellers active',
        'У RESISTANCE — продавцы',
        'Perto da RESISTÊNCIA – vendedores ativos',
        'Cerca de RESISTENCIA - vendedores activos',
      );
  String get zoneNeutral => _t(
        'Mid-range — no clear edge',
        'Середина — нет преимущества',
        'Intervalo médio – sem limites claros',
        'Rango medio: sin ventaja clara',
      );
  String get checkpointTitle => _t(
        'Quick check',
        'Проверка знаний',
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
        'Key takeaway from "$title"?',
        'Главный вывод урока?',
        'Conclusão importante de "$title"?',
        '¿Conclusión clave de "$title"?',
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
        '+$xp XP earned',
        '+$xp XP',
        '+$xp XP',
        '+$xp XP ganada',
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
        'Trade Master — практические уроки, разбор в TradingView, не сигналы. Присоединяйся!',
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
        'Пока пусто. Записывай сетапы из уроков.',
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
        'Сетап',
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
        'Цель',
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
        'Ваш код',
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
        '+500 XP per friend · +100 XP when you join',
        '+500 XP за друга · +100 XP при вводе кода',
        '+500 XP por amigo · +100 XP ao entrar',
        '+500 XP por amigo · +100 XP cuando te unes',
      );
  String get referralErrorEmpty => _t(
        'Enter a code',
        'Введите код',
        'Digite o código',
        'Introduce un código',
      );
  String get referralErrorOwn => _t(
        'That\'s your own code',
        'Это ваш код',
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
        'Code applied! +100 XP',
        'Код принят! +100 XP',
        'Código aplicado! +100 XP',
        '¡Código aplicado! +100 EXP',
      );
  String practiceLessonSetup(int id) => _t(
        'Practice lesson $id setup',
        'Отработать сетап урока $id',
        'Praticar setup aula $id',
        'Configuración de $id de la lección de práctica',
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
        'Level',
        'Уровень',
        'Nível',
        'Nivel',
      );
  String get xp => _t(
        'XP',
        'XP',
        'XP',
        'experiencia',
      );
  String levelProgress(int current, int needed) => _t(
        '$current / $needed XP',
        '$current / $needed XP',
        '$current / $needed XP',
        '$current / $needed XP',
      );
  String get practiceAfterLesson => _t(
        'Apply in Paper Trading',
        'Попробуй в симуляторе',
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
        'График в стиле TradingView · крипторынок',
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
        'Покупатели vs продавцы — как движется цена',
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
    'Торговые сессии (крипто 24/7)',
    'Sessões de trading (cripto 24h)',
  );
  String get chartConceptCorrelation => _t(
        'How two assets move together',
        'Как два актива движутся вместе',
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
        'Интерактив',
        'Interativo',
        'Interactivo',
      );

  // ── Flashcards ──
  String get flashcardSessionComplete => _t(
        'Flashcard session complete!',
        'Сессия карточек завершена!',
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
        'Арена тестов',
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
        'В арену тестов',
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
        'Вы набрали $score из $total',
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
        'Начать сегодняшний челлендж',
        'Iniciar desafio de hoje',
        'Comienza el desafío de hoy',
      );
  String get practiceMoreQuiz => _t(
        'Practice more in Quiz Arena',
        'Больше практики в арене тестов',
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
        'Живой демо-рынок со свечами. График обновляется сам — открывай long/short, выбирай размер и следи за P&L. Без реальных денег.',
        'Mercado demo ao vivo com candlesticks. O gráfico atualiza sozinho — abra long/short, defina o tamanho e acompanhe o P&L. Sem dinheiro real.',
        'Mercado de demostración en vivo con velas japonesas. Los gráficos se actualizan automáticamente: abra en largo o en corto, establezca el tamaño y realice un seguimiento de las pérdidas y ganancias. Sin dinero real.',
      );
  String get live => _t(
        'LIVE',
        'LIVE',
        'AO VIVO',
        'VIVIR',
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
        'Premium member',
        'Premium участник',
        'Membro Premium',
        'miembro premium',
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
        'Тестов пока нет. Перейди в арену!',
        'Nenhum quiz ainda. Vá para a Arena!',
        'Aún no hay pruebas. ¡Dirígete a Quiz Arena!',
      );
  String get upgradePremium => _t(
        'Upgrade to Premium',
        'Перейти на Premium',
        'Upgrade para Premium',
        'Actualizar a Premium',
      );
  String get replayOnboarding => _t(
        'Replay onboarding',
        'Пройти онбординг заново',
        'Refazer onboarding',
        'Incorporación de repetición',
      );
  String get resetAllProgress => _t(
        'Reset all progress',
        'Сбросить весь прогресс',
        'Redefinir todo o progresso',
        'Restablecer todo el progreso',
      );
  String get resetProgressTitle => _t(
        'Reset all progress?',
        'Сбросить весь прогресс?',
        'Redefinir todo o progresso?',
        '¿Restablecer todo el progreso?',
      );
  String get resetProgressBody => _t(
        'This will clear lessons, quizzes, trading balance, and streaks.',
        'Это удалит прогресс уроков, тестов, баланс торговли и серии.',
        'Isso apagará aulas, quizzes, saldo de trading e sequências.',
        'Esto borrará lecciones, cuestionarios, saldo comercial y rachas.',
      );
  String get progressReset => _t(
        'Progress reset',
        'Прогресс сброшен',
        'Progresso redefinido',
        'Restablecer progreso',
      );
  String get appDisclaimer => _t(
        'Trade Master v1.0.0\nEducational app — not financial advice.',
        'Trade Master v1.0.0\nОбразовательное приложение — не финансовый совет.',
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
        'Выберите язык',
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
        'Практика на демо-счёте',
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
        'Тесты, карточки и ежедневные челленджи',
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
        'Цель: Изучить трейдинг',
        'Meta: Aprender trading',
        'Objetivo: aprender a operar',
      );
      case 'practice_demo':
        return _t(
        'Goal: Demo practice',
        'Цель: Демо-практика',
        'Objetivo: prática de demonstração',
        'Objetivo: práctica de demostración',
      );
      case 'pass_quiz':
        return _t(
        'Goal: Test knowledge',
        'Цель: Проверить знания',
        'Meta: Testar conhecimento',
        'Objetivo: probar conocimientos',
      );
      case 'build_discipline':
        return _t(
        'Goal: Build discipline',
        'Цель: Развить дисциплину',
        'Meta: Construir disciplina',
        'Objetivo: desarrollar disciplina',
      );
      default:
        return _t(
        'Trading learner',
        'Учащийся трейдер',
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
        'Your complete trading education platform — lessons, quizzes, flashcards, and paper trading.',
        'Полная платформа для обучения трейдингу — уроки, тесты, карточки и бумажная торговля.',
        'Sua plataforma completa de educação em trading — aulas, quizzes, flashcards e trading simulado.',
        'Su plataforma completa de educación comercial: lecciones, cuestionarios, tarjetas didácticas y comercio en papel.',
      );
  String get getStarted => _t(
        'Get started',
        'Начать',
        'Começar',
        'Empezar',
      );

  // ── Premium ──
  String get premium => _t(
        'Premium',
        'Premium',
        'Premium',
        'Premium',
      );
  String get premiumActivated => _t(
        'Premium activated!',
        'Premium активирован!',
        'Premium ativado!',
        '¡Premium activado!',
      );
  String get youHavePremium => _t(
        'You have Premium access',
        'У вас есть Premium доступ',
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
        'Get unlimited access to all lessons, advanced quizzes, and exclusive content.',
        'Полный доступ ко всем урокам, продвинутым тестам и эксклюзивному контенту.',
        'Acesso ilimitado a todas as aulas, quizzes avançados e conteúdo exclusivo.',
        'Obtenga acceso ilimitado a todas las lecciones, cuestionarios avanzados y contenido exclusivo.',
      );
  String get activatePremium => _t('Activate Premium (Demo)', 'Активировать Premium (Демо)', 'Ativar Premium (Demo)');

  // ── Market concepts ──
  String get marketConceptsTitle => _t(
        'Market Concepts',
        'Рыночные концепции',
        'Conceitos de Mercado',
        'Conceptos de mercado',
      );
  String get marketConceptsIntro => _t(
        'Essential concepts every trader should understand before risking capital.',
        'Ключевые концепции, которые должен понимать каждый трейдер.',
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
        'Price Action',
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
  String get sectionReferences => _t(
        'References',
        'Источники',
        'Referências',
        'Referencias',
      );
  String get submitHomework => _t('Submit homework (Telegram)', 'Сдать домашку (Telegram)', 'Enviar tarefa (Telegram)');
  String get homeworkOpenError => _t(
        'Could not open Telegram',
        'Не удалось открыть Telegram',
        'Não foi possível abrir o Telegram',
        'No se pudo abrir Telegram',
      );
  String get syllabusTitle => _t(
        'Course syllabus',
        'Силлабус курса',
        'Programa do curso',
        'Programa del curso',
      );
  String get glossaryTitle => _t(
        'Glossary',
        'Глоссарий',
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
        'Тесты по модулям',
        'Testes por módulo',
        'Pruebas del módulo',
      );
  String get caseStudies => _t(
        'Case studies',
        'Кейсы',
        'Estudos de caso',
        'Estudios de caso',
      );
  String prerequisitesRequired(String ids) =>
      _t(
        'Complete lessons $ids first',
        'Сначала пройдите уроки $ids',
        'Conclua as aulas $ids primeiro',
        'Complete las lecciones $ids primero',
      );
  String get checkpointPassHint =>
      _t('Pass the checkpoint (70%+) to complete the lesson', 'Пройдите чекпоинт (70%+) чтобы завершить урок', 'Passe no checkpoint (70%+) para concluir a lição');
  String get skillTree => _t(
        'Skill tree',
        'Дерево навыков',
        'Árvore de habilidades',
        'árbol de habilidades',
      );
  String moduleProgress(int done, int total) =>
      _t(
        '$done/$total lessons',
        '$done/$total уроков',
        '$done/$total aulas',
        '$done/$total totales',
      );
  String moduleTestMeta(int questions, int minutes, int lessons) =>
      _t(
        '$questions Q · ~$minutes min · $lessons lessons',
        '$questions вопр. · ~$minutes мин · $lessons уроков',
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
        'Критерии домашки',
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
        'Pass score: \$s/10',
        'Проходной балл: \$s/10',
        'Nota mínima: \$s/10',
        'Puntaje de aprobación: \$s/10',
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
        'Цель',
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
        'R:R 1:$rr',
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
        'Укажите вход, стоп и цель',
        'Informe entrada, stop e alvo',
        'Introduzca una entrada, una parada y un objetivo válidos',
      );
  String get planErrorRisk => _t(
        'Risk must be 0.25–3%',
        'Риск 0.25–3%',
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
        'Лонг: цель выше входа',
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
        'Шорт: цель ниже входа',
        'Short: alvo abaixo da entrada',
        'Breve: objetivo debajo de la entrada',
      );
  String get planErrorRR => _t(
        'Minimum R:R 1:1.5 required',
        'Минимум R:R 1:1.5',
        'Mínimo R:R 1:1.5',
        'Se requiere R:R 1:1,5 mínimo',
      );
  String get planRequiredMsg => _t(
        'Save a valid trade plan first',
        'Сначала сохраните план',
        'Salve um plano válido primeiro',
        'Guarde primero un plan comercial válido',
      );
  String get certificateHash => _t(
        'Verification ID',
        'ID верификации',
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
        'Видео ниже. Если не загружается — нажмите ссылку.',
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
        'Представьте',
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
        'Sign in with email to sync progress and unlock purchases across devices.',
        'Войдите по почте, чтобы синхронизировать прогресс и покупки на всех устройствах.',
        'Entre com e-mail para sincronizar progresso e compras em todos os dispositivos.',
        'Inicie sesión con correo electrónico para sincronizar el progreso y desbloquear compras en todos los dispositivos.',
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
        'Введите корректную почту',
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
        'Админ: полный доступ открыт',
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
        'Desk Club: практика, структура, академия и домашки',
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
        'Полный курс через сообщество',
        'Curso completo pela comunidade',
        'Curso completo vía comunidad',
      );
  String get communityFullAccessBody => _t(
        'This free build has trial lessons. Join the Telegram community for the full program, homework, and live chat.',
        'В этой бесплатной версии — пробные уроки. Полный курс, домашки и живой чат — в Telegram-сообществе.',
        'Nesta versão grátis há aulas de teste. Curso completo, tarefas e chat ao vivo — na comunidade Telegram.',
        'Esta versión gratuita tiene lecciones de prueba. Únase a la comunidad de Telegram para ver el programa completo, las tareas y el chat en vivo.',
      );
  String get openCommunityCta => _t(
        'Open Telegram community',
        'Открыть Telegram-чат',
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
        'You have $n free trial lessons. Unlock all 58 lessons with a one-time purchase.',
        'У вас $n бесплатных урока. Откройте все 58 уроков разовой покупкой.',
        'Você tem $n aulas experimentais gratuitas. Desbloqueie todas as 58 aulas com uma compra única.',
        'Tienes $n lecciones de prueba gratuitas. Desbloquea las 58 lecciones con una compra única.',
      );
  String paywallLessonBodyCommunity(int n) => _t(
        'You have $n free trial lessons. Join the community to get the full course and chat with traders.',
        'У вас $n бесплатных урока. Вступите в сообщество — полный курс и чат с трейдерами.',
        'Você tem $n aulas experimentais gratuitas. Junte-se à comunidade para obter o curso completo e conversar com traders.',
        'Tienes $n lecciones de prueba gratuitas. Únase a la comunidad para obtener el curso completo y chatear con comerciantes.',
      );
  String get paywallTrialLessons => _t(
        'Trial: Intro 1–2, Amplitude, Beginner mistakes, Impulse strategy',
        'Триал: Ввод 1–2, Амплитуда, Ошибки новичков, Стратегия импульсов',
        'Trial: Intro 1–2, Amplitude, Erros, Estratégia de impulso',
        'Prueba: Introducción 1–2, Amplitud, Errores de principiante, Estrategia de impulso',
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
        'Your YouTube lessons in-app',
        'Ваши видео-уроки в приложении',
        'Suas aulas do YouTube no aplicativo',
        'Tus lecciones de YouTube en la aplicación',
      );
  String get premiumFeatureHomework => _t(
        'Homework & Telegram chat',
        'Домашки и чат Telegram',
        'Aula de casa e bate-papo por telegrama',
        'Tareas y chat de Telegram',
      );
  String get premiumFeatureJournal => _t(
        'Unlimited trade journal',
        'Безлимитный журнал',
        'Diário ilimitado',
        'Diario comercial ilimitado',
      );
  String get premiumFeatureCertificate => _t(
        'Course certificate',
        'Сертификат курса',
        'Certificado do curso',
        'Certificado del curso',
      );
  String get premiumFeaturePractice => _t(
        'Paper trading simulator',
        'Симулятор сделок',
        'Simulador de negociação de papel',
        'Simulador de comercio de papel',
      );

  String get otpSent => _t(
        'Check your email for the code',
        'Проверьте почту — код отправлен',
        'Verifique seu e-mail para o código',
        'Revisa tu correo electrónico para ver el código.',
      );
  String get enterOtpCode => _t(
        'Enter 6-digit code',
        'Введите 6-значный код',
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
        'Ошибка входа. Попробуйте снова.',
        'Falha no login. Tente novamente.',
        'Error al iniciar sesión. Intentar otra vez.',
      );
  String get backendNotConfigured => _t(
        'Cloud sync is not configured. Contact support.',
        'Облако не настроено. Свяжитесь с поддержкой.',
        'A sincronização na nuvem não está configurada. Entre em contato com o suporte.',
        'La sincronización en la nube no está configurada. Póngase en contacto con el soporte.',
      );
  String get signInRequiredForPurchase => _t(
        'Sign in before purchasing',
        'Войдите перед покупкой',
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
        'Облачная синхронизация',
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
        'Прогресс: $done уроков (цель к сегодня: $expected из $totalLessons)',
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
        'Записей в журнале: $n / $min',
        'Entradas no diário: $n / $min',
        'Entradas de diario: $n / $min',
      );
  String certificateReqModules(int n, int min) => _t(
        'Module tests passed: $n / $min',
        'Модульных тестов: $n / $min',
        'Testes de módulo: $n / $min',
        'Pruebas del módulo superadas: $n / $min',
      );

  // ── Partner offers (post-certificate) ──
  String get partnerOffersTitle => _t(
        'Next step: exchanges & terminals',
        'Следующий шаг: биржи и терминалы',
        'Próximo passo: exchanges e terminais',
        'Siguiente paso: exchanges y terminales',
      );
  String get partnerOffersSubtitle => _t(
        'Certificate unlocked. Here are our partner links to open an account and move from paper to live — with risk limits from the course.',
        'Сертификат открыт. Ниже партнёрские ссылки: открыть счёт и перейти от paper к live — с лимитами риска из курса.',
        'Certificado desbloqueado. Abaixo estão nossos links de parceiros para abrir conta e sair do paper para live — com os limites de risco do curso.',
        'Certificado desbloqueado. Aquí están nuestros enlaces de partners para abrir cuenta y pasar de paper a live — con los límites de riesgo del curso.',
      );
  String get partnerDisclosure => _t(
        'Partner / affiliate links. Educational product — not financial advice. Trading involves risk of loss.',
        'Партнёрские / реферальные ссылки. Образовательный продукт — не финсовет. Торговля несёт риск убытков.',
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
        'Терминалы',
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
        'Партнёрские ссылки появятся здесь после настройки URL.',
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
          'Основная CEX: спот и фьючерсы после курса.',
          'CEX principal para spot e futuros após o curso.',
          'CEX principal para spot y futuros después del curso.',
        );
      case 'bybit':
        return _t(
          'Alternative exchange for futures and live practice.',
          'Альтернативная биржа для фьючерсов и live-практики.',
          'Exchange alternativa para futuros e prática ao vivo.',
          'Exchange alternativa para futuros y práctica en vivo.',
        );
      case 'bitso':
        return _t(
          'LATAM-friendly on-ramp (Mexico and region).',
          'Удобный вход для LATAM (Мексика и регион).',
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
          'Про-терминал через API — скорость исполнения, не стратегия.',
          'Terminal pro via API — velocidade de execução, não estratégia.',
          'Terminal pro vía API — velocidad de ejecución, no estrategia.',
        );
      case 'vataga':
        return _t(
          'Order-flow terminal for advanced practice.',
          'Терминал order flow для продвинутой практики.',
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

