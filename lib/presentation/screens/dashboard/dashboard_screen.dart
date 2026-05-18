import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/models/user_model.dart';
import 'package:eazychise/core/providers/auth_provider.dart';
import 'package:eazychise/core/providers/franchise_provider.dart';
import 'package:eazychise/core/providers/funding_provider.dart';
import 'package:eazychise/presentation/screens/marketplace/marketplace_screen.dart';
import 'package:eazychise/presentation/screens/ai_recommendation/ai_recommendation_screen.dart';
import 'package:eazychise/presentation/screens/bep_simulation/bep_simulation_screen.dart';
import 'package:eazychise/presentation/screens/funding/funding_screen.dart';
import 'package:eazychise/presentation/screens/tracking/tracking_screen.dart';
import 'package:eazychise/presentation/screens/profile/profile_screen.dart';
import 'package:eazychise/presentation/screens/academy/academy_screen.dart';
import 'package:eazychise/presentation/screens/trust_score_screen.dart';
import 'package:eazychise/core/providers/notification_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    const MarketplaceScreen(),
    const AIRecommendationScreen(),
    const FundingScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) {
                return _buildNavItem(
                  index: index,
                  icon: _getIcon(index),
                  label: _getLabel(index),
                  isSelected: _selectedIndex == index,
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textHint,
            size: 24,
          ),
          if (isSelected) ...[
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ] else ...[
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textHint,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ]
        ],
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.store_rounded;
      case 2:
        return Icons.auto_awesome_rounded;
      case 3:
        return Icons.account_balance_wallet_rounded;
      case 4:
        return Icons.person_rounded;
      default:
        return Icons.error;
    }
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Beranda';
      case 1:
        return 'Pasar';
      case 2:
        return 'AI';
      case 3:
        return 'Pendanaan';
      case 4:
        return 'Profil';
      default:
        return '';
    }
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<IconData> _recommendationIcons = [
    Icons.store,
    Icons.restaurant,
    Icons.coffee,
    Icons.shopping_bag,
    Icons.fitness_center,
  ];

  Color _getGradientColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.primaryDark,
      AppColors.primaryLight,
      AppColors.gold,
      AppColors.warning,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final franchiseProvider = Provider.of<FranchiseProvider>(context);
    final fundingProvider = Provider.of<FundingProvider>(context);
    final user = authProvider.currentUser!;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header greeting — flat white surface
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1),
                  boxShadow: AppColors.shadowSm,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primaryBg,
                      backgroundImage: user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null
                          ? Text(
                              user.name[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, ${user.name.split(' ').first}!',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Senang melihatmu kembali',
                            style: TextStyle(
                              color: AppColors.textSub,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer<NotificationProvider>(
                      builder: (context, notifProvider, child) {
                        return Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications_outlined,
                                  color: AppColors.textPrimary),
                              onPressed: () {
                                Navigator.pushNamed(context, '/notifications');
                              },
                            ),
                            if (notifProvider.unreadCount > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    notifProvider.unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Balance Card — solid primary flat color
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.shadowPrimary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Portofolio',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.visibility_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Rp 2.500.000.000',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '+12.5%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildBalanceItem(
                            'Aktif',
                            '${user.activeFranchises}',
                            Icons.store,
                          ),
                        ),
                        Container(height: 40, width: 1, color: Colors.white30),
                        Expanded(
                          child: _buildBalanceItem(
                            'Investasi',
                            'Rp ${(user.totalInvestment / 1000000).toStringAsFixed(0)}Jt',
                            Icons.trending_up,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quick Actions — flat no gradient
              const Text(
                'Aksi Cepat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
                children: [
                  _buildQuickAction(
                    icon: Icons.search,
                    label: 'Jelajahi',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MarketplaceScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.calculate,
                    label: 'BEP',
                    color: AppColors.gold,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BEPSimulationScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.auto_awesome,
                    label: 'AI Rekom',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AIRecommendationScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.psychology,
                    label: 'Simulasi AI',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.pushNamed(context, '/ai-simulator');
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.timeline,
                    label: 'Lacak',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrackingScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.school,
                    label: 'Akademi',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AcademyScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.shield,
                    label: 'Keamanan',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrustScoreScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.location_on,
                    label: 'Cek Lokasi',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.pushNamed(context, '/location-checker');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Recommended section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rekomendasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MarketplaceScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: franchiseProvider.recommended.length,
                  itemBuilder: (context, index) {
                    final franchise = franchiseProvider.recommended[index];
                    final icon = _recommendationIcons[index % _recommendationIcons.length];

                    return Container(
                      width: 240,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 1),
                        boxShadow: AppColors.shadowSm,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Container(
                              height: 100,
                              color: AppColors.primaryBg,
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(franchise.images),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: AppColors.gold,
                                            size: 12,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${4.5 + (index * 0.1)}'.substring(0, 3),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  franchise.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  franchise.category,
                                  style: const TextStyle(
                                    color: AppColors.textSub,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Modal',
                                          style: const TextStyle(
                                            color: AppColors.textSub,
                                            fontSize: 9,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Rp ${(franchise.investmentMin / 1000000).toStringAsFixed(0)}Jt',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.successBg,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.trending_up,
                                            size: 10,
                                            color: AppColors.success,
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            '${franchise.roi}%',
                                            style: const TextStyle(
                                              color: AppColors.success,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Funding Progress
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1),
                  boxShadow: AppColors.shadowSm,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progres Pendanaan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${fundingProvider.activeFundings.length} Proyek',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: fundingProvider.totalFundedAmount /
                            (fundingProvider.totalFundedAmount +
                                fundingProvider.totalPendingAmount),
                        backgroundColor: AppColors.bg,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFundingStat(
                          'Terkumpul',
                          'Rp ${fundingProvider.totalFundedAmount.toStringAsFixed(0)}',
                          AppColors.primary,
                        ),
                        _buildFundingStat(
                          'Target',
                          'Rp ${(fundingProvider.totalFundedAmount + fundingProvider.totalPendingAmount).toStringAsFixed(0)}',
                          AppColors.textSub,
                        ),
                        _buildFundingStat(
                          'Sisa Waktu',
                          '12 Hari',
                          AppColors.warning,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Recent Activity
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1),
                  boxShadow: AppColors.shadowSm,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Aktivitas Terkini',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textSub,
                          ),
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      separatorBuilder: (context, index) =>
                          Divider(height: 16, color: AppColors.divider),
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                index == 0
                                    ? Icons.arrow_upward
                                    : index == 1
                                        ? Icons.account_balance
                                        : Icons.notifications,
                                color: AppColors.primary,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    index == 0
                                        ? 'Investasi Berhasil'
                                        : index == 1
                                            ? 'Pendanaan Dibuka'
                                            : 'Pembaruan Portofolio',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    index == 0
                                        ? 'Anda telah berinvestasi di Franchise Mie'
                                        : index == 1
                                            ? 'Proyek baru tersedia untuk didanai'
                                            : 'Nilai portofolio Anda naik 5.2%',
                                    style: const TextStyle(
                                      color: AppColors.textSub,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${index + 2} jam lalu',
                              style: const TextStyle(
                                color: AppColors.textHint,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundingStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSub,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    );
  }
}
