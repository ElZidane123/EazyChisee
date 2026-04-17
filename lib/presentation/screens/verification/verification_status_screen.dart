// ════════════════════════════════════════════════════════════════
//  EazyChise · Verification Status Screen
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/models/franchisor_verification_model.dart';
import 'package:eazychise/core/providers/verification_provider.dart';
import 'package:eazychise/presentation/screens/verification/franchise_verification_screen.dart';

class VerificationStatusScreen extends StatefulWidget {
  const VerificationStatusScreen({super.key});

  @override
  State<VerificationStatusScreen> createState() =>
      _VerificationStatusScreenState();
}

class _VerificationStatusScreenState extends State<VerificationStatusScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0, 0.6, curve: Curves.elasticOut),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.3, 1, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VerificationProvider>(
      builder: (_, provider, __) {
        final submission = provider.currentSubmission;
        if (submission == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.bg,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(submission),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildStatusCard(submission),
                        const SizedBox(height: 20),
                        _buildTimelineCard(submission),
                        const SizedBox(height: 20),
                        _buildSummaryCard(submission),
                        if (submission.status == VerificationStatus.rejected)
                          _buildRejectionCard(submission, provider),
                        // Demo buttons (untuk keperluan presentasi)
                        const SizedBox(height: 20),
                        _buildDemoButtons(provider),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ────────────────────────────────────────────────────────────
  //  App Bar
  // ────────────────────────────────────────────────────────────
  SliverAppBar _buildAppBar(FranchisorVerificationModel s) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: _statusColor(s.status),
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.popUntil(
          context,
          (route) => route.isFirst,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _statusColor(s.status),
                _statusColorLight(s.status),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _statusIcon(s.status),
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  s.statusLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  Status Card
  // ────────────────────────────────────────────────────────────
  Widget _buildStatusCard(FranchisorVerificationModel s) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _statusColor(s.status).withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: _statusColor(s.status).withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.brandName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.businessCategory,
                      style: const TextStyle(
                        color: AppColors.textSub,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(s.status),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                Icons.tag_rounded,
                'ID: ${s.id.substring(s.id.length - 8)}',
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                Icons.schedule_rounded,
                _formatDate(s.submittedAt),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(VerificationStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _statusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _statusColor(status).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _statusColor(status),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _statusShortLabel(status),
            style: TextStyle(
              color: _statusColor(status),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textSub),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSub,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  Timeline Card
  // ────────────────────────────────────────────────────────────
  Widget _buildTimelineCard(FranchisorVerificationModel s) {
    final steps = [
      {
        'title': 'Pengajuan Dikirim',
        'subtitle': 'Data Anda telah berhasil diterima',
        'done': true,
        'icon': Icons.send_rounded,
      },
      {
        'title': 'Review Dokumen',
        'subtitle': 'Tim kami sedang memverifikasi dokumen legalitas',
        'done': s.status != VerificationStatus.pending,
        'icon': Icons.find_in_page_rounded,
      },
      {
        'title': 'Verifikasi Identitas',
        'subtitle': 'Pengecekan data pemilik & izin usaha',
        'done': s.status == VerificationStatus.verified,
        'icon': Icons.verified_user_rounded,
      },
      {
        'title': 'Keputusan Final',
        'subtitle': s.status == VerificationStatus.verified
            ? 'Franchise Anda resmi terdaftar ✓'
            : s.status == VerificationStatus.rejected
                ? 'Pengajuan ditolak — lihat alasan di bawah'
                : 'Diperkirakan 2–5 hari kerja',
        'done': s.status == VerificationStatus.verified ||
            s.status == VerificationStatus.rejected,
        'icon': s.status == VerificationStatus.rejected
            ? Icons.cancel_rounded
            : Icons.check_circle_rounded,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.timeline_rounded,
                    color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Progres Verifikasi',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(steps.length, (i) {
            final step = steps[i];
            final isDone = step['done'] as bool;
            final isLast = i == steps.length - 1;
            final isRejected = s.status == VerificationStatus.rejected && i == 3;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isRejected
                            ? AppColors.error.withOpacity(0.1)
                            : isDone
                                ? AppColors.primary
                                : AppColors.surfaceDim,
                        border: Border.all(
                          color: isRejected
                              ? AppColors.error
                              : isDone
                                  ? AppColors.primary
                                  : AppColors.divider,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          step['icon'] as IconData,
                          size: 16,
                          color: isRejected
                              ? AppColors.error
                              : isDone
                                  ? Colors.white
                                  : AppColors.textHint,
                        ),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 36,
                        color: isDone ? AppColors.primary : AppColors.divider,
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(
                          step['title'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isRejected
                                ? AppColors.error
                                : isDone
                                    ? AppColors.textPrimary
                                    : AppColors.textHint,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          step['subtitle'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSub,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  Summary Card
  // ────────────────────────────────────────────────────────────
  Widget _buildSummaryCard(FranchisorVerificationModel s) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.receipt_long_rounded,
                    color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Ringkasan Pengajuan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),
          _summaryRow('Nama Brand', s.brandName),
          _summaryRow('Kategori', s.businessCategory),
          _summaryRow('Tahun Berdiri', s.foundedYear),
          _summaryRow('Jumlah Outlet', '${s.numberOfOutlets} outlet'),
          _summaryRow(
            'Estimasi Modal',
            'Rp ${_formatMoney(s.investmentMin)} – ${_formatMoney(s.investmentMax)}',
          ),
          _summaryRow('Ekspektasi ROI', '${s.expectedRoi}% / tahun'),
          _summaryRow('Pemilik', s.ownerName),
          _summaryRow('Kontak', s.ownerEmail),
          _summaryRow('Dokumen', '${s.uploadedDocuments.length} file'),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textHint,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  Rejection Card
  // ────────────────────────────────────────────────────────────
  Widget _buildRejectionCard(
      FranchisorVerificationModel s, VerificationProvider provider) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.errorBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.error.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.cancel_rounded, color: AppColors.error, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Alasan Penolakan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                s.rejectionReason ?? 'Dokumen tidak lengkap atau tidak valid.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSub,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  provider.resetSubmission();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FranchiseVerificationScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: AppColors.gradCoral),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_rounded,
                            color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Ajukan Ulang',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────
  //  Demo Buttons (untuk keperluan presentasi)
  // ────────────────────────────────────────────────────────────
  Widget _buildDemoButtons(VerificationProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.science_outlined,
                  color: AppColors.textHint, size: 16),
              SizedBox(width: 6),
              Text(
                'Simulasi (Mode Demo)',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => provider.simulateApproval(),
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                  label: const Text('Setujui'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    textStyle: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size.zero,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => provider.simulateRejection(
                    'Dokumen SIUP yang diunggah sudah kadaluarsa. Harap unggah ulang dokumen yang masih berlaku.',
                  ),
                  icon: const Icon(Icons.cancel_outlined, size: 16),
                  label: const Text('Tolak'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    textStyle: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size.zero,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  Helpers
  // ────────────────────────────────────────────────────────────
  Color _statusColor(VerificationStatus s) {
    switch (s) {
      case VerificationStatus.verified:
        return AppColors.primary;
      case VerificationStatus.rejected:
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  Color _statusColorLight(VerificationStatus s) {
    switch (s) {
      case VerificationStatus.verified:
        return AppColors.primaryLight;
      case VerificationStatus.rejected:
        return const Color(0xFFF87171);
      default:
        return const Color(0xFFFBBF24);
    }
  }

  IconData _statusIcon(VerificationStatus s) {
    switch (s) {
      case VerificationStatus.verified:
        return Icons.verified_rounded;
      case VerificationStatus.rejected:
        return Icons.cancel_rounded;
      default:
        return Icons.hourglass_empty_rounded;
    }
  }

  String _statusShortLabel(VerificationStatus s) {
    switch (s) {
      case VerificationStatus.verified:
        return 'Terverifikasi';
      case VerificationStatus.rejected:
        return 'Ditolak';
      case VerificationStatus.underReview:
        return 'Ditinjau';
      default:
        return 'Pending';
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatMoney(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}M';
    }
    return '${(amount / 1000000).toStringAsFixed(0)}Jt';
  }
}
