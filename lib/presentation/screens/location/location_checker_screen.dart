import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/data/location_data.dart';
import 'dart:math';

class LocationCheckerScreen extends StatefulWidget {
  const LocationCheckerScreen({super.key});

  @override
  State<LocationCheckerScreen> createState() => _LocationCheckerScreenState();
}

class _LocationCheckerScreenState extends State<LocationCheckerScreen> {
  String _selectedCity = 'Jakarta';
  String _selectedArea = 'Pusat Kota';
  final TextEditingController _streetController = TextEditingController();
  bool _hasAnalyzed = false;

  final Map<String, Map<String, LocationData>> _mockData = LocationData.mockData;

  @override
  void dispose() {
    _streetController.dispose();
    super.dispose();
  }

  void _analyze() {
    if (_streetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Masukkan nama jalan/area', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.error,
      ));
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _hasAnalyzed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Cek Lokasi Strategis', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, letterSpacing: -0.3)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputForm(),
            if (_hasAnalyzed) ...[
              const SizedBox(height: 32),
              _buildAnalysisResult(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
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
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              const Text('Detail Lokasi', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.3)),
            ],
          ),
          const SizedBox(height: 24),
          _buildLabel('Nama Jalan / Area Patokan'),
          TextField(
            controller: _streetController,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
            decoration: _inputDecoration('Contoh: Jl. Sudirman No. 10', Icons.map_rounded),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Kota'),
                    DropdownButtonFormField<String>(
                      value: _selectedCity,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
                      decoration: _inputDecoration('', Icons.location_city_rounded),
                      dropdownColor: AppColors.surface,
                      items: _mockData.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setState(() {
                        _selectedCity = v!;
                        _selectedArea = _mockData[_selectedCity]!.keys.first;
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Tipe Area'),
                    DropdownButtonFormField<String>(
                      value: _selectedArea,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
                      decoration: _inputDecoration('', Icons.category_rounded),
                      dropdownColor: AppColors.surface,
                      items: _mockData[_selectedCity]!.keys.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                      onChanged: (v) => setState(() => _selectedArea = v!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _analyze,
              icon: const Icon(Icons.analytics_rounded, color: Colors.white, size: 20),
              label: const Text('Analisis Lokasi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textSub)));
  
  InputDecoration _inputDecoration(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.textHint, fontWeight: FontWeight.w500, fontSize: 14),
    filled: true,
    fillColor: AppColors.surfaceDim,
    prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
  );

  Widget _buildAnalysisResult() {
    final data = _mockData[_selectedCity]![_selectedArea]!;
    // Add some random variation based on the street name length to make it look "AI" computed
    final variance = (_streetController.text.length % 10) - 5;
    final finalScore = (data.baseScore + variance).clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hasil Analisis AI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.3)),
        const SizedBox(height: 20),
        
        // Gauge Meter Score
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.grad, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 110, height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: finalScore / 100,
                      strokeWidth: 10,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      strokeCap: StrokeCap.round,
                    ),
                    Text('$finalScore', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1)),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Skor Potensi Lokasi', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Text(
                      finalScore >= 80 ? 'SANGAT STRATEGIS' : (finalScore >= 60 ? 'CUKUP STRATEGIS' : 'KURANG STRATEGIS'),
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                      child: Text('Tipe: ${data.areaType}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 5 Kategori Analisis
        _buildStatCard('Potensi Traffic', data.trafficPotential, Icons.people_rounded, AppColors.info),
        _buildStatCard('Kepadatan Kompetitor', '${data.competitionScore}/10', Icons.storefront_rounded, AppColors.warning),
        _buildStatCard('Estimasi Harga Sewa', data.rentRange, Icons.monetization_on_rounded, AppColors.gold),
        _buildStatCard('Waktu Puncak (Ramai)', data.peakHours, Icons.access_time_filled_rounded, const Color(0xFF8B5CF6)),
        _buildStatCard('Kategori Franchise Cocok', data.bestCategories.join(', '), Icons.category_rounded, AppColors.primary),
        const SizedBox(height: 32),

        // Bar Chart
        const Text('Grafik Traffic Harian (Estimasi)', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.3)),
        const SizedBox(height: 20),
        Container(
          height: 220,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border), boxShadow: AppColors.shadowSm),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (v, meta) => SideTitleWidget(
                      meta: meta,
                      space: 8.0,
                      child: Text('${v.toInt() * 3 + 6}:00', style: const TextStyle(fontSize: 11, color: AppColors.textSub, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(6, (i) {
                // generate some curve based on peak hours roughly
                double val = 30.0 + Random(i + finalScore).nextInt(50);
                if (data.peakHours.contains('Malam') && i > 3) val += 20;
                if (data.peakHours.contains('Pagi') && i < 2) val += 20;
                return BarChartGroupData(
                  x: i,
                  barRods: [BarChartRodData(toY: val.clamp(0, 100).toDouble(), color: AppColors.primary, width: 14, borderRadius: BorderRadius.circular(6))],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Kompetitor Terdekat
        const Text('Kompetitor Serupa Terdekat', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.3)),
        const SizedBox(height: 16),
        ...List.generate(3, (i) => _buildCompetitorTile(i)),
        const SizedBox(height: 32),

        // Save Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Laporan lokasi berhasil disimpan', style: TextStyle(fontWeight: FontWeight.w600)),
                backgroundColor: AppColors.success,
              ));
            },
            icon: const Icon(Icons.file_download_rounded, color: AppColors.primary, size: 20),
            label: const Text('Simpan Laporan Lokasi', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.primary, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border), boxShadow: AppColors.shadowSm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSub, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitorTile(int index) {
    final names = ['Toko Sebelah', 'Bisnis Lama', 'Franchise Pesaing'];
    final distances = ['120m', '450m', '800m'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.storefront_rounded, color: AppColors.error, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(names[index], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text('Jarak: ${distances[index]}', style: const TextStyle(fontSize: 12, color: AppColors.textSub, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 14),
                SizedBox(width: 4),
                Text('Pesaing', style: TextStyle(color: AppColors.warning, fontSize: 10, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
