import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/models/franchise_model.dart';
import 'package:eazychise/core/providers/franchise_provider.dart';
import 'package:eazychise/presentation/widgets/franchise_card.dart';

class AIRecommendationScreen extends StatefulWidget {
  const AIRecommendationScreen({super.key});

  @override
  State<AIRecommendationScreen> createState() => _AIRecommendationScreenState();
}

class _AIRecommendationScreenState extends State<AIRecommendationScreen>
    with SingleTickerProviderStateMixin {
  bool _isAnalyzing = false;
  bool _showResults = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Data jawaban pengguna
  final Map<String, String> _answers = {};
  List<FranchiseModel> _recommendations = [];
  
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Berapa kisaran modal yang Anda siapkan?',
      'key': 'budget',
      'icon': Icons.account_balance_wallet_rounded,
      'options': [
        {'label': '< Rp 100 Juta', 'value': 'small', 'min': 0, 'max': 100000000, 'icon': Icons.savings_rounded},
        {'label': 'Rp 100 - 250 Juta', 'value': 'medium', 'min': 100000000, 'max': 250000000, 'icon': Icons.account_balance_wallet_rounded},
        {'label': 'Rp 250 - 500 Juta', 'value': 'large', 'min': 250000000, 'max': 500000000, 'icon': Icons.account_balance_rounded},
        {'label': '> Rp 500 Juta', 'value': 'xlarge', 'min': 500000000, 'max': 999999999, 'icon': Icons.workspace_premium_rounded},
      ],
    },
    {
      'question': 'Sektor industri apa yang paling menarik?',
      'key': 'industry',
      'icon': Icons.category_rounded,
      'options': [
        {'label': 'Kuliner', 'value': 'F&B', 'icon': Icons.restaurant_rounded},
        {'label': 'Ritel', 'value': 'Retail', 'icon': Icons.shopping_bag_rounded},
        {'label': 'Pendidikan', 'value': 'Education', 'icon': Icons.school_rounded},
        {'label': 'Kesehatan', 'value': 'Health', 'icon': Icons.health_and_safety_rounded},
        {'label': 'Jasa', 'value': 'Services', 'icon': Icons.handyman_rounded},
      ],
    },
    {
      'question': 'Seberapa berpengalaman Anda dalam bisnis?',
      'key': 'experience',
      'icon': Icons.timeline_rounded,
      'options': [
        {'label': 'Pemula (0-1 tahun)', 'value': 'beginner', 'icon': Icons.eco_rounded},
        {'label': 'Menengah (1-3 tahun)', 'value': 'intermediate', 'icon': Icons.trending_up_rounded},
        {'label': 'Ahli (>3 tahun)', 'value': 'advanced', 'icon': Icons.military_tech_rounded},
      ],
    },
    {
      'question': 'Tingkat keterlibatan yang diinginkan?',
      'key': 'involvement',
      'icon': Icons.psychology_rounded,
      'options': [
        {'label': 'Pasif (Investor)', 'value': 'passive', 'icon': Icons.weekend_rounded},
        {'label': 'Aktif (Operator)', 'value': 'active', 'icon': Icons.directions_run_rounded},
        {'label': 'Semi-aktif', 'value': 'semi', 'icon': Icons.balance_rounded},
      ],
    },
  ];
  
  int _currentQuestion = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  void _resetQuestionnaire() {
    setState(() {
      _currentQuestion = 0;
      _answers.clear();
      _recommendations.clear();
      _isAnalyzing = false;
      _showResults = false;
    });
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: _isAnalyzing || _showResults ? null : AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('AI Rekomendasi', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, letterSpacing: -0.3)),
      ),
      body: SafeArea(
        child: _isAnalyzing
            ? _buildAnalysisScreen()
             : _showResults
                 ? AIRecommendationResults(
                     answers: _answers,
                     recommendations: _recommendations,
                     onBack: _resetQuestionnaire,
                   )
                 : _buildQuestionnaireScreen(),
      ),
    );
  }

  Widget _buildQuestionnaireScreen() {
    return Column(
      children: [
        // Header dengan Progress
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Temukan Franchise idealmu',
                    style: TextStyle(
                      color: AppColors.textSub,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.quiz_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${_currentQuestion + 1}/${_questions.length}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_currentQuestion + 1) / _questions.length,
                  minHeight: 10,
                  backgroundColor: AppColors.surfaceDim,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Konten Utama
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _questions.length,
            onPageChanged: (index) {
              setState(() {
                _currentQuestion = index;
              });
            },
            itemBuilder: (context, index) {
              return TweenAnimationBuilder(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.easeOutCubic,
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: _buildQuestionPage(index),
              );
            },
          ),
        ),

        // Bottom Navigation
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: Row(
            children: [
              if (_currentQuestion > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousQuestion,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSub,
                      side: BorderSide(
                        color: AppColors.textHint.withOpacity(0.5),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Kembali', style: TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              if (_currentQuestion > 0) const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentQuestion == _questions.length - 1
                            ? 'Lihat Hasil'
                            : 'Lanjut',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      if (_currentQuestion < _questions.length - 1) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionPage(int index) {
    final question = _questions[index];
    final questionKey = question['key'] as String;
    final currentAnswer = _answers[questionKey];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon Pertanyaan
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              question['icon'] as IconData,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 24),

          // Teks Pertanyaan
          Text(
            question['question'] as String,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Pilih salah satu opsi di bawah',
            style: TextStyle(
              color: AppColors.textSub,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),

          // Opsi Jawaban
          ...(question['options'] as List).map((option) {
            final isSelected = currentAnswer == option['value'];
            return _buildOptionCard(
              label: option['label'],
              icon: option['icon'],
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _answers[questionKey] = option['value'];
                });
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 200),
      tween: Tween<double>(begin: 1, end: isSelected ? 1.02 : 1),
      curve: Curves.easeOutCubic,
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBg : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ] : AppColors.shadowSm,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _previousQuestion() {
    if (_currentQuestion > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _nextQuestion() {
    final currentKey = _questions[_currentQuestion]['key'] as String;
    if (_answers[currentKey] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Silakan pilih salah satu opsi', style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(20),
        ),
      );
      return;
    }

    if (_currentQuestion < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      _analyzeRecommendations();
    }
  }

  void _analyzeRecommendations() {
    if (_answers.length < _questions.length) return;

    setState(() {
      _isAnalyzing = true;
    });

    // Simulasi analisis AI
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _generateRecommendations();
        setState(() {
          _isAnalyzing = false;
          _showResults = true;
        });
      }
    });
  }

  void _generateRecommendations() {
    final franchiseProvider = Provider.of<FranchiseProvider>(context, listen: false);
    final allFranchises = franchiseProvider.franchises;
    
    // Skor untuk setiap franchise
    Map<FranchiseModel, int> scores = {};
    
    for (var franchise in allFranchises) {
      int score = 0;
      
      // 1. Filter berdasarkan budget
      final budget = _answers['budget'];
      if (budget == 'small' && franchise.investmentMin <= 100000000) score += 30;
      else if (budget == 'medium' && franchise.investmentMin >= 100000000 && franchise.investmentMin <= 250000000) score += 30;
      else if (budget == 'large' && franchise.investmentMin >= 250000000 && franchise.investmentMin <= 500000000) score += 30;
      else if (budget == 'xlarge' && franchise.investmentMin >= 500000000) score += 30;
      else score += 5; // Tetap beri skor kecil jika tidak sesuai budget
      
      // 2. Filter berdasarkan industri
      final industry = _answers['industry'];
      if (franchise.category.contains(industry ?? '')) {
        score += 25;
      } else if (industry == 'F&B' && (franchise.category.contains('Food') || franchise.category.contains('Beverage'))) {
        score += 20;
      } else {
        score += 5;
      }
      
      // 3. Filter berdasarkan pengalaman
      final experience = _answers['experience'];
      if (experience == 'beginner' && franchise.roi < 20) score += 15; // ROI rendah cocok untuk pemula
      else if (experience == 'intermediate' && franchise.roi >= 20 && franchise.roi < 30) score += 15;
      else if (experience == 'advanced' && franchise.roi >= 30) score += 15;
      else score += 5;
      
      // 4. Filter berdasarkan keterlibatan
      final involvement = _answers['involvement'];
      if (involvement == 'passive' && franchise.roi > 15) score += 15; // Investor suka ROI tinggi
      else if (involvement == 'active' && franchise.paybackPeriod < 24) score += 15; // Operator suka payback cepat
      else if (involvement == 'semi' && franchise.paybackPeriod >= 24 && franchise.paybackPeriod <= 36) score += 15;
      else score += 5;
      
      // 5. Bonus untuk rating tinggi
      if (franchise.rating >= 4.5) score += 15;
      else if (franchise.rating >= 4.0) score += 10;
      
      scores[franchise] = score;
    }
    
    // Urutkan berdasarkan skor tertinggi
    var sortedEntries = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Ambil 5 rekomendasi teratas
    _recommendations = sortedEntries.take(5).map((e) => e.key).toList();
  }

  Widget _buildAnalysisScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animasi AI
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 1500),
            tween: Tween<double>(begin: 0, end: 1),
            curve: Curves.easeInOutCubic,
            builder: (context, double value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.2),
                        AppColors.accent.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.grad,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),

          // Teks Analisis
          const Text(
            'AI Sedang Menganalisis',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Menemukan Franchise terbaik untukmu...',
            style: TextStyle(
              color: AppColors.textSub,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 48),

          // Progress Indicator
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 3000),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return SweepGradient(
                              colors: const [
                                AppColors.primary,
                                AppColors.accent,
                                AppColors.primary,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                              transform: GradientRotation(value * 2 * 3.14),
                            ).createShader(bounds);
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 170,
                            height: 170,
                            decoration: const BoxDecoration(
                              color: AppColors.bg,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${(value * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class AIRecommendationResults extends StatefulWidget {
  final Map<String, String> answers;
  final List<FranchiseModel> recommendations;
  final VoidCallback? onBack;

  const AIRecommendationResults({
    super.key,
    required this.answers,
    required this.recommendations,
    this.onBack,
  });

  @override
  State<AIRecommendationResults> createState() => _AIRecommendationResultsState();
}

class _AIRecommendationResultsState extends State<AIRecommendationResults>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  late List<String> _insights;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    
    _generateInsights();
  }

  void _generateInsights() {
    final budget = widget.answers['budget'];
    final industry = widget.answers['industry'];
    final experience = widget.answers['experience'];
    
    _insights = [
      _getBudgetInsight(budget),
      _getIndustryInsight(industry),
      _getExperienceInsight(experience),
    ];
  }
  
  String _getBudgetInsight(String? budget) {
    switch (budget) {
      case 'small':
        return 'Dengan modal di bawah Rp 100 Juta, kami merekomendasikan Franchise skala kecil dengan potensi pertumbuhan yang cepat.';
      case 'medium':
        return 'Modal Rp 100-250 Juta cocok untuk Franchise menengah dengan keseimbangan risiko dan keuntungan yang stabil.';
      case 'large':
        return 'Investasi Rp 250-500 Juta membuka peluang Franchise premium dengan sistem yang sudah sangat matang.';
      case 'xlarge':
        return 'Modal besar memungkinkan Anda memilih Franchise internasional dengan ROI yang menjanjikan.';
      default:
        return 'Berdasarkan preferensi modal Anda, kami fokus pada Franchise yang paling sesuai.';
    }
  }
  
  String _getIndustryInsight(String? industry) {
    switch (industry) {
      case 'F&B':
        return 'Sektor kuliner memiliki potensi tinggi dengan permintaan pasar yang terus bertumbuh pesat.';
      case 'Retail':
        return 'Bisnis ritel menawarkan stabilitas yang baik dan kemudahan dalam melakukan ekspansi.';
      case 'Education':
        return 'Sektor pendidikan terus berkembang seiring dengan meningkatnya kesadaran masyarakat.';
      case 'Health':
        return 'Kesehatan & kecantikan adalah industri dengan pertumbuhan konsisten dan loyalitas tinggi.';
      case 'Services':
        return 'Bisnis jasa memiliki fleksibilitas tinggi dan beban modal operasional yang relatif lebih rendah.';
      default:
        return 'Industri yang Anda pilih memiliki prospek yang cerah ke depannya.';
    }
  }
  
  String _getExperienceInsight(String? experience) {
    switch (experience) {
      case 'beginner':
        return 'Sebagai pemula, kami pilihkan Franchise dengan sistem lengkap dan dukungan intensif.';
      case 'intermediate':
        return 'Pengalaman menengah Anda cocok untuk Franchise dengan tantangan yang terkontrol.';
      case 'advanced':
        return 'Keahlian Anda memungkinkan untuk mengelola Franchise kompleks dengan ROI tinggi.';
      default:
        return 'Rekomendasi ini disesuaikan dengan tingkat pengalaman Anda.';
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar Khusus
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            scrolledUnderElevation: 1,
            title: const Text(
              'Rekomendasi AI',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: -0.3,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              onPressed: () {
                if (widget.onBack != null) {
                  widget.onBack!();
                } else {
                  Navigator.maybePop(context);
                }
              },
            ),
          ),

          // Konten Utama
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // AI Summary Card
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween<double>(begin: 0, end: 1),
                  curve: Curves.easeOutCubic,
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.grad,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.auto_awesome_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Analisis AI untukmu',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Tingkat Kecocokan',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '92%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 56,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -2,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Sangat Cocok',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // AI Insights
                const Text(
                  'Mengapa rekomendasi ini?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(_insights.length, (index) {
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 500 + (index * 100)),
                    tween: Tween<double>(begin: 0, end: 1),
                    curve: Curves.easeOutCubic,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(20 * (1 - value), 0),
                        child: Opacity(opacity: value, child: child),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border, width: 1),
                        boxShadow: AppColors.shadowSm,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBg,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lightbulb_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                _insights[index],
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 32),

                // Top Recommendations
                const Text(
                  'Rekomendasi Terbaik',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),

          // Daftar Rekomendasi
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= widget.recommendations.length) return null;
                  
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 600 + (index * 100)),
                    tween: Tween<double>(begin: 0, end: 1),
                    curve: Curves.easeOutCubic,
                    builder: (context, double value, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: Opacity(opacity: value, child: child),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Stack(
                        children: [
                          FranchiseCard(
                            franchise: widget.recommendations[index],
                            onTap: () {
                              // Navigate to detail
                            },
                          ),
                          if (index == 0)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.emoji_events_rounded,
                                      color: AppColors.gold,
                                      size: 14,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Pilihan Terbaik',
                                      style: TextStyle(
                                        color: AppColors.gold,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: widget.recommendations.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }
}