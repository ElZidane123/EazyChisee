// ════════════════════════════════════════════════════════════════
//  EazyChise · Design Tokens
//  Theme  : Clean Minimal · Light Mode
//  Primary: #16A34A  (brand green — used sparingly as accent)
//  BG     : #FAFAFA  (near-white neutral — no color tint)
//  Accent : #F59E0B  (warm amber — highlight & ROI only)
// ════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Backgrounds ─────────────────────────────────────────────
  static const Color bg          = Color(0xFFFAFAFA); // near-white neutral
  static const Color surface     = Color(0xFFFFFFFF); // pure white card
  static const Color surfaceDim  = Color(0xFFF4F4F5); // subtle gray fill
  static const Color divider     = Color(0xFFE4E4E7); // clean neutral divider

  // ── Primary  : Brand Green (used only for CTAs & brand marks) ─
  static const Color primary      = Color(0xFF16A34A); // brand green
  static const Color primaryLight = Color(0xFF22C55E); // hover / lighter state
  static const Color primaryDark  = Color(0xFF15803D); // pressed / deep state
  static const Color primaryBg    = Color(0xFFF0FDF4); // very faint green fill

  // ── Accent   : Warm Amber (highlights, ROI, star — rare use) ──
  static const Color accent       = Color(0xFFF59E0B);
  static const Color accentLight  = Color(0xFFFBBF24);
  static const Color accentBg     = Color(0xFFFFFBEB);

  // ── Text  (neutral grays — no color tinting) ─────────────────
  static const Color textPrimary  = Color(0xFF18181B); // near-black
  static const Color textSub      = Color(0xFF71717A); // medium gray
  static const Color textHint     = Color(0xFFA1A1AA); // light placeholder

  // ── Semantic ─────────────────────────────────────────────────
  static const Color success      = Color(0xFF16A34A);
  static const Color successBg    = Color(0xFFF0FDF4);
  static const Color warning      = Color(0xFFD97706);
  static const Color warningBg    = Color(0xFFFFFBEB);
  static const Color error        = Color(0xFFDC2626);
  static const Color errorBg      = Color(0xFFFEF2F2);
  static const Color info         = Color(0xFF0284C7);

  // ── Gradients (2 only — kept intentionally minimal) ──────────
  static const List<Color> grad        = [Color(0xFF16A34A), Color(0xFF22C55E)];
  static const List<Color> gradDeep    = [Color(0xFF14532D), Color(0xFF16A34A)];

  // ── Legacy compat aliases (kept for backward compatibility) ───
  static const List<Color> gradMint    = [Color(0xFF22C55E), Color(0xFFBBF7D0)];
  static const List<Color> gradGold    = [Color(0xFFD97706), Color(0xFFF59E0B)];
  static const List<Color> gradSky     = [Color(0xFF0284C7), Color(0xFF38BDF8)];
  static const List<Color> gradCoral   = [Color(0xFFE11D48), Color(0xFFFB7185)];
  static const Color background       = bg;
  static const Color gradientStart    = Color(0xFF16A34A);
  static const Color gradientEnd      = Color(0xFF22C55E);
  static const Color textSecondary    = textSub;
}