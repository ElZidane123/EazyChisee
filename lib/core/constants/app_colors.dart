// ════════════════════════════════════════════════════════════════
//  EazyChise · Design System v3.0
//  Theme  : Midnight Indigo — Premium Business Platform
//  Filosofi: Authority · Trust · Modern · Breathable
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Core Brand — Deep Royal Indigo ────────────────────────────
  // Indigo menyampaikan: kepercayaan, otoritas, profesional, premium
  static const Color primary      = Color(0xFF2C3E8C); // deep royal indigo
  static const Color primaryLight = Color(0xFF4A5EC4); // medium indigo (hover)
  static const Color primaryDark  = Color(0xFF1A2566); // dark indigo (pressed)
  static const Color primaryBg    = Color(0xFFEEF0FF); // soft indigo tint (badge/chip)

  // ── Backgrounds ─────────────────────────────────────────────
  static const Color bg           = Color(0xFFF4F5F9); // blue-tinted off-white
  static const Color surface      = Color(0xFFFFFFFF); // putih bersih
  static const Color surfaceHover = Color(0xFFF0F2FB); // hover state card
  static const Color surfaceDim   = Color(0xFFEAECF5); // dim surface
  static const Color surfaceCard  = Color(0xFFFAFBFF); // layered card bg

  // ── Borders & Dividers ───────────────────────────────────────
  static const Color border       = Color(0xFFE4E6F0); // slightly blue-tinted border
  static const Color borderFocus  = Color(0xFF2C3E8C); // border saat focus
  static const Color divider      = Color(0xFFEFF0F8); // divider sangat tipis

  // ── Text ────────────────────────────────────────────────────
  static const Color textPrimary  = Color(0xFF1A1D2E); // near-black cool undertone
  static const Color textSub      = Color(0xFF5C6280); // blue-grey medium
  static const Color textHint     = Color(0xFF9EA7C2); // placeholder
  static const Color textOnDark   = Color(0xFFFFFFFF); // teks di atas primary

  // ── Semantic Colors (FLAT, no gradient) ──────────────────────
  static const Color success      = Color(0xFF059669); // emerald — positive/growth
  static const Color successBg    = Color(0xFFECFDF5);
  static const Color successText  = Color(0xFF065F46);

  static const Color warning      = Color(0xFFD97706); // amber — perhatian
  static const Color warningBg    = Color(0xFFFFFBEB);
  static const Color warningText  = Color(0xFF92400E);

  static const Color error        = Color(0xFFDC2626); // red — bahaya
  static const Color errorBg      = Color(0xFFFEF2F2);
  static const Color errorText    = Color(0xFF7F1D1D);

  static const Color info         = Color(0xFF2563EB); // blue — informasi
  static const Color infoBg       = Color(0xFFEFF6FF);
  static const Color infoText     = Color(0xFF1E3A8A);

  // ── Gold Accent (SANGAT terbatas — ROI/premium/bintang) ──────
  static const Color gold         = Color(0xFFF59E0B); // warm amber
  static const Color goldBg       = Color(0xFFFFFBEB);
  static const Color goldText     = Color(0xFF92400E);

  // ── Gradients (gunakan HEMAT, max 1x per screen untuk hero) ──
  static const List<Color> gradPrimary = [
    Color(0xFF2C3E8C),
    Color(0xFF4A5EC4),
  ];
  static const List<Color> gradDeep = [
    Color(0xFF1A2566),
    Color(0xFF2C3E8C),
  ];
  static const List<Color> grad = [
    Color(0xFF2C3E8C),
    Color(0xFF4A5EC4),
  ];
  // Gradient premium untuk hero card (pakai sparingly)
  static const List<Color> gradCard = [
    Color(0xFF2C3E8C),
    Color(0xFF3B50AA),
  ];

  // ── Shadows ──────────────────────────────────────────────────
  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0xFF1A1D2E).withOpacity(0.06),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0xFF1A1D2E).withOpacity(0.08),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0xFF1A1D2E).withOpacity(0.1),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowPrimary = [
    BoxShadow(
      color: Color(0xFF2C3E8C).withOpacity(0.28),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowGold = [
    BoxShadow(
      color: Color(0xFFF59E0B).withOpacity(0.25),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  // ── Legacy aliases (agar kode lama tidak error) ───────────────
  static const Color background    = bg;
  static const Color accent        = gold;
  static const Color accentLight   = Color(0xFFFBBF24);
  static const Color accentBg      = goldBg;
  static const Color textSecondary = textSub;
  static const Color gradientStart = Color(0xFF2C3E8C);
  static const Color gradientEnd   = Color(0xFF4A5EC4);
}