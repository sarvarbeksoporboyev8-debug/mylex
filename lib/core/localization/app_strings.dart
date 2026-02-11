import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_language.dart';

/// Localized strings for the app
class AppStrings {
  final AppLanguage language;

  AppStrings(this.language);

  String get code => language.code;

  String _get(Map<String, String> translations) {
    return translations[language.code] ?? translations['uz-Cyrl'] ?? '';
  }

  List<String> _getList(Map<String, List<String>> translations) {
    return translations[language.code] ?? translations['uz-Cyrl'] ?? [];
  }

  // Navigation
  String get navConstitution => _get({
    'uz': 'Konstitutsiya',
    'uz-Cyrl': 'Конституция',
    'ru': 'Конституция',
    'en': 'Constitution',
  });

  String get navCodes => _get({
    'uz': 'Kodekslar',
    'uz-Cyrl': 'Кодекслар',
    'ru': 'Кодексы',
    'en': 'Codes',
  });

  String get navAiAssistant => _get({
    'uz': 'AI Yordamchi',
    'uz-Cyrl': 'AI Ёрдамчи',
    'ru': 'AI Помощник',
    'en': 'AI Assistant',
  });

  String get navLaws => _get({
    'uz': 'Qonunlar',
    'uz-Cyrl': 'Қонунлар',
    'ru': 'Законы',
    'en': 'Laws',
  });

  String get navNews => _get({
    'uz': 'Yangiliklar',
    'uz-Cyrl': 'Янгиликлар',
    'ru': 'Новости',
    'en': 'News',
  });

  // Auth
  String get login => _get({
    'uz': 'Kirish',
    'uz-Cyrl': 'Кириш',
    'ru': 'Вход',
    'en': 'Login',
  });

  String get signup => _get({
    'uz': "Ro'yxatdan o'tish",
    'uz-Cyrl': 'Рўйхатдан ўтиш',
    'ru': 'Регистрация',
    'en': 'Sign Up',
  });

  String get loginToAccount => _get({
    'uz': 'Hisobingizga kiring',
    'uz-Cyrl': 'Ҳисобингизга киринг',
    'ru': 'Войдите в аккаунт',
    'en': 'Login to your account',
  });

  String get createNewAccount => _get({
    'uz': 'Yangi hisob yarating',
    'uz-Cyrl': 'Янги ҳисоб яратинг',
    'ru': 'Создайте новый аккаунт',
    'en': 'Create new account',
  });

  String get joinUsFillDetails => _get({
    'uz': 'Bizga qo\'shiling! Hisob yaratish uchun ma\'lumotlaringizni kiriting!',
    'uz-Cyrl': 'Бизга қўшилинг! Ҳисоб яратиш учун маълумотларингизни киритинг!',
    'ru': 'Присоединяйтесь к нам! Заполните свои данные для создания аккаунта!',
    'en': 'Join us! Fill in your details to create an account!',
  });

  String get phoneNumber => _get({
    'uz': 'Telefon raqami',
    'uz-Cyrl': 'Телефон рақами',
    'ru': 'Номер телефона',
    'en': 'Phone number',
  });

  String get password => _get({
    'uz': 'Parol',
    'uz-Cyrl': 'Парол',
    'ru': 'Пароль',
    'en': 'Password',
  });

  String get enterPassword => _get({
    'uz': 'Parolni kiriting',
    'uz-Cyrl': 'Паролни киритинг',
    'ru': 'Введите пароль',
    'en': 'Enter password',
  });

  String get forgotPassword => _get({
    'uz': 'Parolni unutdingizmi?',
    'uz-Cyrl': 'Паролни унутдингизми?',
    'ru': 'Забыли пароль?',
    'en': 'Forgot Password?',
  });

  String get continueLabel => _get({
    'uz': 'Davom etish',
    'uz-Cyrl': 'Давом этиш',
    'ru': 'Продолжить',
    'en': 'Continue',
  });

  String get orLabel => _get({
    'uz': 'Yoki',
    'uz-Cyrl': 'Ёки',
    'ru': 'Или',
    'en': 'Or',
  });

  String get enterEmail => _get({
    'uz': 'Email manzilingizni kiriting',
    'uz-Cyrl': 'Email манзилингизни киритинг',
    'ru': 'Введите ваш email',
    'en': 'Enter your email address',
  });

  String get enterPhoneNumber => _get({
    'uz': 'Telefon raqamingizni kiriting',
    'uz-Cyrl': 'Телефон рақамингизни киритинг',
    'ru': 'Введите номер телефона',
    'en': 'Enter your phone number',
  });

  String get yourName => _get({
    'uz': 'Ismingiz',
    'uz-Cyrl': 'Исмингиз',
    'ru': 'Ваше имя',
    'en': 'Your name',
  });

  String get enterName => _get({
    'uz': 'Ismingizni kiriting',
    'uz-Cyrl': 'Исмингизни киритинг',
    'ru': 'Введите имя',
    'en': 'Enter your name',
  });

  String get createPassword => _get({
    'uz': 'Parol yarating',
    'uz-Cyrl': 'Парол яратинг',
    'ru': 'Создайте пароль',
    'en': 'Create password',
  });

  String get confirmPassword => _get({
    'uz': 'Parolni tasdiqlang',
    'uz-Cyrl': 'Паролни тасдиқланг',
    'ru': 'Подтвердите пароль',
    'en': 'Confirm password',
  });

  String get reenterPassword => _get({
    'uz': 'Parolni qayta kiriting',
    'uz-Cyrl': 'Паролни қайта киритинг',
    'ru': 'Повторите пароль',
    'en': 'Re-enter password',
  });

  String get changePassword => _get({
    'uz': 'Parolni o\'zgartirish',
    'uz-Cyrl': 'Паролни ўзгартириш',
    'ru': 'Изменить пароль',
    'en': 'Change Password',
  });

  String get rememberMe => _get({
    'uz': 'Eslab qolish',
    'uz-Cyrl': 'Эслаб қолиш',
    'ru': 'Запомнить',
    'en': 'Remember me',
  });

  String get noAccount => _get({
    'uz': "Hisobingiz yo'qmi?",
    'uz-Cyrl': 'Ҳисобингиз йўқми?',
    'ru': 'Нет аккаунта?',
    'en': "Don't have an account?",
  });

  String get haveAccount => _get({
    'uz': 'Hisobingiz bormi?',
    'uz-Cyrl': 'Ҳисобингиз борми?',
    'ru': 'Есть аккаунт?',
    'en': 'Already have an account?',
  });

  // PIN
  String get createPin => _get({
    'uz': 'PIN kod yarating',
    'uz-Cyrl': 'PIN код яратинг',
    'ru': 'Создайте PIN-код',
    'en': 'Create PIN',
  });

  String get enterPinDigits => _get({
    'uz': '4 raqamli PIN kod kiriting',
    'uz-Cyrl': '4 рақамли PIN код киритинг',
    'ru': 'Введите 4-значный PIN-код',
    'en': 'Enter 4-digit PIN',
  });

  String get confirmPin => _get({
    'uz': 'PIN kodni tasdiqlang',
    'uz-Cyrl': 'PIN кодни тасдиқланг',
    'ru': 'Подтвердите PIN-код',
    'en': 'Confirm PIN',
  });

  String get reenterPin => _get({
    'uz': 'PIN kodni qayta kiriting',
    'uz-Cyrl': 'PIN кодни қайта киритинг',
    'ru': 'Повторите PIN-код',
    'en': 'Re-enter PIN',
  });

  String get enterPin => _get({
    'uz': 'PIN kodni kiriting',
    'uz-Cyrl': 'PIN кодни киритинг',
    'ru': 'Введите PIN-код',
    'en': 'Enter PIN',
  });

  String get pinMismatch => _get({
    'uz': "PIN kodlar mos kelmadi",
    'uz-Cyrl': 'PIN кодлар мос келмади',
    'ru': 'PIN-коды не совпадают',
    'en': 'PINs do not match',
  });

  String get wrongPin => _get({
    'uz': "Noto'g'ri PIN kod",
    'uz-Cyrl': 'Нотўғри PIN код',
    'en': 'Wrong PIN',
    'ru': 'Неверный PIN-код',
  });

  String get forgotPin => _get({
    'uz': 'PIN kodni unutdingizmi?',
    'uz-Cyrl': 'PIN кодни унутдингизми?',
    'ru': 'Забыли PIN-код?',
    'en': 'Forgot PIN?',
  });

  String get tooManyAttempts => _get({
    'uz': "Ko'p urinish. Qayta kiring.",
    'uz-Cyrl': 'Жуда кўп уриниш. Қайта киринг.',
    'ru': 'Слишком много попыток. Войдите снова.',
    'en': 'Too many attempts. Please login again.',
  });

  // Settings
  String get settings => _get({
    'uz': 'Sozlamalar',
    'uz-Cyrl': 'Созламалар',
    'ru': 'Настройки',
    'en': 'Settings',
  });

  String get languageLabel => _get({
    'uz': 'Til',
    'uz-Cyrl': 'Тил',
    'ru': 'Язык',
    'en': 'Language',
  });

  String get selectLanguage => _get({
    'uz': 'Tilni tanlang',
    'uz-Cyrl': 'Тилни танланг',
    'ru': 'Выберите язык',
    'en': 'Select language',
  });

  String get about => _get({
    'uz': "Dastur haqida",
    'uz-Cyrl': 'Дастур ҳақида',
    'ru': 'О приложении',
    'en': 'About',
  });

  String get version => _get({
    'uz': 'Versiya',
    'uz-Cyrl': 'Версия',
    'ru': 'Версия',
    'en': 'Version',
  });

  String get general => _get({
    'uz': 'Umumiy',
    'uz-Cyrl': 'Умумий',
    'ru': 'Общие',
    'en': 'General',
  });

  String get notifications => _get({
    'uz': 'Bildirishnomalar',
    'uz-Cyrl': 'Билдиришномалар',
    'ru': 'Уведомления',
    'en': 'Notifications',
  });

  String get clearCache => _get({
    'uz': 'Keshni tozalash',
    'uz-Cyrl': 'Кешни тозалаш',
    'ru': 'Очистить кэш',
    'en': 'Clear cache',
  });

  String get clearCacheConfirm => _get({
    'uz': 'Barcha saqlangan ma\'lumotlar o\'chiriladi. Davom etasizmi?',
    'uz-Cyrl': 'Барча сақланган маълумотлар ўчирилади. Давом этасизми?',
    'ru': 'Все сохраненные данные будут удалены. Продолжить?',
    'en': 'All saved data will be deleted. Continue?',
  });

  String get cacheCleared => _get({
    'uz': 'Kesh tozalandi',
    'uz-Cyrl': 'Кеш тозаланди',
    'ru': 'Кэш очищен',
    'en': 'Cache cleared',
  });

  String get wallet => _get({
    'uz': 'Hamyon',
    'uz-Cyrl': 'Ҳамён',
    'ru': 'Кошелек',
    'en': 'Wallet',
  });

  String get currentBalance => _get({
    'uz': 'Joriy balans',
    'uz-Cyrl': 'Жорий баланс',
    'ru': 'Текущий баланс',
    'en': 'Current balance',
  });

  String get topUpWallet => _get({
    'uz': 'Balansni to\'ldirish',
    'uz-Cyrl': 'Балансни тўлдириш',
    'ru': 'Пополнить баланс',
    'en': 'Top up wallet',
  });

  String get support => _get({
    'uz': 'Yordam',
    'uz-Cyrl': 'Ёрдам',
    'ru': 'Поддержка',
    'en': 'Support',
  });

  // Settings - Security
  String get security => _get({
    'uz': 'Xavfsizlik',
    'uz-Cyrl': 'Хавфсизлик',
    'ru': 'Безопасность',
    'en': 'Security',
  });

  String get twoFactorAuthentication => _get({
    'uz': '2-bosqichli autentifikatsiya',
    'uz-Cyrl': '2-боскичли аутентификация',
    'ru': 'Двухфакторная аутентификация',
    'en': '2-Factor Authentication',
  });

  String get resetPassword => _get({
    'uz': 'Parolni tiklash',
    'uz-Cyrl': 'Паролни тиклаш',
    'ru': 'Сброс пароля',
    'en': 'Reset Password',
  });

  String get useFaceIdToLogin => _get({
    'uz': 'Kirish uchun Face ID dan foydalanish',
    'uz-Cyrl': 'Кириш учун Face ID дан фойдаланиш',
    'ru': 'Использовать Face ID для входа',
    'en': 'Use Face ID to login',
  });

  String get appLock => _get({
    'uz': 'Ilovani qulflash',
    'uz-Cyrl': 'Иловани қуллаш',
    'ru': 'Блокировка приложения',
    'en': 'App Lock',
  });

  String get changeEmail => _get({
    'uz': 'Emailni o\'zgartirish',
    'uz-Cyrl': 'Emailни ўзгартириш',
    'ru': 'Изменить email',
    'en': 'Change Email',
  });

  // Settings - Profile
  String get editProfile => _get({
    'uz': 'Profilni tahrirlash',
    'uz-Cyrl': 'Профилни таҳрирлаш',
    'ru': 'Редактировать профиль',
    'en': 'Edit Profile',
  });

  String get edit => _get({
    'uz': 'Tahrirlash',
    'uz-Cyrl': 'Таҳрирлаш',
    'ru': 'Редактировать',
    'en': 'Edit',
  });

  String get fullName => _get({
    'uz': 'To\'liq ism',
    'uz-Cyrl': 'Тўлиқ исм',
    'ru': 'Полное имя',
    'en': 'Full name',
  });

  String get gender => _get({
    'uz': 'Jins',
    'uz-Cyrl': 'Жинс',
    'ru': 'Пол',
    'en': 'Gender',
  });

  String get male => _get({
    'uz': 'Erkak',
    'uz-Cyrl': 'Эркак',
    'ru': 'Мужской',
    'en': 'Male',
  });

  String get female => _get({
    'uz': 'Ayol',
    'uz-Cyrl': 'Аёл',
    'ru': 'Женский',
    'en': 'Female',
  });

  String get email => _get({
    'uz': 'Email',
    'uz-Cyrl': 'Email',
    'ru': 'Email',
    'en': 'Email',
  });

  String get phone => _get({
    'uz': 'Telefon',
    'uz-Cyrl': 'Телефон',
    'ru': 'Телефон',
    'en': 'Phone',
  });

  String get saveChanges => _get({
    'uz': 'O\'zgarishlarni saqlash',
    'uz-Cyrl': 'Ўзгаришларни сақлаш',
    'ru': 'Сохранить изменения',
    'en': 'Save Changes',
  });

  // Settings - Bank Account
  String get addBankAccount => _get({
    'uz': 'Bank hisobini qo\'shish',
    'uz-Cyrl': 'Банк ҳисобини қўшиш',
    'ru': 'Добавить банковский счет',
    'en': 'Add Bank Account',
  });

  String get bankName => _get({
    'uz': 'Bank nomi',
    'uz-Cyrl': 'Банк номи',
    'ru': 'Название банка',
    'en': 'Bank Name',
  });

  String get accountName => _get({
    'uz': 'Hisob nomi',
    'uz-Cyrl': 'Ҳисоб номи',
    'ru': 'Название счета',
    'en': 'Account Name',
  });

  String get accountNumber => _get({
    'uz': 'Hisob raqami',
    'uz-Cyrl': 'Ҳисоб рақами',
    'ru': 'Номер счета',
    'en': 'Account Number',
  });

  String get setAsPrimaryAccount => _get({
    'uz': 'Asosiy hisob sifatida belgilash',
    'uz-Cyrl': 'Асосий ҳисоб сифатида белгилаш',
    'ru': 'Установить как основной счет',
    'en': 'Set as primary account',
  });

  String get complete => _get({
    'uz': 'Faol',
    'uz-Cyrl': 'Фаол',
    'ru': 'Активен',
    'en': 'Complete',
  });

  String get personalInformation => _get({
    'uz': 'Shaxsiy ma\'lumotlar',
    'uz-Cyrl': 'Шахсий маълумотлар',
    'ru': 'Личная информация',
    'en': 'Personal Information',
  });

  String get linkedBankAccounts => _get({
    'uz': 'Ulangan bank hisoblari',
    'uz-Cyrl': 'Уланган банк ҳисоблари',
    'ru': 'Привязанные банковские счета',
    'en': 'Linked Bank Accounts',
  });

  // Settings - Legal
  String get faq => _get({
    'uz': 'Savol-javob',
    'uz-Cyrl': 'Савол-жавоб',
    'ru': 'Часто задаваемые вопросы',
    'en': 'FAQ',
  });

  String get gotQuestions => _get({
    'uz': 'Savollaringiz bormi?',
    'uz-Cyrl': 'Саволларингиз борми?',
    'ru': 'Есть вопросы?',
    'en': 'Got Questions?',
  });

  String get weveGotAnswers => _get({
    'uz': "Bizda javoblar bor",
    'uz-Cyrl': 'Бизда жавоблар бор',
    'ru': 'У нас есть ответы',
    'en': "We've Got Answers",
  });

  String get termsAndConditions => _get({
    'uz': 'Shartlar va qoidalar',
    'uz-Cyrl': 'Шартлар ва қоидалар',
    'ru': 'Условия и положения',
    'en': 'Terms & Conditions',
  });

  String get helpAndLegal => _get({
    'uz': 'Yordam va huquqiy',
    'uz-Cyrl': 'Ёрдам ва ҳуқуқий',
    'ru': 'Помощь и правовая информация',
    'en': 'Help & Legal',
  });

  String get appSettings => _get({
    'uz': 'Ilova sozlamalari',
    'uz-Cyrl': 'Илова созламалари',
    'ru': 'Настройки приложения',
    'en': 'App Settings',
  });

  String get logout => _get({
    'uz': 'Chiqish',
    'uz-Cyrl': 'Чиқиш',
    'ru': 'Выйти',
    'en': 'Logout',
  });

  // Shared legal text
  String get byContinuingAgree => _get({
    'uz': 'Davom etish orqali siz quyidagilarga rozisiz:',
    'uz-Cyrl': 'Давом этиш орқали сиз қуйидагиларга розисиз:',
    'ru': 'Продолжая, вы соглашаетесь с нашими',
    'en': 'By continuing, you agree to our',
  });

  String get termsAndPrivacyPolicy => _get({
    'uz': 'Shartlar va Maxfiylik siyosati',
    'uz-Cyrl': 'Шартлар ва Махфийлик сиёсати',
    'ru': 'Условия и Политику конфиденциальности',
    'en': 'Terms & Privacy Policy',
  });

  String get agreeTermsAndPrivacy => _get({
    'uz': 'Men shartlar va maxfiylik siyosatiga roziman',
    'uz-Cyrl': 'Мен шартлар ва махфийлик сиёсатига розиман',
    'ru': 'Я согласен с условиями и политикой конфиденциальности',
    'en': 'I agree to the terms & Privacy Policy',
  });

  String get byAddingBankAccountAgree => _get({
    'uz': 'Bank hisobingizni qo\'shish orqali siz hisobni bog\'lash bo\'yicha shartlarimizga rozisiz.',
    'uz-Cyrl': 'Банк ҳисобингизни қўшиш орқали сиз ҳисобни боғлаш бўйича шартларимизга розисиз.',
    'ru': 'Добавляя банковский счет, вы соглашаетесь с нашими условиями относительно привязки счета.',
    'en': 'By adding your bank account, you agree to our terms and conditions regarding account linking.',
  });

  // Notifications
  String get notification => _get({
    'uz': 'Bildirishnoma',
    'uz-Cyrl': 'Билдиришнома',
    'ru': 'Уведомление',
    'en': 'Notification',
  });

  String get all => _get({
    'uz': 'Barchasi',
    'uz-Cyrl': 'Барчаси',
    'ru': 'Все',
    'en': 'All',
  });

  String get payment => _get({
    'uz': 'To\'lov',
    'uz-Cyrl': 'Тўлов',
    'ru': 'Платеж',
    'en': 'Payment',
  });

  String get updates => _get({
    'uz': 'Yangilanishlar',
    'uz-Cyrl': 'Янгиланишлар',
    'ru': 'Обновления',
    'en': 'Updates',
  });

  String get rateApp => _get({
    'uz': 'Ilovani baholash',
    'uz-Cyrl': 'Иловани баҳолаш',
    'ru': 'Оценить приложение',
    'en': 'Rate app',
  });

  String get shareApp => _get({
    'uz': 'Ilovani ulashish',
    'uz-Cyrl': 'Иловани улашиш',
    'ru': 'Поделиться приложением',
    'en': 'Share app',
  });

  String get shareAppText => _get({
    'uz': 'Lex.uz AI - O\'zbekiston qonunchiligi bo\'yicha sun\'iy intellekt yordamchisi',
    'uz-Cyrl': 'Lex.uz AI - Ўзбекистон қонунчилиги бўйича сунъий интеллект ёрдамчиси',
    'ru': 'Lex.uz AI - ИИ помощник по законодательству Узбекистана',
    'en': 'Lex.uz AI - AI assistant for Uzbekistan legislation',
  });

  String get contactUs => _get({
    'uz': 'Bog\'lanish',
    'uz-Cyrl': 'Боғланиш',
    'ru': 'Связаться с нами',
    'en': 'Contact us',
  });

  String get telegramChannel => _get({
    'uz': 'Telegram kanal',
    'uz-Cyrl': 'Телеграм канал',
    'ru': 'Telegram канал',
    'en': 'Telegram channel',
  });

  String get legal => _get({
    'uz': 'Huquqiy',
    'uz-Cyrl': 'Ҳуқуқий',
    'ru': 'Правовая информация',
    'en': 'Legal',
  });

  String get termsOfService => _get({
    'uz': 'Foydalanish shartlari',
    'uz-Cyrl': 'Фойдаланиш шартлари',
    'ru': 'Условия использования',
    'en': 'Terms of Service',
  });

  String get privacyPolicy => _get({
    'uz': 'Maxfiylik siyosati',
    'uz-Cyrl': 'Махфийлик сиёсати',
    'ru': 'Политика конфиденциальности',
    'en': 'Privacy Policy',
  });

  String get premiumLegalAssistant => _get({
    'uz': 'O\'zbekiston qonunchiligi bo\'yicha AI yordamchi',
    'uz-Cyrl': 'Ўзбекистон қонунчилиги бўйича AI ёрдамчи',
    'ru': 'ИИ помощник по законодательству Узбекистана',
    'en': 'AI assistant for Uzbekistan legislation',
  });

  // Search
  String get search => _get({
    'uz': 'Qidirish',
    'uz-Cyrl': 'Қидириш',
    'ru': 'Поиск',
    'en': 'Search',
  });

  String get documentNumber => _get({
    'uz': 'Hujjat raqami',
    'uz-Cyrl': 'Ҳужжат рақами',
    'ru': 'Номер документа',
    'en': 'Document number',
  });

  String get documentName => _get({
    'uz': 'Hujjat nomi',
    'uz-Cyrl': 'Ҳужжат номи',
    'ru': 'Название документа',
    'en': 'Document name',
  });

  String get documentType => _get({
    'uz': 'Hujjat turi',
    'uz-Cyrl': 'Ҳужжат тури',
    'ru': 'Тип документа',
    'en': 'Document type',
  });

  String get selectDocumentType => _get({
    'uz': 'Hujjat turini tanlang',
    'uz-Cyrl': 'Ҳужжат турини танланг',
    'ru': 'Выберите тип документа',
    'en': 'Select document type',
  });

  String get adoptionDate => _get({
    'uz': 'Qabul qilingan sana',
    'uz-Cyrl': 'Қабул қилинган сана',
    'ru': 'Дата принятия',
    'en': 'Adoption date',
  });

  String get selectDate => _get({
    'uz': 'Sanani tanlang',
    'uz-Cyrl': 'Санани танланг',
    'ru': 'Выберите дату',
    'en': 'Select date',
  });

  String get clear => _get({
    'uz': 'Tozalash',
    'uz-Cyrl': 'Тозалаш',
    'ru': 'Очистить',
    'en': 'Clear',
  });

  String get results => _get({
    'uz': 'Natijalar',
    'uz-Cyrl': 'Натижалар',
    'ru': 'Результаты',
    'en': 'Results',
  });

  String documentsFound(int count) => _get({
    'uz': '$count ta hujjat topildi',
    'uz-Cyrl': '$count та ҳужжат топилди',
    'ru': 'Найдено $count документов',
    'en': '$count documents found',
  });

  // Chat
  String get legalAssistant => _get({
    'uz': 'Huquqiy yordamchi',
    'uz-Cyrl': 'Ҳуқуқий ёрдамчи',
    'ru': 'Юридический помощник',
    'en': 'Legal Assistant',
  });

  String get chatGreeting => _get({
    'uz': 'Salom! Men YuristAI',
    'uz-Cyrl': 'Салом! Мен YuristAI',
    'ru': 'Привет! Я YuristAI',
    'en': 'Hello! I am YuristAI',
  });

  String get chatDescription => _get({
    'uz': "O'zbekiston qonunchiligi bo'yicha savollaringizga javob beraman",
    'uz-Cyrl': 'Ўзбекистон қонунчилиги бўйича саволларингизга жавоб бераман',
    'ru': 'Отвечу на ваши вопросы по законодательству Узбекистана',
    'en': 'I will answer your questions about Uzbekistan legislation',
  });

  String get typeMessage => _get({
    'uz': 'Xabar yozing...',
    'uz-Cyrl': 'Хабар ёзинг...',
    'ru': 'Напишите сообщение...',
    'en': 'Type a message...',
  });

  String get typing => _get({
    'uz': 'Yozilmoqda...',
    'uz-Cyrl': 'Ёзилмоқда...',
    'ru': 'Печатает...',
    'en': 'Typing...',
  });

  String get chatHistory => _get({
    'uz': 'Suhbatlar tarixi',
    'uz-Cyrl': 'Суҳбатлар тарихи',
    'ru': 'История чатов',
    'en': 'Chat history',
  });

  String get newChat => _get({
    'uz': 'Yangi suhbat',
    'uz-Cyrl': 'Янги суҳбат',
    'ru': 'Новый чат',
    'en': 'New chat',
  });

  String get noChats => _get({
    'uz': "Suhbatlar yo'q",
    'uz-Cyrl': 'Суҳбатлар йўқ',
    'ru': 'Нет чатов',
    'en': 'No chats',
  });

  String get startNewChat => _get({
    'uz': 'Yangi suhbat boshlang',
    'uz-Cyrl': 'Янги суҳбат бошланг',
    'ru': 'Начните новый чат',
    'en': 'Start a new chat',
  });

  String get today => _get({
    'uz': 'Bugun',
    'uz-Cyrl': 'Бугун',
    'ru': 'Сегодня',
    'en': 'Today',
  });

  String get thisWeek => _get({
    'uz': 'Bu hafta',
    'uz-Cyrl': 'Бу ҳафта',
    'ru': 'На этой неделе',
    'en': 'This week',
  });

  String get older => _get({
    'uz': 'Oldingi',
    'uz-Cyrl': 'Олдинги',
    'ru': 'Ранее',
    'en': 'Older',
  });

  // Common
  String get loading => _get({
    'uz': 'Yuklanmoqda...',
    'uz-Cyrl': 'Юкланмоқда...',
    'ru': 'Загрузка...',
    'en': 'Loading...',
  });

  String get error => _get({
    'uz': 'Xatolik',
    'uz-Cyrl': 'Хатолик',
    'ru': 'Ошибка',
    'en': 'Error',
  });

  String get cancel => _get({
    'uz': 'Bekor qilish',
    'uz-Cyrl': 'Бекор қилиш',
    'ru': 'Отмена',
    'en': 'Cancel',
  });

  String get select => _get({
    'uz': 'Tanlash',
    'uz-Cyrl': 'Танлаш',
    'ru': 'Выбрать',
    'en': 'Select',
  });

  String get notFound => _get({
    'uz': 'Topilmadi',
    'uz-Cyrl': 'Топилмади',
    'ru': 'Не найдено',
    'en': 'Not found',
  });

  String searchHint(String type) => _get({
    'uz': '$type qidirish...',
    'uz-Cyrl': '$type қидириш...',
    'ru': 'Поиск $type...',
    'en': 'Search $type...',
  });

  String get codesNotFound => _get({
    'uz': 'Kodekslar topilmadi',
    'uz-Cyrl': 'Кодекслар топилмади',
    'ru': 'Кодексы не найдены',
    'en': 'Codes not found',
  });

  String get lawsNotFound => _get({
    'uz': 'Qonunlar topilmadi',
    'uz-Cyrl': 'Қонунлар топилмади',
    'ru': 'Законы не найдены',
    'en': 'Laws not found',
  });

  String get newsNotFound => _get({
    'uz': 'Yangiliklar topilmadi',
    'uz-Cyrl': 'Янгиликлар топилмади',
    'ru': 'Новости не найдены',
    'en': 'News not found',
  });

  String get effectiveDate => _get({
    'uz': 'Kuchga kirish sanasi',
    'uz-Cyrl': 'Кучга кириш санаси',
    'ru': 'Дата вступления в силу',
    'en': 'Effective date',
  });

  String get expiredDate => _get({
    'uz': "Kuchini yo'qotgan",
    'uz-Cyrl': 'Кучини йўқотган',
    'ru': 'Утратил силу',
    'en': 'Expired',
  });

  String get downloaded => _get({
    'uz': 'Yuklandi',
    'uz-Cyrl': 'Юкланди',
    'ru': 'Загружено',
    'en': 'Downloaded',
  });

  String get downloadFailed => _get({
    'uz': "Yuklab bo'lmadi",
    'uz-Cyrl': 'Юклаб бўлмади',
    'ru': 'Ошибка загрузки',
    'en': 'Download failed',
  });

  String get urlNotAvailable => _get({
    'uz': 'URL mavjud emas',
    'uz-Cyrl': 'URL мавжуд эмас',
    'ru': 'URL недоступен',
    'en': 'URL not available',
  });

  String get searchNews => _get({
    'uz': 'Yangiliklarni qidirish...',
    'uz-Cyrl': 'Янгиликларни қидириш...',
    'ru': 'Поиск новостей...',
    'en': 'Search news...',
  });

  String get noNewsFound => _get({
    'uz': 'Yangiliklar topilmadi',
    'uz-Cyrl': 'Янгиликлар топилмади',
    'ru': 'Новости не найдены',
    'en': 'No news found',
  });

  String get downloading => _get({
    'uz': 'Yuklanmoqda...',
    'uz-Cyrl': 'Юкланмоқда...',
    'ru': 'Загрузка...',
    'en': 'Downloading...',
  });

  String get downloadError => _get({
    'uz': "Xatolik: yuklab bo'lmadi",
    'uz-Cyrl': 'Хатолик: юклаб бўлмади',
    'ru': 'Ошибка: не удалось загрузить',
    'en': 'Error: download failed',
  });

  String get searchCodes => _get({
    'uz': 'Kodekslarni qidirish...',
    'uz-Cyrl': 'Кодексларни қидириш...',
    'ru': 'Поиск кодексов...',
    'en': 'Search codes...',
  });

  String get noCodesFound => _get({
    'uz': 'Kodekslar topilmadi',
    'uz-Cyrl': 'Кодекслар топилмади',
    'ru': 'Кодексы не найдены',
    'en': 'No codes found',
  });

  String get searchLaws => _get({
    'uz': 'Qonunlarni qidirish...',
    'uz-Cyrl': 'Қонунларни қидириш...',
    'ru': 'Поиск законов...',
    'en': 'Search laws...',
  });

  String get noLawsFound => _get({
    'uz': 'Qonunlar topilmadi',
    'uz-Cyrl': 'Қонунлар топилмади',
    'ru': 'Законы не найдены',
    'en': 'No laws found',
  });

  // Search screen specific strings
  String get fillAtLeastOneField => _get({
    'uz': "Kamida bitta maydonni to'ldiring",
    'uz-Cyrl': 'Камида битта майдонни тўлдиринг',
    'ru': 'Заполните хотя бы одно поле',
    'en': 'Fill at least one field',
  });

  String get showing100 => _get({
    'uz': '(100 tasi ko\'rsatilmoqda)',
    'uz-Cyrl': '(100 таси кўрсатилмоқда)',
    'ru': '(показано 100)',
    'en': '(showing 100)',
  });

  String get loadMore => _get({
    'uz': 'Ko\'proq yuklash',
    'uz-Cyrl': 'Кўпроқ юклаш',
    'ru': 'Загрузить ещё',
    'en': 'Load more',
  });

  String get moreAvailable => _get({
    'uz': 'yana bor',
    'uz-Cyrl': 'яна бор',
    'ru': 'ещё есть',
    'en': 'more available',
  });

  String get searchError => _get({
    'uz': 'Qidirishda xatolik yuz berdi',
    'uz-Cyrl': 'Қидиришда хатолик юз берди',
    'ru': 'Ошибка поиска',
    'en': 'Search error occurred',
  });

  String get enterDocumentNumber => _get({
    'uz': 'Hujjat raqamini kiriting',
    'uz-Cyrl': 'Ҳужжат рақамини киритинг',
    'ru': 'Введите номер документа',
    'en': 'Enter document number',
  });

  String get enterDocumentName => _get({
    'uz': 'Hujjat nomini kiriting',
    'uz-Cyrl': 'Ҳужжат номини киритинг',
    'ru': 'Введите название документа',
    'en': 'Enter document name',
  });

  String get searchButton => _get({
    'uz': 'Qidirish',
    'uz-Cyrl': 'Қидириш',
    'ru': 'Искать',
    'en': 'Search',
  });

  List<String> get monthNames => _getList({
    'uz': ["Yanvar", "Fevral", "Mart", "Aprel", "May", "Iyun", "Iyul", "Avgust", "Sentabr", "Oktabr", "Noyabr", "Dekabr"],
    'uz-Cyrl': ["Январ", "Феврал", "Март", "Апрел", "Май", "Июн", "Июл", "Август", "Сентябр", "Октябр", "Ноябр", "Декабр"],
    'ru': ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"],
    'en': ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
  });

}

/// Provider for localized strings
final stringsProvider = Provider<AppStrings>((ref) {
  final language = ref.watch(languageProvider);
  return AppStrings(language);
});
