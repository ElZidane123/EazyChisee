import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/providers/franchise_provider.dart';
import 'package:eazychise/core/models/franchise_model.dart';

class FranchiseSimulatorScreen extends StatefulWidget {
  const FranchiseSimulatorScreen({super.key});

  @override
  State<FranchiseSimulatorScreen> createState() => _FranchiseSimulatorScreenState();
}

class _FranchiseSimulatorScreenState extends State<FranchiseSimulatorScreen> {
  int _currentStep = 0;
  FranchiseModel? _selectedFranchise;
  
  // Step 2 Inputs
  String _selectedCity = 'Jakarta';
  double _dailyTraffic = 200;
  double _opHours = 12;
  double _employeeCount = 3;
  final TextEditingController _capitalController = TextEditingController();
  String _experienceLevel = 'Menengah';

  // Step 3 States
  String _scenario = 'Realistis'; // Optimistis, Realistis, Pesimistis

  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  @override
  void dispose() {
    _capitalController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedFranchise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih franchise terlebih dahulu')),
      );
      return;
    }
    if (_currentStep == 1) {
      if (_capitalController.text.isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Masukkan modal tersedia')),
        );
        return;
      }
    }
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Franchise Simulator', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildStepper(),
          Expanded(
            child: _buildStepContent(),
          ),
          if (_currentStep < 2) _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepIndicator(0, 'Pilih Franchise'),
          _buildStepDivider(),
          _buildStepIndicator(1, 'Input Data'),
          _buildStepDivider(),
          _buildStepIndicator(2, 'Hasil AI'),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String label) {
    final isActive = _currentStep == stepIndex;
    final isPast = _currentStep > stepIndex;
    final color = isActive || isPast ? AppColors.primary : AppColors.divider;
    
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : (isPast ? AppColors.primary : Colors.transparent),
            border: Border.all(color: color, width: 2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isPast 
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text('${stepIndex + 1}', 
                  style: TextStyle(
                    color: isActive ? Colors.white : AppColors.textSub,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  )),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive || isPast ? AppColors.textPrimary : AppColors.textHint,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        color: AppColors.divider,
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Kembali', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                _currentStep == 1 ? 'Mulai Simulasi AI' : 'Selanjutnya', 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0: return _buildStep1();
      case 1: return _buildStep2();
      case 2: return _buildStep3();
      default: return const SizedBox();
    }
  }

  // ── STEP 1: Pilih Franchise ───────────────────────────────────────────────
  Widget _buildStep1() {
    return Consumer<FranchiseProvider>(
      builder: (context, provider, _) {
        final franchises = provider.franchises;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari franchise...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: franchises.length,
                itemBuilder: (context, index) {
                  final f = franchises[index];
                  final isSelected = _selectedFranchise?.id == f.id;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFranchise = f),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.divider,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                        ] : [],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60, height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(image: NetworkImage(f.logoUrl), fit: BoxFit.cover),
                              color: AppColors.surfaceDim,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(f.category, style: const TextStyle(color: AppColors.textSub, fontSize: 13)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.monetization_on, size: 14, color: AppColors.accent),
                                    const SizedBox(width: 4),
                                    Text(currencyFormatter.format(f.investmentMin), 
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                      child: Text('ROI ${f.roi}%', style: const TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // ── STEP 2: Input Data Simulasi ───────────────────────────────────────────────
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lengkapi Profil Rencana Bisnis Anda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          
          _buildLabel('Kota/Lokasi Target'),
          DropdownButtonFormField<String>(
            value: _selectedCity,
            decoration: _inputDecoration(),
            items: ['Jakarta', 'Surabaya', 'Medan', 'Semarang', 'Malang', 'Bandung']
                .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => _selectedCity = v!),
          ),
          const SizedBox(height: 20),

          _buildLabel('Estimasi Traffic Harian (Orang)'),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _dailyTraffic,
                  min: 50, max: 1000,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _dailyTraffic = v),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text('${_dailyTraffic.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildLabel('Jam Operasional (Jam/Hari)'),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _opHours,
                  min: 8, max: 24,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _opHours = v),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text('${_opHours.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildLabel('Rencana Jumlah Karyawan'),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _employeeCount,
                  min: 1, max: 20,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _employeeCount = v),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text('${_employeeCount.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildLabel('Modal Tersedia (Rp)'),
          TextField(
            controller: _capitalController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration().copyWith(
              prefixText: 'Rp ',
            ),
          ),
          const SizedBox(height: 20),

          _buildLabel('Pengalaman Bisnis'),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Pemula', label: Text('Pemula')),
              ButtonSegment(value: 'Menengah', label: Text('Menengah')),
              ButtonSegment(value: 'Ahli', label: Text('Ahli')),
            ],
            selected: {_experienceLevel},
            onSelectionChanged: (s) => setState(() => _experienceLevel = s.first),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) return AppColors.primary.withOpacity(0.1);
                return AppColors.surface;
              }),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.divider)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.divider)),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
    );
  }

  // ── STEP 3: Hasil Simulasi AI ───────────────────────────────────────────────
  Widget _buildStep3() {
    // Basic calculation logic for demonstration
    final baseRevenue = (_dailyTraffic * 30 * 50000); // assume 50k per customer
    double multiplier = _scenario == 'Optimistis' ? 1.2 : (_scenario == 'Pesimistis' ? 0.7 : 1.0);
    
    // City factor
    if (_selectedCity == 'Jakarta') multiplier *= 1.1;
    
    final monthlyRev = baseRevenue * multiplier;
    final bepMonths = (_selectedFranchise?.investmentMin ?? 200000000) / (monthlyRev * 0.2); // assume 20% margin
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scenario Toggle
          Center(
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Pesimistis', label: Text('Pesimistis')),
                ButtonSegment(value: 'Realistis', label: Text('Realistis')),
                ButtonSegment(value: 'Optimistis', label: Text('Optimistis')),
              ],
              selected: {_scenario},
              onSelectionChanged: (s) => setState(() => _scenario = s.first),
            ),
          ),
          const SizedBox(height: 24),

          // Highlight Cards
          Row(
            children: [
              Expanded(child: _buildResultCard('Estimasi BEP', '${bepMonths.toInt()} Bulan', Icons.update, AppColors.info)),
              const SizedBox(width: 12),
              Expanded(child: _buildResultCard('Proyeksi ROI', '${(_selectedFranchise?.roi ?? 25) * multiplier}%', Icons.trending_up, AppColors.success)),
            ],
          ),
          const SizedBox(height: 12),
          _buildResultCard('Proyeksi Pendapatan (Bulan 1)', currencyFormatter.format(monthlyRev), Icons.account_balance_wallet, AppColors.accent),
          
          const SizedBox(height: 24),
          const Text('Proyeksi Pendapatan 12 Bulan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          // Chart
          Container(
            height: 220,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.divider, strokeWidth: 1)),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('B${v.toInt()}', style: const TextStyle(fontSize: 10, color: AppColors.textSub)),
                        );
                      },
                      interval: 2,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(12, (i) => FlSpot(i.toDouble() + 1, monthlyRev * (1 + (i * 0.05)))),
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // AI Recommendations
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.psychology, color: AppColors.primary),
                    const SizedBox(width: 8),
                    const Text('Rekomendasi AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildBulletPoint('Lokasi di $_selectedCity sangat strategis untuk kategori ${_selectedFranchise?.category}.'),
                _buildBulletPoint('Traffic $_dailyTraffic orang/hari membutuhkan minimal ${(_dailyTraffic/50).ceil()} karyawan aktif saat jam sibuk.'),
                _buildBulletPoint('Dengan jam buka $_opHours jam, pertimbangkan sistem shift untuk optimasi cost.'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/marketplace');
              },
              icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white),
              label: const Text('Lanjut ke Proses Pembelian', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulasi disimpan!')));
                  },
                  icon: const Icon(Icons.save, color: AppColors.textPrimary),
                  label: const Text('Simpan', style: TextStyle(color: AppColors.textPrimary)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Membuka PDF...')));
                  },
                  icon: const Icon(Icons.share, color: AppColors.textPrimary),
                  label: const Text('Bagikan PDF', style: TextStyle(color: AppColors.textPrimary)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildResultCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSub))),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
          Expanded(child: Text(text, style: const TextStyle(color: AppColors.primaryDark, fontSize: 13, height: 1.4))),
        ],
      ),
    );
  }
}
