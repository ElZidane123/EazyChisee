// ════════════════════════════════════════════════════════════════
//  EazyChise · RoleSelectionScreen
//  Pilih peran: Franchisee atau Franchisor
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eazychise/core/constants/app_colors.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  String? _selectedRole;
  bool _isLoading = false;

  late AnimationController _enterCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_selectedRole == null) return;
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', _selectedRole!);
    await prefs.setBool('onboarding_done', true);

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // Header
                  _buildHeader(),

                  const SizedBox(height: 40),

                  // Role Cards
                  _RoleCard(
                    role: 'franchisee',
                    selected: _selectedRole == 'franchisee',
                    icon: Icons.person_rounded,
                    title: 'Saya Calon Franchisee',
                    description:
                        'Saya ingin mencari dan berinvestasi di franchise terpercaya yang sesuai dengan profil dan anggaran saya.',
                    accentColor: AppColors.primary,
                    features: const [
                      'Akses 500+ franchise premium',
                      'Analisis ROI & BEP otomatis',
                      'Rekomendasi AI personal',
                    ],
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedRole = 'franchisee');
                    },
                  ),

                  const SizedBox(height: 16),

                  _RoleCard(
                    role: 'franchisor',
                    selected: _selectedRole == 'franchisor',
                    icon: Icons.store_rounded,
                    title: 'Saya Pemilik UMKM (Franchisor)',
                    description:
                        'Saya memiliki bisnis dan ingin mendaftarkan franchise serta mengakses pendanaan untuk ekspansi.',
                    accentColor: const Color(0xFF7C3AED),
                    features: const [
                      'Daftarkan franchise ke marketplace',
                      'Akses pendanaan ekspansi',
                      'Kelola cabang & franchisee',
                    ],
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedRole = 'franchisor');
                    },
                  ),

                  const Spacer(),

                  // CTA
                  _buildCTA(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo pill
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.grad,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 17),
            ),
            const SizedBox(width: 8),
            const Text(
              'EazyChise',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textSub,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Siapa Anda?',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -1,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Pilih peran Anda agar kami dapat menyesuaikan\npengalaman terbaik untuk Anda.',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildCTA() {
    final isEnabled = _selectedRole != null && !_isLoading;
    return GestureDetector(
      onTap: isEnabled ? _confirm : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: isEnabled
              ? const LinearGradient(
                  colors: AppColors.grad,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isEnabled ? null : AppColors.surfaceDim,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  'Lanjutkan',
                  style: TextStyle(
                    color: isEnabled ? Colors.white : AppColors.textHint,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════
//  ROLE CARD
// ══════════════════════════════════════════════════
class _RoleCard extends StatelessWidget {
  final String role;
  final bool selected;
  final IconData icon;
  final String title;
  final String description;
  final Color accentColor;
  final List<String> features;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.selected,
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.features,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? accentColor.withOpacity(0.05) : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? accentColor : AppColors.divider,
            width: selected ? 2 : 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: selected
                        ? accentColor.withOpacity(0.15)
                        : AppColors.surfaceDim,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: selected ? accentColor : AppColors.textSub,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: selected ? accentColor : AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                // Check indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? accentColor : Colors.transparent,
                    border: Border.all(
                      color: selected ? accentColor : AppColors.divider,
                      width: 2,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 14),
            // Features
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 15,
                      color: selected ? accentColor : AppColors.textHint,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      f,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: selected ? AppColors.textPrimary : AppColors.textSub,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
