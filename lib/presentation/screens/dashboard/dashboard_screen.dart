import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:eazychise/core/constants/app_colors.dart';
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

// ============================================================
// MODERN ORANGE COLOR PALETTE (No gradients)
// ============================================================
const Color _orangePrimary = Color(0xFFF85C2E);
const Color _orangeLight = Color(0xFFFFF0EA);
const Color _orangeDark = Color(0xFFE04A1F);
const Color _orangeBg = Color(0xFFFFF6F2);
const Color _orangeSoft = Color(0xFFFFA07A);

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

  static const List<_NavItem> _navItems = [
    _NavItem(Icons.home_rounded, Icons.home_outlined, 'Beranda'),
    _NavItem(Icons.storefront_rounded, Icons.storefront_outlined, 'Pasar'),
    _NavItem(Icons.auto_awesome_rounded, Icons.auto_awesome_outlined, 'AI'),
    _NavItem(Icons.account_balance_wallet_rounded, Icons.account_balance_wallet_outlined, 'Dana'),
    _NavItem(Icons.person_rounded, Icons.person_outlined, 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(_navItems.length, (i) {
            final item = _navItems[i];
            final selected = i == _selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedIndex = i);
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        scale: selected ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          selected ? item.activeIcon : item.icon,
                          color: selected ? _orangePrimary : AppColors.textHint,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            color: selected ? _orangePrimary : AppColors.textHint,
                            fontSize: 11,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData activeIcon;
  final IconData icon;
  final String label;
  const _NavItem(this.activeIcon, this.icon, this.label);
}

// ============================================================
// MODERN HOME SCREEN - ELEGANT & HUMAN-CENTRIC
// ============================================================
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<_QuickActionData> _quickActions = const [
    _QuickActionData(Icons.search_rounded, 'Jelajahi', _orangePrimary, '/marketplace'),
    _QuickActionData(Icons.calculate_rounded, 'BEP', _orangePrimary, '/bep-simulation'),
    _QuickActionData(Icons.auto_awesome_rounded, 'AI Rekom', _orangePrimary, '/ai-recommendation'),
    _QuickActionData(Icons.psychology_rounded, 'AI Sim', _orangePrimary, '/ai-simulator'),
    _QuickActionData(Icons.timeline_rounded, 'Lacak', _orangePrimary, '/tracking'),
    _QuickActionData(Icons.school_rounded, 'Akademi', _orangePrimary, '/academy'),
    _QuickActionData(Icons.shield_rounded, 'Trust', _orangePrimary, '/trust'),
    _QuickActionData(Icons.location_on_rounded, 'Lokasi', _orangePrimary, '/location-checker'),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final franchiseProvider = Provider.of<FranchiseProvider>(context);
    final fundingProvider = Provider.of<FundingProvider>(context);
    final user = auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: _orangePrimary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          _buildModernHeader(context, user),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildPortfolioCard(user),
                const SizedBox(height: 28),
                _buildSectionTitle('Akses Cepat'),
                const SizedBox(height: 0),
                _buildQuickActions(context),
                const SizedBox(height: 28),
                _buildSectionTitle('Rekomendasi untuk Anda', trailing: _seeAllButton(context)),
                const SizedBox(height: 16),
                _buildRecommendedList(franchiseProvider),
                const SizedBox(height: 28),
                _buildFundingCard(fundingProvider),
                const SizedBox(height: 24),
                _buildActivityCard(),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context, user) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      floating: true,
      snap: true,
      elevation: 0,
      toolbarHeight: 80,
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _orangeLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.storefront_rounded, color: _orangePrimary, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'EazyChise',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Halo, ${user.name.split(' ').first} 👋',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSub,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Consumer<NotificationProvider>(
          builder: (_, notif, __) => Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: _orangeLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 22),
                  onPressed: () => Navigator.pushNamed(context, '/notifications'),
                ),
              ),
              if (notif.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildPortfolioCard(user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _orangePrimary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: _orangePrimary.withOpacity(0.25), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Portofolio',
                style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text('+12.5%', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
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
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Terakhir diperbarui hari ini',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 24),
          Divider(height: 1, color: Colors.white.withOpacity(0.15)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildCardStat('Franchise Aktif', '${user.activeFranchises}', Icons.store_rounded)),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
              Expanded(child: _buildCardStat('Total Investasi', 'Rp ${(user.totalInvestment / 1000000).toStringAsFixed(0)}Jt', Icons.account_balance_rounded)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardStat(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _quickActions.length,
      itemBuilder: (_, i) {
        final a = _quickActions[i];
        return GestureDetector(
          onTap: () {
            // Haptic feedback
            HapticFeedback.lightImpact();
            if (a.route == '/academy') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AcademyScreen()));
            } else if (a.route == '/marketplace') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketplaceScreen()));
            } else if (a.route == '/tracking') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackingScreen()));
            } else if (a.route == '/trust') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => TrustScoreScreen()));
            } else if (a.route == '/ai-recommendation') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AIRecommendationScreen()));
            } else if (a.route == '/bep-simulation') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const BEPSimulationScreen()));
            } else {
              Navigator.pushNamed(context, a.route);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 60,
                decoration: BoxDecoration(
                  color: _orangeBg,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Icon(a.icon, color: _orangePrimary, size: 28),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  a.label,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSub, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecommendedList(FranchiseProvider provider) {
    if (provider.recommended.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: provider.recommended.length,
        itemBuilder: (_, i) {
          final f = provider.recommended[i];
          return Container(
            width: 210,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Stack(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        color: AppColors.surfaceDim,
                        child: Image.network(
                          f.images,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.store_rounded, size: 48, color: AppColors.textHint),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4)],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: _orangePrimary, size: 12),
                              const SizedBox(width: 4),
                              Text(f.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f.name,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(f.category, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp ${(f.investmentMin / 1000000).toStringAsFixed(0)}Jt',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: _orangePrimary),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.successBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'ROI ${f.roi}%',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.success),
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
    );
  }

  Widget _buildFundingCard(FundingProvider fp) {
    final total = fp.totalFundedAmount + fp.totalPendingAmount;
    final progress = total > 0 ? fp.totalFundedAmount / total : 0.0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progres Pendanaan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _orangeBg,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${fp.activeFundings.length} Proyek',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _orangePrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.bg,
              valueColor: const AlwaysStoppedAnimation<Color>(_orangePrimary),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _fundingStat('Terkumpul', 'Rp ${(fp.totalFundedAmount / 1000000).toStringAsFixed(1)}Jt', _orangePrimary),
              _fundingStat('Target', 'Rp ${(total / 1000000).toStringAsFixed(1)}Jt', AppColors.textSub),
              _fundingStat('Sisa', '12 Hari', AppColors.warning),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fundingStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildActivityCard() {
    final activities = [
      _ActivityData(Icons.check_circle_rounded, 'Pendanaan disetujui', 'BEP Bakso Solo — Rp 50Jt', AppColors.success, '2 jam lalu'),
      _ActivityData(Icons.pending_rounded, 'Pengajuan diproses', 'Franchise Kopi Kekinian', AppColors.warning, '5 jam lalu'),
      _ActivityData(Icons.store_rounded, 'Outlet baru dibuka', 'Bakso Solo Cab. Depok', _orangePrimary, '1 jam lalu'),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aktivitas Terkini',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 18),
          ...activities.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: a.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(a.icon, color: a.color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text(a.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSub)),
                        ],
                      ),
                    ),
                    Text(a.time, style: const TextStyle(fontSize: 11, color: AppColors.textHint, fontWeight: FontWeight.w500)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _seeAllButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketplaceScreen()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _orangeBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Lihat Semua',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _orangePrimary),
        ),
      ),
    );
  }
}

class _QuickActionData {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  const _QuickActionData(this.icon, this.label, this.color, this.route);
}

class _ActivityData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String time;
  const _ActivityData(this.icon, this.title, this.subtitle, this.color, this.time);
}