import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/models/franchisor_verification_model.dart';
import 'package:eazychise/core/models/user_model.dart';
import 'package:eazychise/core/providers/auth_provider.dart';
import 'package:eazychise/core/providers/verification_provider.dart';
import 'package:eazychise/presentation/screens/auth/login_screen.dart';
import 'package:eazychise/presentation/screens/verification/franchise_verification_screen.dart';
import 'package:eazychise/presentation/screens/verification/verification_status_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _isEditing = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser!;

    // Initialize controllers with user data
    if (_nameController.text.isEmpty) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.check_rounded : Icons.edit_rounded,
              color: _isEditing ? AppColors.success : AppColors.primary,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
              
              if (!_isEditing) {
                // Save changes
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Profil berhasil diperbarui'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(20),
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.shadowSm,
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.surfaceDim,
                              backgroundImage: user.photoUrl != null
                                  ? NetworkImage(user.photoUrl!)
                                  : null,
                              child: user.photoUrl == null
                                  ? Text(
                                      user.name[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  // Change photo
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.surface, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (!_isEditing) ...[
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: AppColors.textSub,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildRoleBadge(context),
                            _buildVerificationBadge(),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Edit Form fields (if editing)
                if (_isEditing) ...[
                  _buildEditableField(
                    'Nama Lengkap',
                    _nameController,
                    Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildEditableField(
                    'Email',
                    _emailController,
                    Icons.email_outlined,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  _buildEditableField(
                    'Nomor Telepon',
                    _phoneController,
                    Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                ],

                // Stats Cards
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.shadowSm,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              'Franchise Aktif',
                              user.activeFranchises.toString(),
                              Icons.storefront_rounded,
                              AppColors.primary,
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: AppColors.border,
                          ),
                          Expanded(
                            child: _buildStatItem(
                              'Total Investasi',
                              'Rp ${(user.totalInvestment / 1000000).toStringAsFixed(0)}Jt',
                              Icons.trending_up_rounded,
                              AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24, color: AppColors.border),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              'Tingkat Sukses',
                              '92%',
                              Icons.analytics_rounded,
                              AppColors.warning,
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: AppColors.border,
                          ),
                          Expanded(
                            child: _buildStatItem(
                              'Member Sejak',
                              '2024',
                              Icons.calendar_today_rounded,
                              AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Section Title: Pengaturan
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pengaturan Akun',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Menu list items
                ...List.generate(
                  user.role == 'franchisor' ? 7 : 6,
                  (index) {
                    final menuItems = [
                      if (user.role == 'franchisor')
                        {
                          'icon': Icons.dashboard_rounded,
                          'title': 'Dashboard Franchisor',
                          'trailing': null,
                          'color': AppColors.primary,
                          'route': '/franchisor-dashboard',
                        },
                      {
                        'icon': Icons.storefront_rounded,
                        'title': 'Daftarkan Franchise Saya',
                        'trailing': null,
                        'color': AppColors.primary,
                        'isVerification': true,
                      },
                      {
                        'icon': Icons.bookmark_rounded,
                        'title': 'Franchise Tersimpan',
                        'trailing': '12',
                        'color': AppColors.accent,
                        'isVerification': false,
                      },
                      {
                        'icon': Icons.notifications_rounded,
                        'title': 'Notifikasi',
                        'trailing': '3',
                        'color': AppColors.warning,
                        'isVerification': false,
                      },
                      {
                        'icon': Icons.security_rounded,
                        'title': 'Privasi & Keamanan',
                        'trailing': null,
                        'color': AppColors.success,
                        'isVerification': false,
                      },
                      {
                        'icon': Icons.help_rounded,
                        'title': 'Pusat Bantuan',
                        'trailing': null,
                        'color': AppColors.info,
                        'isVerification': false,
                      },
                      {
                        'icon': Icons.info_rounded,
                        'title': 'Tentang Aplikasi',
                        'trailing': null,
                        'color': AppColors.textSub,
                        'isVerification': false,
                      },
                    ];

                    return _buildMenuItem(
                      icon: menuItems[index]['icon'] as IconData,
                      title: menuItems[index]['title'] as String,
                      trailing: menuItems[index]['trailing'] as String?,
                      color: menuItems[index]['color'] as Color,
                      isVerification: menuItems[index]['isVerification'] as bool? ?? false,
                      onTap: menuItems[index]['route'] != null
                          ? () => Navigator.pushNamed(context, menuItems[index]['route'] as String)
                          : (menuItems[index]['isVerification'] == true
                              ? _navigateToVerification
                              : () {}),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Logout Button
                OutlinedButton.icon(
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text(
                    'Keluar Akun',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: enabled ? AppColors.primary : AppColors.textHint,
          size: 20,
        ),
        filled: true,
        fillColor: enabled ? AppColors.bg : AppColors.surfaceDim,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSub,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? trailing,
    required Color color,
    required VoidCallback onTap,
    bool isVerification = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isVerification ? AppColors.primaryBg : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isVerification ? AppColors.primary.withOpacity(0.3) : AppColors.border,
          width: 1,
        ),
        boxShadow: AppColors.shadowSm,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isVerification ? AppColors.primary.withOpacity(0.1) : color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isVerification ? AppColors.primary : color,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isVerification ? FontWeight.w600 : FontWeight.w500,
            color: isVerification ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        subtitle: isVerification
            ? const Text(
                'Daftarkan untuk tampil di marketplace',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSub,
                ),
              )
            : null,
        trailing: trailing != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trailing,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : Icon(
                Icons.chevron_right_rounded,
                color: isVerification ? AppColors.primary : AppColors.textSecondary,
                size: 20,
              ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.errorBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Keluar dari Aplikasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Apakah Anda yakin ingin keluar?',
                  style: TextStyle(
                    color: AppColors.textSub,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(
                            color: AppColors.border,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<AuthProvider>(context, listen: false).logout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Keluar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleBadge(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isFranchisor = auth.isFranchisor;
    final label = isFranchisor ? 'Pemilik UMKM' : 'Calon Franchisee';
    final icon = isFranchisor ? Icons.store_rounded : Icons.person_rounded;
    final color = isFranchisor ? const Color(0xFF7C3AED) : AppColors.primary;
    final bg = isFranchisor ? const Color(0xFFF3E8FF) : AppColors.primaryBg;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationBadge() {
    return Consumer<VerificationProvider>(
      builder: (_, provider, __) {
        if (!provider.hasSubmission) return const SizedBox.shrink();
        final status = provider.currentStatus!;
        Color badgeColor;
        Color badgeBg;
        IconData badgeIcon;
        String badgeLabel;
        switch (status) {
          case VerificationStatus.verified:
            badgeColor = AppColors.primary;
            badgeBg = AppColors.primaryBg;
            badgeIcon = Icons.verified_rounded;
            badgeLabel = 'Terverifikasi';
            break;
          case VerificationStatus.rejected:
            badgeColor = AppColors.error;
            badgeBg = AppColors.errorBg;
            badgeIcon = Icons.cancel_rounded;
            badgeLabel = 'Ditolak';
            break;
          default:
            badgeColor = AppColors.warning;
            badgeBg = AppColors.warningBg;
            badgeIcon = Icons.hourglass_empty_rounded;
            badgeLabel = 'Diproses';
        }
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const VerificationStatusScreen(),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(badgeIcon, color: badgeColor, size: 12),
                const SizedBox(width: 4),
                Text(
                  badgeLabel,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: badgeColor, size: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToVerification() {
    final provider =
        Provider.of<VerificationProvider>(context, listen: false);
    if (provider.hasSubmission &&
        provider.currentStatus != VerificationStatus.rejected) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VerificationStatusScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => const FranchiseVerificationScreen()),
      );
    }
  }
}