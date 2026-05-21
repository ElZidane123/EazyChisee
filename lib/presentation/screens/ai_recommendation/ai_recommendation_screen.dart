import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:eazychise/core/models/franchise_model.dart';
import 'package:eazychise/core/providers/franchise_provider.dart';
import 'package:eazychise/presentation/widgets/franchise_card.dart';

// ============================================================
// MODERN ORANGE COLOR PALETTE (No gradients)
// ============================================================
const Color _orangePrimary = Color(0xFFF85C2E);
const Color _orangeLight = Color(0xFFFFF0EA);
const Color _orangeBg = Color(0xFFFFF6F2);
const Color _orangeDark = Color(0xFFE04A1F);

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

  final Map<String, String> _answers = {};
  List<FranchiseModel> _recommendations = [];

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Berapa kisaran modal yang Anda siapkan?',
      'key': 'budget',
      'icon': Icons.account_balance_wallet_rounded,
      'options': [
        {'label': '< Rp 100 Juta', 'value': 'small', 'icon': Icons.savings_rounded},
        {'label': 'Rp 100 - 250 Juta', 'value': 'medium', 'icon': Icons.account_balance_wallet_rounded},
        {'label': 'Rp 250 - 500 Juta', 'value': 'large', 'icon': Icons.account_balance_rounded},
        {'label': '> Rp 500 Juta', 'value': 'xlarge', 'icon': Icons.workspace_premium_rounded},
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
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
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
      appBar: _isAnalyzing || _showResults
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: const Text(
                'AI Rekomendasi',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  letterSpacing: -0.3,
                  color: AppColors.textPrimary,
                ),
              ),
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
        // Header with progress
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          color: Colors.white,
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _orangeLight,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.quiz_rounded, size: 16, color: _orangePrimary),
                        const SizedBox(width: 6),
                        Text(
                          '${_currentQuestion + 1}/${_questions.length}',
                          style: const TextStyle(
                            color: _orangePrimary,
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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_currentQuestion + 1) / _questions.length,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceDim,
                  valueColor: const AlwaysStoppedAnimation<Color>(_orangePrimary),
                ),
              ),
            ],
          ),
        ),

        // Main content
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _questions.length,
            onPageChanged: (index) => setState(() => _currentQuestion = index),
            itemBuilder: (context, index) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildQuestionPage(index),
                ),
              );
            },
          ),
        ),

        // Bottom navigation
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
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
                      side: const BorderSide(color: AppColors.border, width: 1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Kembali', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              if (_currentQuestion > 0) const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orangePrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentQuestion == _questions.length - 1 ? 'Lihat Hasil' : 'Lanjut',
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
          // Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _orangeLight,
              shape: BoxShape.circle,
            ),
            child: Icon(question['icon'] as IconData, color: _orangePrimary, size: 32),
          ),
          const SizedBox(height: 24),

          // Question text
          Text(
            question['question'] as String,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Pilih salah satu opsi di bawah',
            style: TextStyle(
              color: AppColors.textSub,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),

          // Options
          ...(question['options'] as List).map((option) {
            final isSelected = currentAnswer == option['value'];
            return _buildOptionCard(
              label: option['label'],
              icon: option['icon'],
              isSelected: isSelected,
              onTap: () => setState(() => _answers[questionKey] = option['value']),
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? _orangeLight : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _orangePrimary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: _orangePrimary.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? _orangePrimary : _orangeLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: isSelected ? Colors.white : _orangePrimary, size: 22),
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
                decoration: const BoxDecoration(color: _orangePrimary, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
              ),
          ],
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

    setState(() => _isAnalyzing = true);
    Future.delayed(const Duration(seconds: 2), () {
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
    Map<FranchiseModel, int> scores = {};

    for (var franchise in allFranchises) {
      int score = 0;

      // Budget
      final budget = _answers['budget'];
      if (budget == 'small' && franchise.investmentMin <= 100000000) score += 30;
      else if (budget == 'medium' && franchise.investmentMin >= 100000000 && franchise.investmentMin <= 250000000) score += 30;
      else if (budget == 'large' && franchise.investmentMin >= 250000000 && franchise.investmentMin <= 500000000) score += 30;
      else if (budget == 'xlarge' && franchise.investmentMin >= 500000000) score += 30;
      else score += 5;

      // Industry
      final industry = _answers['industry'];
      if (franchise.category.contains(industry ?? '')) score += 25;
      else if (industry == 'F&B' && (franchise.category.contains('Food') || franchise.category.contains('Beverage'))) score += 20;
      else score += 5;

      // Experience
      final experience = _answers['experience'];
      if (experience == 'beginner' && franchise.roi < 20) score += 15;
      else if (experience == 'intermediate' && franchise.roi >= 20 && franchise.roi < 30) score += 15;
      else if (experience == 'advanced' && franchise.roi >= 30) score += 15;
      else score += 5;

      // Involvement
      final involvement = _answers['involvement'];
      if (involvement == 'passive' && franchise.roi > 15) score += 15;
      else if (involvement == 'active' && franchise.paybackPeriod < 24) score += 15;
      else if (involvement == 'semi' && franchise.paybackPeriod >= 24 && franchise.paybackPeriod <= 36) score += 15;
      else score += 5;

      // Rating bonus
      if (franchise.rating >= 4.5) score += 15;
      else if (franchise.rating >= 4.0) score += 10;

      scores[franchise] = score;
    }

    var sortedEntries = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    _recommendations = sortedEntries.take(5).map((e) => e.key).toList();
  }

  Widget _buildAnalysisScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated AI icon
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 1500),
            tween: Tween<double>(begin: 0, end: 1),
            curve: Curves.easeInOutCubic,
            builder: (context, double value, child) {
              return Transform.scale(
                scale: 0.9 + (0.1 * value),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: _orangeLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: _orangePrimary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: _orangePrimary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.auto_awesome_rounded, size: 48, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),

          const Text(
            'AI Sedang Menganalisis',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Menemukan Franchise terbaik untukmu...',
            style: TextStyle(color: AppColors.textSub, fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 48),

          // Circular progress
          TweenAnimationBuilder(
            duration: const Duration(seconds: 2),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 6,
                        color: _orangePrimary,
                        backgroundColor: _orangeLight,
                      ),
                    ),
                    Text(
                      '${(value * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _orangePrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// AI RECOMMENDATION RESULTS
// ============================================================
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
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..forward();
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
          // App Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
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
              onPressed: () => widget.onBack?.call(),
            ),
          ),

          // Main content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Score card
                FadeTransition(
                  opacity: _animationController,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _orangePrimary,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(color: _orangePrimary.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Analisis AI untukmu',
                                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text('Tingkat Kecocokan', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '92%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -2,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.star_rounded, color: Colors.white, size: 14),
                                    SizedBox(width: 6),
                                    Text('Sangat Cocok', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
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
                const SizedBox(height: 28),

                // Insights
                const Text(
                  'Mengapa rekomendasi ini?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.3),
                ),
                const SizedBox(height: 16),
                ...List.generate(_insights.length, (index) {
                  return FadeTransition(
                    opacity: CurvedAnimation(parent: _animationController, curve: Interval(0.2 + index * 0.1, 1.0)),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border.withOpacity(0.3)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: _orangeLight, shape: BoxShape.circle),
                            child: const Icon(Icons.lightbulb_rounded, color: _orangePrimary, size: 18),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _insights[index],
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.4, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 28),

                const Text(
                  'Rekomendasi Terbaik',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.3),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),

          // Recommendations list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= widget.recommendations.length) return null;
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(0.4 + index * 0.1, 1.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Stack(
                        children: [
                          FranchiseCard(
                            franchise: widget.recommendations[index],
                            onTap: () {},
                          ),
                          if (index == 0)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: _orangeLight,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: _orangePrimary.withOpacity(0.2)),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.emoji_events_rounded, color: _orangePrimary, size: 14),
                                    SizedBox(width: 4),
                                    Text('Pilihan Terbaik', style: TextStyle(color: _orangePrimary, fontSize: 11, fontWeight: FontWeight.w700)),
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