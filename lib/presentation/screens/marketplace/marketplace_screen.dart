import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/models/franchise_model.dart';
import 'package:eazychise/core/providers/franchise_provider.dart';

// ============================================================
// ORANGE COLOR PALETTE (same as dashboard)
// ============================================================
const Color _orangePrimary = Color(0xFFF85C2E);
const Color _orangeLight = Color(0xFFFFF0EA);
const Color _orangeBg = Color(0xFFFFF6F2);

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  RangeValues _investmentRange = const RangeValues(0, 1000);
  double _minROI = 15;
  String _selectedSort = 'Populer';

  final List<Map<String, dynamic>> _subCategories = [
    {'name': 'Semua', 'icon': Icons.restaurant_menu_rounded, 'filter': ''},
    {'name': 'Minuman', 'icon': Icons.local_cafe_rounded, 'filter': 'F&B'},
    {'name': 'Makanan', 'icon': Icons.dinner_dining_rounded, 'filter': 'F&B'},
    {'name': 'Dessert', 'icon': Icons.cake_rounded, 'filter': 'F&B'},
    {'name': 'Snack', 'icon': Icons.cookie_rounded, 'filter': 'F&B'},
  ];

  final List<String> _sortOptions = [
    'Populer',
    'ROI Tertinggi',
    'Modal Terendah',
    'Modal Tertinggi',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scrollController.addListener(_onScroll);
    _animationController.forward();
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
    _searchController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text(
          'Pasar Franchise',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.3),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _showFilterDialog,
            color: AppColors.textPrimary,
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildSubCategories(),
                const SizedBox(height: 24),
                _buildStatsCard(),
                const SizedBox(height: 24),
                _buildSortSection(),
                const SizedBox(height: 16),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: Consumer<FranchiseProvider>(
              builder: (context, provider, child) {
                final franchises = provider.franchises;
                if (franchises.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(provider),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildFranchiseItem(franchises[index], index),
                    childCount: franchises.length,
                  ),
                );
              },
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: (value) {
          Provider.of<FranchiseProvider>(context, listen: false).setSearchQuery(value);
        },
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Cari franchise...',
          hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: _focusNode.hasFocus ? _orangePrimary : AppColors.textHint,
            size: 22,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded, color: AppColors.textSub, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    Provider.of<FranchiseProvider>(context, listen: false).setSearchQuery('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.bg,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSubCategories() {
    return Consumer<FranchiseProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _subCategories.length,
            itemBuilder: (context, index) {
              final cat = _subCategories[index];
              final filterValue = cat['filter']?.toString() ?? '';
              final label = cat['name']?.toString() ?? '';
              final isSelected = provider.selectedCategory == filterValue;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  provider.setCategory(filterValue);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? _orangePrimary : Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: isSelected ? _orangePrimary : AppColors.border,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: _orangePrimary.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))]
                        : [],
                  ),
                  child: Row(
                    children: [
                      Icon(cat['icon'] as IconData, size: 18, color: isSelected ? Colors.white : AppColors.textSub),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total Franchise', '150+', Icons.storefront_rounded, _orangePrimary),
          Container(width: 1, height: 40, color: AppColors.divider),
          _buildStatItem('Rata-rata ROI', '25%', Icons.trending_up_rounded, AppColors.success),
          Container(width: 1, height: 40, color: AppColors.divider),
          _buildStatItem('Modal Minimal', 'Rp 50Jt', Icons.money_rounded, AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }

  Widget _buildSortSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Rekomendasi Franchise',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: AppColors.textPrimary),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _orangeLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSort,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: _orangePrimary, size: 20),
              items: _sortOptions.map((opt) {
                return DropdownMenuItem(value: opt, child: Text(opt, style: const TextStyle(fontSize: 13)));
              }).toList(),
              onChanged: (val) => setState(() => _selectedSort = val!),
              style: const TextStyle(color: _orangePrimary, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFranchiseItem(FranchiseModel franchise, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 20 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border.withOpacity(0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: () => _showFranchiseDetail(context, franchise),
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: AppColors.surfaceDim,
                      child: Image.network(
                        franchise.images,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.store_rounded, size: 40, color: AppColors.textHint),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                franchise.name,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _orangeLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star_rounded, color: _orangePrimary, size: 12),
                                  const SizedBox(width: 2),
                                  Text(franchise.rating.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          franchise.category,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSub),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Modal', style: TextStyle(fontSize: 10, color: AppColors.textHint)),
                                Text(
                                  'Rp ${(franchise.investmentMin / 1000000).toStringAsFixed(0)}Jt',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _orangePrimary),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('ROI', style: TextStyle(fontSize: 10, color: AppColors.textHint)),
                                Text(
                                  '${franchise.roi}%',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.success),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Payback', style: TextStyle(fontSize: 10, color: AppColors.textHint)),
                                Text(
                                  '${franchise.paybackPeriod} bln',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.warning),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(FranchiseProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(color: _orangeLight, shape: BoxShape.circle),
            child: Icon(Icons.search_off_rounded, size: 48, color: _orangePrimary.withOpacity(0.5)),
          ),
          const SizedBox(height: 20),
          const Text('Franchise Tidak Ditemukan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('Coba atur ulang kata kunci atau filter', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              provider.setSearchQuery('');
              provider.setCategory('');
              _searchController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _orangePrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Reset Filter'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Text('Filter', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const Text('Rentang Modal (Juta)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSub)),
                    const SizedBox(height: 12),
                    RangeSlider(
                      values: _investmentRange,
                      min: 0,
                      max: 1000,
                      divisions: 20,
                      labels: RangeLabels('Rp ${_investmentRange.start.round()}Jt', 'Rp ${_investmentRange.end.round()}Jt'),
                      onChanged: (v) => setState(() => _investmentRange = v),
                      activeColor: _orangePrimary,
                      inactiveColor: AppColors.divider,
                    ),
                    const SizedBox(height: 24),
                    const Text('ROI Minimum', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSub)),
                    const SizedBox(height: 12),
                    Slider(
                      value: _minROI,
                      min: 0,
                      max: 50,
                      divisions: 25,
                      label: '${_minROI.round()}%',
                      onChanged: (v) => setState(() => _minROI = v),
                      activeColor: _orangePrimary,
                      inactiveColor: AppColors.divider,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Text('${_minROI.round()}% atau lebih', style: const TextStyle(fontWeight: FontWeight.w600, color: _orangePrimary)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() {
                          _investmentRange = const RangeValues(0, 1000);
                          _minROI = 15;
                        }),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _orangePrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Terapkan'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFranchiseDetail(BuildContext context, FranchiseModel franchise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.info_rounded, color: _orangePrimary, size: 24),
                    const SizedBox(width: 12),
                    const Text('Detail Franchise', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        height: 200,
                        color: AppColors.surfaceDim,
                        child: Image.network(franchise.images, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.store, size: 60, color: AppColors.textHint)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(franchise.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: _orangeLight, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, color: _orangePrimary, size: 14),
                          const SizedBox(width: 4),
                          Text('${franchise.rating}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildDetailCard('Modal', 'Rp ${(franchise.investmentMin / 1000000).toStringAsFixed(0)} - ${(franchise.investmentMax / 1000000).toStringAsFixed(0)}Jt', Icons.money_rounded, _orangePrimary),
                        _buildDetailCard('ROI', '${franchise.roi}%', Icons.trending_up_rounded, AppColors.success),
                        _buildDetailCard('Payback', '${franchise.paybackPeriod} bln', Icons.timelapse_rounded, AppColors.warning),
                        _buildDetailCard('Outlet', franchise.totalOutlets.toString(), Icons.store_rounded, AppColors.accent),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Deskripsi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(franchise.description, style: const TextStyle(height: 1.5, color: AppColors.textSecondary)),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => HapticFeedback.lightImpact(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _orangePrimary),
                          foregroundColor: _orangePrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showFundingDialog(context, franchise),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _orangePrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Ajukan Pendanaan', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14), textAlign: TextAlign.center),
          Text(label, style: const TextStyle(color: AppColors.textSub, fontSize: 11)),
        ],
      ),
    );
  }

  void _showFundingDialog(BuildContext context, FranchiseModel franchise) {
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    int? selectedTenure;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.payments_rounded, color: _orangePrimary, size: 24),
                    const SizedBox(width: 12),
                    const Text('Ajukan Pendanaan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              Expanded(
                child: Form(
                  key: formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _orangeLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(width: 50, height: 50, color: Colors.white, child: Icon(Icons.store_rounded, color: _orangePrimary)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(franchise.name, style: const TextStyle(fontWeight: FontWeight.w700))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Jumlah Pendanaan', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixText: 'Rp ',
                          hintText: 'Minimal Rp 10.000.000',
                          filled: true,
                          fillColor: AppColors.bg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Masukkan jumlah' : null,
                      ),
                      const SizedBox(height: 16),
                      const Text('Jangka Waktu', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.bg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                        items: [12, 24, 36].map((m) => DropdownMenuItem(value: m, child: Text('$m bulan'))).toList(),
                        onChanged: (v) => selectedTenure = v,
                        validator: (v) => v == null ? 'Pilih tenor' : null,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: _orangeLight, borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                              Text('Cicilan per Bulan', style: TextStyle(color: AppColors.textSub)),
                              Text('Rp 2.500.000', style: TextStyle(fontWeight: FontWeight.w700, color: _orangePrimary)),
                            ]),
                            const SizedBox(height: 8),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                              Text('Bunga', style: TextStyle(color: AppColors.textSub)),
                              Text('8.5% per tahun', style: TextStyle(fontWeight: FontWeight.w600)),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
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
                                content: const Text('Pengajuan pendanaan berhasil dikirim'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: _orangePrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                        child: const Text('Kirim', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}