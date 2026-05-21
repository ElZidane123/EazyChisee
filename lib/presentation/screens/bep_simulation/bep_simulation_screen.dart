import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:eazychise/core/constants/app_colors.dart';

// ============================================================
// MODERN ORANGE COLOR PALETTE (No gradients)
// ============================================================
const Color _orangePrimary = Color(0xFFF85C2E);
const Color _orangeLight = Color(0xFFFFF0EA);
const Color _orangeBg = Color(0xFFFFF6F2);

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
  late Animation<double> _scaleAnimation;

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
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
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
    FocusScope.of(context).unfocus();
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
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0.5,
            title: const Text(
              'Simulasi BEP',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -0.5,
                color: AppColors.textPrimary,
              ),
            ),
            centerTitle: false,
            leading: Container(
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: _orangeLight,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                onPressed: () => Navigator.maybePop(context),
                color: _orangePrimary,
              ),
            ),
            actions: [
              if (_showResult)
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: _orangeLight,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _resetForm,
                    icon: const Icon(Icons.refresh_rounded, color: _orangePrimary, size: 20),
                  ),
                ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHeaderCard(),
                const SizedBox(height: 24),
                _buildInputForm(),
                if (_showResult) ...[
                  const SizedBox(height: 24),
                  _buildResultCard(),
                ],
                const SizedBox(height: 24),
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.border.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _orangeLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.timeline_rounded, color: _orangePrimary, size: 32),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analisis Break Even Point',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
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
      ),
    );
  }

  Widget _buildInputForm() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.border.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Masukkan Data Investasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Isi semua field untuk melihat hasil simulasi',
                style: TextStyle(
                  color: AppColors.textSub,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),
              _buildInputField(
                controller: _investmentController,
                label: 'Modal Awal',
                hint: 'Contoh: 500.000.000',
                icon: Icons.monetization_on_rounded,
                color: _orangePrimary,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _monthlyRevenueController,
                label: 'Pendapatan Bulanan',
                hint: 'Contoh: 100.000.000',
                icon: Icons.trending_up_rounded,
                color: AppColors.success,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _monthlyCostController,
                label: 'Biaya Operasional Bulanan',
                hint: 'Contoh: 60.000.000',
                icon: Icons.receipt_long_rounded,
                color: AppColors.warning,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculateBEP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orangePrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calculate_rounded, size: 22),
                      SizedBox(width: 10),
                      Text(
                        'Hitung BEP',
                        style: TextStyle(
                          fontSize: 16,
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: AppColors.textSub,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textHint),
          prefixIcon: Icon(icon, color: color, size: 24),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final investment = double.tryParse(_investmentController.text) ?? 0;
    final roi = investment > 0 ? ((_profitPerMonth * 12 / investment) * 100) : 0;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.border.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _orangeLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.analytics_rounded,
                      color: _orangePrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Hasil Analisis',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // BEP Gauge dengan animasi
              SizedBox(
                height: 180,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 1200),
                        tween: Tween<double>(
                          begin: 0,
                          end: _bepMonths.isFinite
                              ? (_bepMonths / 24).clamp(0, 1)
                              : 0,
                        ),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return SizedBox(
                            width: 160,
                            height: 160,
                            child: CircularProgressIndicator(
                              value: value,
                              strokeWidth: 14,
                              backgroundColor: _orangeLight,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _bepMonths.isFinite
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                          );
                        },
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 1000),
                            tween: Tween<double>(
                              begin: 0,
                              end: _bepMonths.isFinite ? _bepMonths : 0,
                            ),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Text(
                                _bepMonths.isFinite
                                    ? value.toStringAsFixed(1)
                                    : '∞',
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                  color: _orangePrimary,
                                ),
                              );
                            },
                          ),
                          const Text(
                            'Bulan',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textSub,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Grid hasil
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.4,
                children: [
                  _buildResultGridItem(
                    'BEP',
                    _bepMonths.isFinite
                        ? '${_bepMonths.toStringAsFixed(1)} bln'
                        : 'Tidak tercapai',
                    _bepMonths.isFinite ? AppColors.success : AppColors.error,
                    Icons.timelapse_rounded,
                  ),
                  _buildResultGridItem(
                    'Profit Bulanan',
                    _currencyFormat.format(_profitPerMonth),
                    _orangePrimary,
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
              const SizedBox(height: 28),
              // Chart
              SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _profitPerMonth > 0
                          ? _profitPerMonth * 2
                          : 1000000,
                      getDrawingHorizontalLine: (v) => FlLine(
                        color: AppColors.border,
                        strokeWidth: 1,
                        dashArray: [4, 4],
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (v, meta) {
                            return SideTitleWidget(
                              meta: meta,
                              space: 8.0,
                              child: Text(
                                'B${v.toInt()}',
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
                          reservedSize: 45,
                          getTitlesWidget: (v, meta) {
                            return SideTitleWidget(
                              meta: meta,
                              space: 8.0,
                              child: Text(
                                '${(v / 1000000).toInt()}Jt',
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
                        spots: List.generate(
                          25,
                          (i) => FlSpot(i.toDouble(), _profitPerMonth * i),
                        ),
                        isCurved: true,
                        color: _orangePrimary,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: _orangePrimary.withOpacity(0.1),
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
                          dashArray: [6, 4],
                          dotData: const FlDotData(show: false),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSub,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.border.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _orangeLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: _orangePrimary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Tips Simulasi Akurat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildTipItem(
              'Sertakan semua biaya awal seperti renovasi, peralatan, dan lisensi',
              Icons.build_circle_rounded,
            ),
            const SizedBox(height: 16),
            _buildTipItem(
              'Masukkan biaya marketing dan promosi dalam biaya operasional',
              Icons.campaign_rounded,
            ),
            const SizedBox(height: 16),
            _buildTipItem(
              'Pertimbangkan fluktuasi musiman dalam pendapatan',
              Icons.calendar_month_rounded,
            ),
            const SizedBox(height: 16),
            _buildTipItem(
              'Tambahkan buffer 10-20% untuk biaya tak terduga',
              Icons.shield_rounded,
            ),
          ],
        ),
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
            color: AppColors.successBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.success),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            tip,
            style: const TextStyle(
              color: AppColors.textSub,
              fontSize: 13,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}