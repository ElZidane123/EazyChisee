import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:eazychise/core/constants/app_colors.dart';

class BEPSimulationScreen extends StatefulWidget {
  const BEPSimulationScreen({super.key});

  @override
  State<BEPSimulationScreen> createState() => _BEPSimulationScreenState();
}

class _BEPSimulationScreenState extends State<BEPSimulationScreen>
    with SingleTickerProviderStateMixin {
  final _investmentController = TextEditingController();
  final _monthlyRevenueController = TextEditingController();
  final _monthlyCostController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  double _bepMonths = 0;
  double _profitPerMonth = 0;
  bool _showResult = false;
  
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _investmentController.dispose();
    _monthlyRevenueController.dispose();
    _monthlyCostController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calculateBEP() {
    FocusScope.of(context).unfocus(); // Tutup keyboard
    
    final investment = double.tryParse(_investmentController.text) ?? 0;
    final monthlyRevenue = double.tryParse(_monthlyRevenueController.text) ?? 0;
    final monthlyCost = double.tryParse(_monthlyCostController.text) ?? 0;
    
    final monthlyProfit = monthlyRevenue - monthlyCost;
    
    setState(() {
      if (monthlyProfit > 0) {
        _bepMonths = investment / monthlyProfit;
        _profitPerMonth = monthlyProfit;
      } else {
        _bepMonths = double.infinity;
        _profitPerMonth = 0;
      }
      _showResult = true;
    });
    
    _animationController.reset();
    _animationController.forward();
  }

  void _resetForm() {
    _investmentController.clear();
    _monthlyRevenueController.clear();
    _monthlyCostController.clear();
    setState(() {
      _showResult = false;
      _bepMonths = 0;
      _profitPerMonth = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern App Bar
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: const Text(
              'Simulasi BEP',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: AppColors.textPrimary,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              onPressed: () => Navigator.maybePop(context),
            ),
            actions: [
              if (_showResult)
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: _resetForm,
                  color: AppColors.primary,
                ),
            ],
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header Card
                _buildHeaderCard(),
                const SizedBox(height: 24),

                // Input Form Card
                _buildInputForm(),
                const SizedBox(height: 24),

                // Result Card
                if (_showResult) _buildResultCard(),
                if (_showResult) const SizedBox(height: 24),

                // Tips Card
                _buildTipsCard(),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: AppColors.shadowSm,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.timeline_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analisis Break Even Point',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Hitung kapan investasi Franchisemu akan kembali',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
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

  Widget _buildInputForm() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 700),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: AppColors.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan Data Investasi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Isi semua field untuk melihat hasil simulasi',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            
            // Investment Field
            _buildInputField(
              controller: _investmentController,
              label: 'Modal Awal',
              hint: 'Contoh: 500000000',
              icon: Icons.monetization_on_rounded,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            
            // Revenue Field
            _buildInputField(
              controller: _monthlyRevenueController,
              label: 'Pendapatan Bulanan',
              hint: 'Contoh: 100000000',
              icon: Icons.trending_up_rounded,
              color: AppColors.success,
            ),
            const SizedBox(height: 16),
            
            // Cost Field
            _buildInputField(
              controller: _monthlyCostController,
              label: 'Biaya Operasional Bulanan',
              hint: 'Contoh: 60000000',
              icon: Icons.receipt_rounded,
              color: AppColors.warning,
            ),
            
            const SizedBox(height: 24),
            
            // Calculate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateBEP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
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
                    Icon(Icons.calculate_rounded),
                    SizedBox(width: 8),
                    Text(
                      'Hitung BEP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: color, size: 22),
      ),
    );
  }

  Widget _buildResultCard() {
    final investment = double.tryParse(_investmentController.text) ?? 0;
    final roi = investment > 0 
        ? ((_profitPerMonth * 12 / investment) * 100) 
        : 0;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: AppColors.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.analytics_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Hasil Analisis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // BEP Gauge
            Container(
              height: 120,
              child: Stack(
                children: [
                  // Background Circle
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.textHint.withOpacity(0.2),
                          width: 8,
                        ),
                      ),
                    ),
                  ),
                  
                  // Progress Circle
                  Center(
                    child: TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween<double>(
                        begin: 0,
                        end: _bepMonths.isFinite 
                            ? (_bepMonths / 24).clamp(0, 1) 
                            : 0,
                      ),
                      curve: Curves.easeOutCubic,
                      builder: (context, double value, child) {
                        return SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 8,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _bepMonths.isFinite 
                                  ? AppColors.success 
                                  : AppColors.error,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Center Text
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _bepMonths.isFinite
                              ? '${_bepMonths.toStringAsFixed(1)}'
                              : '∞',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const Text(
                          'Bulan',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Result Items Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _buildResultGridItem(
                  'BEP',
                  _bepMonths.isFinite
                      ? '${_bepMonths.toStringAsFixed(1)} bulan'
                      : 'Tidak tercapai',
                  _bepMonths.isFinite ? AppColors.success : AppColors.error,
                  Icons.timelapse_rounded,
                ),
                _buildResultGridItem(
                  'Profit Bulanan',
                  _currencyFormat.format(_profitPerMonth),
                  AppColors.primary,
                  Icons.trending_up_rounded,
                ),
                _buildResultGridItem(
                  'Profit Tahunan',
                  _currencyFormat.format(_profitPerMonth * 12),
                  AppColors.success,
                  Icons.calendar_month_rounded,
                ),
                _buildResultGridItem(
                  'ROI',
                  '${roi.toStringAsFixed(1)}%',
                  AppColors.warning,
                  Icons.percent_rounded,
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            // Chart
            Container(
              height: 180,
              padding: const EdgeInsets.all(8),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    horizontalInterval: _profitPerMonth * 3,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.textHint.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value / 1000000).toInt()}Jt',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: AppColors.textHint.withOpacity(0.2),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateChartSpots(),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.primary,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                    if (_bepMonths.isFinite)
                      LineChartBarData(
                        spots: [
                          FlSpot(_bepMonths, 0),
                          FlSpot(_bepMonths, _profitPerMonth * _bepMonths),
                        ],
                        isCurved: false,
                        color: AppColors.success,
                        barWidth: 2,
                        dashArray: [5, 5],
                        dotData: FlDotData(show: false),
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

  List<FlSpot> _generateChartSpots() {
    final spots = <FlSpot>[];
    final maxMonths = 24; // Tampilkan hingga 24 bulan
    
    for (int i = 0; i <= maxMonths; i++) {
      spots.add(FlSpot(i.toDouble(), _profitPerMonth * i));
    }
    
    return spots;
  }

  Widget _buildResultGridItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppColors.shadowSm,
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
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSub,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: AppColors.info,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tips untuk Simulasi Akurat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem(
            'Sertakan semua biaya awal seperti renovasi, peralatan, dan lisensi',
            Icons.build_rounded,
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            'Masukkan biaya marketing dan promosi dalam biaya operasional',
            Icons.campaign_rounded,
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            'Pertimbangkan fluktuasi musiman dalam pendapatan',
            Icons.calendar_month_rounded,
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            'Tambahkan buffer 10-20% untuk biaya tak terduga',
            Icons.shield_rounded,
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            'BEP ideal untuk Franchise adalah 12-24 bulan',
            Icons.flag_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 12,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            tip,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}