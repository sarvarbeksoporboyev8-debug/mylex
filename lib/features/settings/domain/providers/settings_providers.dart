import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/settings_models.dart';

part 'settings_providers.g.dart';

/// Settings state notifier for managing all user settings
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.asLoading;
    
    try {
      // TODO: Load settings from backend/local storage
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock data - replace with real API call
      final profile = UserProfile(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+1234567890',
      );
      
      final cards = [
        CreditCardModel(
          id: '1',
          name: 'Uzcard',
          last4Digits: '1234',
          creditLimit: 5000.0,
          usedAmount: 512.23,
          repaymentDate: DateTime(2025, 7, 1),
          nextPaymentAmount: 678.33,
          isPrimary: true,
        ),
        CreditCardModel(
          id: '2',
          name: 'Humo',
          last4Digits: '5678',
          creditLimit: 3000.0,
          usedAmount: 1200.0,
          repaymentDate: DateTime(2025, 6, 15),
          nextPaymentAmount: 400.0,
          isPrimary: false,
        ),
      ];
      
      state = state.copyWith(
        viewMode: SettingsViewMode.normal,
        profile: profile,
        cards: cards,
      );
    } catch (e) {
      state = state.copyWith(
        viewMode: SettingsViewMode.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Update notification settings
  void updateNotificationSettings(NotificationSettings settings) {
    state = state.copyWith(notifications: settings);
    // TODO: Save to backend/local storage
  }

  /// Update security settings
  void updateSecuritySettings(SecuritySettings settings) {
    state = state.copyWith(security: settings);
    // TODO: Save to backend/local storage
  }

  /// Toggle notification enabled state
  void toggleNotifications(bool enabled) {
    state = state.copyWith(
      notifications: state.notifications.copyWith(pushEnabled: enabled),
    );
    // TODO: Save to backend/local storage
  }

  /// Toggle Face ID
  void toggleFaceId(bool enabled) {
    state = state.copyWith(
      security: state.security.copyWith(faceIdEnabled: enabled),
    );
    // TODO: Save to backend/local storage
  }

  /// Toggle App Lock
  void toggleAppLock(bool enabled) {
    state = state.copyWith(
      security: state.security.copyWith(appLockEnabled: enabled),
    );
    // TODO: Save to backend/local storage
  }

  /// Update user profile
  void updateProfile(UserProfile profile) {
    state = state.copyWith(profile: profile);
    // TODO: Save to backend
  }

  /// Add a new card
  void addCard(CreditCardModel card) {
    state = state.copyWith(
      cards: [...state.cards, card],
    );
    // TODO: Save to backend
  }

  /// Remove a card
  void removeCard(String cardId) {
    state = state.copyWith(
      cards: state.cards.where((c) => c.id != cardId).toList(),
    );
    // TODO: Save to backend
  }

  /// Set primary card
  void setPrimaryCard(String cardId) {
    state = state.copyWith(
      cards: state.cards.map((c) {
        return c.copyWith(isPrimary: c.id == cardId);
      }).toList(),
    );
    // TODO: Save to backend
  }

  /// Refresh settings
  Future<void> refresh() => _initialize();
}

/// Provider for settings state
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

/// Computed provider for total credit available
@riverpod
double totalCreditAvailable(TotalCreditAvailableRef ref) {
  final cards = ref.watch(settingsProvider.select((s) => s.cards));
  return cards.fold(0.0, (sum, card) => sum + card.availableCredit);
}

/// Computed provider for total credit used
@riverpod
double totalCreditUsed(TotalCreditUsedRef ref) {
  final cards = ref.watch(settingsProvider.select((s) => s.cards));
  return cards.fold(0.0, (sum, card) => sum + card.usedAmount);
}

/// Computed provider for total credit limit
@riverpod
double totalCreditLimit(TotalCreditLimitRef ref) {
  final cards = ref.watch(settingsProvider.select((s) => s.cards));
  return cards.fold(0.0, (sum, card) => sum + card.creditLimit);
}

/// Computed provider for overall credit utilization ratio
@riverpod
double creditUtilizationRatio(CreditUtilizationRatioRef ref) {
  final used = ref.watch(totalCreditUsedProvider);
  final limit = ref.watch(totalCreditLimitProvider);
  return limit > 0 ? used / limit : 0.0;
}

/// Provider for primary card
@riverpod
CreditCardModel? primaryCard(PrimaryCardRef ref) {
  final cards = ref.watch(settingsProvider.select((s) => s.cards));
  try {
    return cards.firstWhere((card) => card.isPrimary);
  } catch (_) {
    return cards.isNotEmpty ? cards.first : null;
  }
}

/// Provider for notification settings
final notificationSettingsProvider = Provider<NotificationSettings>((ref) {
  return ref.watch(settingsProvider.select((s) => s.notifications));
});

/// Provider for security settings
final securitySettingsProvider = Provider<SecuritySettings>((ref) {
  return ref.watch(settingsProvider.select((s) => s.security));
});

/// Provider for user profile
final userProfileProvider = Provider<UserProfile?>((ref) {
  return ref.watch(settingsProvider.select((s) => s.profile));
});
