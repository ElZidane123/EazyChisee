import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:eazychise/core/constants/app_colors.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  String _selectedPeriod = 'Bulan';
  final List<String> _periods = ['Minggu', 'Bulan', 'Tahun'];

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': '1',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'description': 'Kopi Kenangan - Pendapatan Bulanan',
      'amount': 25000000,
      'type': 'income',
      'category': 'Pendapatan',
      'icon': Icons.coffee_rounded,
    },
    {
      'id': '2',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'description': 'Mie Gacoan - Biaya Operasional',
      'amount': 15000000,
      'type': 'expense',
      'category': 'Operasional',
      'icon': Icons.restaurant_rounded,
    },
    {
      'id': '3',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'description': 'Miniso - Biaya Marketing',
      'amount': 5000000,
      'type': 'expense',
      'category': 'Marketing',
      'icon': Icons.campaign_rounded,
    },
    {
      'id': '4',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'description': 'Kopi Kenangan - Royalti',
      'amount': 5000000,
      'type': 'expense',
      'category': 'Royalti',
      'icon': Icons.percent_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Pelacakan'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_rounded),
            onPressed: () {},
            color: AppColors.textPrimary,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            _buildPeriodSelector(),
            const SizedBox(height: 20),

            // Summary Cards
            _buildSummaryCards(),
            const SizedBox(height: 20),

            // Net Profit Card
            _buildNetProfitCard(),
            const SizedBox(height: 20),

            // Chart Section
            _buildChartSection(),
            const SizedBox(height: 20),

            // Transactions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaksi Terkini',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Transactions List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildTransactionItem(_transactions[index]),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Tambah'),
        icon: const Icon(Icons.add_rounded),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: _periods.map((period) {
          final isSelected = period == _selectedPeriod;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? Border.all(color: AppColors.primary, width: 1)
                      : null,
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSub,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Total Pendapatan',
            amount: 45000000,
            color: AppColors.success,
            icon: Icons.trending_up_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            title: 'Total Pengeluaran',
            amount: 25000000,
            color: AppColors.error,
            icon: Icons.trending_down_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int amount,
    required Color color,
    required IconData icon,
  }) {
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSub,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Rp ${(amount / 1000000).toStringAsFixed(0)}Jt',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetProfitCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Net Profit Bulan Ini',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white70,
                  fontSize: 13,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Rp 20.000.000',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '+5.2%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
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
          const Text(
            'Analisis Keuangan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 30000000,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['Jan', 'Feb', 'Mar'];
                        return Text(
                          titles[value.toInt()],
                          style: const TextStyle(
                            color: AppColors.textSub,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _buildBarGroup(0, 25000000, 15000000),
                  _buildBarGroup(1, 30000000, 18000000),
                  _buildBarGroup(2, 28000000, 16000000),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Pendapatan',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSub,
                      fontSize: 12,
                    ),
              ),
              const SizedBox(width: 24),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Pengeluaran',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSub,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(
    int x,
    double income,
    double expense,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: income,
          color: AppColors.primary,
          width: 8,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
        BarChartRodData(
          toY: expense,
          color: AppColors.error,
          width: 8,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
      groupVertically: true,
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    return Container(
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (transaction['type'] == 'income'
                      ? AppColors.success
                      : AppColors.error)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              transaction['icon'] as IconData,
              color: transaction['type'] == 'income'
                  ? AppColors.success
                  : AppColors.error,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['description'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd MMM yyyy').format(transaction['date']),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSub,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${transaction['type'] == 'income' ? '+' : '-'} Rp ${(transaction['amount'] / 1000000).toStringAsFixed(0)}Jt',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: transaction['type'] == 'income'
                  ? AppColors.success
                  : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
