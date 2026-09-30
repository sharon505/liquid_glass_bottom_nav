import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import 'liquid_glass_action_button.dart';
import 'liquid_glass_theme.dart';
import 'liquid_nav_item.dart';

enum LiquidGlassNavStyle { circle, tab }

class LiquidGlassBottomNav extends StatelessWidget {
  // ============================================================
  // REQUIRED
  // ============================================================

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<LiquidGlassNavItem> items;

  // ============================================================
  // ACTION BUTTON
  // ============================================================

  final LiquidGlassActionButton? actionButton;
  final double actionButtonSpacing;

  // ============================================================
  // THEME
  // ============================================================

  final LiquidGlassNavTheme theme;

  // ============================================================
  // LAYOUT
  // ============================================================

  final EdgeInsetsGeometry margin;
  final bool safeArea;

  // ============================================================
  // NAV STYLE
  // ============================================================

  final LiquidGlassNavStyle navStyle;
  final bool showLabels;

  // ============================================================
  // INTERACTION
  // ============================================================

  final bool enableItemTap;
  final bool enableActionButtonTap;

  final HitTestBehavior hitTestBehavior;

  // ============================================================
  // ANIMATION
  // ============================================================

  final bool enableItemAnimation;
  final bool enableIconAnimation;
  final bool enableLabelAnimation;

  // ============================================================
  // ITEM APPEARANCE
  // ============================================================

  final bool showSelectedBackground;
  final bool showSelectedShadow;
  final bool showSelectedBorder;

  final bool showUnselectedBackground;
  final bool showUnselectedBorder;

  // ============================================================
  // ACCESSIBILITY
  // ============================================================

  final bool enableTooltips;
  final bool enableSemantics;

  // ============================================================
  // ITEM LAYOUT
  // ============================================================

  final MainAxisAlignment itemAlignment;
  final AlignmentGeometry itemContentAlignment;

  // ============================================================
  // ACTION BUTTON OPTIONS
  // ============================================================

  final bool enableActionButtonOpacity;
  final bool enableActionButtonTooltip;
  final bool enableActionButtonSemantics;

  const LiquidGlassBottomNav({
    super.key,

    // Required
    required this.currentIndex,
    required this.items,
    required this.onTap,

    // Action button
    this.actionButton,
    this.actionButtonSpacing = 10,

    // Theme
    this.theme = const LiquidGlassNavTheme(),

    // Outer layout
    this.margin = const EdgeInsets.only(left: 20, right: 20, bottom: 22),

    this.safeArea = true,

    // Style
    this.navStyle = LiquidGlassNavStyle.circle,
    this.showLabels = false,

    // Interaction
    this.enableItemTap = true,
    this.enableActionButtonTap = true,

    this.hitTestBehavior = HitTestBehavior.opaque,

    // Animation
    this.enableItemAnimation = true,
    this.enableIconAnimation = true,
    this.enableLabelAnimation = true,

    // Selected item
    this.showSelectedBackground = true,
    this.showSelectedShadow = true,
    this.showSelectedBorder = false,

    // Unselected item
    this.showUnselectedBackground = false,
    this.showUnselectedBorder = false,

    // Accessibility
    this.enableTooltips = true,
    this.enableSemantics = true,

    // Item layout
    this.itemAlignment = MainAxisAlignment.spaceBetween,
    this.itemContentAlignment = Alignment.center,

    // Action button
    this.enableActionButtonOpacity = true,
    this.enableActionButtonTooltip = true,
    this.enableActionButtonSemantics = true,
  }) : assert(
         items.length >= 2,
         'LiquidGlassBottomNav requires at least 2 items.',
       ),
       assert(currentIndex >= 0, 'currentIndex must not be negative.');

  @override
  Widget build(BuildContext context) {
    // Fail with a useful error in release builds too, rather than silently
    // presenting a navigation bar with no selected destination.
    if (items.length < 2) {
      throw ArgumentError.value(
        items.length,
        'items',
        'requires at least two items',
      );
    }
    RangeError.checkValidIndex(currentIndex, items, 'currentIndex');
    final labelHeight = showLabels ? _labelHeight(context) : 0.0;
    final itemHeight = math.max(
      theme.selectedItemSize,
      theme.unselectedItemSize,
    );
    final padding = theme.contentPadding.resolve(Directionality.of(context));
    final tabPaddingHeight = math.max(
      theme.selectedTabPadding.resolve(Directionality.of(context)).vertical,
      theme.unselectedTabPadding.resolve(Directionality.of(context)).vertical,
    );
    final contentHeight = navStyle == LiquidGlassNavStyle.circle
        ? itemHeight + (showLabels ? labelHeight + theme.labelSpacing : 0)
        : math.max(
            itemHeight,
            math.max(
                  labelHeight,
                  math.max(theme.selectedIconSize, theme.unselectedIconSize),
                ) +
                tabPaddingHeight,
          );
    final height = math.max(
      theme.height +
          (showLabels && navStyle == LiquidGlassNavStyle.circle
              ? theme.labelExtraHeight
              : 0),
      contentHeight + padding.vertical,
    );
    Widget child = Padding(
      padding: margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _GlassSurface(
              theme: theme,
              child: SizedBox(
                height: height,
                child: Padding(
                  padding: theme.contentPadding,
                  child: Row(
                    mainAxisAlignment: itemAlignment,
                    children: [
                      for (var index = 0; index < items.length; index++)
                        Expanded(
                          child: _NavigationItem(
                            config: this,
                            item: items[index],
                            index: index,
                            labelHeight: labelHeight,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (actionButton != null) ...[
            SizedBox(width: actionButtonSpacing),
            _ActionButton(config: this, button: actionButton!),
          ],
        ],
      ),
    );
    if (safeArea) child = SafeArea(top: false, child: child);
    return child;
  }

  double _labelHeight(BuildContext context) {
    var height = 0.0;
    for (final selected in [false, true]) {
      final painter = TextPainter(
        text: TextSpan(
          text: 'Mg',
          style: _labelStyle(theme, selected, navStyle),
        ),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: 1,
      )..layout();
      height = math.max(height, painter.height);
      painter.dispose();
    }
    return height;
  }
}

TextStyle _labelStyle(
  LiquidGlassNavTheme theme,
  bool selected,
  LiquidGlassNavStyle style,
) {
  return (selected ? theme.selectedLabelStyle : theme.unselectedLabelStyle) ??
      TextStyle(
        fontSize: selected
            ? (style == LiquidGlassNavStyle.tab
                  ? theme.selectedTabLabelFontSize
                  : theme.selectedLabelFontSize)
            : theme.unselectedLabelFontSize,
        fontWeight: selected
            ? theme.selectedLabelFontWeight
            : theme.unselectedLabelFontWeight,
        color: selected ? theme.selectedIconColor : theme.unselectedIconColor,
      );
}

// Settings are independent of the selected index and animation frames. Keep
// the renderer's layer/state and settings stable until the glass configuration changes.
class _GlassSurface extends StatefulWidget {
  const _GlassSurface({
    required this.theme,
    required this.child,
    this.action = false,
    this.color,
  });
  final LiquidGlassNavTheme theme;
  final Widget child;
  final bool action;
  final Color? color;

  @override
  State<_GlassSurface> createState() => _GlassSurfaceState();
}

class _GlassSurfaceState extends State<_GlassSurface> {
  late LiquidGlassSettings settings;

  @override
  void initState() {
    super.initState();
    _updateSettings();
  }

  @override
  void didUpdateWidget(_GlassSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.theme != widget.theme ||
        oldWidget.action != widget.action ||
        oldWidget.color != widget.color) {
      _updateSettings();
    }
  }

  void _updateSettings() {
    final t = widget.theme;
    final action = widget.action;
    settings = LiquidGlassSettings.figma(
      refraction: action
          ? t.actionButtonRefraction ?? t.refraction
          : t.refraction,
      depth: action ? t.actionButtonDepth ?? t.depth : t.depth,
      dispersion: action
          ? t.actionButtonDispersion ?? t.dispersion
          : t.dispersion,
      frost: action ? t.actionButtonFrost ?? t.frost : t.frost,
      lightAngle: action
          ? t.actionButtonLightAngle ?? t.lightAngle
          : t.lightAngle,
      lightIntensity: action
          ? t.actionButtonLightIntensity ?? t.lightIntensity
          : t.lightIntensity,
      visibility: action
          ? t.actionButtonVisibility ?? t.visibility
          : t.visibility,
      glassColor:
          widget.color ??
          (action ? t.actionButtonGlassColor : null) ??
          t.glassColor,
    );
  }

  @override
  Widget build(BuildContext context) => LiquidGlassLayer(
    settings: settings,
    child: LiquidGlass(
      shape: LiquidRoundedSuperellipse(
        borderRadius: widget.action
            ? widget.theme.actionButtonRadius
            : widget.theme.borderRadius,
      ),
      child: widget.child,
    ),
  );
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.config,
    required this.item,
    required this.index,
    required this.labelHeight,
  });
  final LiquidGlassBottomNav config;
  final LiquidGlassNavItem item;
  final int index;
  final double labelHeight;

  @override
  Widget build(BuildContext context) {
    final theme = config.theme;
    final selected = index == config.currentIndex;
    final enabled = config.enableItemTap && item.enabled;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final target = selected ? 1.0 : 0.0;
    final duration =
        reduceMotion ||
            !(config.enableItemAnimation ||
                config.enableIconAnimation ||
                config.enableLabelAnimation)
        ? Duration.zero
        : theme.animationDuration;

    Widget content = TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: target, end: target),
      duration: duration,
      curve: theme.animationCurve,
      builder: (context, value, child) {
        final progress = value.clamp(0.0, 1.0);
        final t = config.enableItemAnimation ? progress : target;
        final iconT = config.enableIconAnimation ? progress : target;
        final labelT = config.enableLabelAnimation ? progress : target;
        final iconSize = lerpDouble(
          theme.unselectedIconSize,
          theme.selectedIconSize,
          iconT,
        )!;
        final iconColor = Color.lerp(
          theme.unselectedIconColor,
          theme.selectedIconColor,
          iconT,
        )!;
        // A bounded pair of icons reverses cleanly under rapid taps. Unlike an
        // AnimatedSwitcher, it cannot accumulate outgoing children.
        final icon = SizedBox.square(
          dimension: math.max(theme.selectedIconSize, theme.unselectedIconSize),
          child: Center(
            child: item.iconFor(true) == item.icon
                ? Icon(item.icon, size: iconSize, color: iconColor)
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      if (iconT < 1)
                        Opacity(
                          opacity: 1 - iconT,
                          child: Icon(
                            item.icon,
                            size: iconSize,
                            color: iconColor,
                          ),
                        ),
                      if (iconT > 0)
                        Opacity(
                          opacity: iconT,
                          child: Icon(
                            item.iconFor(true),
                            size: iconSize,
                            color: iconColor,
                          ),
                        ),
                    ],
                  ),
          ),
        );
        final decoration = BoxDecoration(
          shape: config.navStyle == LiquidGlassNavStyle.circle
              ? theme.selectedItemShape
              : BoxShape.rectangle,
          borderRadius:
              config.navStyle == LiquidGlassNavStyle.tab ||
                  theme.selectedItemShape == BoxShape.rectangle
              ? BorderRadius.circular(
                  config.navStyle == LiquidGlassNavStyle.tab
                      ? theme.tabRadius
                      : theme.selectedItemRadius,
                )
              : null,
          color: Color.lerp(
            config.showUnselectedBackground
                ? theme.unselectedBackgroundColor
                : Colors.transparent,
            config.showSelectedBackground
                ? theme.selectedBackgroundColor
                : Colors.transparent,
            t,
          ),
          border: Border.all(
            color: Color.lerp(
              config.showUnselectedBorder
                  ? theme.unselectedBorderColor
                  : Colors.transparent,
              config.showSelectedBorder
                  ? theme.selectedBorderColor
                  : Colors.transparent,
              t,
            )!,
            width: lerpDouble(
              config.showUnselectedBorder ? theme.unselectedBorderWidth : 0,
              config.showSelectedBorder ? theme.selectedBorderWidth : 0,
              t,
            )!,
          ),
          // Only fade the shadow color; keep blur/spread/offset stable.
          boxShadow: config.showSelectedShadow
              ? [
                  BoxShadow(
                    color: theme.selectedShadowColor.withValues(
                      alpha: theme.selectedShadowColor.a * t,
                    ),
                    blurRadius: theme.selectedShadowBlurRadius,
                    spreadRadius: theme.selectedShadowSpreadRadius,
                    offset: theme.selectedShadowOffset,
                  ),
                ]
              : null,
        );
        final labelStyle = TextStyle.lerp(
          _labelStyle(theme, false, config.navStyle),
          _labelStyle(theme, true, config.navStyle),
          labelT,
        )!;
        final label = Text(
          item.label ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: labelStyle,
        );
        return LayoutBuilder(
          builder: (context, constraints) {
            final maxSize = math.max(
              theme.selectedItemSize,
              theme.unselectedItemSize,
            );
            if (config.navStyle == LiquidGlassNavStyle.circle) {
              final size = lerpDouble(
                theme.unselectedItemSize,
                theme.selectedItemSize,
                t,
              )!;
              final slotSize = math.min(maxSize, constraints.maxWidth);
              final scale = maxSize == 0 ? 1.0 : slotSize / maxSize;
              final circle = SizedBox.square(
                dimension: slotSize,
                child: Center(
                  child: Container(
                    width: size * scale,
                    height: size * scale,
                    decoration: decoration,
                    child: Center(
                      child: FittedBox(fit: BoxFit.scaleDown, child: icon),
                    ),
                  ),
                ),
              );
              return Align(
                alignment: config.itemContentAlignment,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    circle,
                    if (config.showLabels) ...[
                      SizedBox(height: theme.labelSpacing),
                      SizedBox(
                        height: labelHeight,
                        width: constraints.maxWidth,
                        child: Center(child: label),
                      ),
                    ],
                  ],
                ),
              );
            }
            final tabPadding = EdgeInsetsGeometry.lerp(
              theme.unselectedTabPadding,
              theme.selectedTabPadding,
              t,
            )!.resolve(Directionality.of(context));
            // Bound the icon and text even when four tabs share a narrow phone.
            final horizontal = math.min(
              tabPadding.horizontal / 2,
              math.max(0.0, (constraints.maxWidth - 32) / 2),
            );
            return Align(
              alignment: config.itemContentAlignment,
              child: Container(
                constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                decoration: decoration,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontal,
                  vertical: tabPadding.vertical / 2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: FittedBox(fit: BoxFit.scaleDown, child: icon),
                    ),
                    if (config.showLabels && item.label != null)
                      Flexible(
                        child: ClipRect(
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            widthFactor: labelT,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: theme.tabLabelSpacing,
                              ),
                              child: Opacity(opacity: labelT, child: label),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    final onTap = enabled ? () => config.onTap(index) : null;
    content = _Interactive(
      onTap: onTap,
      behavior: config.hitTestBehavior,
      semantics: config.enableSemantics,
      selected: selected,
      label: item.label ?? item.tooltip ?? 'Navigation item ${index + 1}',
      child: content,
    );
    if (config.enableTooltips && item.tooltip != null) {
      content = Tooltip(
        message: item.tooltip!,
        excludeFromSemantics: true,
        child: content,
      );
    }
    return content;
  }
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({required this.config, required this.button});
  final LiquidGlassBottomNav config;
  final LiquidGlassActionButton button;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  late Widget _glass;

  @override
  void initState() {
    super.initState();
    _updateGlass();
  }

  @override
  void didUpdateWidget(_ActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previous = oldWidget.button;
    final next = widget.button;
    if (oldWidget.config.theme != widget.config.theme ||
        previous.icon != next.icon ||
        previous.size != next.size ||
        previous.iconSize != next.iconSize ||
        previous.iconColor != next.iconColor ||
        previous.glassColor != next.glassColor) {
      _updateGlass();
    }
  }

  void _updateGlass() {
    _glass = _GlassSurface(
      theme: widget.config.theme,
      action: true,
      color: widget.button.glassColor,
      child: SizedBox.square(
        dimension: widget.button.size,
        child: Center(
          child: Icon(
            widget.button.icon,
            size: widget.button.iconSize,
            color:
                widget.button.iconColor ??
                widget.config.theme.actionButtonIconColor ??
                widget.config.theme.unselectedIconColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final button = widget.button;
    final theme = config.theme;
    final enabled = config.enableActionButtonTap && button.enabled;
    Widget content = _glass;
    if (config.enableActionButtonOpacity) {
      content = AnimatedOpacity(
        opacity: enabled ? 1 : theme.disabledActionButtonOpacity,
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : theme.animationDuration,
        curve: theme.animationCurve,
        child: content,
      );
    }
    content = _Interactive(
      onTap: enabled ? button.onTap : null,
      behavior: config.hitTestBehavior,
      semantics: config.enableActionButtonSemantics,
      label: button.semanticLabel ?? button.tooltip ?? 'Action button',
      child: content,
    );
    if (config.enableActionButtonTooltip && button.tooltip != null) {
      content = Tooltip(
        message: button.tooltip!,
        excludeFromSemantics: true,
        child: content,
      );
    }
    return content;
  }
}

class _Interactive extends StatelessWidget {
  const _Interactive({
    required this.onTap,
    required this.behavior,
    required this.semantics,
    required this.label,
    required this.child,
    this.selected,
  });
  final VoidCallback? onTap;
  final HitTestBehavior behavior;
  final bool semantics;
  final String label;
  final bool? selected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget result = FocusableActionDetector(
      enabled: onTap != null,
      mouseCursor: onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            onTap?.call();
            return null;
          },
        ),
      },
      child: GestureDetector(
        behavior: behavior,
        onTap: onTap,
        excludeFromSemantics: semantics,
        child: child,
      ),
    );
    if (semantics) {
      result = Semantics(
        button: true,
        enabled: onTap != null,
        selected: selected,
        label: label,
        onTap: onTap,
        excludeSemantics: true,
        child: result,
      );
    }
    return result;
  }
}
