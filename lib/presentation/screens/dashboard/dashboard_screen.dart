import 'package:flutter/material.dart';
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
      height: 72,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(_navItems.length, (i) {
            final item = _navItems[i];
            final selected = i == _selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: selected ? 40 : 0,
                        height: selected ? 4 : 0,
                        margin: EdgeInsets.only(bottom: selected ? 4 : 0),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Icon(
                        selected ? item.activeIcon : item.icon,
                        color: selected ? AppColors.primary : AppColors.textHint,
                        size: 24,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: selected ? AppColors.primary : AppColors.textHint,
                          fontSize: 10,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
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

// ═══════════════════════════════════════════════════════
//  HOME SCREEN
// ═══════════════════════════════════════════════════════
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<_QuickActionData> _quickActions = const [
    _QuickActionData(Icons.search_rounded, 'Jelajahi', AppColors.primary, '/marketplace'),
    _QuickActionData(Icons.calculate_rounded, 'BEP', AppColors.gold, '/bep-simulation'),
    _QuickActionData(Icons.auto_awesome_rounded, 'AI Rekom', AppColors.primary, '/ai-recommendation'),
    _QuickActionData(Icons.psychology_rounded, 'AI Sim', AppColors.primary, '/ai-simulator'),
    _QuickActionData(Icons.timeline_rounded, 'Lacak', AppColors.primary, '/tracking'),
    _QuickActionData(Icons.school_rounded, 'Akademi', AppColors.primary, '/academy'),
    _QuickActionData(Icons.shield_rounded, 'Trust', AppColors.success, '/trust'),
    _QuickActionData(Icons.location_on_rounded, 'Lokasi', AppColors.primary, '/location-checker'),
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
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(context, user),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildPortfolioCard(user),
                const SizedBox(height: 24),
                _buildSectionTitle('Aksi Cepat'),
                const SizedBox(height: 12),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                _buildSectionTitle('Rekomendasi', trailing: _seeAllButton(context)),
                const SizedBox(height: 12),
                _buildRecommendedList(franchiseProvider),
                const SizedBox(height: 24),
                _buildFundingCard(fundingProvider),
                const SizedBox(height: 24),
                _buildActivityCard(),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context, user) {
    return SliverAppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      floating: true,
      snap: true,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      shadowColor: AppColors.border,
      toolbarHeight: 72,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.gradPrimary,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(children: [
                  TextSpan(text: 'Eazy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5)),
                  TextSpan(text: 'Chise', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: -0.5)),
                ]),
              ),
              Text(
                'Halo, ${user.name.split(' ').first}! 👋',
                style: const TextStyle(fontSize: 11, color: AppColors.textSub, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Consumer<NotificationProvider>(
          builder: (_, notif, __) => Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 24),
                onPressed: () => Navigator.pushNamed(context, '/notifications'),
              ),
              if (notif.unreadCount > 0)
                Positioned(
                  right: 10,
                  top: 10,
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
        gradient: const LinearGradient(
          colors: AppColors.gradCard,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.shadowPrimary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Portofolio', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(children: [
                  Icon(Icons.trending_up_rounded, color: Colors.white, size: 12),
                  SizedBox(width: 4),
                  Text('+12.5%', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Rp 2.500.000.000', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          const Text('Diperbarui hari ini', style: TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.white.withOpacity(0.15)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildCardStat('Franchise Aktif', '${user.activeFranchises}', Icons.store_rounded)),
              Container(width: 1, height: 36, color: Colors.white.withOpacity(0.2)),
              Expanded(child: _buildCardStat('Total Investasi', 'Rp ${(user.totalInvestment / 1000000).toStringAsFixed(0)}Jt', Icons.account_balance_rounded)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardStat(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white60, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
              const SizedBox(height: 1),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
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
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: _quickActions.length,
      itemBuilder: (_, i) {
        final a = _quickActions[i];
        return GestureDetector(
          onTap: () {
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
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: a.color == AppColors.gold ? AppColors.goldBg : AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: a.color == AppColors.gold ? AppColors.gold.withOpacity(0.2) : AppColors.primary.withOpacity(0.15),
                  ),
                ),
                child: Icon(a.icon, color: a.color, size: 24),
              ),
              const SizedBox(height: 6),
              Text(a.label, style: const TextStyle(fontSize: 10, color: AppColors.textSub, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecommendedList(FranchiseProvider provider) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: provider.recommended.length,
        itemBuilder: (_, i) {
          final f = provider.recommended[i];
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Stack(
                    children: [
                      Container(
                        height: 110,
                        width: double.infinity,
                        color: AppColors.surfaceDim,
                        child: Image.network(f.images, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.store_rounded, size: 40, color: AppColors.textHint)),
                      ),
                      Positioned(
                        top: 8, right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(6)),
                          child: Row(children: [
                            const Icon(Icons.star_rounded, color: AppColors.gold, size: 11),
                            const SizedBox(width: 3),
                            Text(f.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(f.category, style: const TextStyle(color: AppColors.textHint, fontSize: 10)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rp ${(f.investmentMin / 1000000).toStringAsFixed(0)}Jt', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(5)),
                            child: Text('ROI ${f.roi}%', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.success)),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Progres Pendanaan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primaryBg, borderRadius: BorderRadius.circular(6)),
                child: Text('${fp.activeFundings.length} Proyek', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.bg,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _fundingStat('Terkumpul', 'Rp ${(fp.totalFundedAmount / 1000000).toStringAsFixed(1)}Jt', AppColors.primary),
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
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
      ],
    );
  }

  Widget _buildActivityCard() {
    final activities = [
      _ActivityData(Icons.check_circle_rounded, 'Pendanaan disetujui', 'BEP Bakso Solo — Rp 50Jt', AppColors.success, '2j lalu'),
      _ActivityData(Icons.pending_rounded, 'Pengajuan diproses', 'Franchise Kopi Kekinian', AppColors.warning, '5j lalu'),
      _ActivityData(Icons.store_rounded, 'Outlet baru dibuka', 'Bakso Solo Cab. Depok', AppColors.primary, '1h lalu'),
    ];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Aktivitas Terkini', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          ...activities.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: a.color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(a.icon, color: a.color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                      Text(a.subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSub)),
                    ],
                  ),
                ),
                Text(a.time, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
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
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.3)),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _seeAllButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketplaceScreen())),
      child: const Text('Lihat Semua', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
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
