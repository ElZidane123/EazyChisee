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
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: AppColors.shadowSm,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Image
                  Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(franchise.images),
                        fit: BoxFit.cover,
                      ),
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
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (franchise.isVerified)
                              Container(
                                margin: const EdgeInsets.only(left: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.verified_rounded,
                                      color: AppColors.primary,
                                      size: 12,
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      'Verified',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
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
                                  color: AppColors.goldBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Pick',
                                  style: TextStyle(
                                    color: AppColors.gold,
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
                          style: const TextStyle(
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
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.successBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.trending_up,
                                    size: 10,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${franchise.roi}%',
                                    style: const TextStyle(
                                      color: AppColors.success,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 10,
                                    color: AppColors.gold,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    franchise.rating.toString(),
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: _getTrustColor(franchise.trustScore)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.shield_rounded,
                                    size: 10,
                                    color:
                                        _getTrustColor(franchise.trustScore),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${franchise.trustScore}',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: _getTrustColor(franchise.trustScore),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rp ${(franchise.investmentMin / 1000000).toStringAsFixed(0)}Jt - ${(franchise.investmentMax / 1000000).toStringAsFixed(0)}Jt',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                                fontSize: 12,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                provider.isBookmarked(franchise)
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                color: provider.isBookmarked(franchise)
                                    ? AppColors.primary
                                    : AppColors.textHint,
                                size: 18,
                              ),
                              onPressed: () {
                                provider.toggleBookmark(franchise);
                              },
                              constraints: BoxConstraints.tight(Size(32, 32)),
                              padding: EdgeInsets.zero,
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
