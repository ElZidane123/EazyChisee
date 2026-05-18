import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/models/funding_model.dart';

class FundingCard extends StatelessWidget {
  final FundingModel funding;
  final VoidCallback onTap;

  const FundingCard({
    super.key,
    required this.funding,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(funding.status);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStatusIcon(funding.status),
                      color: statusColor,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      funding.franchiseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      funding.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn(
                    'Amount',
                    'Rp ${(funding.amount / 1000000).toStringAsFixed(0)}Jt',
                  ),
                  _buildInfoColumn(
                    'Funded',
                    '${((funding.fundedAmount / funding.amount) * 100).toStringAsFixed(0)}%',
                  ),
                  _buildInfoColumn(
                    'Tenure',
                    '${funding.tenureMonths}m',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: funding.fundedAmount / funding.amount,
                backgroundColor: AppColors.surfaceDim,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Applied: ${DateFormat('dd MMM yyyy').format(funding.applicationDate)}',
                style: const TextStyle(
                  color: AppColors.textSub,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSub, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'rejected':
        return AppColors.error;
      case 'disbursed':
        return AppColors.info;
      default:
        return AppColors.textHint;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle;
      case 'pending':
        return Icons.hourglass_empty;
      case 'rejected':
        return Icons.cancel;
      case 'disbursed':
        return Icons.account_balance;
      default:
        return Icons.help;
    }
  }
}