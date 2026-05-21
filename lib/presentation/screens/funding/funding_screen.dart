import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/models/funding_model.dart';
import 'package:eazychise/core/providers/funding_provider.dart';
import 'package:eazychise/presentation/widgets/funding_card.dart';

// ============================================================
// MODERN ORANGE COLOR PALETTE (No gradients)
// ============================================================
const Color _orangePrimary = Color(0xFFF85C2E);
const Color _orangeLight = Color(0xFFFFF0EA);
const Color _orangeBg = Color(0xFFFFF6F2);
const Color _orangeDark = Color(0xFFE04A1F);

class FundingScreen extends StatefulWidget {
  const FundingScreen({super.key});

  @override
  State<FundingScreen> createState() => _FundingScreenState();
}

class _FundingScreenState extends State<FundingScreen> with TickerProviderStateMixin {
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
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() => _selectedTab = _tabController.index);
    });
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward();
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
    _tabController.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0.5,
            title: const Text(
              'Pendanaan',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -0.5,
                color: AppColors.textPrimary,
              ),
            ),
            centerTitle: false,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                child: Material(
                  color: _orangeLight,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () => _showNewFundingDialog(context),
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.add_rounded, color: _orangePrimary, size: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                FadeTransition(
                  opacity: _animationController,
                  child: _buildSummaryCards(),
                ),
                const SizedBox(height: 28),
                _buildTabBar(),
                const SizedBox(height: 16),
              ]),
            ),
          ),
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
                    (context, index) => _buildFundingItem(fundings[index], index),
                    childCount: fundings.length,
                  ),
                );
              },
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
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
              child: _buildSummaryCard(
                title: 'Total Terdanai',
                amount: provider.totalFundedAmount,
                icon: Icons.account_balance_rounded,
                color: _orangePrimary,
                subtitle: 'Sudah cair',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Menunggu',
                amount: provider.totalPendingAmount,
                icon: Icons.hourglass_empty_rounded,
                color: AppColors.warning,
                subtitle: 'Diproses',
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
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: color, size: 20),
              ),
              if (amount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    '+${(amount / 1000000).toStringAsFixed(1)}Jt',
                    style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: AppColors.textSub, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            'Rp ${amount.toStringAsFixed(0)}',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? _orangePrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_tabs[index]['icon'], size: 18, color: isSelected ? Colors.white : AppColors.textSub),
                    const SizedBox(width: 6),
                    Text(
                      _tabs[index]['label'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSub,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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

  Widget _buildFundingItem(FundingModel funding, int index) {
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
            onTap: () => _showFundingDetail(context, funding),
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _orangeLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.storefront_rounded, color: _orangePrimary, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              funding.franchiseName,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _getStatusColor(funding.status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                funding.status.toUpperCase(),
                                style: TextStyle(color: _getStatusColor(funding.status), fontSize: 10, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Rp ${(funding.amount / 1000000).toStringAsFixed(0)}Jt',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _orangePrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tenor ${funding.tenureMonths} bln',
                            style: const TextStyle(color: AppColors.textSub, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (funding.status == 'approved' || funding.status == 'disbursed') ...[
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: funding.fundedAmount / funding.amount,
                        minHeight: 6,
                        backgroundColor: AppColors.surfaceDim,
                        valueColor: const AlwaysStoppedAnimation<Color>(_orangePrimary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Terkumpul: Rp ${(funding.fundedAmount / 1000000).toStringAsFixed(1)}Jt',
                          style: const TextStyle(color: AppColors.textSub, fontSize: 11),
                        ),
                        Text(
                          '${((funding.fundedAmount / funding.amount) * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: _orangePrimary),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(FundingProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(color: _orangeLight, shape: BoxShape.circle),
            child: Icon(Icons.account_balance_wallet_rounded, size: 48, color: _orangePrimary.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum Ada Pengajuan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai perjalanan Franchisemu dengan\nmengajukan pendanaan pertama',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: () => _showNewFundingDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _orangePrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.add_rounded), SizedBox(width: 8), Text('Ajukan Pendanaan', style: TextStyle(fontWeight: FontWeight.w700))],
            ),
          ),
        ],
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
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _orangeLight, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.add_card_rounded, color: _orangePrimary, size: 22)),
                    const SizedBox(width: 14),
                    const Expanded(child: Text('Ajukan Pendanaan Baru', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.5))),
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
                      _buildFormField(label: 'Pilih Franchise', child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                        items: const [
                          DropdownMenuItem(value: '1', child: Row(children: [Icon(Icons.coffee, size: 18, color: _orangePrimary), SizedBox(width: 8), Text('Kopi Kenangan')])),
                          DropdownMenuItem(value: '2', child: Row(children: [Icon(Icons.restaurant, size: 18, color: _orangePrimary), SizedBox(width: 8), Text('Mie Gacoan')])),
                          DropdownMenuItem(value: '3', child: Row(children: [Icon(Icons.shopping_bag, size: 18, color: _orangePrimary), SizedBox(width: 8), Text('Miniso')])),
                        ],
                        onChanged: (v) => selectedFranchise = v,
                        validator: (v) => v == null ? 'Pilih Franchise' : null,
                      )),
                      const SizedBox(height: 16),
                      _buildFormField(label: 'Jumlah Pendanaan', child: TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(prefixText: 'Rp ', border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
                        validator: (v) => v == null || v.isEmpty ? 'Masukkan jumlah' : null,
                      )),
                      const SizedBox(height: 16),
                      _buildFormField(label: 'Jangka Waktu', child: DropdownButtonFormField<int>(
                        decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                        items: [12, 24, 36, 48].map((m) => DropdownMenuItem(value: m, child: Text('$m bulan'))).toList(),
                        onChanged: (v) => selectedTenure = v,
                        validator: (v) => v == null ? 'Pilih tenor' : null,
                      )),
                      const SizedBox(height: 16),
                      _buildFormField(label: 'Catatan Tambahan', child: TextFormField(
                        controller: notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(16), hintText: 'Opsional'),
                      )),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: _orangeLight, borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            _buildSummaryRow('Estimasi Cicilan', 'Rp 2.500.000 / bulan', _orangePrimary),
                            const SizedBox(height: 10),
                            _buildSummaryRow('Bunga', '8.5% per tahun', AppColors.success),
                            const SizedBox(height: 10),
                            _buildSummaryRow('Biaya Admin', 'Rp 250.000', AppColors.warning),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w600)),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _orangePrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                        ),
                        child: const Text('Kirim', style: TextStyle(fontWeight: FontWeight.w700)),
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

  Widget _buildFormField({required String label, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSub)),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSub, fontSize: 13)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 13)),
      ],
    );
  }

  void _showFundingDetail(BuildContext context, FundingModel funding) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _orangeLight, borderRadius: BorderRadius.circular(14)), child: Icon(_getStatusIcon(funding.status), color: _getStatusColor(funding.status), size: 22)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(funding.franchiseName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: _getStatusColor(funding.status).withOpacity(0.1), borderRadius: BorderRadius.circular(30)),
                            child: Text(funding.status.toUpperCase(), style: TextStyle(color: _getStatusColor(funding.status), fontSize: 11, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    if (funding.status == 'approved' || funding.status == 'disbursed')
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(color: _orangeLight, borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Progres Pendanaan', style: TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: funding.fundedAmount / funding.amount,
                                minHeight: 8,
                                backgroundColor: Colors.white,
                                valueColor: const AlwaysStoppedAnimation<Color>(_orangePrimary),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Rp ${(funding.fundedAmount / 1000000).toStringAsFixed(1)}Jt', style: const TextStyle(fontWeight: FontWeight.w700)),
                                Text('Target Rp ${(funding.amount / 1000000).toStringAsFixed(0)}Jt', style: const TextStyle(color: AppColors.textSub, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.6,
                      children: [
                        _buildDetailCard('Jumlah', 'Rp ${(funding.amount / 1000000).toStringAsFixed(0)}Jt', Icons.money_rounded, _orangePrimary),
                        _buildDetailCard('Bunga', '${funding.interestRate}%', Icons.percent_rounded, AppColors.warning),
                        _buildDetailCard('Tenor', '${funding.tenureMonths} bulan', Icons.timelapse_rounded, AppColors.success),
                        _buildDetailCard('Terdanai', '${((funding.fundedAmount / funding.amount) * 100).toStringAsFixed(0)}%', Icons.pie_chart_rounded, AppColors.accent),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Timeline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                    const SizedBox(height: 16),
                    _buildTimelineItem('Pengajuan', DateFormat('dd MMM yyyy').format(funding.applicationDate), Icons.description_rounded, true),
                    if (funding.approvalDate != null)
                      _buildTimelineItem('Persetujuan', DateFormat('dd MMM yyyy').format(funding.approvalDate!), Icons.check_circle_rounded, true),
                    if (funding.disbursementDate != null)
                      _buildTimelineItem('Pencairan', DateFormat('dd MMM yyyy').format(funding.disbursementDate!), Icons.account_balance_rounded, true),
                    _buildTimelineItem(
                      'Jatuh Tempo',
                      DateFormat('dd MMM yyyy').format(funding.applicationDate.add(Duration(days: 30 * funding.tenureMonths))),
                      Icons.event_rounded,
                      funding.status == 'disbursed',
                    ),
                    if (funding.notes != null) ...[
                      const SizedBox(height: 20),
                      const Text('Catatan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(16)), child: Text(funding.notes!)),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              if (funding.status == 'pending')
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      child: const Text('Batalkan Pengajuan', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border.withOpacity(0.3))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
          Text(label, style: const TextStyle(color: AppColors.textSub, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String date, IconData icon, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: isCompleted ? _orangeLight : AppColors.border, shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: isCompleted ? _orangePrimary : AppColors.textHint),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: isCompleted ? AppColors.textPrimary : AppColors.textHint)),
                Text(date, style: TextStyle(color: isCompleted ? AppColors.textSub : AppColors.textHint, fontSize: 12)),
              ],
            ),
          ),
          if (isCompleted) Icon(Icons.check_circle_rounded, color: _orangePrimary, size: 18),
        ],
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Batalkan Pengajuan', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Apakah Anda yakin ingin membatalkan pengajuan pendanaan ini? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tidak', style: TextStyle(color: AppColors.textSub))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text('Pengajuan pendanaan dibatalkan'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved': return AppColors.success;
      case 'pending': return AppColors.warning;
      case 'rejected': return AppColors.error;
      case 'disbursed': return _orangePrimary;
      default: return AppColors.textHint;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'approved': return Icons.check_circle_rounded;
      case 'pending': return Icons.hourglass_empty_rounded;
      case 'rejected': return Icons.cancel_rounded;
      case 'disbursed': return Icons.account_balance_rounded;
      default: return Icons.help_rounded;
    }
  }
}