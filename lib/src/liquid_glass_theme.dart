import 'dart:math' as math;

import 'package:flutter/material.dart';

@immutable
class LiquidGlassNavTheme {
  // ============================================================
  // MAIN NAV DIMENSIONS
  // ============================================================

  /// Main bottom navigation height.
  final double height;

  /// Main liquid-glass nav corner radius.
  final double borderRadius;

  /// Inner padding of the nav content.
  final EdgeInsetsGeometry contentPadding;

  /// Extra height added when labels are enabled.
  final double labelExtraHeight;

  // ============================================================
  // MAIN LIQUID GLASS SETTINGS
  // ============================================================

  /// Refraction strength.
  final double refraction;

  /// Glass depth.
  final double depth;

  /// RGB/chromatic dispersion.
  final double dispersion;

  /// Frost/blur strength.
  final double frost;

  /// Direction of the simulated light.
  final double lightAngle;

  /// Strength of the light/highlight.
  final double lightIntensity;

  /// Overall glass visibility.
  final double visibility;

  /// Main nav glass tint.
  final Color glassColor;

  // ============================================================
  // ACTION BUTTON SETTINGS
  // ============================================================

  /// Action button corner radius.
  final double actionButtonRadius;

  /// Optional custom action button glass color.
  ///
  /// If null, the main [glassColor] is used.
  final Color? actionButtonGlassColor;

  /// Optional custom action button icon color.
  ///
  /// If null, the button icon color or
  /// [unselectedIconColor] is used.
  final Color? actionButtonIconColor;

  /// Optional custom action button refraction.
  final double? actionButtonRefraction;

  /// Optional custom action button depth.
  final double? actionButtonDepth;

  /// Optional custom action button dispersion.
  final double? actionButtonDispersion;

  /// Optional custom action button frost.
  final double? actionButtonFrost;

  /// Optional custom action button light angle.
  final double? actionButtonLightAngle;

  /// Optional custom action button light intensity.
  final double? actionButtonLightIntensity;

  /// Optional custom action button visibility.
  final double? actionButtonVisibility;

  /// Opacity used when action button is disabled.
  final double disabledActionButtonOpacity;

  // ============================================================
  // ITEM SIZE
  // ============================================================

  /// Width and height of selected circle item.
  final double selectedItemSize;

  /// Width and height of unselected circle item.
  final double unselectedItemSize;

  /// Selected icon size.
  final double selectedIconSize;

  /// Unselected icon size.
  final double unselectedIconSize;

  // ============================================================
  // SELECTED ITEM
  // ============================================================

  /// Selected item background.
  final Color selectedBackgroundColor;

  /// Selected icon color.
  final Color selectedIconColor;

  /// Shape of circle-style navigation items.
  ///
  /// Example:
  /// BoxShape.circle
  /// BoxShape.rectangle
  final BoxShape selectedItemShape;

  /// Radius used if [selectedItemShape]
  /// is [BoxShape.rectangle].
  final double selectedItemRadius;

  // ============================================================
  // UNSELECTED ITEM
  // ============================================================

  /// Unselected item background color.
  final Color unselectedBackgroundColor;

  /// Unselected icon color.
  final Color unselectedIconColor;

  // ============================================================
  // SELECTED BORDER
  // ============================================================

  final Color selectedBorderColor;

  final double selectedBorderWidth;

  // ============================================================
  // UNSELECTED BORDER
  // ============================================================

  final Color unselectedBorderColor;

  final double unselectedBorderWidth;

  // ============================================================
  // SELECTED SHADOW
  // ============================================================

  final Color selectedShadowColor;

  final double selectedShadowBlurRadius;

  final double selectedShadowSpreadRadius;

  final Offset selectedShadowOffset;

  // ============================================================
  // TAB / PILL STYLE
  // ============================================================

  /// Padding when tab is selected.
  final EdgeInsetsGeometry selectedTabPadding;

  /// Padding when tab is not selected.
  final EdgeInsetsGeometry unselectedTabPadding;

  /// Pill/tab border radius.
  final double tabRadius;

  /// Space between selected tab icon and label.
  final double tabLabelSpacing;

  // ============================================================
  // LABEL SETTINGS
  // ============================================================

  /// Space between circle item and label.
  final double labelSpacing;

  /// Selected circle label font size.
  final double selectedLabelFontSize;

  /// Unselected circle label font size.
  final double unselectedLabelFontSize;

  /// Selected tab label font size.
  final double selectedTabLabelFontSize;

  /// Selected label weight.
  final FontWeight selectedLabelFontWeight;

  /// Unselected label weight.
  final FontWeight unselectedLabelFontWeight;

  /// Optional complete selected label style.
  final TextStyle? selectedLabelStyle;

  /// Optional complete unselected label style.
  final TextStyle? unselectedLabelStyle;

  // ============================================================
  // ANIMATION
  // ============================================================

  final Duration animationDuration;

  final Curve animationCurve;

  const LiquidGlassNavTheme({
    // ==========================================================
    // MAIN NAV
    // ==========================================================

    this.height = 62,

    this.borderRadius = 32,

    this.contentPadding = const EdgeInsets.symmetric(horizontal: 6),

    this.labelExtraHeight = 12,

    // ==========================================================
    // MAIN LIQUID GLASS
    // ==========================================================
    this.refraction = 80,

    this.depth = 20,

    this.dispersion = 50,

    this.frost = 4,

    this.lightAngle = -math.pi / 4,

    this.lightIntensity = 80,

    this.visibility = 0.9,

    this.glassColor = const Color(0x10FFFFFF),

    // ==========================================================
    // ACTION BUTTON
    // ==========================================================
    this.actionButtonRadius = 40,

    this.actionButtonGlassColor,

    this.actionButtonIconColor,

    this.actionButtonRefraction,

    this.actionButtonDepth,

    this.actionButtonDispersion,

    this.actionButtonFrost,

    this.actionButtonLightAngle,

    this.actionButtonLightIntensity,

    this.actionButtonVisibility,

    this.disabledActionButtonOpacity = 0.45,

    // ==========================================================
    // ITEM SIZE
    // ==========================================================
    this.selectedItemSize = 52,

    this.unselectedItemSize = 44,

    this.selectedIconSize = 27,

    this.unselectedIconSize = 24,

    // ==========================================================
    // SELECTED ITEM
    // ==========================================================
    this.selectedBackgroundColor = const Color(0xE8FFFFFF),

    this.selectedIconColor = const Color(0xFF07338E),

    this.selectedItemShape = BoxShape.circle,

    this.selectedItemRadius = 26,

    // ==========================================================
    // UNSELECTED ITEM
    // ==========================================================
    this.unselectedBackgroundColor = Colors.transparent,

    this.unselectedIconColor = Colors.white,

    // ==========================================================
    // SELECTED BORDER
    // ==========================================================
    this.selectedBorderColor = Colors.transparent,

    this.selectedBorderWidth = 0,

    // ==========================================================
    // UNSELECTED BORDER
    // ==========================================================
    this.unselectedBorderColor = Colors.transparent,

    this.unselectedBorderWidth = 0,

    // ==========================================================
    // SELECTED SHADOW
    // ==========================================================
    this.selectedShadowColor = const Color(0x1A000000),

    this.selectedShadowBlurRadius = 12,

    this.selectedShadowSpreadRadius = 0,

    this.selectedShadowOffset = const Offset(0, 4),

    // ==========================================================
    // TAB / PILL
    // ==========================================================
    this.selectedTabPadding = const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 8,
    ),

    this.unselectedTabPadding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 8,
    ),

    this.tabRadius = 30,

    this.tabLabelSpacing = 7,

    // ==========================================================
    // LABELS
    // ==========================================================
    this.labelSpacing = 2,

    this.selectedLabelFontSize = 10,

    this.unselectedLabelFontSize = 10,

    this.selectedTabLabelFontSize = 12,

    this.selectedLabelFontWeight = FontWeight.w600,

    this.unselectedLabelFontWeight = FontWeight.w500,

    this.selectedLabelStyle,

    this.unselectedLabelStyle,

    // ==========================================================
    // ANIMATION
    // ==========================================================
    this.animationDuration = const Duration(milliseconds: 250),

    this.animationCurve = Curves.easeOutCubic,
  }) : assert(height > 0 && height < double.infinity),
       assert(borderRadius >= 0 && actionButtonRadius >= 0),
       assert(selectedItemSize > 0 && selectedItemSize < double.infinity),
       assert(unselectedItemSize > 0 && unselectedItemSize < double.infinity),
       assert(selectedIconSize > 0 && unselectedIconSize > 0),
       assert(
         labelExtraHeight >= 0 && labelSpacing >= 0 && tabLabelSpacing >= 0,
       ),
       assert(selectedShadowBlurRadius >= 0),
       assert(selectedBorderWidth >= 0 && unselectedBorderWidth >= 0),
       assert(visibility >= 0 && visibility <= 1),
       assert(
         actionButtonVisibility == null ||
             (actionButtonVisibility >= 0 && actionButtonVisibility <= 1),
       ),
       assert(
         disabledActionButtonOpacity >= 0 && disabledActionButtonOpacity <= 1,
       ),
       assert(frost >= 0),
       assert(actionButtonFrost == null || actionButtonFrost >= 0);

  // ============================================================
  // COPY WITH
  // ============================================================

  /// Useful when you want to keep the current theme
  /// and modify only a few properties.
  LiquidGlassNavTheme copyWith({
    double? height,
    double? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    double? labelExtraHeight,

    double? refraction,
    double? depth,
    double? dispersion,
    double? frost,
    double? lightAngle,
    double? lightIntensity,
    double? visibility,
    Color? glassColor,

    double? actionButtonRadius,
    Color? actionButtonGlassColor,
    Color? actionButtonIconColor,
    double? actionButtonRefraction,
    double? actionButtonDepth,
    double? actionButtonDispersion,
    double? actionButtonFrost,
    double? actionButtonLightAngle,
    double? actionButtonLightIntensity,
    double? actionButtonVisibility,
    double? disabledActionButtonOpacity,

    double? selectedItemSize,
    double? unselectedItemSize,
    double? selectedIconSize,
    double? unselectedIconSize,

    Color? selectedBackgroundColor,
    Color? selectedIconColor,
    BoxShape? selectedItemShape,
    double? selectedItemRadius,

    Color? unselectedBackgroundColor,
    Color? unselectedIconColor,

    Color? selectedBorderColor,
    double? selectedBorderWidth,

    Color? unselectedBorderColor,
    double? unselectedBorderWidth,

    Color? selectedShadowColor,
    double? selectedShadowBlurRadius,
    double? selectedShadowSpreadRadius,
    Offset? selectedShadowOffset,

    EdgeInsetsGeometry? selectedTabPadding,
    EdgeInsetsGeometry? unselectedTabPadding,
    double? tabRadius,
    double? tabLabelSpacing,

    double? labelSpacing,
    double? selectedLabelFontSize,
    double? unselectedLabelFontSize,
    double? selectedTabLabelFontSize,
    FontWeight? selectedLabelFontWeight,
    FontWeight? unselectedLabelFontWeight,

    TextStyle? selectedLabelStyle,
    TextStyle? unselectedLabelStyle,

    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return LiquidGlassNavTheme(
      height: height ?? this.height,

      borderRadius: borderRadius ?? this.borderRadius,

      contentPadding: contentPadding ?? this.contentPadding,

      labelExtraHeight: labelExtraHeight ?? this.labelExtraHeight,

      refraction: refraction ?? this.refraction,

      depth: depth ?? this.depth,

      dispersion: dispersion ?? this.dispersion,

      frost: frost ?? this.frost,

      lightAngle: lightAngle ?? this.lightAngle,

      lightIntensity: lightIntensity ?? this.lightIntensity,

      visibility: visibility ?? this.visibility,

      glassColor: glassColor ?? this.glassColor,

      actionButtonRadius: actionButtonRadius ?? this.actionButtonRadius,

      actionButtonGlassColor:
          actionButtonGlassColor ?? this.actionButtonGlassColor,

      actionButtonIconColor:
          actionButtonIconColor ?? this.actionButtonIconColor,

      actionButtonRefraction:
          actionButtonRefraction ?? this.actionButtonRefraction,

      actionButtonDepth: actionButtonDepth ?? this.actionButtonDepth,

      actionButtonDispersion:
          actionButtonDispersion ?? this.actionButtonDispersion,

      actionButtonFrost: actionButtonFrost ?? this.actionButtonFrost,

      actionButtonLightAngle:
          actionButtonLightAngle ?? this.actionButtonLightAngle,

      actionButtonLightIntensity:
          actionButtonLightIntensity ?? this.actionButtonLightIntensity,

      actionButtonVisibility:
          actionButtonVisibility ?? this.actionButtonVisibility,

      disabledActionButtonOpacity:
          disabledActionButtonOpacity ?? this.disabledActionButtonOpacity,

      selectedItemSize: selectedItemSize ?? this.selectedItemSize,

      unselectedItemSize: unselectedItemSize ?? this.unselectedItemSize,

      selectedIconSize: selectedIconSize ?? this.selectedIconSize,

      unselectedIconSize: unselectedIconSize ?? this.unselectedIconSize,

      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,

      selectedIconColor: selectedIconColor ?? this.selectedIconColor,

      selectedItemShape: selectedItemShape ?? this.selectedItemShape,

      selectedItemRadius: selectedItemRadius ?? this.selectedItemRadius,

      unselectedBackgroundColor:
          unselectedBackgroundColor ?? this.unselectedBackgroundColor,

      unselectedIconColor: unselectedIconColor ?? this.unselectedIconColor,

      selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,

      selectedBorderWidth: selectedBorderWidth ?? this.selectedBorderWidth,

      unselectedBorderColor:
          unselectedBorderColor ?? this.unselectedBorderColor,

      unselectedBorderWidth:
          unselectedBorderWidth ?? this.unselectedBorderWidth,

      selectedShadowColor: selectedShadowColor ?? this.selectedShadowColor,

      selectedShadowBlurRadius:
          selectedShadowBlurRadius ?? this.selectedShadowBlurRadius,

      selectedShadowSpreadRadius:
          selectedShadowSpreadRadius ?? this.selectedShadowSpreadRadius,

      selectedShadowOffset: selectedShadowOffset ?? this.selectedShadowOffset,

      selectedTabPadding: selectedTabPadding ?? this.selectedTabPadding,

      unselectedTabPadding: unselectedTabPadding ?? this.unselectedTabPadding,

      tabRadius: tabRadius ?? this.tabRadius,

      tabLabelSpacing: tabLabelSpacing ?? this.tabLabelSpacing,

      labelSpacing: labelSpacing ?? this.labelSpacing,

      selectedLabelFontSize:
          selectedLabelFontSize ?? this.selectedLabelFontSize,

      unselectedLabelFontSize:
          unselectedLabelFontSize ?? this.unselectedLabelFontSize,

      selectedTabLabelFontSize:
          selectedTabLabelFontSize ?? this.selectedTabLabelFontSize,

      selectedLabelFontWeight:
          selectedLabelFontWeight ?? this.selectedLabelFontWeight,

      unselectedLabelFontWeight:
          unselectedLabelFontWeight ?? this.unselectedLabelFontWeight,

      selectedLabelStyle: selectedLabelStyle ?? this.selectedLabelStyle,

      unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,

      animationDuration: animationDuration ?? this.animationDuration,

      animationCurve: animationCurve ?? this.animationCurve,
    );
  }
}
