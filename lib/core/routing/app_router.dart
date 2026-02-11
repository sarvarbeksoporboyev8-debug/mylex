import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_email_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_new_password_screen.dart';
import '../../features/auth/presentation/screens/create_pin_screen.dart';
import '../../features/auth/presentation/screens/confirm_pin_screen.dart';
import '../../features/auth/presentation/screens/enter_pin_screen.dart';
import '../../features/shell/presentation/main_shell.dart';
import '../../features/constitution/presentation/screens/constitution_screen.dart';
import '../../features/codes/presentation/screens/codes_list_screen.dart';
import '../../features/codes/presentation/screens/code_details_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/chat/presentation/screens/chat_history_screen.dart';
import '../../features/laws/presentation/screens/laws_list_screen.dart';
import '../../features/laws/presentation/screens/law_details_screen.dart';
import '../../features/news/presentation/screens/news_list_screen.dart';
import '../../features/news/presentation/screens/news_details_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/edit_profile_screen.dart';
import '../../features/settings/presentation/screens/add_bank_account_screen.dart';
import '../../features/settings/presentation/screens/top_up_screen.dart';
import '../../features/settings/presentation/screens/terms_conditions_screen.dart';
import '../../features/settings/presentation/screens/privacy_policy_screen.dart';
import '../../features/settings/presentation/screens/faq_screen.dart';
import '../../features/settings/presentation/screens/security_screen.dart';
import '../../features/settings/presentation/screens/two_factor_change_email_screen.dart';
import '../../features/settings/presentation/screens/notifications_screen.dart';
import 'app_routes.dart';

// Navigation keys for nested navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _constitutionNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'constitution');
final _codesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'codes');
final _chatNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'chat');
final _lawsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'laws');
final _newsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'news');

/// Router provider for the app
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Auth routes (outside shell)
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordEmailScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ForgotPasswordNewPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.createPin,
        builder: (context, state) => const CreatePinScreen(),
      ),
      GoRoute(
        path: AppRoutes.confirmPin,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! String || extra.isEmpty) {
            // Safety fallback (e.g. deep link without extra)
            return const CreatePinScreen();
          }
          return ConfirmPinScreen(pin: extra);
        },
      ),
      GoRoute(
        path: AppRoutes.enterPin,
        builder: (context, state) => const EnterPinScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.addBankAccount,
        builder: (context, state) => const AddBankAccountScreen(),
      ),
      GoRoute(
        path: AppRoutes.topUp,
        builder: (context, state) => const TopUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.termsConditions,
        builder: (context, state) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: AppRoutes.faq,
        builder: (context, state) => const FaqScreen(),
      ),
      GoRoute(
        path: AppRoutes.security,
        builder: (context, state) => const SecurityScreen(),
      ),
      GoRoute(
        path: AppRoutes.twoFactorChangeEmail,
        builder: (context, state) => const TwoFactorChangeEmailScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Main shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Constitution tab
          StatefulShellBranch(
            navigatorKey: _constitutionNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.constitution,
                builder: (context, state) => const ConstitutionScreen(),
              ),
            ],
          ),

          // Codes tab
          StatefulShellBranch(
            navigatorKey: _codesNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.codes,
                builder: (context, state) => const CodesListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return CodeDetailsScreen(id: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Chat tab
          StatefulShellBranch(
            navigatorKey: _chatNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.chat,
                builder: (context, state) => const ChatScreen(),
                routes: [
                  GoRoute(
                    path: 'history',
                    builder: (context, state) => const ChatHistoryScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Laws tab
          StatefulShellBranch(
            navigatorKey: _lawsNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.laws,
                builder: (context, state) => const LawsListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return LawDetailsScreen(id: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // News tab
          StatefulShellBranch(
            navigatorKey: _newsNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.news,
                builder: (context, state) => const NewsListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return NewsDetailsScreen(id: id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});
