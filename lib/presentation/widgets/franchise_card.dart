import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/models/franchise_model.dart';
import 'package:eazychise/core/providers/franchise_provider.dart';

class FranchiseCard extends StatelessWidget {
  final FranchiseModel franchise;
  final VoidCallback onTap;

  const FranchiseCard({
    super.key,
    required this.franchise,
    required this.onTap,
  });

  Color _getTrustColor(int score) {
    if (score >= 85) return AppColors.success;
    if (score >= 70) return AppColors.warning;
    return AppColors.error;
  }

  Color _getRiskColor(String risk) {
    if (risk == 'Low') return AppColors.success;
    if (risk == 'Medium') return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FranchiseProvider>(
      builder: (context, provider, child) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(franchise.images),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      // child: Icon(
                      //   Icons.store,
                      //   size: 40,
                      //   color: AppColors.primary.withOpacity(0.5),
                      // ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                franchise.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (franchise.isVerified)
                              Container(
                                margin: const EdgeInsets.only(left: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: AppColors.grad,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified_rounded,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      'Terverifikasi',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (franchise.isRecommended) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'AI Pick',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          franchise.category,
                          style: TextStyle(
                            color: AppColors.textSub,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.trending_up,
                                    size: 12,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${franchise.roi}%',
                                    style: const TextStyle(
                                      color: AppColors.success,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.info.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 12,
                                    color: AppColors.warning,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    franchise.rating.toString(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getTrustColor(franchise.trustScore).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.shield,
                                    size: 12,
                                    color: _getTrustColor(franchise.trustScore),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${franchise.trustScore}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _getTrustColor(franchise.trustScore),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (franchise.riskPrediction.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getRiskColor(franchise.riskPrediction).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  franchise.riskPrediction,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _getRiskColor(franchise.riskPrediction),
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rp ${(franchise.investmentMin / 1000000).toStringAsFixed(0)}Jt - ${(franchise.investmentMax / 1000000).toStringAsFixed(0)}Jt',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 12,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                provider.isBookmarked(franchise)
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: provider.isBookmarked(franchise)
                                    ? AppColors.primary
                                    : AppColors.textHint,
                                size: 20,
                              ),
                              onPressed: () {
                                provider.toggleBookmark(franchise);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
