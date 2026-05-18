import 'package:flutter/material.dart';
import 'package:eazychise/core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('EazyChise Academy'),
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: AppColors.textPrimary,
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700),
            tabs: const [
              Tab(icon: Icon(Icons.school_rounded), text: 'Akademi'),
              Tab(icon: Icon(Icons.article_rounded), text: 'Artikel'),
              Tab(icon: Icon(Icons.forum_rounded), text: 'Forum'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAcademyTab(),
            _buildArticlesTab(),
            _buildForumTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademyTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildCourseCard(
            'Dasar-dasar Franchise', '4 modul • 2 jam', 'Pemula', Icons.storefront_rounded),
        _buildCourseCard(
            'Analisis Keuangan', '6 modul • 3 jam', 'Menengah', Icons.analytics_rounded),
        _buildCourseCard(
            'Strategi Marketing', '5 modul • 2.5 jam', 'Menengah', Icons.campaign_rounded),
        _buildCourseCard(
            'Legalitas & Perizinan', '3 modul • 1.5 jam', 'Pemula', Icons.gavel_rounded),
        _buildCourseCard(
            'Scale Up Bisnis', '8 modul • 4 jam', 'Lanjutan', Icons.trending_up_rounded),
      ],
    );
  }

  Widget _buildCourseCard(String title, String duration, String level, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        duration,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          level,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArticlesTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildArticleCard('10 Tips Sukses Franchise Pemula', '5 mnt baca', 'Tips & Trik'),
        _buildArticleCard('Cara Menghitung BEP Akurat', '7 mnt baca', 'Keuangan'),
        _buildArticleCard('Memilih Lokasi Area Bisnis', '6 mnt baca', 'Strategi'),
        _buildArticleCard('Legalitas Franchise Lengkap', '10 mnt baca', 'Legal'),
      ],
    );
  }

  Widget _buildArticleCard(String title, String readTime, String category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.info.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.article_rounded, color: AppColors.info),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            '$readTime • $category',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        onTap: () {},
      ),
    );
  }

  Widget _buildForumTab() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse('https://wa.me/6281234567890');
              if (!await launchUrl(url)) {
                debugPrint('Could not launch \$url');
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF25D366).withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat, color: Color(0xFF25D366), size: 20),
                  SizedBox(width: 8),
                  Text('Bergabung Komunitas WhatsApp', style: TextStyle(color: Color(0xFF25D366), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            tabs: [
              Tab(text: 'Kisah Sukses'),
              Tab(text: 'Diskusi'),
              Tab(text: 'Tanya Jawab'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildSuccessStoryTab(),
                _buildDiscussionTab(),
                _buildQnATab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStoryTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSuccessStoryCard('Budi Santoso', 'Malang', 'Kopi Kenangan', 'Rp 100 Jt', 'Rp 45 Jt', 8, 'Bisnis ini mengubah hidup saya sepenuhnya!'),
        _buildSuccessStoryCard('Siti Aminah', 'Surabaya', 'Mie Gacoan', 'Rp 200 Jt', 'Rp 120 Jt', 6, 'Sistemnya sangat rapi dan mudah dijalankan.'),
        _buildSuccessStoryCard('Ahmad Fauzi', 'Jakarta', 'Ayam Geprek Bensu', 'Rp 75 Jt', 'Rp 30 Jt', 10, 'Cocok untuk pemula yang ingin belajar bisnis.'),
        _buildSuccessStoryCard('Rina Wati', 'Semarang', 'Es Teh Indonesia', 'Rp 50 Jt', 'Rp 20 Jt', 5, 'Balik modal sangat cepat, luar biasa!'),
      ],
    );
  }

  Widget _buildSuccessStoryCard(String name, String city, String franchise, String capital, String revenue, int bep, String quote) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: AppColors.primary.withOpacity(0.2), child: Text(name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('\$city • \$franchise', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.verified, color: AppColors.success, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStoryStat('Modal', capital),
              _buildStoryStat('Omzet/bln', revenue),
              _buildStoryStat('BEP', '\$bep Bulan'),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primary.withOpacity(0.1))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.format_quote, color: AppColors.primary, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text('"\$quote"', style: const TextStyle(fontStyle: FontStyle.italic, color: AppColors.textPrimary, fontSize: 13))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStoryStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildDiscussionTab() {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
          children: [
            _buildForumPost('Ahmad R', 'Cara memilih franchise dengan modal 50jt?', '2 jam lalu', 5, 12, 'Keuangan'),
            _buildForumPost('Siti N', 'Review pengalaman franchise minuman', '5 jam lalu', 8, 24, 'Operasional'),
            _buildForumPost('Budi S', 'Tips negosiasi dengan franchisor', '1 hari lalu', 3, 8, 'Legal'),
            _buildForumPost('Rina W', 'Strategi marketing opening hari pertama', '2 hari lalu', 15, 30, 'Marketing'),
            _buildForumPost('Joko P', 'Pentingnya SOP dalam menjalankan cabang', '3 hari lalu', 10, 5, 'Operasional'),
          ],
        ),
        Positioned(
          bottom: 20, right: 20,
          child: FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text('Buat Diskusi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildForumPost(String username, String content, String time, int likes, int comments, String tag) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: AppColors.primary.withOpacity(0.2), child: Text(username[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(tag, style: const TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.4)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.thumb_up_outlined, size: 18, color: AppColors.textSecondary), const SizedBox(width: 6), Text('\$likes', style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(width: 20),
              const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColors.textSecondary), const SizedBox(width: 6), Text('\$comments', style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
              const Spacer(),
              const Icon(Icons.visibility_outlined, size: 18, color: AppColors.textHint), const SizedBox(width: 6), const Text('120', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQnATab() {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
          children: [
            _buildQnAItem('Bagaimana cara menghitung royalty fee yang benar?', 'Royalty fee dihitung dari persentase gross sales (penjualan kotor) setiap bulannya, dikurangi pajak jika berlaku.'),
            _buildQnAItem('Apakah bisa ganti lokasi setelah buka?', 'Tergantung perjanjian awal. Biasanya dikenakan biaya penalti dan wajib persetujuan franchisor.'),
            _buildQnAItem('Berapa lama rata-rata proses verifikasi pendanaan?', 'Proses verifikasi pendanaan memakan waktu sekitar 3-7 hari kerja tergantung kelengkapan dokumen.'),
            _buildQnAItem('Apa yang terjadi jika saya gagal mencapai target omzet?', 'Anda akan mendapatkan pendampingan khusus dari tim EazyChise. Jika berlanjut, akan ada evaluasi status cabang.'),
            _buildQnAItem('Bagaimana sistem pembagian hasil di P2P lending?', 'Pembagian hasil dilakukan setiap bulan secara prorata sesuai porsi investasi masing-masing pendana.'),
          ],
        ),
        Positioned(
          bottom: 20, right: 20,
          child: FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.help_outline, color: Colors.white),
            label: const Text('Tanya Ahli', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildQnAItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          leading: const Icon(Icons.help, color: AppColors.warning),
          childrenPadding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primaryBg, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.support_agent, color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      const Text('Tim EazyChise', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: const Text('EXPERT', style: TextStyle(color: AppColors.primary, fontSize: 9, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(answer, style: const TextStyle(fontSize: 13, height: 1.4)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.thumb_up_alt_outlined, size: 16),
                        label: const Text('Membantu (12)', style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}