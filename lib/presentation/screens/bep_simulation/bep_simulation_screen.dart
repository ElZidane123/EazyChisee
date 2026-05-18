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
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern App Bar
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            scrolledUnderElevation: 1,
            title: const Text(
              'Simulasi BEP',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: -0.3,
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
              const SizedBox(width: 8),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: AppColors.shadowSm,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryBg,
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
                  SizedBox(height: 6),
                  Text(
                    'Hitung kapan investasi Franchisemu akan kembali',
                    style: TextStyle(
                      color: AppColors.textSub,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: AppColors.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan Data Investasi',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Isi semua field untuk melihat hasil simulasi',
              style: TextStyle(
                color: AppColors.textSub,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            
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
              icon: Icons.receipt_long_rounded,
              color: AppColors.warning,
            ),
            
            const SizedBox(height: 28),
            
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
                  elevation: 4,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calculate_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Hitung BEP',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
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
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textHint, fontWeight: FontWeight.w400),
        prefixIcon: Icon(icon, color: color, size: 22),
        filled: true,
        fillColor: AppColors.surfaceDim,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBg,
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
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // BEP Gauge
            SizedBox(
              height: 140,
              child: Stack(
                children: [
                  // Background Circle
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surfaceDim,
                          width: 10,
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
                          width: 140,
                          height: 140,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 10,
                            backgroundColor: Colors.transparent,
                            strokeCap: StrokeCap.round,
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
                              ? _bepMonths.toStringAsFixed(1)
                              : '∞',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: -1,
                          ),
                        ),
                        const Text(
                          'Bulan',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSub,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Result Items Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
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
                  'ROI Tahunan',
                  '${roi.toStringAsFixed(1)}%',
                  AppColors.warning,
                  Icons.percent_rounded,
                ),
              ],
            ),
            
            const SizedBox(height: 32),

            // Chart
            Container(
              height: 220,
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    horizontalInterval: (_profitPerMonth > 0 && _profitPerMonth.isFinite)
                        ? _profitPerMonth * 3
                        : 1000000.0,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.border,
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      );
                    },
                    drawVerticalLine: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 8.0,
                            child: Text(
                              'B${value.toInt()}',
                              style: const TextStyle(
                                color: AppColors.textSub,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 8.0,
                            child: Text(
                              '${(value / 1000000).toInt()}Jt',
                              style: const TextStyle(
                                color: AppColors.textSub,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                        reservedSize: 32,
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
                    border: const Border(
                      bottom: BorderSide(color: AppColors.border),
                      left: BorderSide(color: AppColors.border),
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
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.2),
                            AppColors.primary.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
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
                        dotData: const FlDotData(show: false),
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
    const maxMonths = 24; // Tampilkan hingga 24 bulan
    
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSub,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.info,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                'Tips untuk Simulasi Akurat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTipItem(
            'Sertakan semua biaya awal seperti renovasi, peralatan, dan lisensi',
            Icons.build_circle_rounded,
          ),
          const SizedBox(height: 14),
          _buildTipItem(
            'Masukkan biaya marketing dan promosi dalam biaya operasional',
            Icons.campaign_rounded,
          ),
          const SizedBox(height: 14),
          _buildTipItem(
            'Pertimbangkan fluktuasi musiman dalam pendapatan',
            Icons.calendar_month_rounded,
          ),
          const SizedBox(height: 14),
          _buildTipItem(
            'Tambahkan buffer 10-20% untuk biaya tak terduga',
            Icons.shield_rounded,
          ),
          const SizedBox(height: 14),
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
        Icon(
          icon,
          size: 18,
          color: AppColors.success,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            tip,
            style: const TextStyle(
              color: AppColors.textSub,
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}