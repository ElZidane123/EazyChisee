// ════════════════════════════════════════════════════════════════
//  EazyChise · Design Tokens
//  Theme  : Fresh Green · Light Mode
//  Primary: #1A9E5C  (emerald-green)
//  Accent : #F5C842  (golden yellow — ROI / highlights only)
//  BG     : #F2FBF6  (mint-white)
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Backgrounds ─────────────────────────────────────────────
  static const Color bg          = Color(0xFFF2FBF6); // mint-white base
  static const Color surface     = Color(0xFFFFFFFF); // card white
  static const Color surfaceDim  = Color(0xFFECF8F1); // very soft green tint
  static const Color divider     = Color(0xFFD4EEE0); // green-tinted divider

  // ── Primary  : Fresh Emerald Green ──────────────────────────
  static const Color primary      = Color(0xFF1A9E5C); // main CTA green
  static const Color primaryLight = Color(0xFF22C55E); // lighter action green
  static const Color primaryDark  = Color(0xFF16754A); // pressed / deep state
  static const Color primaryBg    = Color(0xFFDCF5E8); // soft fill / chip bg

  // ── Accent   : Golden Yellow (ROI, star, earn only) ─────────
  static const Color accent       = Color(0xFFF5C842);
  static const Color accentLight  = Color(0xFFFAD96A);
  static const Color accentBg     = Color(0xFFFEF9E3);

  // ── Text ────────────────────────────────────────────────────
  static const Color textPrimary  = Color(0xFF0D3320); // near-black dark green
  static const Color textSub      = Color(0xFF4A7A60); // medium green-grey
  static const Color textHint     = Color(0xFF8DB89E); // muted placeholder

  // ── Semantic ────────────────────────────────────────────────
  static const Color success      = Color(0xFF1A9E5C);
  static const Color successBg    = Color(0xFFDCF5E8);
  static const Color warning      = Color(0xFFD97706);
  static const Color warningBg    = Color(0xFFFFF7ED);
  static const Color error        = Color(0xFFDC2626);
  static const Color errorBg      = Color(0xFFFEF2F2);
  static const Color info         = Color(0xFF0284C7);

  // ── Gradients ───────────────────────────────────────────────
  static const List<Color> grad        = [Color(0xFF1A9E5C), Color(0xFF22C55E)];
  static const List<Color> gradDeep    = [Color(0xFF16754A), Color(0xFF1A9E5C)];
  static const List<Color> gradMint    = [Color(0xFF22C55E), Color(0xFF86EFAC)];
  static const List<Color> gradGold    = [Color(0xFFD97706), Color(0xFFF5C842)];
  static const List<Color> gradSky     = [Color(0xFF0284C7), Color(0xFF38BDF8)];
  static const List<Color> gradCoral   = [Color(0xFFE11D48), Color(0xFFFB7185)];

  // ── Legacy compat aliases ────────────────────────────────────
  static const Color background       = bg;
  static const Color gradientStart    = Color(0xFF1A9E5C);
  static const Color gradientEnd      = Color(0xFF22C55E);
  static const Color textSecondary    = textSub;
}