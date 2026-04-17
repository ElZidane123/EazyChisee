// ════════════════════════════════════════════════════════════════
//  EazyChise · SplashScreen Premium
//  Direction : Luxury Organic · Deep Forest · Frosted Glass
//  Palet     : Emerald Deep #0D5C36 → #1A9E5C · Gold #F5C842
//  Features  : Floating particles, morphing blob BG, staggered
//              text reveals, spring-animated page transitions,
//              shimmer CTA button
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:eazychise/core/constants/app_colors.dart';

// ─────────────────────────────────────────────────────────────
//  DATA MODEL
// ─────────────────────────────────────────────────────────────
class _PageData {
  final String tag;
  final String headline;
  final String subline;
  final String body;
  final IconData icon;
  final List<Color> gradientColors;

  const _PageData({
    required this.tag,
    required this.headline,
    required this.subline,
    required this.body,
    required this.icon,
    required this.gradientColors,
  });
}

const _pages = [
  _PageData(
    tag: 'DISCOVERY',
    headline: 'Temukan\nFranchise',
    subline: 'Impian Anda',
    body: 'Jelajahi ribuan peluang franchise terbaik dari berbagai kategori — sesuai minat, modal, dan ambisi Anda.',
    icon: Icons.travel_explore_rounded,
    gradientColors: [Color(0xFF0D5C36), Color(0xFF1A9E5C)],
  ),
  _PageData(
    tag: 'AI POWERED',
    headline: 'Analisis\nCerdas',
    subline: 'Berbasis Kecerdasan Buatan',
    body: 'Rekomendasi franchise yang dipersonalisasi menggunakan AI canggih — berdasarkan profil, budget, dan risiko Anda.',
    icon: Icons.auto_awesome_rounded,
    gradientColors: [Color(0xFF064E3B), Color(0xFF059669)],
  ),
  _PageData(
    tag: 'INVESTASI',
    headline: 'Kelola &\nKembangkan',
    subline: 'Portofolio Investasi Anda',
    body: 'Simulasi BEP, ajukan pendanaan, dan pantau pertumbuhan investasi franchise Anda secara real-time.',
    icon: Icons.rocket_launch_rounded,
    gradientColors: [Color(0xFF14532D), Color(0xFF16A34A)],
  ),
];

// ─────────────────────────────────────────────────────────────
//  MAIN WIDGET
// ─────────────────────────────────────────────────────────────
class SplashScreenWave extends StatefulWidget {
  const SplashScreenWave({super.key});

  @override
  State<SplashScreenWave> createState() => _SplashScreenWaveState();
}

class _SplashScreenWaveState extends State<SplashScreenWave>
    with TickerProviderStateMixin {
  late PageController _pageCtrl;
  int _currentPage = 0;

  // Blob morphing
  late AnimationController _blobCtrl;
  // Particle float
  late AnimationController _particleCtrl;
  // Shimmer on CTA
  late AnimationController _shimmerCtrl;
  // Page content stagger
  late AnimationController _staggerCtrl;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));

    _pageCtrl = PageController();

    _blobCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _blobCtrl.dispose();
    _particleCtrl.dispose();
    _shimmerCtrl.dispose();
    _staggerCtrl.dispose();
    super.dispose();
  }

  void _goNext() {
    HapticFeedback.lightImpact();
    if (_currentPage < _pages.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: page.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // ── Layer 1: Morphing blob ─────────────────────
              _BlobBackground(animation: _blobCtrl),

              // ── Layer 2: Floating particles ────────────────
              _ParticleField(animation: _particleCtrl),

              // ── Layer 3: Radial glow (bottom centre) ───────
              Positioned(
                bottom: -100,
                left: 0,
                right: 0,
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accentLight.withOpacity(0.18),
                        Colors.transparent,
                      ],
                      radius: 0.7,
                    ),
                  ),
                ),
              ),

              // ── Layer 4: Content ───────────────────────────
              SafeArea(
                child: Column(
                  children: [
                    _buildTopBar(context),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageCtrl,
                        onPageChanged: (i) {
                          setState(() => _currentPage = i);
                          _staggerCtrl.forward(from: 0);
                        },
                        itemCount: _pages.length,
                        itemBuilder: (ctx, i) =>
                            _PageContent(
                              data: _pages[i],
                              stagger: _staggerCtrl,
                            ),
                      ),
                    ),
                    _buildBottomBar(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── TOP BAR ───────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
      child: Row(
        children: [
          // Logo pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.storefront_rounded,
                      color: AppColors.primary, size: 17),
                ),
                const SizedBox(width: 8),
                const Text(
                  'EazyChise',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Skip
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/login'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white.withOpacity(0.7),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text(
              'Lewati →',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── BOTTOM BAR ────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
      child: Column(
        children: [
          // ── Progress dots ────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (i) {
              final sel = i == _currentPage;
              return GestureDetector(
                onTap: () {
                  _pageCtrl.animateToPage(i,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: sel ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: sel
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 28),

          // ── CTA Button ────────────────────────────────────
          _ShimmerButton(
            shimmer: _shimmerCtrl,
            label: _currentPage == _pages.length - 1
                ? 'Mulai Sekarang 🚀'
                : 'Lanjutkan',
            onTap: _goNext,
          ),

          const SizedBox(height: 16),

          // ── Step counter ──────────────────────────────────
          Text(
            '${_currentPage + 1} dari ${_pages.length}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  PAGE CONTENT
// ═══════════════════════════════════════════════════════════════
class _PageContent extends StatelessWidget {
  final _PageData data;
  final AnimationController stagger;

  const _PageContent({required this.data, required this.stagger});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Floating icon card ──────────────────────────
          _StaggerReveal(
            controller: stagger,
            delay: 0.0,
            child: _IconCard(icon: data.icon),
          ),

          const SizedBox(height: 40),

          // ── TAG ─────────────────────────────────────────
          _StaggerReveal(
            controller: stagger,
            delay: 0.1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.accentLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.accentLight.withOpacity(0.4)),
              ),
              child: Text(
                data.tag,
                style: TextStyle(
                  color: AppColors.accentLight,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ── HEADLINE ────────────────────────────────────
          _StaggerReveal(
            controller: stagger,
            delay: 0.2,
            child: Text(
              data.headline,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 46,
                fontWeight: FontWeight.w900,
                height: 1.05,
                letterSpacing: -1.5,
              ),
            ),
          ),

          // ── SUBLINE ─────────────────────────────────────
          _StaggerReveal(
            controller: stagger,
            delay: 0.3,
            child: Text(
              data.subline,
              style: TextStyle(
                color: Colors.white.withOpacity(0.55),
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1.3,
                letterSpacing: -0.3,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── BODY ────────────────────────────────────────
          _StaggerReveal(
            controller: stagger,
            delay: 0.4,
            child: Text(
              data.body,
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 15,
                height: 1.65,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ICON CARD  (frosted glass + glow ring)
// ═══════════════════════════════════════════════════════════════
class _IconCard extends StatefulWidget {
  final IconData icon;
  const _IconCard({required this.icon});

  @override
  State<_IconCard> createState() => _IconCardState();
}

class _IconCardState extends State<_IconCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _float;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -6, end: 6).animate(
        CurvedAnimation(parent: _float, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow ring
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accentLight.withOpacity(0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Glass card
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(widget.icon, color: Colors.white, size: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHIMMER BUTTON
// ═══════════════════════════════════════════════════════════════
class _ShimmerButton extends StatefulWidget {
  final AnimationController shimmer;
  final String label;
  final VoidCallback onTap;

  const _ShimmerButton({
    required this.shimmer,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ShimmerButton> createState() => _ShimmerButtonState();
}

class _ShimmerButtonState extends State<_ShimmerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 110));
    _scale = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _press, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _press.forward(),
      onTapUp: (_) {
        _press.reverse();
        widget.onTap();
      },
      onTapCancel: () => _press.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedBuilder(
          animation: widget.shimmer,
          builder: (_, __) {
            final shimmerX =
                -1.5 + widget.shimmer.value * 3.5; // sweeps left→right
            return Container(
              width: double.infinity,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: AppColors.accentLight.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Shimmer sweep
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(shimmerX - 1, 0),
                          end: Alignment(shimmerX + 1, 0),
                          colors: [
                            Colors.transparent,
                            AppColors.accentLight.withOpacity(0.25),
                            Colors.transparent,
                          ],
                          stops: const [0.3, 0.5, 0.7],
                        ),
                      ),
                    ),
                  ),
                  // Label
                  Center(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  STAGGER REVEAL
// ═══════════════════════════════════════════════════════════════
class _StaggerReveal extends StatelessWidget {
  final AnimationController controller;
  final double delay; // 0.0 – 0.6
  final Widget child;

  const _StaggerReveal({
    required this.controller,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final start = delay * 0.6;
    final end = (start + 0.5).clamp(0.0, 1.0);

    final opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    ));

    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(position: slide, child: child),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  MORPHING BLOB BACKGROUND
// ═══════════════════════════════════════════════════════════════
class _BlobBackground extends StatelessWidget {
  final Animation<double> animation;
  const _BlobBackground({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return CustomPaint(
          painter: _BlobPainter(progress: animation.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _BlobPainter extends CustomPainter {
  final double progress;
  _BlobPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    final paint2 = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.fill;

    // Blob 1 — top-right, morphing
    final cx1 = size.width * 0.8 +
        math.sin(progress * math.pi * 2) * size.width * 0.06;
    final cy1 = size.height * 0.15 +
        math.cos(progress * math.pi * 2) * size.height * 0.04;
    final r1 = size.width * 0.42 +
        math.sin(progress * math.pi * 2 + 1) * size.width * 0.04;
    _drawBlob(canvas, paint1, cx1, cy1, r1, progress);

    // Blob 2 — bottom-left
    final cx2 = size.width * 0.1 +
        math.cos(progress * math.pi * 2 + 2) * size.width * 0.05;
    final cy2 = size.height * 0.85 +
        math.sin(progress * math.pi * 2 + 2) * size.height * 0.03;
    final r2 = size.width * 0.38 +
        math.cos(progress * math.pi * 2) * size.width * 0.05;
    _drawBlob(canvas, paint2, cx2, cy2, r2, progress + 0.5);
  }

  void _drawBlob(Canvas canvas, Paint paint, double cx, double cy,
      double r, double phase) {
    final path = Path();
    const segments = 8;
    for (int i = 0; i <= segments; i++) {
      final angle = (i / segments) * math.pi * 2;
      final noiseR = r *
          (1 +
              0.18 *
                  math.sin(3 * angle + phase * math.pi * 2) +
              0.10 *
                  math.cos(5 * angle + phase * math.pi * 2));
      final x = cx + noiseR * math.cos(angle);
      final y = cy + noiseR * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BlobPainter old) => old.progress != progress;
}

// ═══════════════════════════════════════════════════════════════
//  FLOATING PARTICLES
// ═══════════════════════════════════════════════════════════════
class _Particle {
  final double x;      // 0–1
  final double speed;  // 0–1
  final double size;
  final double phase;
  final double wobble;

  const _Particle({
    required this.x,
    required this.speed,
    required this.size,
    required this.phase,
    required this.wobble,
  });
}

final _rng = math.Random(42);

final _particleList = List.generate(18, (i) {
  return _Particle(
    x: _rng.nextDouble(),
    speed: 0.3 + _rng.nextDouble() * 0.7,
    size: 3 + _rng.nextDouble() * 6,
    phase: _rng.nextDouble() * math.pi * 2,
    wobble: 0.01 + _rng.nextDouble() * 0.03,
  );
});

class _ParticleField extends StatelessWidget {
  final Animation<double> animation;
  const _ParticleField({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => CustomPaint(
        painter: _ParticlePainter(progress: animation.value),
        size: Size.infinite,
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  _ParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particleList) {
      // y: moves from bottom to top, looping
      final rawY = 1.0 - ((progress * p.speed + p.phase / (math.pi * 2)) % 1.0);
      final y = rawY * size.height;
      final x = p.x * size.width +
          math.sin(progress * math.pi * 2 * p.speed + p.phase) *
              p.wobble *
              size.width;

      // Opacity fades in at bottom, fades out at top
      final opacity = rawY < 0.15
          ? (rawY / 0.15)
          : rawY > 0.85
              ? ((1.0 - rawY) / 0.15)
              : 1.0;

      final paint = Paint()
        ..color = Colors.white.withOpacity(0.18 * opacity)
        ..style = PaintingStyle.fill;

      // Alternate between circles and diamonds
      if (_particleList.indexOf(p) % 3 == 0) {
        // Diamond
        final path = Path()
          ..moveTo(x, y - p.size)
          ..lineTo(x + p.size * 0.6, y)
          ..lineTo(x, y + p.size)
          ..lineTo(x - p.size * 0.6, y)
          ..close();
        canvas.drawPath(path, paint);
      } else {
        canvas.drawCircle(Offset(x, y), p.size * 0.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}