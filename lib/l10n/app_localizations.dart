import '../services/locale_service.dart';

class AppLocalizations {
  final AppLanguage locale;

  AppLocalizations(this.locale);

  // ── Navigation ──
  String get navHome => _t('Home', 'Главная', 'Início');
  String get navLearn => _t('Learn', 'Обучение', 'Aprender');
  String get navQuiz => _t('Quiz', 'Тесты', 'Quiz');
  String get navPractice => _t('Practice', 'Практика', 'Prática');
  String get navProfile => _t('Profile', 'Профиль', 'Perfil');

  // ── Common ──
  String get appName => 'Trade Master';
  String get cancel => _t('Cancel', 'Отмена', 'Cancelar');
  String get continueBtn => _t('Continue', 'Продолжить', 'Continuar');
  String get reset => _t('Reset', 'Сбросить', 'Redefinir');
  String get all => _t('All', 'Все', 'Todos');
  String get error => _t('Error', 'Ошибка', 'Erro');
  String get done => _t('Done', 'Готово', 'Feito');
  String get newBadge => _t('New', 'Новое', 'Novo');
  String get min => _t('min', 'мин', 'min');
  String get days => _t('days', 'дн.', 'dias');
  String get dayShort => _t('d', 'д', 'd');

  // ── Home ──
  String get keepBuildingEdge => _t('Keep building your edge', 'Развивай своё преимущество', 'Continue construindo sua vantagem');
  String percentComplete(int p) => _t('$p% complete', '$p% пройдено', '$p% concluído');
  String lessonsCompleted(int done, int total) =>
      _t('$done of $total lessons completed', '$done из $total уроков пройдено', '$done de $total lições concluídas');
  String get streak => _t('Streak', 'Серия', 'Sequência');
  String get lessons => _t('Lessons', 'Уроки', 'Lições');
  String get continueLearning => _t('Continue learning', 'Продолжить обучение', 'Continuar aprendendo');
  String get interactiveTraining => _t('Interactive training', 'Интерактивное обучение', 'Treinamento interativo');
  String get dailyChallenge => _t('Daily Challenge', 'Ежедневный челлендж', 'Desafio Diário');
  String dailyChallengeDone(int score) =>
      _t('Completed today — $score/5 correct', 'Сегодня пройдено — $score/5 верно', 'Concluído hoje — $score/5 corretas');
  String get dailyChallengeNew => _t('5 questions · test yourself today', '5 вопросов · проверь себя', '5 perguntas · teste-se hoje');
  String get flashcards => _t('Flashcards', 'Карточки', 'Flashcards');
  String get flashcardsSubtitle => _t('Review key takeaways from lessons', 'Повтори ключевые выводы из уроков', 'Revise os pontos-chave das lições');
  String get paperTrading => _t('Paper Trading', 'Бумажная торговля', 'Trading Simulado');
  String get paperTradingSubtitle => _t('Practice buy & sell with virtual money', 'Тренируйся покупать и продавать', 'Pratique compra e venda com dinheiro virtual');
  String get explore => _t('Explore', 'Изучить', 'Explorar');
  String get marketConcepts => _t('Market concepts', 'Рыночные концепции', 'Conceitos de mercado');
  String get marketConceptsSubtitle => _t('Learn how markets work', 'Узнай, как работают рынки', 'Aprenda como os mercados funcionam');
  String get learningActivity => _t('Learning activity', 'Активность обучения', 'Atividade de aprendizado');
  String get weeklyMomentum => _t('Your weekly momentum', 'Твоя недельная динамика', 'Seu momentum semanal');
  String get yourTradingJourney => _t('Your trading journey', 'Твой торговый путь', 'Sua jornada de trading');
  String get learningFromScratch => _t('Learning from scratch', 'Обучение с нуля', 'Aprendendo do zero');
  String get demoTradingFocus => _t('Demo trading focus', 'Фокус на демо-торговлю', 'Foco em trading demo');
  String get knowledgeTesting => _t('Knowledge testing', 'Проверка знаний', 'Teste de conhecimento');
  String get buildingDiscipline => _t('Building discipline', 'Развитие дисциплины', 'Construindo disciplina');

  // ── Learning ──
  String get learningPath => _t('Learning path', 'Путь обучения', 'Trilha de aprendizado');
  String completedCount(int done, int total) =>
      _t('$done/$total completed', '$done/$total пройдено', '$done/$total concluído');
  String get searchLessons => _t('Search lessons...', 'Поиск уроков...', 'Buscar lições...');
  String get noLessonsFound => _t('No lessons found', 'Уроки не найдены', 'Nenhuma lição encontrada');
  String lessonNumber(int id) => _t('Lesson $id', 'Урок $id', 'Lição $id');

  // ── Lesson ──
  String get lessonNotFound => _t('Lesson not found', 'Урок не найден', 'Lição não encontrada');
  String get whatYouWillLearn => _t('What you will learn', 'Что вы изучите', 'O que você vai aprender');
  String get lessonContent => _t('Lesson content', 'Содержание урока', 'Conteúdo da lição');
  String get keyTakeaway => _t('Key takeaway', 'Главный вывод', 'Conclusão principal');
  String get markComplete => _t('Mark as complete', 'Отметить как пройденный', 'Marcar como concluída');
  String get nextLesson => _t('Next lesson', 'Следующий урок', 'Próxima lição');
  String get completeAndContinue => _t('Complete & continue', 'Завершить и продолжить', 'Concluir e continuar');
  String get reviewFlashcards => _t('Review flashcards', 'Повторить карточки', 'Revisar flashcards');
  String get lessonMarkedComplete => _t('Lesson marked as complete', 'Урок отмечен как пройденный', 'Lição marcada como concluída');
  String get sectionIntroduction => _t('Introduction', 'Введение', 'Introdução');
  String get sectionCoreConcept => _t('Core concept', 'Основная концепция', 'Conceito principal');
  String get sectionChartExample => _t('Chart example', 'Пример на графике', 'Exemplo no gráfico');
  String get sectionPracticalScenario => _t('Practical scenario', 'Практический сценарий', 'Cenário prático');
  String get sectionKeyPoints => _t('Key points to remember', 'Ключевые моменты', 'Pontos-chave para lembrar');
  String get sectionProTip => _t('Pro tip', 'Совет профи', 'Dica profissional');
  String get sectionExample => _t('Example', 'Пример', 'Exemplo');
  String get sectionTradingView => _t('TradingView setup', 'Разбор в TradingView', 'Setup no TradingView');
  String get sectionPractice => _t('Hands-on practice', 'Практика', 'Prática guiada');
  String get sectionJournal => _t('Trade journal', 'Запись в журнал', 'Diário de trades');
  String get openTradingView => _t('Open chart in TradingView', 'Открыть график в TradingView', 'Abrir gráfico no TradingView');
  String get tradingViewOpenError => _t('Could not open TradingView', 'Не удалось открыть TradingView', 'Não foi possível abrir o TradingView');
  String get marketBrazil => _t('Brazil · LATAM', 'Бразилия · LATAM', 'Brasil · LATAM');
  String get marketMexico => _t('Mexico · LATAM', 'Мексика · LATAM', 'México · LATAM');
  String get marketLatam => _t('LATAM focus', 'Фокус LATAM', 'Foco LATAM');
  String get marketRussia => _t('Russia · CIS', 'Россия · СНГ', 'Rússia · CEI');
  String get marketGlobal => _t('Global markets', 'Мировые рынки', 'Mercados globais');

  // ── Interactive lessons ──
  String get next => _t('Next', 'Далее', 'Próximo');
  String get back => _t('Back', 'Назад', 'Voltar');
  String stepOf(int current, int total) => _t('Step $current of $total', 'Шаг $current из $total', 'Passo $current de $total');
  String get tapToExplore => _t('Tap chart', 'Нажми', 'Toque');
  String get tapEachPoint => _t('Tap each card to reveal', 'Нажми на карточку', 'Toque em cada cartão');
  String get interactiveDemo => _t('Try it yourself', 'Попробуй сам', 'Experimente');
  String get zoneSupport => _t('Near SUPPORT — buyers active', 'У SUPPORT — покупатели', 'Perto do SUPORTE');
  String get zoneResistance => _t('Near RESISTANCE — sellers active', 'У RESISTANCE — продавцы', 'Perto da RESISTÊNCIA');
  String get zoneNeutral => _t('Mid-range — no clear edge', 'Середина — нет преимущества', 'Meio — sem vantagem');
  String get checkpointTitle => _t('Quick check', 'Проверка знаний', 'Verificação rápida');
  String checkpointProgress(int c, int t) => _t('Question $c of $t', 'Вопрос $c из $t', 'Pergunta $c de $t');
  String get checkpointQuestion1 => _t('Which statement is most accurate?', 'Какое утверждение вернее?', 'Qual afirmação é mais precisa?');
  String checkpointQuestion2(String title) => _t('Key takeaway from "$title"?', 'Главный вывод урока?', 'Conclusão principal?');
  String get checkpointComplete => _t('Passed! Complete lesson', 'Сдал! Завершить', 'Passou! Concluir');
  String get checkpointRetry => _t('Review and retry', 'Повтори урок', 'Revisar e tentar');
  String get lessonComplete => _t('Lesson complete!', 'Урок пройден!', 'Lição concluída!');
  String xpEarned(int xp) => _t('+$xp XP earned', '+$xp XP', '+$xp XP');
  String get startPractice => _t('Practice now', 'Попрактикуйся', 'Praticar agora');
  String get shareApp => _t('Invite friends', 'Пригласить друзей', 'Convidar amigos');
  String get shareMessage => _t(
        'Trade Master — real trading lessons, TradingView setups & practice. Not signals. Join me!',
        'Trade Master — практические уроки, разбор в TradingView, не сигналы. Присоединяйся!',
        'Trade Master — lições práticas, setups no TradingView, não sinais. Vem comigo!',
      );
  String get linkCopied => _t('Invite link copied!', 'Ссылка и код скопированы!', 'Link e código copiados!');
  String get journalTitle => _t('Trade journal', 'Журнал сделок', 'Diário de trades');
  String get journalNewEntry => _t('New entry', 'Новая запись', 'Nova entrada');
  String get journalEmpty => _t('No entries yet. Log your setups from lessons.', 'Пока пусто. Записывай сетапы из уроков.', 'Vazio. Registre setups das lições.');
  String get journalSave => _t('Save entry', 'Сохранить', 'Salvar');
  String get journalWriteEntry => _t('Write to journal', 'Записать в журнал', 'Escrever no diário');
  String get journalEntryPair => _t('Pair', 'Пара', 'Par');
  String get journalEntrySetup => _t('Setup', 'Сетап', 'Setup');
  String get journalEntryEntry => _t('Entry', 'Вход', 'Entrada');
  String get journalEntryStop => _t('Stop', 'Стоп', 'Stop');
  String get journalEntryTarget => _t('Target', 'Цель', 'Alvo');
  String get journalEntryEmotion => _t('Emotion', 'Эмоция', 'Emoção');
  String get journalEntryNotes => _t('Notes', 'Заметки', 'Notas');
  String get referralTitle => _t('Invite friends', 'Пригласить друзей', 'Convidar amigos');
  String get referralYourCode => _t('Your code', 'Ваш код', 'Seu código');
  String get referralEnterCode => _t('Enter friend\'s code', 'Ввести код друга', 'Código do amigo');
  String get referralRedeem => _t('Redeem', 'Активировать', 'Ativar');
  String referralInvites(int n) => _t('$n friends joined', '$n друзей присоединились', '$n amigos entraram');
  String get referralXpInfo => _t('+500 XP per friend · +100 XP when you join', '+500 XP за друга · +100 XP при вводе кода', '+500 XP por amigo · +100 XP ao entrar');
  String get referralErrorEmpty => _t('Enter a code', 'Введите код', 'Digite o código');
  String get referralErrorOwn => _t('That\'s your own code', 'Это ваш код', 'É o seu código');
  String get referralErrorAlready => _t('Code already used', 'Код уже использован', 'Código já usado');
  String get referralErrorInvalid => _t('Invalid code', 'Неверный код', 'Código inválido');
  String get referralSuccess => _t('Code applied! +100 XP', 'Код принят! +100 XP', 'Código aplicado! +100 XP');
  String practiceLessonSetup(int id) => _t('Practice lesson $id setup', 'Отработать сетап урока $id', 'Praticar setup lição $id');
  String lessonPracticeStarted(int id) => _t('Lesson $id practice started', 'Практика урока $id', 'Prática lição $id iniciada');
  String practiceLessonBanner(int id, String title) => _t('Lesson $id: $title', 'Урок $id: $title', 'Lição $id: $title');
  String lessonPracticeComplete(int id) => _t('Lesson $id practice done!', 'Практика урока $id завершена!', 'Lição $id prática concluída!');
  String get level => _t('Level', 'Уровень', 'Nível');
  String get xp => _t('XP', 'XP', 'XP');
  String levelProgress(int current, int needed) => _t('$current / $needed XP', '$current / $needed XP', '$current / $needed XP');
  String get practiceAfterLesson => _t('Apply in Paper Trading', 'Попробуй в симуляторе', 'Aplicar no simulador');
  String chartCaptionDefault(String pair) => _t(
    'Study how price behaves on $pair. Mark support, resistance, and where you would enter with a stop loss.',
    'Изучи поведение цены на $pair. Отметь поддержку, сопротивление и точку входа со стоп-лоссом.',
    'Estude o comportamento do preço em $pair. Marque suporte, resistência e entrada com stop loss.',
  );
  String get tradingViewStyleNote => _t(
    'TradingView-style chart · crypto market',
    'График в стиле TradingView · крипторынок',
    'Gráfico estilo TradingView · mercado cripto',
  );
  String scenarioOnChart(String pair) => _t(
    '$pair — real scenario on chart',
    '$pair — сценарий на графике',
    '$pair — cenário no gráfico',
  );
  String get readThenStudyChart => _t(
    'Read the theory, then study the chart below',
    'Прочитай теорию, затем изучи график ниже',
    'Leia a teoria, depois estude o gráfico abaixo',
  );
  String get chartConceptMarketBalance => _t(
    'Buyers vs sellers — how price moves',
    'Покупатели vs продавцы — как движется цена',
    'Compradores vs vendedores — como o preço se move',
  );
  String get chartConceptOrderBook => _t(
    'Order book — bids and asks',
    'Стакан — заявки на покупку и продажу',
    'Livro de ordens — bids e asks',
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
  );
  String get chartExplainCaption => _t(
    'Read the explanation below the diagram — it connects directly to this lesson.',
    'Прочитай пояснение под схемой — оно связано с темой урока.',
    'Leia a explicação abaixo do diagrama — ela se conecta à lição.',
  );
  String get interactive => _t('Interactive', 'Интерактив', 'Interativo');

  // ── Flashcards ──
  String get flashcardSessionComplete => _t('Flashcard session complete!', 'Сессия карточек завершена!', 'Sessão de flashcards concluída!');
  String get noLessonsAvailable => _t('No lessons available', 'Нет доступных уроков', 'Nenhuma lição disponível');
  String get tapToReveal => _t('Tap to reveal answer', 'Нажми, чтобы увидеть ответ', 'Toque para revelar a resposta');
  String get knewIt => _t('Knew it', 'Знал', 'Sabia');
  String get studyMore => _t('Study more', 'Нужно повторить', 'Preciso estudar');
  String cardProgress(int current, int total) =>
      _t('Card $current of $total', 'Карточка $current из $total', 'Cartão $current de $total');

  // ── Quiz ──
  String get quizArena => _t('Quiz Arena', 'Арена тестов', 'Arena de Quiz');
  String get category => _t('Category', 'Категория', 'Categoria');
  String get difficulty => _t('Difficulty', 'Сложность', 'Dificuldade');
  String get quickDrill => _t('Quick 5-question drill', 'Быстрый тест из 5 вопросов', 'Teste rápido de 5 perguntas');
  String get backToQuizArena => _t('Back to Quiz Arena', 'В арену тестов', 'Voltar à Arena');
  String get goHome => _t('Go home', 'На главную', 'Ir para início');
  String get reviewLessons => _t('Review lessons', 'Повторить уроки', 'Revisar lições');
  String get nextQuestion => _t('Next question', 'Следующий вопрос', 'Próxima pergunta');
  String get seeResults => _t('See results', 'Результаты', 'Ver resultados');
  String get questionOf => _t('Question', 'Вопрос', 'Pergunta');
  String scoreResult(int score, int total) =>
      _t('You scored $score out of $total', 'Вы набрали $score из $total', 'Você marcou $score de $total');
  String get greatJob => _t('Great job! Keep it up.', 'Отлично! Так держать.', 'Ótimo trabalho! Continue assim.');
  String get keepPracticing => _t('Keep practicing — review the lessons.', 'Продолжай практику — повтори уроки.', 'Continue praticando — revise as lições.');

  // ── Daily challenge ──
  String get startTodayChallenge => _t('Start today\'s challenge', 'Начать сегодняшний челлендж', 'Iniciar desafio de hoje');
  String get practiceMoreQuiz => _t('Practice more in Quiz Arena', 'Больше практики в арене тестов', 'Pratique mais na Arena de Quiz');
  String get backToHome => _t('Back to home', 'На главную', 'Voltar ao início');
  String get alreadyCompletedToday => _t('Already completed today!', 'Уже пройдено сегодня!', 'Já concluído hoje!');
  String get dailyChallengeDesc =>
      _t('5 random questions from across all topics. One attempt per day.', '5 случайных вопросов по всем темам. Одна попытка в день.', '5 perguntas aleatórias de todos os tópicos. Uma tentativa por dia.');

  // ── Trading ──
  String get portfolioEquity => _t('Portfolio equity', 'Капитал портфеля', 'Patrimônio do portfólio');
  String get buy => _t('BUY', 'КУПИТЬ', 'COMPRAR');
  String get sell => _t('SELL', 'ПРОДАТЬ', 'VENDER');
  String get close => _t('Close', 'Закрыть', 'Fechar');
  String get howItWorks => _t('How it works', 'Как это работает', 'Como funciona');
  String get tradingHowItWorks => _t(
        'This is a demo simulator. Buy low, sell high, and track your virtual balance. No real money is involved.',
        'Это демо-симулятор. Покупай дёшево, продавай дорого и следи за виртуальным балансом. Реальные деньги не используются.',
        'Este é um simulador demo. Compre barato, venda caro e acompanhe seu saldo virtual. Nenhum dinheiro real está envolvido.',
      );
  String get positionOpened => _t('Position opened', 'Позиция открыта', 'Posição aberta');
  String get positionClosed => _t('Position closed', 'Позиция закрыта', 'Posição fechada');
  String get noOpenPosition => _t('No open position', 'Нет открытых позиций', 'Nenhuma posição aberta');

  // ── Profile ──
  String get profile => _t('Profile', 'Профиль', 'Perfil');
  String get trader => _t('Trader', 'Трейдер', 'Trader');
  String get premiumMember => _t('Premium member', 'Premium участник', 'Membro Premium');
  String get cards => _t('Cards', 'Карточки', 'Cartões');
  String get recentQuizResults => _t('Recent quiz results', 'Последние результаты тестов', 'Resultados recentes de quiz');
  String get noQuizzesYet => _t('No quizzes yet. Head to Quiz Arena!', 'Тестов пока нет. Перейди в арену!', 'Nenhum quiz ainda. Vá para a Arena!');
  String get upgradePremium => _t('Upgrade to Premium', 'Перейти на Premium', 'Upgrade para Premium');
  String get replayOnboarding => _t('Replay onboarding', 'Пройти онбординг заново', 'Refazer onboarding');
  String get resetAllProgress => _t('Reset all progress', 'Сбросить весь прогресс', 'Redefinir todo o progresso');
  String get resetProgressTitle => _t('Reset all progress?', 'Сбросить весь прогресс?', 'Redefinir todo o progresso?');
  String get resetProgressBody => _t(
        'This will clear lessons, quizzes, trading balance, and streaks.',
        'Это удалит прогресс уроков, тестов, баланс торговли и серии.',
        'Isso apagará lições, quizzes, saldo de trading e sequências.',
      );
  String get progressReset => _t('Progress reset', 'Прогресс сброшен', 'Progresso redefinido');
  String get appDisclaimer => _t(
        'Trade Master v1.0.0\nEducational app — not financial advice.',
        'Trade Master v1.0.0\nОбразовательное приложение — не финансовый совет.',
        'Trade Master v1.0.0\nApp educacional — não é aconselhamento financeiro.',
      );
  String get language => _t('Language', 'Язык', 'Idioma');
  String get selectLanguage => _t('Select language', 'Выберите язык', 'Selecionar idioma');

  // ── Goals ──
  String get yourGoal => _t('Your goal', 'Ваша цель', 'Seu objetivo');
  String get goalQuestion => _t('What brings you to Trade Master?', 'Зачем вы здесь?', 'O que te traz ao Trade Master?');
  String get goalSubtitle => _t('We\'ll personalize your experience', 'Мы настроим приложение под вас', 'Personalizaremos sua experiência');
  String get goalLearnTrading => _t('Learn trading from scratch', 'Изучить трейдинг с нуля', 'Aprender trading do zero');
  String get goalLearnTradingSub => _t('Start with basics and build a solid foundation', 'Начните с основ и постройте фундамент', 'Comece com o básico e construa uma base sólida');
  String get goalDemoPractice => _t('Practice with demo trading', 'Практика на демо-счёте', 'Praticar com trading demo');
  String get goalDemoPracticeSub => _t('Train in a risk-free simulator', 'Тренируйтесь без риска', 'Treine em um simulador sem risco');
  String get goalTestKnowledge => _t('Test my knowledge', 'Проверить знания', 'Testar meu conhecimento');
  String get goalTestKnowledgeSub => _t('Quizzes, flashcards, and daily challenges', 'Тесты, карточки и ежедневные челленджи', 'Quizzes, flashcards e desafios diários');
  String get goalBuildDiscipline => _t('Build trading discipline', 'Развить дисциплину', 'Construir disciplina de trading');
  String get goalBuildDisciplineSub => _t('Streaks, routines, and structured learning', 'Серии, рутины и структурированное обучение', 'Sequências, rotinas e aprendizado estruturado');
  String goalLabel(String? goal) {
    switch (goal) {
      case 'learn_trading':
        return _t('Goal: Learn trading', 'Цель: Изучить трейдинг', 'Meta: Aprender trading');
      case 'practice_demo':
        return _t('Goal: Demo practice', 'Цель: Демо-практика', 'Meta: Prática demo');
      case 'pass_quiz':
        return _t('Goal: Test knowledge', 'Цель: Проверить знания', 'Meta: Testar conhecimento');
      case 'build_discipline':
        return _t('Goal: Build discipline', 'Цель: Развить дисциплину', 'Meta: Construir disciplina');
      default:
        return _t('Trading learner', 'Учащийся трейдер', 'Aprendiz de trading');
    }
  }

  // ── Onboarding ──
  String get welcomeTitle => _t('Welcome to Trade Master', 'Добро пожаловать в Trade Master', 'Bem-vindo ao Trade Master');
  String get welcomeSubtitle => _t(
        'Your complete trading education platform — lessons, quizzes, flashcards, and paper trading.',
        'Полная платформа для обучения трейдингу — уроки, тесты, карточки и бумажная торговля.',
        'Sua plataforma completa de educação em trading — lições, quizzes, flashcards e trading simulado.',
      );
  String get getStarted => _t('Get started', 'Начать', 'Começar');

  // ── Premium ──
  String get premium => _t('Premium', 'Premium', 'Premium');
  String get premiumActivated => _t('Premium activated! (Demo mode)', 'Premium активирован! (Демо)', 'Premium ativado! (Modo demo)');
  String get youHavePremium => _t('You have Premium access', 'У вас есть Premium доступ', 'Você tem acesso Premium');
  String get premiumTitle => _t('Unlock your full potential', 'Раскрой полный потенциал', 'Desbloqueie todo o potencial');
  String get premiumSubtitle => _t(
        'Get unlimited access to all lessons, advanced quizzes, and exclusive content.',
        'Полный доступ ко всем урокам, продвинутым тестам и эксклюзивному контенту.',
        'Acesso ilimitado a todas as lições, quizzes avançados e conteúdo exclusivo.',
      );
  String get activatePremium => _t('Activate Premium (Demo)', 'Активировать Premium (Демо)', 'Ativar Premium (Demo)');

  // ── Market concepts ──
  String get marketConceptsTitle => _t('Market Concepts', 'Рыночные концепции', 'Conceitos de Mercado');
  String get marketConceptsIntro => _t(
        'Essential concepts every trader should understand before risking capital.',
        'Ключевые концепции, которые должен понимать каждый трейдер.',
        'Conceitos essenciais que todo trader deve entender antes de arriscar capital.',
      );

  // ── Modules ──
  String moduleName(String module) {
    switch (module) {
      case 'Basics':
        return _t('Basics', 'Основы', 'Fundamentos');
      case 'Price Action':
        return _t('Price Action', 'Price Action', 'Price Action');
      case 'Risk':
        return _t('Risk', 'Риск', 'Risco');
      case 'Psychology':
        return _t('Psychology', 'Психология', 'Psicologia');
      case 'Strategy':
        return _t('Strategy', 'Стратегия', 'Estratégia');
      case 'Execution':
        return _t('Execution', 'Исполнение', 'Execução');
      case 'Review':
        return _t('Review', 'Разбор', 'Revisão');
      case 'Advanced':
        return _t('Advanced', 'Продвинутый', 'Avançado');
      default:
        return module;
    }
  }

  String difficultyName(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return _t('Beginner', 'Начальный', 'Iniciante');
      case 'Intermediate':
        return _t('Intermediate', 'Средний', 'Intermediário');
      case 'Advanced':
        return _t('Advanced', 'Продвинутый', 'Avançado');
      case 'Easy':
        return _t('Easy', 'Лёгкий', 'Fácil');
      case 'Medium':
        return _t('Medium', 'Средний', 'Médio');
      case 'Hard':
        return _t('Hard', 'Сложный', 'Difícil');
      default:
        return difficulty;
    }
  }

  String categoryName(String category) {
    switch (category) {
      case 'All':
        return all;
      case 'Basics':
        return _t('Basics', 'Основы', 'Fundamentos');
      case 'Risk':
        return _t('Risk', 'Риск', 'Risco');
      case 'Psychology':
        return _t('Psychology', 'Психология', 'Psicologia');
      case 'Charts':
        return _t('Charts', 'Графики', 'Gráficos');
      case 'Habits':
        return _t('Habits', 'Привычки', 'Hábitos');
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

  String _t(String en, String ru, String pt) {
    switch (locale) {
      case AppLanguage.ru:
        return ru;
      case AppLanguage.pt:
        return pt;
      case AppLanguage.en:
        return en;
    }
  }
}
