import 'package:flutter/foundation.dart';

/// Enum for different settings view modes
enum SettingsViewMode {
  /// Default mode - standard display
  normal,
  
  /// Loading state - show loading indicators
  loading,
  
  /// Error state - show error message
  error,
  
  /// Empty state - no data available
  empty,
}

/// Model for credit card information
@immutable
class CreditCardModel {
  final String cardNumber;
  final String cardHolderName;
  final String bankName;
  final double creditLimit;
  final double usedAmount;
  final String? cardType;
  final String? lastFourDigits;

  const CreditCardModel({
    required this.cardNumber,
    required this.cardHolderName,
    required this.bankName,
    required this.creditLimit,
    required this.usedAmount,
    this.cardType,
    this.lastFourDigits,
  });

  /// Calculate available credit dynamically
  double get availableCredit => creditLimit - usedAmount;

  /// Calculate credit utilization ratio (0.0 to 1.0)
  double get creditUtilizationRatio {
    if (creditLimit <= 0) return 0.0;
    return (usedAmount / creditLimit).clamp(0.0, 1.0);
  }

  /// Calculate credit utilization percentage (0 to 100)
  double get creditUtilizationPercentage => creditUtilizationRatio * 100;

  CreditCardModel copyWith({
    String? cardNumber,
    String? cardHolderName,
    String? bankName,
    double? creditLimit,
    double? usedAmount,
    String? cardType,
    String? lastFourDigits,
  }) {
    return CreditCardModel(
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      bankName: bankName ?? this.bankName,
      creditLimit: creditLimit ?? this.creditLimit,
      usedAmount: usedAmount ?? this.usedAmount,
      cardType: cardType ?? this.cardType,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreditCardModel &&
        other.cardNumber == cardNumber &&
        other.cardHolderName == cardHolderName &&
        other.bankName == bankName &&
        other.creditLimit == creditLimit &&
        other.usedAmount == usedAmount &&
        other.cardType == cardType &&
        other.lastFourDigits == lastFourDigits;
  }

  @override
  int get hashCode {
    return Object.hash(
      cardNumber,
      cardHolderName,
      bankName,
      creditLimit,
      usedAmount,
      cardType,
      lastFourDigits,
    );
  }

  @override
  String toString() {
    return 'CreditCardModel(cardNumber: $cardNumber, bankName: $bankName, '
        'creditLimit: $creditLimit, usedAmount: $usedAmount, '
        'available: $availableCredit, utilization: ${creditUtilizationPercentage.toStringAsFixed(1)}%)';
  }
}

/// Model for user profile information
@immutable
class UserProfileModel {
  final String name;
  final String phoneNumber;
  final String? email;
  final String? avatarUrl;
  final String? address;
  final String? dateOfBirth;

  const UserProfileModel({
    required this.name,
    required this.phoneNumber,
    this.email,
    this.avatarUrl,
    this.address,
    this.dateOfBirth,
  });

  UserProfileModel copyWith({
    String? name,
    String? phoneNumber,
    String? email,
    String? avatarUrl,
    String? address,
    String? dateOfBirth,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfileModel &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.email == email &&
        other.avatarUrl == avatarUrl &&
        other.address == address &&
        other.dateOfBirth == dateOfBirth;
  }

  @override
  int get hashCode {
    return Object.hash(name, phoneNumber, email, avatarUrl, address, dateOfBirth);
  }
}

/// Model for notification settings
@immutable
class NotificationSettings {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool promotionalNotifications;
  final bool securityAlerts;

  const NotificationSettings({
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.promotionalNotifications = false,
    this.securityAlerts = true,
  });

  NotificationSettings copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? promotionalNotifications,
    bool? securityAlerts,
  }) {
    return NotificationSettings(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      promotionalNotifications: promotionalNotifications ?? this.promotionalNotifications,
      securityAlerts: securityAlerts ?? this.securityAlerts,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationSettings &&
        other.pushNotifications == pushNotifications &&
        other.emailNotifications == emailNotifications &&
        other.smsNotifications == smsNotifications &&
        other.promotionalNotifications == promotionalNotifications &&
        other.securityAlerts == securityAlerts;
  }

  @override
  int get hashCode {
    return Object.hash(
      pushNotifications,
      emailNotifications,
      smsNotifications,
      promotionalNotifications,
      securityAlerts,
    );
  }
}

/// Model for security settings
@immutable
class SecuritySettings {
  final bool twoFactorEnabled;
  final bool biometricEnabled;
  final bool pinLockEnabled;
  final int? pinLength;

  const SecuritySettings({
    this.twoFactorEnabled = false,
    this.biometricEnabled = false,
    this.pinLockEnabled = false,
    this.pinLength,
  });

  SecuritySettings copyWith({
    bool? twoFactorEnabled,
    bool? biometricEnabled,
    bool? pinLockEnabled,
    int? pinLength,
  }) {
    return SecuritySettings(
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pinLockEnabled: pinLockEnabled ?? this.pinLockEnabled,
      pinLength: pinLength ?? this.pinLength,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SecuritySettings &&
        other.twoFactorEnabled == twoFactorEnabled &&
        other.biometricEnabled == biometricEnabled &&
        other.pinLockEnabled == pinLockEnabled &&
        other.pinLength == pinLength;
  }

  @override
  int get hashCode {
    return Object.hash(twoFactorEnabled, biometricEnabled, pinLockEnabled, pinLength);
  }
}

/// Model for notification item
@immutable
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    String? type,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationItem &&
        other.id == id &&
        other.title == title &&
        other.message == message &&
        other.timestamp == timestamp &&
        other.type == type &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return Object.hash(id, title, message, timestamp, type, isRead);
  }
}
