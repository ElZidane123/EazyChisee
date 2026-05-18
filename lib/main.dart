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
    final textTheme = GoogleFonts.interTextTheme(
      // Ganti Poppins ke Inter — lebih clean untuk fintech
      TextTheme(
        displayLarge:  TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.8, height: 1.2),
        displayMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.5, height: 1.25),
        displaySmall:  TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: -0.3, height: 1.3),
        headlineMedium:TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: -0.2),
        headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        titleLarge:    TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        titleMedium:   TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        bodyLarge:     TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.5),
        bodyMedium:    TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSub, height: 1.5),
        bodySmall:     TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSub, height: 1.4),
        labelLarge:    TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        labelMedium:   TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSub),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnDark,
        secondary: AppColors.primary,
        surface: AppColors.surface,
        background: AppColors.bg,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.bg,
      textTheme: textTheme,

      // App Bar — flat putih bersih, tidak ada gradient
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.border,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary, size: 22),
        surfaceTintColor: Colors.transparent,
      ),

      // Card — shadow halus, tidak ada border warna
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ElevatedButton — solid flat, tidak ada gradient di button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnDark,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.border, width: 1.5),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Field — clean, border tipis
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bg,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        labelStyle: TextStyle(color: AppColors.textSub, fontSize: 14),
        hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
        prefixIconColor: AppColors.textSub,
        suffixIconColor: AppColors.textSub,
      ),

      // BottomNavBar — flat, tidak ada rounded corner berlebihan
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceHover,
        selectedColor: AppColors.primaryBg,
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
        side: BorderSide(color: AppColors.border),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
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
