import 'package:flutter/material.dart';

import 'liquid_glass_theme.dart';

@immutable
class LiquidGlassActionButton {
  /// Icon displayed inside the floating glass button.
  final IconData icon;

  /// Callback when the action button is tapped.
  final VoidCallback onTap;

  /// Optional tooltip / accessibility label.
  final String? tooltip;

  /// Overall button size.
  final double size;

  /// Icon size.
  final double iconSize;

  /// Icon color.
  final Color? iconColor;

  /// Optional custom glass tint.
  ///
  /// If null, the main [LiquidGlassNavTheme.glassColor]
  /// is used by the navigation widget.
  final Color? glassColor;

  /// Optional semantic label.
  final String? semanticLabel;

  /// Whether the action button is enabled.
  final bool enabled;

  const LiquidGlassActionButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.size = 65,
    this.iconSize = 28,
    this.iconColor,
    this.glassColor,
    this.semanticLabel,
    this.enabled = true,
  }) : assert(size > 0 && size < double.infinity),
       assert(iconSize > 0 && iconSize < double.infinity);

  LiquidGlassActionButton copyWith({
    IconData? icon,
    VoidCallback? onTap,
    String? tooltip,
    double? size,
    double? iconSize,
    Color? iconColor,
    Color? glassColor,
    String? semanticLabel,
    bool? enabled,
  }) {
    return LiquidGlassActionButton(
      icon: icon ?? this.icon,
      onTap: onTap ?? this.onTap,
      tooltip: tooltip ?? this.tooltip,
      size: size ?? this.size,
      iconSize: iconSize ?? this.iconSize,
      iconColor: iconColor ?? this.iconColor,
      glassColor: glassColor ?? this.glassColor,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      enabled: enabled ?? this.enabled,
    );
  }
}
