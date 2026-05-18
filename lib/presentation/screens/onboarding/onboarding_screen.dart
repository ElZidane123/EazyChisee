import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/presentation/screens/onboarding/role_selection_screen.dart';

class _OnboardingData {
  final String title;
  final String subtitle;
  final List<IconData> icons;
  final List<Color> iconColors;
  final Color accentColor;

  const _OnboardingData({
    required this.title,
    required this.subtitle,
    required this.icons,
    required this.iconColors,
    required this.accentColor,
  });
}

final _pages = [
  _OnboardingData(
    title: 'Franchise Terpercaya,\nSatu Platform',
    subtitle: '47 parameter verifikasi memastikan investasi Anda aman',
    icons: [Icons.storefront_rounded, Icons.shield_rounded, Icons.trending_up_rounded],
    iconColors: [AppColors.primary, AppColors.success, AppColors.accent],
    accentColor: AppColors.primary,
  ),
  _OnboardingData(
    title: 'AI Bantu Keputusan\nBisnis Anda',
    subtitle: 'Simulasi BEP, prediksi ROI, dan rekomendasi franchise sesuai profil Anda',
    icons: [Icons.psychology_rounded, Icons.bar_chart_rounded, Icons.auto_awesome_rounded],
    iconColors: [Color(0xFF7C3AED), Color(0xFF0EA5E9), AppColors.accent],
    accentColor: Color(0xFF7C3AED),
  ),
  _OnboardingData(
    title: 'Gabung 1.200+\nFranchisee Sukses',
    subtitle: 'Komunitas, mentor ahli, dan dukungan 24/7 siap membantu perjalanan bisnis Anda',
    icons: [Icons.people_rounded, Icons.location_on_rounded, Icons.handshake_rounded],
    iconColors: [AppColors.success, AppColors.error, AppColors.accent],
    accentColor: AppColors.success,
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;
  late AnimationController _contentCtrl;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _goNext() {
    HapticFeedback.lightImpact();
    if (_currentPage < _pages.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 480),
        curve: Curves.easeOutCubic,
      );
    } else {
      _goToRoleSelection();
    }
  }

  void _goToRoleSelection() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const RoleSelectionScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: (i) {
                  setState(() => _currentPage = i);
                  _contentCtrl.forward(from: 0);
                },
                itemCount: _pages.length,
                itemBuilder: (_, i) => _PageContent(
                  data: _pages[i],
                  ctrl: _contentCtrl,
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 20, 0),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.grad,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          const Text(
            'EazyChise',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          if (_currentPage < _pages.length - 1)
            TextButton(
              onPressed: _goToRoleSelection,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSub,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              child: const Text(
                'Lewati',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final isLast = _currentPage == _pages.length - 1;
    final accent = _pages[_currentPage].accentColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (i) {
              final sel = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: sel ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: sel ? accent : AppColors.divider,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 28),
          // CTA
          GestureDetector(
            onTap: _goNext,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent, accent.withOpacity(0.8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLast ? 'Mulai Sekarang' : 'Lanjut',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isLast ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════
//  PAGE CONTENT
// ══════════════════════════════════════════════════
class _PageContent extends StatelessWidget {
  final _OnboardingData data;
  final AnimationController ctrl;

  const _PageContent({required this.data, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Illustration
          Center(child: _Illustration(data: data)),
          const SizedBox(height: 48),
          // Title
          _FadeSlide(
            ctrl: ctrl,
            delay: 0.0,
            child: Text(
              data.title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.2,
                letterSpacing: -0.8,
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Subtitle
          _FadeSlide(
            ctrl: ctrl,
            delay: 0.15,
            child: Text(
              data.subtitle,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.65,
              ),
            ),
          ),
          const SizedBox(height: 28),
          // Accent bar
          _FadeSlide(
            ctrl: ctrl,
            delay: 0.25,
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: data.accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════
//  ILLUSTRATION — 3 circles with icons
// ══════════════════════════════════════════════════
class _Illustration extends StatefulWidget {
  final _OnboardingData data;
  const _Illustration({required this.data});

  @override
  State<_Illustration> createState() => _IllustrationState();
}

class _IllustrationState extends State<_Illustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatCtrl,
      builder: (_, __) {
        final float = Tween<double>(begin: -7, end: 7).evaluate(
          CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
        );
        final floatReverse = float * -1;

        return Transform.translate(
          offset: Offset(0, float * 0.5),
          child: SizedBox(
            width: 210,
            height: 210,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.data.accentColor.withOpacity(0.06),
                    border: Border.all(
                      color: widget.data.accentColor.withOpacity(0.14),
                      width: 1.5,
                    ),
                  ),
                ),
                // Middle ring
                Container(
                  width: 155,
                  height: 155,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.data.accentColor.withOpacity(0.09),
                    border: Border.all(
                      color: widget.data.accentColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                ),
                // Center
                Container(
                  width: 94,
                  height: 94,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        widget.data.accentColor,
                        widget.data.accentColor.withOpacity(0.75),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.data.accentColor.withOpacity(0.3),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.data.icons[0],
                    color: Colors.white,
                    size: 38,
                  ),
                ),
                // Satellite 1 — top right
                Positioned(
                  top: 18,
                  right: 10,
                  child: Transform.translate(
                    offset: Offset(0, floatReverse),
                    child: _SatIcon(
                      icon: widget.data.icons[1],
                      color: widget.data.iconColors[1],
                    ),
                  ),
                ),
                // Satellite 2 — bottom right
                Positioned(
                  bottom: 18,
                  right: 10,
                  child: Transform.translate(
                    offset: Offset(0, float),
                    child: _SatIcon(
                      icon: widget.data.icons[2],
                      color: widget.data.iconColors[2],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SatIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _SatIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

// ══════════════════════════════════════════════════
//  FADE SLIDE HELPER
// ══════════════════════════════════════════════════
class _FadeSlide extends StatelessWidget {
  final AnimationController ctrl;
  final double delay;
  final Widget child;

  const _FadeSlide({required this.ctrl, required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    final start = delay.clamp(0.0, 0.9);
    final end = (start + 0.5).clamp(0.0, 1.0);

    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: ctrl,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: ctrl,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        )),
        child: child,
      ),
    );
  }
}
