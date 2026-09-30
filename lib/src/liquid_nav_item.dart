import 'package:flutter/material.dart';

@immutable
class LiquidGlassNavItem {
  /// Whether this destination can be activated.
  final bool enabled;

  final IconData icon;
  final IconData? selectedIcon;
  final String? label;
  final String? tooltip;

  const LiquidGlassNavItem({
    required this.icon,
    this.enabled = true,
    this.selectedIcon,
    this.label,
    this.tooltip,
  });

  IconData iconFor(bool selected) {
    if (selected && selectedIcon != null) {
      return selectedIcon!;
    }

    return icon;
  }
}
