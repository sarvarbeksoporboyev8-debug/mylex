# Lex.uz AI

Premium legal assistant app for Uzbekistan with gold glassmorphism design.

## Features

- **Konstitutsiya** - Browse the Constitution with table of contents and bookmarks
- **Kodekslar** - View legal codes with search, favorites, and download options
- **Chatbot** - AI-powered legal assistant with streaming responses
- **Qonunlar** - Browse laws with filtering and sorting
- **Yangiliklar** - Legal news feed with categories

## Architecture

```
lib/
├── core/
│   ├── theme/          # Design system (colors, typography, spacing)
│   ├── routing/        # go_router configuration
│   ├── network/        # Dio setup (placeholder)
│   ├── storage/        # Local storage (placeholder)
│   └── widgets/        # Reusable UI components
└── features/
    ├── auth/           # Login, signup, PIN screens
    ├── shell/          # Main scaffold with bottom nav
    ├── constitution/   # Constitution viewer
    ├── codes/          # Legal codes list/details
    ├── laws/           # Laws list/details
    ├── news/           # News feed
    └── chat/           # AI chatbot
```

## Tech Stack

- **State Management**: Riverpod
- **Routing**: go_router with StatefulShellRoute
- **UI**: Custom glassmorphism design system
- **Fonts**: Google Fonts (Inter)
- **Icons**: Phosphor Icons
- **Animations**: flutter_animate

## Development Setup

### Option 1: Dev Container (Recommended)

Open this repo in VS Code with the Dev Containers extension, or use GitHub Codespaces / Gitpod. The `.devcontainer/` config will set up Flutter automatically.

### Option 2: Local Setup

Requirements:
- Flutter 3.27.x
- Java 17 (for Android builds)
- Android SDK

```bash
# Get dependencies
flutter pub get

# Run code generation (required after cloning)
dart run build_runner build --delete-conflicting-outputs

# Run on device/emulator
flutter run

# Build release APK
flutter build apk --release
```

## CI/CD

GitHub Actions automatically builds APKs on every push to `main`.

**To download an APK:**
1. Go to Actions tab → latest "Build APK" workflow
2. Download the `lex-uz-ai-apk` artifact

**To create a release:**
```bash
git tag v1.0.0
git push origin v1.0.0
```
This triggers a build and creates a GitHub Release with the APK attached.

## Design System

### Colors
- Primary: Gold (#D4AF37)
- Background: Dark gradient (#1A1A2E → #16213E → #0F3460)
- Glass surfaces: Semi-transparent white with blur

### Components
- `GoldBackground` - Golden rays background
- `GlassCard` - Glassmorphism card with blur
- `GoldButton` - Primary gradient button
- `GlassButton` - Secondary outline button
- `GlassNavBar` - Custom animated bottom navigation

## API Integration

Replace mock data in repositories with real API calls:

1. **Auth**: `lib/features/auth/domain/auth_state.dart`
2. **Codes**: `lib/features/codes/data/codes_repository.dart`
3. **Laws**: `lib/features/laws/data/laws_repository.dart`
4. **News**: `lib/features/news/data/news_repository.dart`
5. **Constitution**: `lib/features/constitution/data/constitution_repository.dart`
6. **Chat**: `lib/features/chat/data/chat_repository.dart`

### Dio Setup

Create `lib/core/network/dio_client.dart`:

```dart
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.lex.uz/v1',
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
  ));
  
  dio.interceptors.add(LogInterceptor());
  // Add auth interceptor
  
  return dio;
});
```

## Localization

Translations are in `assets/translations/`. Add more languages:

- `uz.json` - Uzbek (Latin)
- `uz_cyrl.json` - Uzbek (Cyrillic)
- `ru.json` - Russian

## License

Proprietary - All rights reserved.
