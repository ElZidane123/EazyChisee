import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/providers/auth_provider.dart';
import 'package:eazychise/core/providers/franchise_provider.dart';
import 'package:eazychise/core/providers/funding_provider.dart';
import 'package:eazychise/core/providers/verification_provider.dart';
import 'package:eazychise/core/providers/notification_provider.dart';
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
import 'package:eazychise/presentation/screens/trust_score_screen.dart';
import 'package:eazychise/presentation/screens/academy/academy_screen.dart';
import 'package:eazychise/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:eazychise/presentation/screens/onboarding/role_selection_screen.dart';
import 'package:eazychise/presentation/screens/ai_simulator/franchise_simulator_screen.dart';
import 'package:eazychise/presentation/screens/notification/notification_screen.dart';
import 'package:eazychise/presentation/screens/location/location_checker_screen.dart';
import 'package:eazychise/presentation/screens/franchisor/franchisor_dashboard_screen.dart';

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
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'EazyChise - Franchise Funding Partner',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreenWave(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/role-selection': (context) => const RoleSelectionScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => HomeScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/marketplace': (context) => const MarketplaceScreen(),
          '/ai-recommendation': (context) => const AIRecommendationScreen(),
          '/ai-simulator': (context) => const FranchiseSimulatorScreen(),
          '/bep-simulation': (context) => const BEPSimulationScreen(),
          '/funding': (context) => const FundingScreen(),
          '/notifications': (context) => const NotificationScreen(),
          '/location-checker': (context) => const LocationCheckerScreen(),
          '/tracking': (context) => const TrackingScreen(),
          '/franchisor-dashboard': (context) => const FranchisorDashboardScreen(),
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
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        onPrimary: Colors.white,
        outline: AppColors.divider,
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

/// Helper data class untuk menu item HomeScreen
class _MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _MenuItem(this.title, this.icon, this.onTap);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isFranchisor = auth.isFranchisor;

    final baseMenuItems = [
      _MenuItem('Marketplace\nTerverifikasi', Icons.storefront, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketplaceScreen()));
      }),
      _MenuItem('AI Business\nRecommendation', Icons.psychology, () {
        Navigator.pushNamed(context, '/ai-recommendation');
      }),
      _MenuItem('Simulasi AI', Icons.auto_awesome, () {
        Navigator.pushNamed(context, '/ai-simulator');
      }),
      _MenuItem('Simulasi BEP\n& Analisis', Icons.calculate, () {
        Navigator.pushNamed(context, '/bep-simulation');
      }),
      _MenuItem('Trust Score\n& Risk', Icons.shield, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => TrustScoreScreen()));
      }),
      _MenuItem('EazyChise\nAcademy', Icons.school, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AcademyScreen()));
      }),
      _MenuItem('Dashboard\nBisnis', Icons.dashboard, () {
        Navigator.pushNamed(context, '/dashboard');
      }),
    ];

    // Tambah menu khusus franchisor
    if (isFranchisor) {
      baseMenuItems.add(
        _MenuItem('Dashboard\nCabang', Icons.account_tree_rounded, () {
          Navigator.pushNamed(context, '/dashboard');
        }),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('EazyChise')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: baseMenuItems
            .map((item) => _buildMenuCard(item.title, item.icon, item.onTap, context))
            .toList(),
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon, VoidCallback onTap, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primaryBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 26, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}