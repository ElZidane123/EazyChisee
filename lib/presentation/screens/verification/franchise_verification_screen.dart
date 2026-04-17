// ════════════════════════════════════════════════════════════════
//  EazyChise · Franchise Verification Screen
//  Multi-step form: Informasi Bisnis → Dokumen → Pemilik
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/models/franchisor_verification_model.dart';
import 'package:eazychise/core/providers/verification_provider.dart';
import 'package:eazychise/presentation/screens/verification/verification_status_screen.dart';

class FranchiseVerificationScreen extends StatefulWidget {
  const FranchiseVerificationScreen({super.key});

  @override
  State<FranchiseVerificationScreen> createState() =>
      _FranchiseVerificationScreenState();
}

class _FranchiseVerificationScreenState
    extends State<FranchiseVerificationScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  // ── Tab 1: Informasi Bisnis ──────────────────────────────────
  final _brandNameController = TextEditingController();
  final _foundedYearController = TextEditingController();
  final _outletsController = TextEditingController();
  final _investMinController = TextEditingController();
  final _investMaxController = TextEditingController();
  final _roiController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'F&B';
  final _formKey1 = GlobalKey<FormState>();

  static const List<String> _categories = [
    'F&B',
    'Retail',
    'Jasa & Layanan',
    'Pendidikan',
    'Kesehatan & Kecantikan',
    'Teknologi',
    'Otomotif',
    'Lainnya',
  ];

  // ── Tab 2: Dokumen Legalitas ─────────────────────────────────
  final Set<LegalDocumentType> _uploadedDocs = {};

  // ── Tab 3: Pemilik Bisnis ────────────────────────────────────
  final _ownerNameController = TextEditingController();
  final _ownerEmailController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  bool _agreedToTerms = false;
  final _formKey3 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    // Inisialisasi awal sebelum _updateProgress dipanggil
    _progressAnimation = const AlwaysStoppedAnimation<double>(0);
    _updateProgress();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _brandNameController.dispose();
    _foundedYearController.dispose();
    _outletsController.dispose();
    _investMinController.dispose();
    _investMaxController.dispose();
    _roiController.dispose();
    _descriptionController.dispose();
    _ownerNameController.dispose();
    _ownerEmailController.dispose();
    _ownerPhoneController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    final current = _progressAnimation.value;
    final target = (_currentStep + 1) / 3;
    _progressAnimation = Tween<double>(
      begin: current,
      end: target,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    _progressController.forward(from: 0);
  }

  void _nextStep() {
    bool valid = false;
    if (_currentStep == 0) valid = _formKey1.currentState?.validate() ?? false;
    if (_currentStep == 1) {
      if (_uploadedDocs.isEmpty) {
        _showSnack('Upload minimal 1 dokumen legalitas', isError: true);
        return;
      }
      valid = true;
    }
    if (_currentStep == 2) valid = _formKey3.currentState?.validate() ?? false;

    if (valid) {
      setState(() {
        _currentStep++;
        _updateProgress();
      });
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _updateProgress();
      });
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _submitVerification() async {
    if (!_agreedToTerms) {
      _showSnack('Anda harus menyetujui pernyataan keaslian data', isError: true);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => _buildConfirmDialog(ctx),
    );
    if (confirmed != true) return;

    final provider = Provider.of<VerificationProvider>(context, listen: false);
    final success = await provider.submitVerification(
      brandName: _brandNameController.text.trim(),
      businessCategory: _selectedCategory,
      foundedYear: _foundedYearController.text.trim(),
      numberOfOutlets: int.tryParse(_outletsController.text) ?? 0,
      investmentMin: double.tryParse(_investMinController.text.replaceAll('.', '')) ?? 0,
      investmentMax: double.tryParse(_investMaxController.text.replaceAll('.', '')) ?? 0,
      expectedRoi: double.tryParse(_roiController.text) ?? 0,
      shortDescription: _descriptionController.text.trim(),
      uploadedDocuments: _uploadedDocs.toList(),
      ownerName: _ownerNameController.text.trim(),
      ownerEmail: _ownerEmailController.text.trim(),
      ownerPhone: _ownerPhoneController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const VerificationStatusScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          _buildHeader(),
          _buildProgressBar(),
          _buildStepIndicator(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: _buildCurrentStep(),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  Header
  // ────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.gradDeep,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 20),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daftarkan Franchise',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Proses verifikasi 2–5 hari kerja',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Langkah ${_currentStep + 1}/3',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  Progress Bar
  // ────────────────────────────────────────────────────────────
  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (_, __) {
        return Container(
          height: 4,
          color: AppColors.divider,
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: _progressAnimation.value,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: AppColors.grad),
              ),
            ),
          ),
        );
      },
    );
  }

  // ────────────────────────────────────────────────────────────
  //  Step Indicator Pills
  // ────────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    final steps = ['Bisnis', 'Dokumen', 'Pemilik'];
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isDone = i < _currentStep;
          final isActive = i == _currentStep;
          return Expanded(
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? AppColors.primary
                        : isActive
                            ? AppColors.primary
                            : AppColors.surfaceDim,
                    border: Border.all(
                      color: isActive ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: isActive ? Colors.white : AppColors.textHint,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[i],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                          color: isActive
                              ? AppColors.primary
                              : isDone
                                  ? AppColors.textSub
                                  : AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 1,
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      color: i < _currentStep
                          ? AppColors.primary
                          : AppColors.divider,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  Current Step Content
  // ────────────────────────────────────────────────────────────
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1(key: const ValueKey('step1'));
      case 1:
        return _buildStep2(key: const ValueKey('step2'));
      default:
        return _buildStep3(key: const ValueKey('step3'));
    }
  }

  // ─── STEP 1: Informasi Bisnis ───────────────────────────────
  Widget _buildStep1({Key? key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionCard(
              title: 'Informasi Bisnis',
              icon: Icons.storefront_rounded,
              children: [
                _buildField(
                  controller: _brandNameController,
                  label: 'Nama Brand Franchise',
                  icon: Icons.badge_outlined,
                  hint: 'Contoh: Kopi Nusantara',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Nama brand wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildDropdown(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        controller: _foundedYearController,
                        label: 'Tahun Berdiri',
                        icon: Icons.calendar_today_outlined,
                        hint: '2020',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Wajib diisi';
                          final year = int.tryParse(v);
                          if (year == null || year < 1900 || year > 2026) {
                            return 'Tahun tidak valid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildField(
                        controller: _outletsController,
                        label: 'Jumlah Outlet',
                        icon: Icons.store_outlined,
                        hint: '10',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: 'Estimasi Investasi',
              icon: Icons.attach_money_rounded,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        controller: _investMinController,
                        label: 'Modal Minimum (Rp)',
                        icon: Icons.south_west_rounded,
                        hint: '150000000',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildField(
                        controller: _investMaxController,
                        label: 'Modal Maksimum (Rp)',
                        icon: Icons.north_east_rounded,
                        hint: '300000000',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller: _roiController,
                  label: 'Estimasi ROI (%/tahun)',
                  icon: Icons.trending_up_rounded,
                  hint: '25',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller: _descriptionController,
                  label: 'Deskripsi Singkat Bisnis',
                  icon: Icons.description_outlined,
                  hint: 'Ceritakan keunggulan franchise Anda...',
                  maxLines: 4,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Deskripsi wajib diisi';
                    if (v.length < 50) return 'Minimal 50 karakter';
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // ─── STEP 2: Dokumen Legalitas ──────────────────────────────
  Widget _buildStep2({Key? key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accentBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    color: AppColors.warning, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Upload minimal 1 dokumen untuk melanjutkan. Dokumen asli akan diverifikasi oleh tim kami.',
                    style: TextStyle(
                      color: AppColors.textSub,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionCard(
            title: 'Dokumen Legalitas',
            icon: Icons.folder_outlined,
            children: LegalDocumentType.values.map((docType) {
              final isUploaded = _uploadedDocs.contains(docType);
              return _buildDocumentItem(docType, isUploaded);
            }).toList(),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Persyaratan Dokumen',
            icon: Icons.checklist_rounded,
            children: [
              _buildRequirement('Format file: PDF, JPG, PNG'),
              _buildRequirement('Ukuran maksimal: 10 MB per file'),
              _buildRequirement('Dokumen harus masih berlaku'),
              _buildRequirement('Dokumen harus terbaca dengan jelas'),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(LegalDocumentType docType, bool isUploaded) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isUploaded) {
            _uploadedDocs.remove(docType);
            _showSnack('Dokumen dihapus');
          } else {
            _uploadedDocs.add(docType);
            _showSnack('Dokumen berhasil diunggah ✓');
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUploaded
              ? AppColors.primaryBg
              : AppColors.bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUploaded ? AppColors.primary : AppColors.divider,
            width: isUploaded ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isUploaded
                    ? AppColors.primary
                    : AppColors.surfaceDim,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isUploaded
                    ? Icons.check_rounded
                    : Icons.upload_file_rounded,
                color: isUploaded ? Colors.white : AppColors.textHint,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FranchisorVerificationModel.documentLabel(docType),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isUploaded
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isUploaded ? 'Berhasil diunggah' : 'Ketuk untuk unggah',
                    style: TextStyle(
                      fontSize: 12,
                      color: isUploaded
                          ? AppColors.primaryDark
                          : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isUploaded
                  ? Icons.check_circle_rounded
                  : Icons.arrow_forward_ios_rounded,
              color: isUploaded ? AppColors.primary : AppColors.textHint,
              size: isUploaded ? 20 : 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSub,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ─── STEP 3: Data Pemilik ───────────────────────────────────
  Widget _buildStep3({Key? key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionCard(
              title: 'Data Pemilik / Penanggung Jawab',
              icon: Icons.person_rounded,
              children: [
                _buildField(
                  controller: _ownerNameController,
                  label: 'Nama Lengkap',
                  icon: Icons.badge_outlined,
                  hint: 'Sesuai KTP',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller: _ownerEmailController,
                  label: 'Email Bisnis',
                  icon: Icons.email_outlined,
                  hint: 'owner@bisnis.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email wajib diisi';
                    if (!v.contains('@') || !v.contains('.')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller: _ownerPhoneController,
                  label: 'Nomor HP/WhatsApp',
                  icon: Icons.phone_outlined,
                  hint: '08xx-xxxx-xxxx',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Nomor HP wajib diisi';
                    if (v.length < 10) return 'Nomor tidak valid';
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Pernyataan Keaslian
            GestureDetector(
              onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _agreedToTerms ? AppColors.primaryBg : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _agreedToTerms ? AppColors.primary : AppColors.divider,
                    width: _agreedToTerms ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _agreedToTerms
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _agreedToTerms
                              ? AppColors.primary
                              : AppColors.textHint,
                          width: 2,
                        ),
                      ),
                      child: _agreedToTerms
                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSub,
                            height: 1.5,
                          ),
                          children: const [
                            TextSpan(
                              text:
                                  'Saya menyatakan bahwa seluruh data dan dokumen yang diberikan adalah ',
                            ),
                            TextSpan(
                              text: 'benar dan sah',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '. Saya memahami bahwa data palsu dapat mengakibatkan pemblokiran akun.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  Reusable Widgets
  // ────────────────────────────────────────────────────────────
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        labelStyle: const TextStyle(color: AppColors.textSub, fontSize: 14),
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
        filled: true,
        fillColor: AppColors.bg,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      onChanged: (v) => setState(() => _selectedCategory = v!),
      items: _categories
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList(),
      decoration: InputDecoration(
        labelText: 'Kategori Bisnis',
        prefixIcon: const Icon(Icons.category_outlined,
            color: AppColors.primary, size: 20),
        labelStyle: const TextStyle(color: AppColors.textSub, fontSize: 14),
        filled: true,
        fillColor: AppColors.bg,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      dropdownColor: AppColors.surface,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: AppColors.textSub),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  Bottom Navigation Bar
  // ────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    final isLastStep = _currentStep == 2;
    return Consumer<VerificationProvider>(
      builder: (_, provider, __) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                if (_currentStep > 0) ...[
                  OutlinedButton(
                    onPressed: _prevStep,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: Size.zero,
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back_rounded, size: 18),
                        SizedBox(width: 6),
                        Text('Kembali',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: GestureDetector(
                    onTap: provider.isSubmitting
                        ? null
                        : (isLastStep ? _submitVerification : _nextStep),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.grad,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: provider.isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isLastStep ? 'Ajukan Verifikasi' : 'Lanjut',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    isLastStep
                                        ? Icons.send_rounded
                                        : Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ────────────────────────────────────────────────────────────
  //  Confirm Dialog
  // ────────────────────────────────────────────────────────────
  Widget _buildConfirmDialog(BuildContext ctx) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: AppColors.grad),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_outlined,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ajukan Verifikasi?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Data Anda akan ditinjau oleh tim EazyChise dalam 2–5 hari kerja. Pastikan semua informasi sudah benar.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSub,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSub,
                      side: BorderSide(
                          color: AppColors.textHint.withOpacity(0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Periksa Lagi'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Ya, Ajukan',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
