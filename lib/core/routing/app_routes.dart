/// Route path constants for the app
class AppRoutes {
  AppRoutes._();

  // Auth routes
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String createPin = '/create-pin';
  static const String confirmPin = '/confirm-pin';
  static const String enterPin = '/enter-pin';
  static const String settings = '/settings';
  static const String editProfile = '/settings/edit-profile';
  static const String addBankAccount = '/settings/add-bank-account';
  static const String topUp = '/top-up';
  static const String termsConditions = '/settings/terms-conditions';
  static const String privacyPolicy = '/settings/privacy-policy';
  static const String faq = '/settings/faq';
  static const String security = '/settings/security';
  static const String twoFactorChangeEmail = '/settings/security/change-email';
  static const String notifications = '/settings/notifications';

  // Main shell routes
  static const String shell = '/app';
  static const String constitution = '/app/constitution';
  static const String codes = '/app/codes';
  static const String codeDetails = '/app/codes/:id';
  static const String chat = '/app/chat';
  static const String chatHistory = '/app/chat/history';
  static const String laws = '/app/laws';
  static const String lawDetails = '/app/laws/:id';
  static const String news = '/app/news';
  static const String newsDetails = '/app/news/:id';

  // Helper methods for parameterized routes
  static String codeDetailsPath(String id) => '/app/codes/$id';
  static String lawDetailsPath(String id) => '/app/laws/$id';
  static String newsDetailsPath(String id) => '/app/news/$id';
}
