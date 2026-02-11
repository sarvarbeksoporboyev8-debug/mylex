/// App-wide constants used across the UI and local auth.
class AppConstants {
  /// Local PIN length (numeric passcode) used for login.
  static const int pinLength = 6;

  /// Secure storage keys
  static const String storagePinKey = 'lexuz_ai_pin_v1';

  /// Assets
  static const String backgroundAsset = 'assets/images/background.png';

  /// Bottom navigation icons (PNG assets - transparent background)
  static const String navKonstitutsiya = 'assets/images/nav/constitution.png';
  static const String navKodekslar = 'assets/images/nav/codes.png';
  static const String navChatbot = 'assets/images/nav/chat.png';
  static const String navQonunlar = 'assets/images/nav/laws.png';
  static const String navYangiliklar = 'assets/images/nav/news.png';
}
