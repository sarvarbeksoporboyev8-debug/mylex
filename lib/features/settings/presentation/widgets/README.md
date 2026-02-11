# Settings Widgets - Architecture Documentation

## Overview
This directory contains reusable widget components for the settings feature. These widgets have been extracted from the monolithic settings screen implementation to improve code maintainability, reusability, and testability.

## Widget Components

### 1. SettingsSection
**File:** `settings_section.dart`

A reusable container widget for settings sections with optional title.

**Usage:**
```dart
SettingsSection(
  title: 'Personal Information',
  child: Column(
    children: [
      SettingsMenuItem(...),
      SettingsMenuDivider(),
      SettingsMenuItem(...),
    ],
  ),
)
```

### 2. SettingsMenuItem
**File:** `settings_menu_item.dart`

A reusable menu item row with optional icon, label, and trailing widget.

**Factory Methods:**
- `SettingsMenuItem.withChevron()` - Menu item with chevron trailing icon
- `SettingsMenuItem.withValue()` - Menu item displaying a static value

**Usage:**
```dart
SettingsMenuItem.withChevron(
  icon: PhosphorIconsRegular.bell,
  label: 'Notifications',
  onTap: () => context.push(AppRoutes.notifications),
)
```

### 3. SettingsProfileHeader
**File:** `settings_profile_header.dart`

Profile header widget displaying user information with edit button.

**Usage:**
```dart
SettingsProfileHeader(
  name: 'John Doe',
  phone: '+1 (555) 123-4567',
  editLabel: 'Edit',
  editRoute: AppRoutes.editProfile,
)
```

### 4. SettingsPaymentCard
**File:** `settings_payment_card.dart`

Card widget for displaying bank account information.

**Usage:**
```dart
SettingsPaymentCard(
  name: 'Emirates NBD Bank',
  last4: '4567',
  isPrimary: true,
  statusLabel: 'Complete',
)
```

### 5. LanguageSelectorModal
**File:** `language_selector_modal.dart`

Bottom sheet modal for language selection.

**Usage:**
```dart
LanguageSelectorModal.show(
  context: context,
  ref: ref,
  strings: strings,
  currentLanguage: currentLanguage,
)
```

### 6. SettingsScreenHeader
**File:** `settings_screen_header.dart`

Standard header with back button and centered title for settings screens.

**Usage:**
```dart
SettingsScreenHeader(
  title: 'Security',
)
```

### 7. SettingsMenuDivider
**File:** `settings_menu_item.dart`

Simple divider for separating menu items.

**Usage:**
```dart
SettingsMenuDivider()
```

## Barrel Export
All widgets are exported through `settings_widgets.dart` for convenient importing:

```dart
import '../widgets/settings_widgets.dart';
```

## Benefits

1. **Code Reusability** - Widgets can be reused across multiple settings screens
2. **Maintainability** - Individual components are easier to update and test
3. **Consistency** - Ensures consistent UI/UX across settings screens
4. **Reduced Complexity** - Main screen files are now much smaller and focused
5. **Better Testing** - Individual widgets can be tested in isolation

## Migration Statistics

- **settings_screen.dart:** 915 lines → 464 lines (49% reduction)
- **security_screen.dart:** 234 lines → 166 lines (29% reduction)
- **terms_conditions_screen.dart:** 300 lines → 255 lines (15% reduction)
- **Total reduction:** ~1449 lines → ~885 lines (39% reduction)

## Future Improvements

- Add unit tests for individual widgets
- Add widget documentation tests
- Consider creating more specialized widgets as patterns emerge
- Extract hardcoded font families ('Roboto', 'Onest') to theme constants for consistency
- Add theming support for easier customization
- Consider extracting hardcoded colors to theme constants
