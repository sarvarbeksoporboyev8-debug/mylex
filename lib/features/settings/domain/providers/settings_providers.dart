import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum for different settings view modes
enum SettingsViewMode {
  defaultView,
  loading,
  error,
}

/// Settings state class
class SettingsState {
  final bool notificationsEnabled;
  final bool faceIdEnabled;
  final bool appLockEnabled;
  final SettingsViewMode viewMode;
  final String? errorMessage;

  const SettingsState({
    this.notificationsEnabled = true,
    this.faceIdEnabled = false,
    this.appLockEnabled = true,
    this.viewMode = SettingsViewMode.defaultView,
    this.errorMessage,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? faceIdEnabled,
    bool? appLockEnabled,
    SettingsViewMode? viewMode,
    String? errorMessage,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      faceIdEnabled: faceIdEnabled ?? this.faceIdEnabled,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      viewMode: viewMode ?? this.viewMode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Settings state notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  void toggleNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }

  void toggleFaceId(bool value) {
    state = state.copyWith(faceIdEnabled: value);
  }

  void toggleAppLock(bool value) {
    state = state.copyWith(appLockEnabled: value);
  }

  void setViewMode(SettingsViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  void setError(String message) {
    state = state.copyWith(
      viewMode: SettingsViewMode.error,
      errorMessage: message,
    );
  }
}

/// Settings state provider
final settingsStateProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

/// Credit card state class
class CreditCardState {
  final double creditLimit;
  final double usedAmount;
  final DateTime? repaymentDate;
  final double repaymentAmount;

  const CreditCardState({
    this.creditLimit = 5000.0,
    this.usedAmount = 512.23,
    this.repaymentDate,
    this.repaymentAmount = 678.33,
  });

  /// Calculate available credit
  double get availableCredit => creditLimit - usedAmount;

  /// Calculate progress ratio for progress bar (0.0 to 1.0)
  double get progressRatio {
    if (creditLimit == 0) return 0.0;
    final ratio = usedAmount / creditLimit;
    return ratio.clamp(0.0, 1.0);
  }

  CreditCardState copyWith({
    double? creditLimit,
    double? usedAmount,
    DateTime? repaymentDate,
    double? repaymentAmount,
  }) {
    return CreditCardState(
      creditLimit: creditLimit ?? this.creditLimit,
      usedAmount: usedAmount ?? this.usedAmount,
      repaymentDate: repaymentDate ?? this.repaymentDate,
      repaymentAmount: repaymentAmount ?? this.repaymentAmount,
    );
  }
}

/// Credit card state notifier
class CreditCardNotifier extends StateNotifier<CreditCardState> {
  CreditCardNotifier() : super(const CreditCardState());

  void updateUsedAmount(double amount) {
    state = state.copyWith(usedAmount: amount);
  }

  void updateCreditLimit(double limit) {
    state = state.copyWith(creditLimit: limit);
  }

  void updateRepaymentAmount(double amount) {
    state = state.copyWith(repaymentAmount: amount);
  }
}

/// Credit card provider
final creditCardProvider =
    StateNotifierProvider<CreditCardNotifier, CreditCardState>((ref) {
  return CreditCardNotifier();
});
