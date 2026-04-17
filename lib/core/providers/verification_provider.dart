// ════════════════════════════════════════════════════════════════
//  EazyChise · Verification Provider
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:eazychise/core/models/franchisor_verification_model.dart';

class VerificationProvider extends ChangeNotifier {
  FranchisorVerificationModel? _currentSubmission;
  bool _isSubmitting = false;
  String? _errorMessage;

  FranchisorVerificationModel? get currentSubmission => _currentSubmission;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  bool get hasSubmission => _currentSubmission != null;

  VerificationStatus? get currentStatus => _currentSubmission?.status;

  /// Kirim pengajuan verifikasi baru
  Future<bool> submitVerification({
    // Tab 1
    required String brandName,
    required String businessCategory,
    required String foundedYear,
    required int numberOfOutlets,
    required double investmentMin,
    required double investmentMax,
    required double expectedRoi,
    required String shortDescription,
    // Tab 2
    required List<LegalDocumentType> uploadedDocuments,
    // Tab 3
    required String ownerName,
    required String ownerEmail,
    required String ownerPhone,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    // Simulasi API call
    await Future.delayed(const Duration(seconds: 2));

    try {
      _currentSubmission = FranchisorVerificationModel(
        id: 'VRF-${DateTime.now().millisecondsSinceEpoch}',
        submittedAt: DateTime.now(),
        status: VerificationStatus.pending,
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
        agreedToTerms: true,
      );

      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mengirim pengajuan. Coba lagi.';
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  /// Simulasi admin menyetujui (untuk demo)
  void simulateApproval() {
    if (_currentSubmission != null) {
      _currentSubmission = _currentSubmission!.copyWith(
        status: VerificationStatus.verified,
      );
      notifyListeners();
    }
  }

  /// Simulasi admin menolak (untuk demo)
  void simulateRejection(String reason) {
    if (_currentSubmission != null) {
      _currentSubmission = _currentSubmission!.copyWith(
        status: VerificationStatus.rejected,
        rejectionReason: reason,
      );
      notifyListeners();
    }
  }

  /// Reset pengajuan (ajukan ulang setelah ditolak)
  void resetSubmission() {
    _currentSubmission = null;
    _errorMessage = null;
    notifyListeners();
  }
}
