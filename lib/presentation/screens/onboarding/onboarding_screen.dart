import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/presentation/screens/onboarding/role_selection_screen.dart';

final _pages = [
  _OnboardingData(
    title: 'Franchise Terpercaya,\nSatu Platform',
    subtitle: '47 parameter verifikasi memastikan investasi Anda aman dan menguntungkan',
    icon: Icons.verified_rounded,
    accent: AppColors.primary,
    tag: '1.200+ Franchisee',
    tagIcon: Icons.people_rounded,
  ),
  _OnboardingData(
    title: 'AI Bantu Keputusan\nBisnis Anda',
    subtitle: 'Simulasi BEP, prediksi ROI, dan rekomendasi franchise sesuai profil Anda',
    icon: Icons.psychology_rounded,
    accent: Color(0xFF6C3FC8),
    tag: 'AI-Powered',
    tagIcon: Icons.auto_awesome_rounded,
  ),
  _OnboardingData(
    title: 'Gabung Komunitas\nFranchisee Sukses',
    subtitle: 'Mentor berpengalaman, forum komunitas, dan dukungan 24/7 menemani perjalanan bisnis Anda',
    icon: Icons.handshake_rounded,
    accent: AppColors.success,
    tag: 'Dukungan 24/7',
    tagIcon: Icons.support_agent_rounded,
  ),
];

class _OnboardingData {
  final String title, subtitle, tag;
  final IconData icon, tagIcon;
  final Color accent;
  const _OnboardingData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.tag,
    required this.tagIcon,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final _pageCtrl = PageController();
  int _current = 0;
  late AnimationController _contentCtrl;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
    _contentCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _goNext() {
    HapticFeedback.lightImpact();
    if (_current < _pages.length - 1) {
      _pageCtrl.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
    } else {
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => const RoleSelectionScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_current];
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: AppColors.gradPrimary, begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 8),
                  const Text('EazyChise', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.3)),
                  const Spacer(),
                  if (_current < _pages.length - 1)
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RoleSelectionScreen())),
                      child: const Text('Lewati', style: TextStyle(color: AppColors.textSub, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: (i) {
                  setState(() => _current = i);
                  _contentCtrl.forward(from: 0);
                },
                itemCount: _pages.length,
                itemBuilder: (_, i) => _PageContent(data: _pages[i], ctrl: _contentCtrl),
              ),
            ),
            // Bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      final sel = i == _current;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: sel ? 24 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: sel ? page.accent : AppColors.border,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  // CTA Button
                  GestureDetector(
                    onTap: _goNext,
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [page.accent, page.accent.withOpacity(0.8)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: page.accent.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _current == _pages.length - 1 ? 'Mulai Sekarang' : 'Lanjut',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _current == _pages.length - 1 ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                            color: Colors.white, size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final _OnboardingData data;
  final AnimationController ctrl;
  const _PageContent({required this.data, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          _Illustration(data: data),
          const SizedBox(height: 40),
          // Tag badge
          FadeTransition(
            opacity: CurvedAnimation(parent: ctrl, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: data.accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: data.accent.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(data.tagIcon, color: data.accent, size: 14),
                  const SizedBox(width: 6),
                  Text(data.tag, style: TextStyle(color: data.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          FadeTransition(
            opacity: CurvedAnimation(parent: ctrl, curve: const Interval(0.1, 0.7, curve: Curves.easeOut)),
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
                  .animate(CurvedAnimation(parent: ctrl, curve: const Interval(0.1, 0.7, curve: Curves.easeOutCubic))),
              child: Text(data.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.2, letterSpacing: -0.8)),
            ),
          ),
          const SizedBox(height: 12),
          // Subtitle
          FadeTransition(
            opacity: CurvedAnimation(parent: ctrl, curve: const Interval(0.2, 0.8, curve: Curves.easeOut)),
            child: Text(data.subtitle, style: const TextStyle(fontSize: 15, color: AppColors.textSub, height: 1.65)),
          ),
        ],
      ),
    );
  }
}

class _Illustration extends StatefulWidget {
  final _OnboardingData data;
  const _Illustration({required this.data});
  @override
  State<_Illustration> createState() => _IllustrationState();
}

class _IllustrationState extends State<_Illustration> with SingleTickerProviderStateMixin {
  late AnimationController _float;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _float,
      builder: (_, __) {
        final y = Tween<double>(begin: -8, end: 8).evaluate(CurvedAnimation(parent: _float, curve: Curves.easeInOut));
        return Transform.translate(
          offset: Offset(0, y * 0.5),
          child: SizedBox(
            width: 220, height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 220, height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.data.accent.withOpacity(0.05),
                    border: Border.all(color: widget.data.accent.withOpacity(0.1), width: 1.5),
                  ),
                ),
                // Mid ring
                Container(
                  width: 160, height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.data.accent.withOpacity(0.08),
                    border: Border.all(color: widget.data.accent.withOpacity(0.18), width: 1.5),
                  ),
                ),
                // Center circle
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [widget.data.accent, widget.data.accent.withOpacity(0.75)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [BoxShadow(color: widget.data.accent.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 12))],
                  ),
                  child: Icon(widget.data.icon, color: Colors.white, size: 44),
                ),
                // Floating badge 1
                Positioned(
                  top: 20, right: 12,
                  child: Transform.translate(
                    offset: Offset(0, -y),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: AppColors.shadowSm,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.star_rounded, color: AppColors.gold, size: 14),
                        const SizedBox(width: 4),
                        const Text('4.9', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      ]),
                    ),
                  ),
                ),
                // Floating badge 2
                Positioned(
                  bottom: 24, right: 8,
                  child: Transform.translate(
                    offset: Offset(0, y),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: AppColors.shadowSm,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.shield_rounded, color: AppColors.success, size: 14),
                        SizedBox(width: 4),
                        Text('Terverifikasi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      ]),
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
