import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:eazychise/core/constants/app_colors.dart';

// ── Models ────────────────────────────────────────────────────
enum _PT { bool_, scale, num_ }

class _Param {
  final String id, name;
  final _PT type;
  double value; // 0.0–1.0
  _Param(this.id, this.name, this.type, {this.value = 0.5});
}

class _Cat {
  final String name, icon;
  final double weight;
  final Color color;
  final List<_Param> params;
  _Cat(this.name, this.icon, this.weight, this.color, this.params);
  double get score {
    if (params.isEmpty) return 0;
    return params.map((p) => p.value).reduce((a, b) => a + b) / params.length;
  }
}

// ── 47 Parameters in 6 categories ────────────────────────────
List<_Cat> _buildCats() => [
  _Cat('Legal', '⚖️', 0.25, AppColors.primary, [
    _Param('siup','SIUP / Izin Usaha',_PT.bool_),
    _Param('npwp','NPWP Perusahaan',_PT.bool_),
    _Param('nib','NIB (Nomor Induk Berusaha)',_PT.bool_),
    _Param('tm','Trademark Terdaftar',_PT.bool_),
    _Param('pf','Perjanjian Franchise Terstandar',_PT.scale),
    _Param('an','Akta Notaris',_PT.bool_),
    _Param('il','Izin Lokasi',_PT.bool_),
    _Param('sh','Sertifikat Halal (jika F&B)',_PT.bool_),
  ]),
  _Cat('Keuangan', '💰', 0.25, AppColors.accent, [
    _Param('omz','Omzet 12 Bulan Terakhir',_PT.scale),
    _Param('lb','Laba Bersih',_PT.scale),
    _Param('dr','Debt Ratio',_PT.scale),
    _Param('cf','Cash Flow Positif',_PT.bool_),
    _Param('ma','Modal Awal Terdokumentasi',_PT.scale),
    _Param('pp','Payback Period Kompetitif',_PT.scale),
    _Param('rf','Royalty Fee % Wajar',_PT.scale),
    _Param('ff','Franchise Fee Transparan',_PT.bool_),
    _Param('bs','Biaya Setup Terdokumentasi',_PT.bool_),
    _Param('wc','Working Capital Memadai',_PT.scale),
  ]),
  _Cat('Operasional', '⚙️', 0.20, AppColors.info, [
    _Param('oa','Jumlah Outlet Aktif',_PT.scale),
    _Param('tb','Tahun Berdiri',_PT.scale),
    _Param('jk','Jumlah Karyawan',_PT.scale),
    _Param('sop','SOP Tersedia & Terdokumentasi',_PT.bool_),
    _Param('tp','Training Program Terstruktur',_PT.scale),
    _Param('sp','Supplier Terkontrak',_PT.bool_),
    _Param('pos','Sistem POS Terintegrasi',_PT.bool_),
    _Param('sq','Standar Kualitas Produk',_PT.scale),
    _Param('cr','Complaint Rate Rendah',_PT.scale),
  ]),
  _Cat('Reputasi', '⭐', 0.15, AppColors.warning, [
    _Param('rg','Rating Google / GoFood',_PT.scale),
    _Param('ju','Jumlah Ulasan',_PT.scale),
    _Param('mc','Media Coverage',_PT.scale),
    _Param('pgh','Penghargaan / Award',_PT.scale),
    _Param('tf','Testimoni Franchisee Positif',_PT.scale),
    _Param('nps','NPS Score',_PT.scale),
    _Param('rc','Repeat Customer Rate',_PT.scale),
    _Param('smf','Social Media Followers',_PT.scale),
  ]),
  _Cat('Skalabilitas', '🚀', 0.10, const Color(0xFF7C3AED), [
    _Param('ek','Potensi Ekspansi Kota',_PT.scale),
    _Param('t3','Target 3 Tahun Realistis',_PT.scale),
    _Param('sd','Sistem Duplikasi Outlet',_PT.bool_),
    _Param('kb','Ketersediaan Bahan Baku',_PT.scale),
    _Param('dt','Dukungan Teknologi',_PT.scale),
    _Param('rm','Remote Monitoring',_PT.bool_),
    _Param('ap','Adaptasi Pasar Lokal',_PT.scale),
  ]),
  _Cat('Dukungan Mitra', '🤝', 0.05, const Color(0xFF0891B2), [
    _Param('ds','Dedicated Support Person',_PT.bool_),
    _Param('fk','Frekuensi Kunjungan Rutin',_PT.scale),
    _Param('pr','Pelatihan Rutin Terjadwal',_PT.bool_),
    _Param('h24','Hotline 24 Jam',_PT.bool_),
    _Param('kf','Komunitas Franchisee Aktif',_PT.bool_),
  ]),
];

// ── Main Screen ───────────────────────────────────────────────
class TrustScoreScreen extends StatefulWidget {
  const TrustScoreScreen({super.key});
  @override
  State<TrustScoreScreen> createState() => _TrustScoreScreenState();
}

class _TrustScoreScreenState extends State<TrustScoreScreen>
    with SingleTickerProviderStateMixin {
  final List<_Cat> _cats = _buildCats();
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  double get _finalScore {
    return _cats.fold(0.0, (sum, c) => sum + c.score * c.weight) * 100;
  }

  String get _tier {
    final s = _finalScore;
    if (s >= 85) return 'PLATINUM';
    if (s >= 70) return 'GOLD';
    if (s >= 55) return 'SILVER';
    return 'BRONZE';
  }

  Color get _tierColor {
    switch (_tier) {
      case 'PLATINUM': return const Color(0xFF6366F1);
      case 'GOLD':     return AppColors.accent;
      case 'SILVER':   return AppColors.textSub;
      default:         return const Color(0xFFCD7F32);
    }
  }

  List<MapEntry<String, double>> get _top3Risks {
    final risks = _cats
        .map((c) => MapEntry(c.name, c.score))
        .toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return risks.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final score = _finalScore;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Trust Score 360°',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSub,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Form 47 Parameter'),
            Tab(text: 'Hasil Analisis'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildForm(),
          _buildResults(score),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _tab.animateTo(1),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.analytics_rounded, color: Colors.white),
        label: const Text('Lihat Hasil',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }

  // ── FORM TAB ─────────────────────────────────────────────────
  Widget _buildForm() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _cats.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, ci) {
        final cat = _cats[ci];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.divider),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: cat.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(cat.icon, style: const TextStyle(fontSize: 20))),
            ),
            title: Text(cat.name,
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            subtitle: Row(children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: cat.score,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation(cat.color),
                    minHeight: 5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('${(cat.score * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 12, color: cat.color, fontWeight: FontWeight.w700)),
              Text(' · ${(cat.weight * 100).toStringAsFixed(0)}% bobot',
                  style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
            ]),
            children: cat.params.map((p) => _buildParamRow(p, cat.color)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildParamRow(_Param p, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text(p.name,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary))),
            if (p.type == _PT.bool_)
              Switch.adaptive(
                value: p.value >= 0.5,
                activeColor: color,
                onChanged: (v) => setState(() => p.value = v ? 1.0 : 0.0),
              ),
            if (p.type == _PT.scale)
              Text('${(p.value * 5).toStringAsFixed(1)}/5',
                  style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w700)),
          ]),
          if (p.type == _PT.scale)
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                activeTrackColor: color,
                inactiveTrackColor: AppColors.divider,
                thumbColor: color,
                overlayColor: color.withOpacity(0.1),
              ),
              child: Slider(
                value: p.value,
                onChanged: (v) => setState(() => p.value = v),
                divisions: 20,
                min: 0, max: 1,
              ),
            ),
        ],
      ),
    );
  }

  // ── RESULTS TAB ──────────────────────────────────────────────
  Widget _buildResults(double score) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        _buildScoreCard(score),
        const SizedBox(height: 16),
        _buildRadarCard(),
        const SizedBox(height: 16),
        _buildBreakdownCard(),
        const SizedBox(height: 16),
        _buildRiskCard(),
        const SizedBox(height: 80),
      ]),
    );
  }

  Widget _buildScoreCard(double score) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_tierColor, _tierColor.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: _tierColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Trust Score 360°',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(_tier,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
          ),
        ]),
        const SizedBox(height: 20),
        SizedBox(
          height: 130,
          child: Stack(alignment: Alignment.center, children: [
            SizedBox(
              width: 130, height: 130,
              child: CircularProgressIndicator(
                value: score / 100,
                strokeWidth: 12,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation(Colors.white),
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(score.toStringAsFixed(1),
                  style: const TextStyle(color: Colors.white, fontSize: 38,
                      fontWeight: FontWeight.w900, height: 1)),
              const Text('/100', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ]),
          ]),
        ),
        const SizedBox(height: 16),
        Text(_tierDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
      ]),
    );
  }

  String get _tierDescription {
    switch (_tier) {
      case 'PLATINUM': return 'Franchise sangat layak. Standar tertinggi dalam industri.';
      case 'GOLD':     return 'Franchise layak dengan minor perbaikan yang disarankan.';
      case 'SILVER':   return 'Franchise cukup layak namun perlu peningkatan di beberapa area.';
      default:         return 'Franchise memerlukan perbaikan signifikan sebelum ditawarkan.';
    }
  }

  Widget _buildRadarCard() {
    final catScores = _cats.map((c) => c.score).toList();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Radar 6 Dimensi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: RadarChart(
            RadarChartData(
              radarShape: RadarShape.polygon,
              tickCount: 4,
              ticksTextStyle: const TextStyle(fontSize: 0, color: Colors.transparent),
              tickBorderData: BorderSide(color: AppColors.divider.withOpacity(0.5)),
              gridBorderData: BorderSide(color: AppColors.divider, width: 1),
              radarBorderData: BorderSide(color: AppColors.divider),
              radarBackgroundColor: Colors.transparent,
              getTitle: (index, angle) => RadarChartTitle(
                text: _cats[index].name,
                angle: angle,
              ),
              titleTextStyle: const TextStyle(fontSize: 11, color: AppColors.textSub,
                  fontWeight: FontWeight.w600),
              titlePositionPercentageOffset: 0.2,
              dataSets: [
                RadarDataSet(
                  fillColor: AppColors.primary.withOpacity(0.15),
                  borderColor: AppColors.primary,
                  borderWidth: 2,
                  entryRadius: 4,
                  dataEntries: catScores
                      .map((s) => RadarEntry(value: s.clamp(0.0, 1.0)))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildBreakdownCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Breakdown Per Kategori',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 16),
        ..._cats.map((c) => _buildCatBar(c)),
      ]),
    );
  }

  Widget _buildCatBar(_Cat c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(c.icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(child: Text(c.name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary))),
          Text('${(c.score * 100).toStringAsFixed(0)}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: c.color)),
          Text('/100',
              style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: c.score,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation(c.color),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Text('Bobot: ${(c.weight * 100).toStringAsFixed(0)}% · '
            'Kontribusi: ${(c.score * c.weight * 100).toStringAsFixed(1)} poin',
            style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
      ]),
    );
  }

  Widget _buildRiskCard() {
    final risks = _top3Risks;
    final riskHints = {
      'Legal': 'Lengkapi dokumen perizinan untuk meningkatkan kepercayaan investor.',
      'Keuangan': 'Tingkatkan transparansi laporan keuangan dan optimalkan cash flow.',
      'Operasional': 'Standarisasi SOP dan tingkatkan kualitas training franchisee.',
      'Reputasi': 'Aktifkan strategi ulasan pelanggan dan media sosial secara konsisten.',
      'Skalabilitas': 'Kembangkan sistem duplikasi dan jangkauan distribusi bahan baku.',
      'Dukungan Mitra': 'Bentuk tim support dedicat dan jadwalkan kunjungan rutin ke outlet.',
    };
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.error.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
          ),
          const SizedBox(width: 10),
          const Text('3 Risiko Terbesar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ]),
        const SizedBox(height: 14),
        ...risks.asMap().entries.map((e) {
          final rank = e.key + 1;
          final risk = e.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.error.withOpacity(0.15)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text('#$rank',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
                        color: AppColors.error))),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(risk.key,
                      style: const TextStyle(fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary, fontSize: 14)),
                  const Spacer(),
                  Text('${(risk.value * 100).toStringAsFixed(0)}/100',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                          color: AppColors.error)),
                ]),
                const SizedBox(height: 4),
                Text(riskHints[risk.key] ?? '',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSub, height: 1.4)),
              ])),
            ]),
          );
        }),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PDF ringkasan berhasil dibuat'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.share_rounded, size: 18),
            label: const Text('Simpan & Bagikan ke Franchisee',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }
}