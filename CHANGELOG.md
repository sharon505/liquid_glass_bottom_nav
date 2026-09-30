# Changelog

All notable changes to this project will be documented in this file.

## 0.1.0-dev.1

Initial prerelease of `liquid_glass_bottom_nav`.

### Added

- Floating liquid-glass bottom navigation
- Circle navigation style
- Tab / pill navigation style
- Independent liquid-glass action button
- Customizable glass properties:
    - refraction
    - depth
    - dispersion
    - frost
    - light angle
    - light intensity
    - visibility
    - glass color
- Custom navigation height and border radius
- Custom action button radius
- Selected and unselected item customization
- Custom icon sizes and colors
- Custom selected item background
- Optional selected item shadow
- Optional selected and unselected borders
- Optional selected and unselected backgrounds
- Optional labels
- Smooth item animations
- Smooth icon transitions
- Optional label animation
- Configurable animation duration and curve
- Tooltip support
- Semantics/accessibility support
- SafeArea configuration
- Custom item alignment
- Custom hit-test behavior
- Separate action-button glass configuration
- Disabled action-button opacity support
- PageView-friendly navigation
- Example application
- Liquid-glass dashboard showcase

### Notes

- Uses `liquid_glass_renderer`
- Impeller is recommended for the full liquid-glass effect
- The underlying renderer may emit SkSL compatibility warnings when Flutter validates shaders for the Skia backend