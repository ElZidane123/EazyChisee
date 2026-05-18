import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/models/funding_model.dart';
import 'package:eazychise/core/providers/funding_provider.dart';
import 'package:eazychise/presentation/widgets/funding_card.dart';

class FundingScreen extends StatefulWidget {
  const FundingScreen({super.key});

  @override
  State<FundingScreen> createState() => _FundingScreenState();
}

class _FundingScreenState extends State<FundingScreen>
    with TickerProviderStateMixin { // GANTI: SingleTickerProviderStateMixin → TickerProviderStateMixin
  int _selectedTab = 0;
  late TabController _tabController;
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  final List<Map<String, dynamic>> _tabs = [
    {'label': 'Aktif', 'icon': Icons.rocket_launch_rounded},
    {'label': 'Menunggu', 'icon': Icons.hourglass_empty_rounded},
    {'label': 'Riwayat', 'icon': Icons.history_rounded},
  ];

  @override
  void initState() {
    super.initState();
    
    // Buat TabController
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {
          _selectedTab = _tabController.index;
        });
      }
    });
    
    // Buat AnimationController
    _animationController = AnimationController(
      vsync: this, // Bisa digunakan karena pakai TickerProviderStateMixin
      duration: const Duration(milliseconds: 800),
    )..forward();
    
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 50 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 50 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose(); // Jangan lupa dispose semua controller
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 160,
            floating: true,
            pinned: true,
            backgroundColor: _isScrolled 
                ? AppColors.surface.withOpacity(0.8)
                : Colors.transparent,
            elevation: _isScrolled ? 4 : 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              title: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.only(
                  left: 20,
                  bottom: _isScrolled ? 12 : 16,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pendanaan',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: _isScrolled ? 20 : 24,
                            letterSpacing: -0.5,
                          ),
                        ),
                        if (!_isScrolled)
                          Text(
                            'Kelola pendanaan Franchisemu',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.05),
                      AppColors.accent.withOpacity(0.05),
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              // Add Button
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
                  icon: const Icon(Icons.add_rounded),
                  onPressed: () => _showNewFundingDialog(context),
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Summary Cards
                _buildSummaryCards(),
                const SizedBox(height: 24),

                // Tab Bar
                _buildTabBar(),
                const SizedBox(height: 16),
              ]),
            ),
          ),

          // Funding List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: Consumer<FundingProvider>(
              builder: (context, provider, child) {
                List<FundingModel> fundings;
                switch (_selectedTab) {
                  case 0:
                    fundings = provider.activeFundings;
                    break;
                  case 1:
                    fundings = provider.pendingFundings;
                    break;
                  default:
                    fundings = provider.fundings;
                }

                if (fundings.isEmpty) {
                  return SliverFillRemaining(
                    child: _buildEmptyState(provider),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return TweenAnimationBuilder(
                        duration: Duration(milliseconds: 500 + (index * 50)),
                        tween: Tween<double>(begin: 0, end: 1),
                        curve: Curves.easeOutCubic,
                        builder: (context, double value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: FundingCard(
                            funding: fundings[index],
                            onTap: () {
                              _showFundingDetail(context, fundings[index]);
                            },
                          ),
                        ),
                      );
                    },
                    childCount: fundings.length,
                  ),
                );
              },
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Consumer<FundingProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Expanded(
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 600),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.easeOutCubic,
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: _buildSummaryCard(
                  title: 'Total Terdanai',
                  amount: provider.totalFundedAmount,
                  icon: Icons.account_balance_rounded,
                  color: AppColors.success,
                  gradientColors: [AppColors.success, const Color(0xFF34D399)],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 700),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.easeOutCubic,
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: _buildSummaryCard(
                  title: 'Menunggu',
                  amount: provider.totalPendingAmount,
                  icon: Icons.hourglass_empty_rounded,
                  color: AppColors.warning,
                  gradientColors: [AppColors.warning, const Color(0xFFFBBF24)],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
    required List<Color> gradientColors,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors.map((c) => c.withOpacity(0.1)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  amount > 0 ? '+${((amount / 1000000)).toStringAsFixed(1)}Jt' : '0',
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Rp ${amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                _tabController.animateTo(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: _selectedTab == index
                      ? LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  color: _selectedTab == index ? null : Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _tabs[index]['icon'],
                      size: 16,
                      color: _selectedTab == index
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _tabs[index]['label'],
                      style: TextStyle(
                        color: _selectedTab == index
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: _selectedTab == index
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState(FundingProvider provider) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 800),
              tween: Tween<double>(begin: 0, end: 1),
              curve: Curves.elasticOut,
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.1),
                          AppColors.accent.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 50,
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Belum Ada Pengajuan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mulai perjalanan Franchisemu dengan\nmengajukan pendanaan pertama',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _showNewFundingDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded),
                  SizedBox(width: 8),
                  Text('Ajukan Pendanaan'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewFundingDialog(BuildContext context) {
    final amountController = TextEditingController();
    final notesController = TextEditingController();
    String? selectedFranchise;
    int? selectedTenure;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textHint.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.accent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.add_card_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Text(
                            'Ajukan Pendanaan Baru',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Form(
                      key: formKey,
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(20),
                        children: [
                          // Franchise Dropdown
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.textHint.withOpacity(0.2),
                              ),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Pilih Franchise',
                                labelStyle: TextStyle(color: AppColors.textSecondary),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: '1',
                                  child: Row(
                                    children: [
                                      Icon(Icons.coffee, size: 18, color: AppColors.primary),
                                      SizedBox(width: 8),
                                      Text('Kopi Kenangan'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: '2',
                                  child: Row(
                                    children: [
                                      Icon(Icons.restaurant, size: 18, color: AppColors.primary),
                                      SizedBox(width: 8),
                                      Text('Mie Gacoan'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: '3',
                                  child: Row(
                                    children: [
                                      Icon(Icons.shopping_bag, size: 18, color: AppColors.primary),
                                      SizedBox(width: 8),
                                      Text('Miniso'),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: (value) => selectedFranchise = value,
                              validator: (value) {
                                if (value == null) {
                                  return 'Pilih Franchise';
                                }
                                return null;
                              },
                              icon: Icon(
                                Icons.arrow_drop_down_rounded,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Amount Field
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.textHint.withOpacity(0.2),
                              ),
                            ),
                            child: TextFormField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                labelText: 'Jumlah Pendanaan',
                                labelStyle: TextStyle(color: AppColors.textSecondary),
                                prefixText: 'Rp ',
                                prefixStyle: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukkan jumlah pendanaan';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tenure Dropdown
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.textHint.withOpacity(0.2),
                              ),
                            ),
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Jangka Waktu',
                                labelStyle: TextStyle(color: AppColors.textSecondary),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              items: [12, 24, 36, 48].map((months) {
                                return DropdownMenuItem(
                                  value: months,
                                  child: Text('$months bulan'),
                                );
                              }).toList(),
                              onChanged: (value) => selectedTenure = value,
                              validator: (value) {
                                if (value == null) {
                                  return 'Pilih jangka waktu';
                                }
                                return null;
                              },
                              icon: Icon(
                                Icons.arrow_drop_down_rounded,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Notes Field
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.textHint.withOpacity(0.2),
                              ),
                            ),
                            child: TextFormField(
                              controller: notesController,
                              maxLines: 3,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                labelText: 'Catatan Tambahan',
                                labelStyle: TextStyle(color: AppColors.textSecondary),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Summary Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.05),
                                  AppColors.accent.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                _buildSummaryRow(
                                  'Estimasi Cicilan',
                                  'Rp 2.500.000 / bulan',
                                  AppColors.primary,
                                ),
                                const SizedBox(height: 8),
                                _buildSummaryRow(
                                  'Bunga',
                                  '8.5% per tahun',
                                  AppColors.success,
                                ),
                                const SizedBox(height: 8),
                                _buildSummaryRow(
                                  'Biaya Admin',
                                  'Rp 250.000',
                                  AppColors.warning,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Action Buttons
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textSecondary,
                              side: BorderSide(
                                color: AppColors.textHint.withOpacity(0.5),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 12),
                                        const Expanded(
                                          child: Text(
                                            'Pengajuan pendanaan berhasil dikirim',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Kirim'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  void _showFundingDetail(BuildContext context, FundingModel funding) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textHint.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _getStatusColor(funding.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            _getStatusIcon(funding.status),
                            color: _getStatusColor(funding.status),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                funding.franchiseName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(funding.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  funding.status.toUpperCase(),
                                  style: TextStyle(
                                    color: _getStatusColor(funding.status),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        // Progress Card untuk Active Fundings
                        if (funding.status == 'approved' || funding.status == 'disbursed')
                          Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.1),
                                  AppColors.accent.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Progres Pendanaan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: funding.fundedAmount / funding.amount,
                                    minHeight: 8,
                                    backgroundColor: AppColors.surfaceDim,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Terkumpul: Rp ${funding.fundedAmount.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      'Target: Rp ${funding.amount.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        // Info Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.6,
                          children: [
                            _buildDetailInfoCard(
                              'Jumlah',
                              'Rp ${funding.amount.toStringAsFixed(0)}',
                              Icons.money_rounded,
                              AppColors.primary,
                            ),
                            _buildDetailInfoCard(
                              'Bunga',
                              '${funding.interestRate}%',
                              Icons.percent_rounded,
                              AppColors.warning,
                            ),
                            _buildDetailInfoCard(
                              'Tenor',
                              '${funding.tenureMonths} bulan',
                              Icons.timelapse_rounded,
                              AppColors.success,
                            ),
                            _buildDetailInfoCard(
                              'Terdanai',
                              '${((funding.fundedAmount / funding.amount) * 100).toStringAsFixed(1)}%',
                              Icons.pie_chart_rounded,
                              AppColors.accent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Timeline
                        const Text(
                          'Timeline',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTimelineItem(
                          'Pengajuan',
                          DateFormat('dd MMM yyyy').format(funding.applicationDate),
                          Icons.description_rounded,
                          true,
                        ),
                        if (funding.approvalDate != null)
                          _buildTimelineItem(
                            'Persetujuan',
                            DateFormat('dd MMM yyyy').format(funding.approvalDate!),
                            Icons.check_circle_rounded,
                            true,
                          ),
                        if (funding.disbursementDate != null)
                          _buildTimelineItem(
                            'Pencairan',
                            DateFormat('dd MMM yyyy').format(funding.disbursementDate!),
                            Icons.account_balance_rounded,
                            true,
                          ),
                        _buildTimelineItem(
                          'Jatuh Tempo',
                          DateFormat('dd MMM yyyy').format(
                            funding.applicationDate.add(
                              Duration(days: 30 * funding.tenureMonths),
                            ),
                          ),
                          Icons.event_rounded,
                          funding.status == 'disbursed',
                        ),
                        const SizedBox(height: 20),

                        // Notes
                        if (funding.notes != null) ...[
                          const Text(
                            'Catatan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              funding.notes!,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Action Button untuk Pending
                  if (funding.status == 'pending')
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showCancelConfirmation(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cancel_rounded),
                              SizedBox(width: 8),
                              Text('Batalkan Pengajuan'),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String date, IconData icon, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.textHint.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: isCompleted ? AppColors.success : AppColors.textHint,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isCompleted ? AppColors.textPrimary : AppColors.textHint,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: isCompleted ? AppColors.textSecondary : AppColors.textHint,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isCompleted)
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 18,
            ),
        ],
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Batalkan Pengajuan',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin membatalkan pengajuan pendanaan ini? Tindakan ini tidak dapat dibatalkan.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
              ),
              child: const Text('Tidak'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Pengajuan pendanaan dibatalkan'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(20),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Ya, Batalkan'),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'rejected':
        return AppColors.error;
      case 'disbursed':
        return AppColors.info;
      default:
        return AppColors.textHint;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle_rounded;
      case 'pending':
        return Icons.hourglass_empty_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      case 'disbursed':
        return Icons.account_balance_rounded;
      default:
        return Icons.help_rounded;
    }
  }
}