// ════════════════════════════════════════════════════════════════
//  EazyChise · Design System v2.0
//  Theme  : Clean Emerald — Premium Fintech
//  Filosofi: Less color, more space, more trust
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Core Brand ───────────────────────────────────────────────
  // Satu warna utama, digunakan HANYA untuk CTA dan highlight
  static const Color primary      = Color(0xFF0F7A4B); // deep emerald
  static const Color primaryLight = Color(0xFF1A9E5C); // medium emerald (hover)
  static const Color primaryDark  = Color(0xFF085C38); // pressed state
  static const Color primaryBg    = Color(0xFFF0FAF5); // sangat soft, untuk chip/tag

  // ── Backgrounds ─────────────────────────────────────────────
  // PENTING: hampir semua screen pakai bg, bukan surface berwarna
  static const Color bg           = Color(0xFFF8F9FA); // off-white netral
  static const Color surface      = Color(0xFFFFFFFF); // card putih bersih
  static const Color surfaceHover = Color(0xFFF2F4F6); // hover state card
  static const Color surfaceDim   = Color(0xFFF1F3F4); // dim surface

  // ── Borders & Dividers ───────────────────────────────────────
  static const Color border       = Color(0xFFE8EAED); // garis tipis netral
  static const Color borderFocus  = Color(0xFF0F7A4B); // border saat focus input
  static const Color divider      = Color(0xFFF1F3F4); // divider sangat tipis

  // ── Text ────────────────────────────────────────────────────
  static const Color textPrimary  = Color(0xFF1A1D1F); // hampir hitam
  static const Color textSub      = Color(0xFF6C737A); // abu medium
  static const Color textHint     = Color(0xFFB0B7BF); // placeholder
  static const Color textOnDark   = Color(0xFFFFFFFF); // teks di atas primary

  // ── Semantic (FLAT, tidak pakai gradient) ────────────────────
  static const Color success      = Color(0xFF0F7A4B);
  static const Color successBg    = Color(0xFFF0FAF5);
  static const Color successText  = Color(0xFF085C38);

  static const Color warning      = Color(0xFFB45309);
  static const Color warningBg    = Color(0xFFFFFBEB);
  static const Color warningText  = Color(0xFF92400E);

  static const Color error        = Color(0xFFB91C1C);
  static const Color errorBg      = Color(0xFFFFF5F5);
  static const Color errorText    = Color(0xFF7F1D1D);

  static const Color info         = Color(0xFF1D4ED8);
  static const Color infoBg       = Color(0xFFEFF6FF);
  static const Color infoText     = Color(0xFF1E3A8A);

  // ── Accent (SANGAT terbatas — hanya untuk badge ROI/gold) ────
  static const Color gold         = Color(0xFFB45309);
  static const Color goldBg       = Color(0xFFFFFBEB);

  // ── Gradient (HANYA untuk header utama — gunakan hemat) ──────
  // Maksimal dipakai 1 kali per screen, sisanya flat
  static const List<Color> gradPrimary = [
    Color(0xFF0F7A4B),
    Color(0xFF1A9E5C),
  ];

  // ── Shadows (ganti gradient dengan shadow yang tepat) ────────
  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0xFF1A1D1F).withOpacity(0.06),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0xFF1A1D1F).withOpacity(0.08),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowPrimary = [
    BoxShadow(
      color: Color(0xFF0F7A4B).withOpacity(0.25),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  // ── Legacy aliases (agar kode lama tidak error) ───────────────
  static const Color background       = bg;
  static const Color accent           = gold;
  static const Color accentLight      = Color(0xFFD97706);
  static const Color accentBg         = goldBg;
  static const Color textSecondary    = textSub;
  static const Color gradientStart    = Color(0xFF0F7A4B);
  static const Color gradientEnd      = Color(0xFF1A9E5C);
  static const List<Color> grad       = [
    Color(0xFF0F7A4B),
    Color(0xFF1A9E5C),
  ];
  static const List<Color> gradDeep   = [
    Color(0xFF085C38),
    Color(0xFF0F7A4B),
  ];
}