import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_models.freezed.dart';
part 'settings_models.g.dart';

/// View modes for settings screens to support different UI states
enum SettingsViewMode {
  /// Default view with all content loaded
  normal,
  
  /// Loading state while fetching data
  loading,
  
  /// Error state when data fetch fails
  error,
  
  /// Empty state when no data available
  empty,
}

/// Credit card model with real calculations
@freezed
class CreditCardModel with _$CreditCardModel {
  const factory CreditCardModel({
    required String id,
    required String name,
    required String last4Digits,
    required double creditLimit,
    required double usedAmount,
    required DateTime repaymentDate,
    required double nextPaymentAmount,
    @Default(false) bool isPrimary,
  }) = _CreditCardModel;

  factory CreditCardModel.fromJson(Map<String, dynamic> json) =>
      _$CreditCardModelFromJson(json);
}

/// Extension for credit card calculations
extension CreditCardCalculations on CreditCardModel {
  /// Calculate available credit
  double get availableCredit => creditLimit - usedAmount;

  /// Calculate credit utilization ratio (0.0 to 1.0)
  double get utilizationRatio => 
      creditLimit > 0 ? usedAmount / creditLimit : 0.0;

  /// Get formatted utilization percentage
  String get utilizationPercentage => 
      '${(utilizationRatio * 100).toStringAsFixed(1)}%';

  /// Check if card is near limit (>80% utilization)
  bool get isNearLimit => utilizationRatio > 0.8;

  /// Check if card is over limit
  bool get isOverLimit => usedAmount > creditLimit;
}

/// Notification settings model
@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @Default(true) bool pushEnabled,
    @Default(true) bool emailEnabled,
    @Default(true) bool smsEnabled,
    @Default(true) bool paymentNotifications,
    @Default(true) bool securityNotifications,
    @Default(false) bool promotionalNotifications,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}

/// Security settings model
@freezed
class SecuritySettings with _$SecuritySettings {
  const factory SecuritySettings({
    @Default(false) bool faceIdEnabled,
    @Default(true) bool appLockEnabled,
    @Default(true) bool twoFactorEnabled,
    DateTime? lastPasswordChange,
  }) = _SecuritySettings;

  factory SecuritySettings.fromJson(Map<String, dynamic> json) =>
      _$SecuritySettingsFromJson(json);
}

/// User profile model for settings
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? avatarUrl,
    DateTime? dateOfBirth,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

/// Settings state combining all settings data
@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(SettingsViewMode.normal) SettingsViewMode viewMode,
    UserProfile? profile,
    @Default([]) List<CreditCardModel> cards,
    @Default(NotificationSettings()) NotificationSettings notifications,
    @Default(SecuritySettings()) SecuritySettings security,
    String? errorMessage,
  }) = _SettingsState;

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);
}

/// Loading state factory
extension SettingsStateX on SettingsState {
  SettingsState get asLoading => copyWith(viewMode: SettingsViewMode.loading);
  SettingsState get asError => copyWith(viewMode: SettingsViewMode.error);
  SettingsState get asEmpty => copyWith(viewMode: SettingsViewMode.empty);
  SettingsState get asNormal => copyWith(viewMode: SettingsViewMode.normal);
  
  bool get isLoading => viewMode == SettingsViewMode.loading;
  bool get isError => viewMode == SettingsViewMode.error;
  bool get isEmpty => viewMode == SettingsViewMode.empty;
  bool get isNormal => viewMode == SettingsViewMode.normal;
}
