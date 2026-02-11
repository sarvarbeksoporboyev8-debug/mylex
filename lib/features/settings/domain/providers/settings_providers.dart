import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings_models.dart';

// ============================================================
// USER PROFILE PROVIDER
// ============================================================

/// Provider for user profile state
class UserProfileNotifier extends StateNotifier<UserProfileModel> {
  UserProfileNotifier()
      : super(const UserProfileModel(
          name: 'Ali Muhajirin',
          phoneNumber: '+1 (555) 123-4567',
          email: 'ali.muhajirin@example.com',
        ));

  void updateProfile(UserProfileModel profile) {
    state = profile;
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateAvatar(String avatarUrl) {
    state = state.copyWith(avatarUrl: avatarUrl);
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileModel>((ref) {
  return UserProfileNotifier();
});

// ============================================================
// CREDIT CARDS PROVIDER
// ============================================================

/// Provider for credit cards list
class CreditCardsNotifier extends StateNotifier<List<CreditCardModel>> {
  CreditCardsNotifier()
      : super([
          const CreditCardModel(
            cardNumber: '**** **** **** 8945',
            cardHolderName: 'Ali Muhajirin',
            bankName: 'Chase Bank',
            creditLimit: 5000.0,
            usedAmount: 512.23,
            cardType: 'Mastercard',
            lastFourDigits: '8945',
          ),
          const CreditCardModel(
            cardNumber: '**** **** **** 3421',
            cardHolderName: 'Ali Muhajirin',
            bankName: 'Bank of America',
            creditLimit: 3000.0,
            usedAmount: 678.33,
            cardType: 'Visa',
            lastFourDigits: '3421',
          ),
        ]);

  void addCard(CreditCardModel card) {
    state = [...state, card];
  }

  void removeCard(int index) {
    state = [...state]..removeAt(index);
  }

  void updateCard(int index, CreditCardModel card) {
    final newState = [...state];
    newState[index] = card;
    state = newState;
  }

  void updateUsedAmount(int index, double amount) {
    final card = state[index];
    final updatedCard = card.copyWith(usedAmount: amount);
    updateCard(index, updatedCard);
  }
}

final creditCardsProvider =
    StateNotifierProvider<CreditCardsNotifier, List<CreditCardModel>>((ref) {
  return CreditCardsNotifier();
});

// Computed provider for primary (first) card
final primaryCardProvider = Provider<CreditCardModel?>((ref) {
  final cards = ref.watch(creditCardsProvider);
  return cards.isNotEmpty ? cards.first : null;
});

// ============================================================
// NOTIFICATION SETTINGS PROVIDER
// ============================================================

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier()
      : super(const NotificationSettings(
          pushNotifications: true,
          emailNotifications: true,
          smsNotifications: false,
          promotionalNotifications: false,
          securityAlerts: true,
        ));

  void togglePushNotifications() {
    state = state.copyWith(pushNotifications: !state.pushNotifications);
  }

  void toggleEmailNotifications() {
    state = state.copyWith(emailNotifications: !state.emailNotifications);
  }

  void toggleSmsNotifications() {
    state = state.copyWith(smsNotifications: !state.smsNotifications);
  }

  void togglePromotionalNotifications() {
    state = state.copyWith(
        promotionalNotifications: !state.promotionalNotifications);
  }

  void toggleSecurityAlerts() {
    state = state.copyWith(securityAlerts: !state.securityAlerts);
  }

  void updateSettings(NotificationSettings settings) {
    state = settings;
  }
}

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
        (ref) {
  return NotificationSettingsNotifier();
});

// ============================================================
// SECURITY SETTINGS PROVIDER
// ============================================================

class SecuritySettingsNotifier extends StateNotifier<SecuritySettings> {
  SecuritySettingsNotifier()
      : super(const SecuritySettings(
          twoFactorEnabled: false,
          biometricEnabled: false,
          pinLockEnabled: false,
        ));

  void toggleTwoFactor() {
    state = state.copyWith(twoFactorEnabled: !state.twoFactorEnabled);
  }

  void toggleBiometric() {
    state = state.copyWith(biometricEnabled: !state.biometricEnabled);
  }

  void togglePinLock() {
    state = state.copyWith(pinLockEnabled: !state.pinLockEnabled);
  }

  void updateSettings(SecuritySettings settings) {
    state = settings;
  }
}

final securitySettingsProvider =
    StateNotifierProvider<SecuritySettingsNotifier, SecuritySettings>((ref) {
  return SecuritySettingsNotifier();
});

// ============================================================
// NOTIFICATIONS LIST PROVIDER
// ============================================================

class NotificationsNotifier extends StateNotifier<List<NotificationItem>> {
  NotificationsNotifier()
      : super([
          NotificationItem(
            id: '1',
            title: 'Payment Received',
            message: 'Your payment of \$100 has been processed successfully.',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            type: 'payment',
            isRead: false,
          ),
          NotificationItem(
            id: '2',
            title: 'Security Alert',
            message: 'New login detected from Chrome on Windows.',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            type: 'security',
            isRead: true,
          ),
          NotificationItem(
            id: '3',
            title: 'Card Added',
            message: 'You have successfully added a new payment method.',
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
            type: 'account',
            isRead: true,
          ),
        ]);

  void markAsRead(String id) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(isRead: true) else item
    ];
  }

  void markAllAsRead() {
    state = [for (final item in state) item.copyWith(isRead: true)];
  }

  void addNotification(NotificationItem notification) {
    state = [notification, ...state];
  }

  void removeNotification(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void clearAll() {
    state = [];
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<NotificationItem>>((ref) {
  return NotificationsNotifier();
});

// Computed provider for unread notifications count
final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((n) => !n.isRead).length;
});

// Provider for filtered notifications by type
final filteredNotificationsProvider =
    Provider.family<List<NotificationItem>, String?>((ref, type) {
  final notifications = ref.watch(notificationsProvider);
  if (type == null || type.isEmpty) {
    return notifications;
  }
  return notifications.where((n) => n.type == type).toList();
});
