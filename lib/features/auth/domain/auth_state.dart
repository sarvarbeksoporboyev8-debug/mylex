import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/constants/app_constants.dart';

/// Authentication status
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
}

/// Authentication state
class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  /// Whether a local PIN has been created on this device.
  final bool hasPinSet;

  /// Whether the current session is verified (PIN entered successfully).
  final bool isPinVerified;

  /// Temporary PIN (used during PIN creation/confirmation flow).
  final String? tempPin;
  
  /// Whether user is logged in (phone/password auth).
  final bool isLoggedIn;
  
  /// User's wallet balance.
  final double walletBalance;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.hasPinSet = false,
    this.isPinVerified = false,
    this.tempPin,
    this.isLoggedIn = false,
    this.walletBalance = 0.0,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    bool? hasPinSet,
    bool? isPinVerified,
    String? tempPin,
    bool? isLoggedIn,
    double? walletBalance,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      hasPinSet: hasPinSet ?? this.hasPinSet,
      isPinVerified: isPinVerified ?? this.isPinVerified,
      tempPin: tempPin ?? this.tempPin,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }
}

/// Authentication notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Check if user is logged in.
  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final isLoggedIn = await _storage.read(key: 'is_logged_in');
      final balanceStr = await _storage.read(key: 'wallet_balance');
      final balance = double.tryParse(balanceStr ?? '0') ?? 0.0;

      state = state.copyWith(
        status: isLoggedIn == 'true' ? AuthStatus.authenticated : AuthStatus.unauthenticated,
        isLoggedIn: isLoggedIn == 'true',
        walletBalance: balance,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoggedIn: false,
        errorMessage: 'Auth holatini tekshirishda xatolik',
      );
    }
  }
  
  /// Login with phone and password.
  Future<bool> login(String phone, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    
    // TODO: Replace with actual API call
    // For now, accept any non-empty credentials
    if (phone.isEmpty || password.isEmpty) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Telefon va parol kiritilishi kerak',
      );
      return false;
    }
    
    try {
      await _storage.write(key: 'is_logged_in', value: 'true');
      await _storage.write(key: 'user_phone', value: phone);
      
      state = state.copyWith(
        status: AuthStatus.authenticated,
        isLoggedIn: true,
        walletBalance: 0.0,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Kirishda xatolik',
      );
      return false;
    }
  }
  
  /// Register new user.
  Future<bool> signup(String name, String phone, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    
    // TODO: Replace with actual API call
    if (name.isEmpty || phone.isEmpty || password.isEmpty) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Barcha maydonlarni to\'ldiring',
      );
      return false;
    }
    
    try {
      await _storage.write(key: 'is_logged_in', value: 'true');
      await _storage.write(key: 'user_phone', value: phone);
      await _storage.write(key: 'user_name', value: name);
      
      state = state.copyWith(
        status: AuthStatus.authenticated,
        isLoggedIn: true,
        walletBalance: 0.0,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Ro\'yxatdan o\'tishda xatolik',
      );
      return false;
    }
  }
  
  /// Logout user.
  Future<void> logout() async {
    try {
      await _storage.delete(key: 'is_logged_in');
      await _storage.delete(key: 'user_phone');
      await _storage.delete(key: 'user_name');
    } catch (_) {}
    
    state = const AuthState(
      status: AuthStatus.unauthenticated,
      isLoggedIn: false,
    );
  }

  /// Start PIN creation flow (stores temporary PIN for confirmation screen).
  Future<bool> setPin(String pin) async {
    if (pin.length != AppConstants.pinLength) {
      state = state.copyWith(errorMessage: 'PIN ${AppConstants.pinLength} ta raqam bo\'lishi kerak');
      return false;
    }

    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      errorMessage: null,
      tempPin: pin,
    );
    return true;
  }

  /// Confirm and persist PIN into secure storage.
  Future<bool> confirmPin(String pin) async {
    if (pin != state.tempPin) {
      state = state.copyWith(errorMessage: 'PIN kodlar mos kelmadi');
      return false;
    }

    try {
      await _storage.write(key: AppConstants.storagePinKey, value: pin);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        errorMessage: null,
        hasPinSet: true,
        isPinVerified: true,
        tempPin: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: 'PIN saqlashda xatolik');
      return false;
    }
  }

  /// Verify entered PIN against secure storage.
  Future<bool> verifyPin(String pin) async {
    if (pin.length != AppConstants.pinLength) {
      state = state.copyWith(errorMessage: 'PIN ${AppConstants.pinLength} ta raqam bo\'lishi kerak');
      return false;
    }

    try {
      final storedPin = await _storage.read(key: AppConstants.storagePinKey);
      if (storedPin == null || storedPin.isEmpty) {
        state = state.copyWith(
          errorMessage: 'PIN topilmadi. Iltimos, yangi PIN yarating.',
          hasPinSet: false,
          isPinVerified: false,
          status: AuthStatus.unauthenticated,
        );
        return false;
      }

      if (pin == storedPin) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          errorMessage: null,
          hasPinSet: true,
          isPinVerified: true,
        );
        return true;
      }

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Noto\'g\'ri PIN kod',
        isPinVerified: false,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'PIN tekshirishda xatolik',
        isPinVerified: false,
      );
      return false;
    }
  }

  /// Clear PIN ("Forgot PIN" flow).
  Future<void> resetPin() async {
    try {
      await _storage.delete(key: AppConstants.storagePinKey);
    } catch (_) {
      // ignore
    }

    state = const AuthState(
      status: AuthStatus.unauthenticated,
      hasPinSet: false,
      isPinVerified: false,
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for authentication state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
