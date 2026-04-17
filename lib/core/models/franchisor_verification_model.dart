// ════════════════════════════════════════════════════════════════
//  EazyChise · Franchisor Verification Model
// ════════════════════════════════════════════════════════════════

enum VerificationStatus { pending, underReview, verified, rejected }

enum LegalDocumentType { nib, siup, aktaNotaris, npwp, tdp }

class FranchisorVerificationModel {
  final String id;
  final DateTime submittedAt;
  final VerificationStatus status;
  final String? rejectionReason;

  // Tab 1 — Informasi Bisnis
  final String brandName;
  final String businessCategory;
  final String foundedYear;
  final int numberOfOutlets;
  final double investmentMin;
  final double investmentMax;
  final double expectedRoi;
  final String shortDescription;

  // Tab 2 — Dokumen Legalitas
  final List<LegalDocumentType> uploadedDocuments;

  // Tab 3 — Pemilik Bisnis
  final String ownerName;
  final String ownerEmail;
  final String ownerPhone;
  final bool agreedToTerms;

  FranchisorVerificationModel({
    required this.id,
    required this.submittedAt,
    required this.status,
    this.rejectionReason,
    required this.brandName,
    required this.businessCategory,
    required this.foundedYear,
    required this.numberOfOutlets,
    required this.investmentMin,
    required this.investmentMax,
    required this.expectedRoi,
    required this.shortDescription,
    required this.uploadedDocuments,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.agreedToTerms,
  });

  /// Nama status yang ramah untuk ditampilkan ke user
  String get statusLabel {
    switch (status) {
      case VerificationStatus.pending:
        return 'Menunggu Review';
      case VerificationStatus.underReview:
        return 'Sedang Ditinjau';
      case VerificationStatus.verified:
        return 'Terverifikasi';
      case VerificationStatus.rejected:
        return 'Ditolak';
    }
  }

  /// Nama dokumen legalitas yang ramah
  static String documentLabel(LegalDocumentType type) {
    switch (type) {
      case LegalDocumentType.nib:
        return 'NIB (Nomor Induk Berusaha)';
      case LegalDocumentType.siup:
        return 'SIUP (Surat Izin Usaha)';
      case LegalDocumentType.aktaNotaris:
        return 'Akta Notaris Perusahaan';
      case LegalDocumentType.npwp:
        return 'NPWP Perusahaan';
      case LegalDocumentType.tdp:
        return 'TDP (Tanda Daftar Perusahaan)';
    }
  }

  FranchisorVerificationModel copyWith({
    VerificationStatus? status,
    String? rejectionReason,
  }) {
    return FranchisorVerificationModel(
      id: id,
      submittedAt: submittedAt,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      brandName: brandName,
      businessCategory: businessCategory,
      foundedYear: foundedYear,
      numberOfOutlets: numberOfOutlets,
      investmentMin: investmentMin,
      investmentMax: investmentMax,
      expectedRoi: expectedRoi,
      shortDescription: shortDescription,
      uploadedDocuments: uploadedDocuments,
      ownerName: ownerName,
      ownerEmail: ownerEmail,
      ownerPhone: ownerPhone,
      agreedToTerms: agreedToTerms,
    );
  }
}
