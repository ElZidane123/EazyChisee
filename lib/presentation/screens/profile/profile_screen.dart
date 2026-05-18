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
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              title: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.only(left: 20, bottom: 16),
                child: const Text(
                  'Profil Saya',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.accent.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative Circles
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent.withOpacity(0.05),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              // Edit Button
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) => RotationTransition(
                      turns: child.key == const ValueKey('edit') 
                          ? Tween<double>(begin: 0, end: 1).animate(anim)
                          : Tween<double>(begin: 1, end: 0).animate(anim),
                      child: ScaleTransition(scale: anim, child: child),
                    ),
                    child: _isEditing
                        ? const Icon(Icons.check_rounded, key: ValueKey('check'))
                        : const Icon(Icons.edit_rounded, key: ValueKey('edit')),
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
                  color: _isEditing ? AppColors.success : AppColors.primary,
                ),
              ),
            ],
          ),

          // Profile Header
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Avatar dengan Animasi
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.accent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            backgroundImage: user.photoUrl != null
                                ? NetworkImage(user.photoUrl!)
                                : null,
                            child: user.photoUrl == null
                                ? Text(
                                    user.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.primary, AppColors.accent],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Name and Email (non-editing mode)
                    if (!_isEditing) ...[
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              user.email,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Badge role user
                      _buildRoleBadge(context),
                      const SizedBox(height: 8),
                      // Badge status verifikasi franchisor
                      _buildVerificationBadge(),
                    ],
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Edit Form
          if (_isEditing)
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
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
                  const SizedBox(height: 8),
                ]),
              ),
            ),

          // Stats Cards
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
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
                              height: 50,
                              width: 1,
                              color: AppColors.textHint.withOpacity(0.2),
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
                        const Divider(height: 32, color: Color.fromARGB(255, 210, 210, 210),),
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
                              height: 50,
                              width: 1,
                              color: AppColors.textHint.withOpacity(0.2),
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
                ),
                const SizedBox(height: 24),

                // Section Title
                const Text(
                  'Pengaturan Akun',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),

          // Menu Items
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
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

                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 500 + (index * 50)),
                    tween: Tween<double>(begin: 0, end: 1),
                    curve: Curves.easeOutCubic,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(20 * (1 - value), 0),
                        child: Opacity(opacity: value, child: child),
                      );
                    },
                    child: _buildMenuItem(
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
                    ),
                  );
                },
                childCount: user.role == 'franchisor' ? 7 : 6,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Logout Button
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ElevatedButton(
                  onPressed: _showLogoutDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.error,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.error),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded),
                      SizedBox(width: 8),
                      Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
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
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 400),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.textHint.withOpacity(0.2),
          ),
        ),
        child: TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: enabled ? AppColors.textSecondary : AppColors.textHint,
            ),
            prefixIcon: Icon(
              icon,
              color: enabled ? AppColors.primary : AppColors.textHint,
              size: 22,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
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
          color: isVerification
              ? AppColors.primary.withOpacity(0.3)
              : color.withOpacity(0.1),
          width: isVerification ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isVerification
                ? AppColors.primary.withOpacity(0.08)
                : Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: isVerification
                ? const LinearGradient(colors: AppColors.grad)
                : null,
            color: isVerification ? null : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isVerification ? Colors.white : color,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isVerification ? FontWeight.w700 : FontWeight.w500,
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  trailing,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
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
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
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
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Apakah Anda yakin ingin keluar?',
                  style: TextStyle(
                    color: AppColors.textSecondary,
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
                          side: BorderSide(
                            color: AppColors.textHint.withOpacity(0.5),
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

  /// Badge role user (Franchisee / Franchisor)
  Widget _buildRoleBadge(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isFranchisor = auth.isFranchisor;
    final label = isFranchisor ? 'Pemilik UMKM (Franchisor)' : 'Calon Franchisee';
    final icon = isFranchisor ? Icons.store_rounded : Icons.person_rounded;
    final color = isFranchisor ? const Color(0xFF7C3AED) : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Badge verifikasi franchisor di bawah email user
  Widget _buildVerificationBadge() {
    return Consumer<VerificationProvider>(
      builder: (_, provider, __) {
        if (!provider.hasSubmission) return const SizedBox.shrink();
        final status = provider.currentStatus!;
        Color badgeColor;
        IconData badgeIcon;
        String badgeLabel;
        switch (status) {
          case VerificationStatus.verified:
            badgeColor = AppColors.primary;
            badgeIcon = Icons.verified_rounded;
            badgeLabel = 'Franchisor Terverifikasi';
            break;
          case VerificationStatus.rejected:
            badgeColor = AppColors.error;
            badgeIcon = Icons.cancel_rounded;
            badgeLabel = 'Verifikasi Ditolak';
            break;
          default:
            badgeColor = AppColors.warning;
            badgeIcon = Icons.hourglass_empty_rounded;
            badgeLabel = 'Verifikasi Sedang Diproses';
        }
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const VerificationStatusScreen(),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: badgeColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(badgeIcon, color: badgeColor, size: 14),
                const SizedBox(width: 6),
                Text(
                  badgeLabel,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: badgeColor, size: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Navigate ke verifikasi atau status (jika sudah ada pengajuan)
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