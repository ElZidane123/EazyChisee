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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan nama jalan/area')));
      return;
    }
    setState(() {
      _hasAnalyzed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cek Lokasi Strategis', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Detail Lokasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 20),
          _buildLabel('Nama Jalan / Area Patokan'),
          TextField(
            controller: _streetController,
            decoration: _inputDecoration('Contoh: Jl. Sudirman No. 10'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Kota'),
                    DropdownButtonFormField<String>(
                      value: _selectedCity,
                      decoration: _inputDecoration(''),
                      items: _mockData.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setState(() => _selectedCity = v!),
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
                      decoration: _inputDecoration(''),
                      items: _mockData[_selectedCity]!.keys.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                      onChanged: (v) => setState(() => _selectedArea = v!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _analyze,
              icon: const Icon(Icons.analytics, color: Colors.white),
              label: const Text('Analisis Lokasi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textSecondary)));
  
  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: AppColors.background,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.divider)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.divider)),
  );

  Widget _buildAnalysisResult() {
    final data = _mockData[_selectedCity]![_selectedArea]!;
    // Add some random variation based on the street name length to make it look "AI" computed
    final variance = (_streetController.text.length % 10) - 5;
    final finalScore = (data.baseScore + variance).clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hasil Analisis AI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 16),
        
        // Gauge Meter Score
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(colors: AppColors.gradDeep, begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 100, height: 100,
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
                    Text('$finalScore', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Skor Potensi Lokasi', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      finalScore >= 80 ? 'SANGAT STRATEGIS' : (finalScore >= 60 ? 'CUKUP STRATEGIS' : 'KURANG STRATEGIS'),
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                      child: Text('Tipe: ${data.areaType}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 5 Kategori Analisis
        _buildStatCard('Potensi Traffic', data.trafficPotential, Icons.people, AppColors.info),
        _buildStatCard('Kepadatan Kompetitor', '${data.competitionScore}/10', Icons.storefront, AppColors.warning),
        _buildStatCard('Estimasi Harga Sewa', data.rentRange, Icons.monetization_on, AppColors.accent),
        _buildStatCard('Waktu Puncak (Ramai)', data.peakHours, Icons.access_time, const Color(0xFF8B5CF6)),
        _buildStatCard('Kategori Franchise Cocok', data.bestCategories.join(', '), Icons.category, AppColors.primary),
        const SizedBox(height: 24),

        // Bar Chart
        const Text('Grafik Traffic Harian (Estimasi)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
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
                    getTitlesWidget: (v, meta) => Padding(padding: const EdgeInsets.only(top: 8), child: Text('${v.toInt() * 3 + 6}:00', style: const TextStyle(fontSize: 10, color: AppColors.textHint))),
                  ),
                ),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                  barRods: [BarChartRodData(toY: val.clamp(0, 100).toDouble(), color: AppColors.primary, width: 16, borderRadius: BorderRadius.circular(4))],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Kompetitor Terdekat
        const Text('Kompetitor Serupa Terdekat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...List.generate(3, (i) => _buildCompetitorTile(i)),
        const SizedBox(height: 24),

        // Save Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Laporan lokasi berhasil disimpan'), backgroundColor: AppColors.success));
            },
            icon: const Icon(Icons.download, color: AppColors.primary),
            label: const Text('Simpan Laporan Lokasi', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: AppColors.errorBg, child: const Icon(Icons.store, color: AppColors.error, size: 20)),
      title: Text(names[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text('Jarak: ${distances[index]}', style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.warning, color: AppColors.warning, size: 16),
    );
  }
}
