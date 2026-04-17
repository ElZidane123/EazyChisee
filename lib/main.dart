import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/providers/auth_provider.dart';
import 'package:eazychise/core/providers/franchise_provider.dart';
import 'package:eazychise/core/providers/funding_provider.dart';
import 'package:eazychise/core/providers/verification_provider.dart';
import 'package:eazychise/presentation/screens/splash_screen.dart';
import 'package:eazychise/presentation/screens/auth/login_screen.dart';
import 'package:eazychise/presentation/screens/auth/register_screen.dart';
import 'package:eazychise/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:eazychise/presentation/screens/marketplace/marketplace_screen.dart';
import 'package:eazychise/presentation/screens/ai_recommendation/ai_recommendation_screen.dart';
import 'package:eazychise/presentation/screens/bep_simulation/bep_simulation_screen.dart';
import 'package:eazychise/presentation/screens/funding/funding_screen.dart';
import 'package:eazychise/presentation/screens/tracking/tracking_screen.dart';
import 'package:eazychise/presentation/screens/profile/profile_screen.dart';
import 'package:eazychise/presentation/screens/verification/franchise_verification_screen.dart';
import 'package:eazychise/presentation/screens/verification/verification_status_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FranchiseProvider()),
        ChangeNotifierProvider(create: (_) => FundingProvider()),
        ChangeNotifierProvider(create: (_) => VerificationProvider()),
      ],
      child: MaterialApp(
        title: 'EazyChise - Franchise Funding Partner',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreenWave(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/marketplace': (context) => const MarketplaceScreen(),
          '/ai-recommendation': (context) => const AIRecommendationScreen(),
          '/bep-simulation': (context) => const BEPSimulationScreen(),
          '/funding': (context) => const FundingScreen(),
          '/tracking': (context) => const TrackingScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/franchise-verification': (context) => const FranchiseVerificationScreen(),
          '/verification-status': (context) => const VerificationStatusScreen(),
        },
        onGenerateRoute: (settings) {
          // Handle named routes jika diperlukan
          return null;
        },
      ),
    );
  }

  ThemeData _buildTheme() {
    // Base text theme dengan Google Fonts Poppins
    final textTheme = GoogleFonts.poppinsTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
    );

    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: textTheme,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        error: AppColors.error,
        background: AppColors.background,
        surface: AppColors.surface,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: textTheme.headlineMedium?.copyWith(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.textHint.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textHint,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.surface,
      ),
      // bottomNavigationBarTheme: BottomNavigationBarThemeData(
      //   backgroundColor: AppColors.surface,
      //   selectedItemColor: AppColors.primary,
      //   unselectedItemColor: AppColors.textSecondary,
      //   type: BottomNavigationBarType.fixed,
      //   elevation: 8,
      //   selectedLabelStyle: textTheme.bodySmall?.copyWith(
      //     fontWeight: FontWeight.w600,
      //   ),
      //   unselectedLabelStyle: textTheme.bodySmall,
      // ),
      // navigationBarTheme: NavigationBarThemeData(
      //   backgroundColor: AppColors.surface,
      //   indicatorColor: AppColors.primary.withOpacity(0.1),
      //   labelTextStyle: MaterialStateProperty.resolveWith((states) {
      //     if (states.contains(MaterialState.selected)) {
      //       return textTheme.bodySmall?.copyWith(
      //         color: AppColors.primary,
      //         fontWeight: FontWeight.w600,
      //       );
      //     }
      //     return textTheme.bodySmall?.copyWith(
      //       color: AppColors.textSecondary,
      //     );
      //   }),
      // ),
    );
  }
}