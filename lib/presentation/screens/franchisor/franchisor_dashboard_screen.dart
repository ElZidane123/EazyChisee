import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:eazychise/core/constants/app_colors.dart';

class FranchisorDashboardScreen extends StatefulWidget {
  const FranchisorDashboardScreen({super.key});

  @override
  State<FranchisorDashboardScreen> createState() => _FranchisorDashboardScreenState();
}

class _FranchisorDashboardScreenState extends State<FranchisorDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _branches = [
    {
      'name': 'Cabang Sudirman (Pusat)',
      'city': 'Jakarta',
      'date': '12 Jan 2025',
      'franchisee': 'Budi Santoso',
      'revenue': 125000000,
      'target': 100000000,
      'status': 'ON TRACK',
      'lastReport': 'Hari ini, 08:00',
    },
    {
      'name': 'Cabang Suhat',
      'city': 'Malang',
      'date': '05 Mar 2025',
      'franchisee': 'Siti Aminah',
      'revenue': 45000000,
      'target': 80000000,
      'status': 'AT RISK',
      'lastReport': 'Kemarin, 17:30',
    },
    {
      'name': 'Cabang Tunjungan',
      'city': 'Surabaya',
      'date': '20 Nov 2024',
      'franchisee': 'Ahmad Fauzi',
      'revenue': 140000000,
      'target': 120000000,
      'status': 'BINTANG',
      'lastReport': 'Hari ini, 09:15',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Monitoring Cabang', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Semua Cabang'),
            Tab(text: 'At Risk'),
            Tab(text: 'Bintang'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBranchList(_branches),
          _buildBranchList(_branches.where((b) => b['status'] == 'AT RISK').toList()),
          _buildBranchList(_branches.where((b) => b['status'] == 'BINTANG').toList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/franchise-verification');
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_business, color: Colors.white),
        label: const Text('Cabang Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildBranchList(List<Map<String, dynamic>> branches) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: branches.length + 1, // +1 for header summary
      itemBuilder: (context, index) {
        if (index == 0) return _buildHeaderSummary();
        final branch = branches[index - 1];
        return _buildBranchCard(branch);
      },
    );
  }

  Widget _buildHeaderSummary() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.gradDeep, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Omzet Bulan Ini', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          const Text('Rp 310.000.000', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('3', 'Cabang Aktif', Icons.storefront),
              _buildSummaryItem('1', 'At Risk', Icons.warning_amber_rounded, isAlert: true),
              _buildSummaryItem('1', 'Bintang', Icons.star_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label, IconData icon, {bool isAlert = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isAlert ? AppColors.error.withOpacity(0.2) : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: isAlert ? AppColors.error : Colors.white, size: 20),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildBranchCard(Map<String, dynamic> branch) {
    Color statusColor;
    IconData statusIcon;
    if (branch['status'] == 'ON TRACK') {
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle;
    } else if (branch['status'] == 'AT RISK') {
      statusColor = AppColors.error;
      statusIcon = Icons.warning;
    } else {
      statusColor = AppColors.accent;
      statusIcon = Icons.star;
    }

    double progress = branch['revenue'] / branch['target'];
    if (progress > 1.0) progress = 1.0;

    return GestureDetector(
      onTap: () => _showBranchDetail(branch),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(branch['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text('${branch['city']} • ${branch['franchisee']}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 14),
                      const SizedBox(width: 4),
                      Text(branch['status'], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Omzet: Rp ${(branch['revenue'] / 1000000).toStringAsFixed(1)}Jt', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text('Target: Rp ${(branch['target'] / 1000000).toStringAsFixed(1)}Jt', style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.background,
              color: statusColor,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text('Laporan terakhir: ${branch['lastReport']}', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBranchDetail(Map<String, dynamic> branch) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(branch['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text('Tren Omzet 6 Bulan Terakhir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) => Text('B${v.toInt()}', style: const TextStyle(fontSize: 10)))),
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [FlSpot(1, 80), FlSpot(2, 95), FlSpot(3, 85), FlSpot(4, 110), FlSpot(5, 120), FlSpot(6, 125)],
                            isCurved: true,
                            color: AppColors.primary,
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: true, color: AppColors.primary.withOpacity(0.1)),
                          ),
                          LineChartBarData(
                            spots: const [FlSpot(1, 100), FlSpot(2, 100), FlSpot(3, 100), FlSpot(4, 100), FlSpot(5, 100), FlSpot(6, 100)], // Benchmark target
                            isCurved: false,
                            color: AppColors.textHint,
                            barWidth: 2,
                            dashArray: [5, 5],
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Checklist Kepatuhan (Compliance)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildChecklistItem('Standar Operasional Prosedur (SOP)', true),
                  _buildChecklistItem('Kebersihan Outlet', true),
                  _buildChecklistItem('Kualitas Produk', branch['status'] != 'AT RISK'),
                  _buildChecklistItem('Laporan Keuangan Bulanan', branch['status'] != 'AT RISK'),
                  const SizedBox(height: 24),
                  if (branch['status'] == 'AT RISK')
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.error.withOpacity(0.3))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
                              SizedBox(width: 8),
                              Text('Catatan Verifikator EazyChise', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text('Kualitas produk menurun dan laporan keuangan bulan lalu belum disubmit. Perlu segera diintervensi.', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Peringatan resmi dikirim ke Franchisee')));
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                              child: const Text('Kirim Surat Peringatan (SP 1)', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
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

  Widget _buildChecklistItem(String title, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(isChecked ? Icons.check_circle : Icons.cancel, color: isChecked ? AppColors.success : AppColors.error, size: 20),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
