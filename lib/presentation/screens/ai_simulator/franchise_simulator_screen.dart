import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/providers/franchise_provider.dart';
import 'package:eazychise/core/models/franchise_model.dart';

// ============================================================
// MODERN ORANGE COLOR PALETTE (No gradients)
// ============================================================
const Color _orangePrimary = Color(0xFFF85C2E);
const Color _orangeLight = Color(0xFFFFF0EA);

class FranchiseSimulatorScreen extends StatefulWidget {
  const FranchiseSimulatorScreen({super.key});

  @override
  State<FranchiseSimulatorScreen> createState() => _FranchiseSimulatorScreenState();
}

class _FranchiseSimulatorScreenState extends State<FranchiseSimulatorScreen> {
  int _currentStep = 0;
  FranchiseModel? _selectedFranchise;

  String _selectedCity = 'Jakarta';
  double _dailyTraffic = 200;
  double _opHours = 12;
  double _employeeCount = 3;
  final TextEditingController _capitalController = TextEditingController();
  String _experienceLevel = 'Menengah';
  String _scenario = 'Realistis';

  final _currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

  @override
  void dispose() {
    _capitalController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedFranchise == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih franchise terlebih dahulu')));
      return;
    }
    if (_currentStep == 1 && _capitalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan modal tersedia')));
      return;
    }
    if (_currentStep < 2) setState(() => _currentStep++);
  }

  void _prevStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('AI Simulator', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, letterSpacing: -0.5)),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
      ),
      body: Column(
        children: [
          _buildStepper(),
          Expanded(child: _buildStepContent()),
          if (_currentStep < 2) _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepIndicator(0, 'Pilih Franchise'),
          Expanded(child: Container(height: 2, margin: const EdgeInsets.symmetric(horizontal: 8), color: _currentStep > 0 ? _orangePrimary : AppColors.border)),
          _buildStepIndicator(1, 'Input Data'),
          Expanded(child: Container(height: 2, margin: const EdgeInsets.symmetric(horizontal: 8), color: _currentStep > 1 ? _orangePrimary : AppColors.border)),
          _buildStepIndicator(2, 'Hasil AI'),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String label) {
    final isActive = _currentStep == stepIndex;
    final isPast = _currentStep > stepIndex;
    final color = isActive || isPast ? _orangePrimary : AppColors.border;
    return Column(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: isActive ? _orangePrimary : (isPast ? _orangeLight : Colors.white),
            border: Border.all(color: color, width: 2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isPast
                ? const Icon(Icons.check, size: 16, color: _orangePrimary)
                : Text('${stepIndex + 1}', style: TextStyle(color: isActive ? Colors.white : AppColors.textSub, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isActive ? _orangePrimary : AppColors.textSub)),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border))),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Kembali', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: _orangePrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: Text(_currentStep == 1 ? 'Mulai Simulasi AI' : 'Selanjutnya', style: const TextStyle(fontWeight: FontWeight.w700)),
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

  Widget _buildStep1() {
    return Consumer<FranchiseProvider>(
      builder: (context, provider, _) {
        final franchises = provider.franchises;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari franchise...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: isSelected ? _orangePrimary : AppColors.border.withOpacity(0.3), width: isSelected ? 2 : 1),
                        boxShadow: isSelected ? [BoxShadow(color: _orangePrimary.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))] : null,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 60, height: 60,
                              color: AppColors.surfaceDim,
                              child: Image.network(f.images, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.store, size: 30)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(f.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(f.category, style: const TextStyle(color: AppColors.textSub, fontSize: 13)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.monetization_on, size: 14, color: _orangePrimary),
                                    const SizedBox(width: 4),
                                    Text(_currencyFormat.format(f.investmentMin), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(8)),
                                      child: Text('ROI ${f.roi}%', style: const TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.w700)),
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

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lengkapi Profil Bisnis Anda', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
          const SizedBox(height: 24),
          _buildLabel('Lokasi Target'),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border.withOpacity(0.3))),
            child: DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
              items: ['Jakarta', 'Surabaya', 'Medan', 'Semarang', 'Malang', 'Bandung'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _selectedCity = v!),
            ),
          ),
          const SizedBox(height: 20),
          _buildLabel('Estimasi Traffic Harian (Orang)'),
          Row(children: [
            Expanded(child: Slider(value: _dailyTraffic, min: 50, max: 1000, activeColor: _orangePrimary, onChanged: (v) => setState(() => _dailyTraffic = v))),
            SizedBox(width: 50, child: Text('${_dailyTraffic.toInt()}', style: const TextStyle(fontWeight: FontWeight.w800))),
          ]),
          const SizedBox(height: 20),
          _buildLabel('Jam Operasional (Jam/Hari)'),
          Row(children: [
            Expanded(child: Slider(value: _opHours, min: 8, max: 24, activeColor: _orangePrimary, onChanged: (v) => setState(() => _opHours = v))),
            SizedBox(width: 50, child: Text('${_opHours.toInt()}', style: const TextStyle(fontWeight: FontWeight.w800))),
          ]),
          const SizedBox(height: 20),
          _buildLabel('Jumlah Karyawan'),
          Row(children: [
            Expanded(child: Slider(value: _employeeCount, min: 1, max: 20, activeColor: _orangePrimary, onChanged: (v) => setState(() => _employeeCount = v))),
            SizedBox(width: 50, child: Text('${_employeeCount.toInt()}', style: const TextStyle(fontWeight: FontWeight.w800))),
          ]),
          const SizedBox(height: 20),
          _buildLabel('Modal Tersedia (Rp)'),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border.withOpacity(0.3))),
            child: TextFormField(
              controller: _capitalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(prefixText: 'Rp ', border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
            ),
          ),
          const SizedBox(height: 20),
          _buildLabel('Pengalaman Bisnis'),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border.withOpacity(0.3))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: SegmentedButton<String>(
                segments: const [ButtonSegment(value: 'Pemula', label: Text('Pemula')), ButtonSegment(value: 'Menengah', label: Text('Menengah')), ButtonSegment(value: 'Ahli', label: Text('Ahli'))],
                selected: {_experienceLevel},
                onSelectionChanged: (s) => setState(() => _experienceLevel = s.first),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => states.contains(MaterialState.selected) ? _orangeLight : Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)));

  Widget _buildStep3() {
    final baseRevenue = (_dailyTraffic * 30 * 50000);
    double multiplier = _scenario == 'Optimistis' ? 1.2 : (_scenario == 'Pesimistis' ? 0.7 : 1.0);
    if (_selectedCity == 'Jakarta') multiplier *= 1.1;
    final monthlyRev = baseRevenue * multiplier;
    final bepMonths = (_selectedFranchise?.investmentMin ?? 200000000) / (monthlyRev * 0.2);
    final roi = ((monthlyRev * 12) / (_selectedFranchise?.investmentMin ?? 200000000)) * 100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40), border: Border.all(color: AppColors.border.withOpacity(0.3))),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: SegmentedButton<String>(
                  segments: const [ButtonSegment(value: 'Pesimistis', label: Text('Pesimistis')), ButtonSegment(value: 'Realistis', label: Text('Realistis')), ButtonSegment(value: 'Optimistis', label: Text('Optimistis'))],
                  selected: {_scenario},
                  onSelectionChanged: (s) => setState(() => _scenario = s.first),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => states.contains(MaterialState.selected) ? _orangePrimary : Colors.white),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>((states) => states.contains(MaterialState.selected) ? Colors.white : AppColors.textPrimary)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: _buildResultCard('Estimasi BEP', '${bepMonths.toInt()} Bulan', Icons.timelapse_rounded, AppColors.success)),
            const SizedBox(width: 12),
            Expanded(child: _buildResultCard('Proyeksi ROI', '${roi.toStringAsFixed(0)}%', Icons.trending_up_rounded, _orangePrimary)),
          ]),
          const SizedBox(height: 12),
          _buildResultCard('Proyeksi Pendapatan (Bulan 1)', _currencyFormat.format(monthlyRev), Icons.account_balance_wallet_rounded, _orangePrimary),
          const SizedBox(height: 24),
          const Text('Proyeksi Pendapatan 12 Bulan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border.withOpacity(0.3))),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.border, strokeWidth: 1)),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32,
                    getTitlesWidget: (v, meta) => SideTitleWidget(meta: meta, space: 8.0, child: Text('B${v.toInt()}', style: const TextStyle(color: AppColors.textSub, fontSize: 11)))),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40,
                    getTitlesWidget: (v, meta) => SideTitleWidget(meta: meta, space: 8.0,
                      child: Text('${(v / 1000000).toInt()}Jt', style: const TextStyle(color: AppColors.textSub, fontSize: 11)))),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(12, (i) => FlSpot(i.toDouble() + 1, monthlyRev * (1 + i * 0.05))),
                    isCurved: true,
                    color: _orangePrimary,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: _orangePrimary.withOpacity(0.1)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: _orangeLight, borderRadius: BorderRadius.circular(24), border: Border.all(color: _orangePrimary.withOpacity(0.2))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [const Icon(Icons.psychology_rounded, color: _orangePrimary), const SizedBox(width: 8), const Text('Rekomendasi AI', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16))]),
                const SizedBox(height: 12),
                _buildBulletPoint('Lokasi di $_selectedCity sangat strategis untuk kategori ${_selectedFranchise?.category}.'),
                _buildBulletPoint('Traffic ${_dailyTraffic.toInt()} orang/hari membutuhkan minimal ${(_dailyTraffic / 50).ceil()} karyawan aktif.'),
                _buildBulletPoint('Dengan jam buka ${_opHours.toInt()} jam, pertimbangkan sistem shift untuk optimasi cost.'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/marketplace'),
              icon: const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white),
              label: const Text('Lanjut ke Proses Pembelian', style: TextStyle(fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(backgroundColor: _orangePrimary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: OutlinedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulasi disimpan!'))), icon: const Icon(Icons.save_rounded), label: const Text('Simpan'),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), padding: const EdgeInsets.symmetric(vertical: 14)))),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Membuka PDF...'))), icon: const Icon(Icons.share_rounded), label: const Text('Bagikan PDF'),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), padding: const EdgeInsets.symmetric(vertical: 14)))),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildResultCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border.withOpacity(0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 18, color: color), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSub, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: _orangePrimary)),
        Expanded(child: Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, height: 1.4))),
      ]),
    );
  }
}