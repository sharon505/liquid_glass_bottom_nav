import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_bottom_nav/liquid_glass_bottom_nav.dart';

import 'widgets/glass_dashboard_showcase.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Liquid Glass Bottom Nav',
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.transparent,
          ),
          home: const ExampleHome(),
        );
      },
    );
  }
}

class ExampleHome extends StatefulWidget {
  const ExampleHome({super.key});

  @override
  State<ExampleHome> createState() => _ExampleHomeState();
}

class _ExampleHomeState extends State<ExampleHome> {
  int currentIndex = 0;

  final PageController pageController = PageController();

  final List<Widget> pages = const [
    _Page(title: 'Home', icon: Icons.home_rounded),
    _Page(title: 'Customers', icon: Icons.contacts_rounded),
    _Page(title: 'Reminders', icon: Icons.push_pin_rounded),
    _Page(title: 'Inactive', icon: Icons.person_remove_alt_1_rounded),
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  late final LiquidGlassActionButton _actionButton = LiquidGlassActionButton(
    icon: Icons.person_add_alt_1_rounded,
    iconSize: 30,
    size: 65,
    iconColor: Colors.white,
    tooltip: 'Add customer',
    onTap: () {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Add customer clicked')));
    },
  );

  int? _pendingPage;
  int _navigationRequest = 0;

  void _selectPage(int index) {
    if (currentIndex != index) setState(() => currentIndex = index);
  }

  Future<void> changePage(int index) async {
    if (!pageController.hasClients || _pendingPage == index) return;
    if (_pendingPage == null && pageController.page == index.toDouble()) return;
    final request = ++_navigationRequest;
    _pendingPage = index;
    _selectPage(index);
    await pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
    if (!mounted || request != _navigationRequest) return;
    _pendingPage = null;
    _selectPage(pageController.page!.round());
  }

  // Reuse the body when only the nav selection changes.
  late final Widget _pageView = NotificationListener<ScrollStartNotification>(
    onNotification: (notification) {
      if (notification.depth == 0 && notification.dragDetails != null) {
        ++_navigationRequest;
        _pendingPage = null;
        _selectPage(pageController.page!.round());
      }
      return false;
    },
    child: PageView(
      controller: pageController,
      physics: const BouncingScrollPhysics(),
      onPageChanged: (index) {
        if (_pendingPage == null) _selectPage(index);
      },
      children: pages,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =====================================================
      // IMPORTANT
      // Allows page content/background to continue
      // BEHIND the bottom navigation.
      // =====================================================
      extendBody: true,

      backgroundColor: Colors.transparent,

      // =====================================================
      // PAGE CONTENT
      // =====================================================
      body: _pageView,

      // =====================================================
      // FLOATING LIQUID GLASS BOTTOM NAV
      // =====================================================
      bottomNavigationBar: LiquidGlassBottomNav(
        // =====================================================
        // CURRENT SELECTED INDEX
        // =====================================================
        // Controls which navigation item is currently selected.
        currentIndex: currentIndex,

        // =====================================================
        // NAVIGATION TAP
        // =====================================================
        // Called when a nav item is tapped.
        // Here it changes the PageView page.
        onTap: changePage,

        // =====================================================
        // NAVIGATION ITEMS
        // =====================================================
        items: const [
          LiquidGlassNavItem(
            // Icon shown when item is NOT selected.
            icon: Icons.home_outlined,

            // Icon shown when item IS selected.
            selectedIcon: Icons.home_rounded,

            // Optional label.
            label: 'Home',
          ),

          LiquidGlassNavItem(
            icon: Icons.contacts_outlined,
            selectedIcon: Icons.contacts_rounded,
            label: 'Customers',
          ),

          LiquidGlassNavItem(
            icon: Icons.push_pin_outlined,
            selectedIcon: Icons.push_pin_rounded,
            label: 'Reminders',
          ),

          LiquidGlassNavItem(
            icon: Icons.person_remove_alt_1_outlined,
            selectedIcon: Icons.person_remove_alt_1_rounded,
            label: 'Inactive',
          ),
        ],

        // =====================================================
        // RIGHT ACTION BUTTON
        // =====================================================
        // Optional separate liquid-glass button placed
        // on the right side of the navigation.
        actionButton: _actionButton,

        // =====================================================
        // LIQUID GLASS THEME
        // =====================================================
        theme: const LiquidGlassNavTheme(
          // =====================================================
          // GLASS REFRACTION
          // =====================================================
          // Controls how strongly the background is visually bent.
          //
          // Higher value = stronger refraction.
          refraction: 80,

          // =====================================================
          // GLASS DEPTH
          // =====================================================
          // Controls the perceived thickness/depth of the glass.
          depth: 20,

          // =====================================================
          // COLOR DISPERSION
          // =====================================================
          // Controls RGB/chromatic separation around glass edges.
          //
          // Higher = stronger colorful refraction.
          dispersion: 50,

          // =====================================================
          // FROST
          // =====================================================
          // Controls frosted/blurred appearance.
          //
          // Lower = clearer glass.
          // Higher = more frosted glass.
          frost: 4,

          // =====================================================
          // LIGHT ANGLE
          // =====================================================
          // Controls the direction from which the glass lighting
          // effect appears.
          //
          // -0.785398... = -PI / 4 = -45 degrees.
          lightAngle: -0.7853981633974483,

          // =====================================================
          // LIGHT INTENSITY
          // =====================================================
          // Controls brightness/intensity of glass highlights.
          lightIntensity: 80,

          // =====================================================
          // GLASS COLOR
          // =====================================================
          // Tint applied over the glass.
          //
          // 0x10FFFFFF =
          // very low-opacity white.
          //
          // Lower alpha = more transparent.
          glassColor: Color(0x10FFFFFF),

          // =====================================================
          // GLASS VISIBILITY
          // =====================================================
          // Overall visibility/strength of the glass effect.
          //
          // 0.0 = invisible
          // 1.0 = fully visible
          visibility: 0.9,

          // =====================================================
          // SELECTED ICON COLOR
          // =====================================================
          // Icon color for the currently selected item.
          selectedIconColor: Color(0xFF07338E),

          // =====================================================
          // SELECTED ITEM BACKGROUND
          // =====================================================
          // Background color of the selected circular item.
          selectedBackgroundColor: Color(0xE8FFFFFF),

          // =====================================================
          // UNSELECTED ICON COLOR
          // =====================================================
          // Icon color for all non-selected items.
          unselectedIconColor: Colors.white,

          // =====================================================
          // SELECTED ITEM SIZE
          // =====================================================
          // Width + height of selected navigation item.
          selectedItemSize: 52,

          // =====================================================
          // UNSELECTED ITEM SIZE
          // =====================================================
          // Width + height of non-selected items.
          unselectedItemSize: 44,

          // =====================================================
          // SELECTED ICON SIZE
          // =====================================================
          selectedIconSize: 27,

          // =====================================================
          // UNSELECTED ICON SIZE
          // =====================================================
          unselectedIconSize: 24,

          // =====================================================
          // NAVIGATION HEIGHT
          // =====================================================
          // Total height of the main glass navigation.
          height: 62,

          // =====================================================
          // NAVIGATION BORDER RADIUS
          // =====================================================
          // Radius of the main liquid-glass container.
          borderRadius: 32,

          // =====================================================
          // ACTION BUTTON RADIUS
          // =====================================================
          // Controls roundness of the right-side action button.
          actionButtonRadius: 40,
        ),

        // =====================================================
        // OUTER NAV MARGIN
        // =====================================================
        // Distance between the floating nav and screen edges.
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 14),

        // =====================================================
        // SPACE BETWEEN MAIN NAV + ACTION BUTTON
        // =====================================================
        actionButtonSpacing: 10,

        // =====================================================
        // SAFE AREA
        // =====================================================
        // true:
        //   automatically keeps nav above system gesture/navigation area.
        //
        // false:
        //   uses only the custom `margin` above.
        safeArea: true,

        // =====================================================
        // SHOW LABELS
        // =====================================================
        // true:
        //   show text labels under/with the navigation items.
        //
        // false:
        //   icons only.
        showLabels: false,

        // =====================================================
        // NAV STYLE
        // =====================================================
        // circle:
        //   selected item shown as a circle.
        //
        // tab:
        //   selected item shown as a pill/tab.
        navStyle: LiquidGlassNavStyle.circle,

        // =====================================================
        // ITEM TAP
        // =====================================================
        // true = user can tap nav items.
        // false = nav items become non-interactive.
        enableItemTap: true,

        // =====================================================
        // ACTION BUTTON TAP
        // =====================================================
        // true = right action button can be tapped.
        enableActionButtonTap: true,

        // =====================================================
        // ITEM ANIMATION
        // =====================================================
        // Animates selected/unselected item size/background.
        enableItemAnimation: true,

        // =====================================================
        // ICON ANIMATION
        // =====================================================
        // Animates between normal and selected icons.
        enableIconAnimation: true,

        // =====================================================
        // LABEL ANIMATION
        // =====================================================
        // Used when labels are enabled.
        enableLabelAnimation: true,

        // =====================================================
        // SELECTED BACKGROUND
        // =====================================================
        // true:
        //   show white selected circle/pill.
        //
        // false:
        //   selected item has no background.
        showSelectedBackground: true,

        // =====================================================
        // SELECTED SHADOW
        // =====================================================
        // Enables/disables shadow around selected item.
        showSelectedShadow: true,

        // =====================================================
        // SELECTED BORDER
        // =====================================================
        // Requires selected border values in LiquidGlassNavTheme.
        showSelectedBorder: false,

        // =====================================================
        // UNSELECTED BACKGROUND
        // =====================================================
        // Normally false because unselected items are transparent.
        showUnselectedBackground: false,

        // =====================================================
        // UNSELECTED BORDER
        // =====================================================
        showUnselectedBorder: false,

        // =====================================================
        // TOOLTIP
        // =====================================================
        // Enables tooltip support for nav items.
        enableTooltips: true,

        // =====================================================
        // SEMANTICS / ACCESSIBILITY
        // =====================================================
        // Recommended to keep true.
        enableSemantics: true,

        // =====================================================
        // ACTION BUTTON DISABLED OPACITY
        // =====================================================
        // When actionButton.enabled == false,
        // reduce its opacity automatically.
        enableActionButtonOpacity: true,

        // =====================================================
        // ACTION BUTTON TOOLTIP
        // =====================================================
        enableActionButtonTooltip: true,

        // =====================================================
        // ACTION BUTTON ACCESSIBILITY
        // =====================================================
        enableActionButtonSemantics: true,

        // =====================================================
        // NAV ITEM DISTRIBUTION
        // =====================================================
        // Controls spacing of icons inside the main nav.
        itemAlignment: MainAxisAlignment.spaceBetween,

        // =====================================================
        // NAV ITEM ALIGNMENT
        // =====================================================
        // Controls where each individual nav item is placed
        // within its available area.
        itemContentAlignment: Alignment.center,

        // =====================================================
        // TOUCH HIT TEST
        // =====================================================
        // opaque makes the whole allocated item area tappable.
        hitTestBehavior: HitTestBehavior.opaque,
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final String title;
  final IconData icon;

  const _Page({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // =====================================================
        // BACKGROUND GRADIENT
        // =====================================================
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF071B4B),
                  Color(0xFF0A3C91),
                  Color(0xFF2563EB),
                  Color(0xFF89B4FF),
                ],
              ),
            ),
          ),
        ),

        // =====================================================
        // LARGE BACKGROUND ORB 1
        // =====================================================
        Positioned(
          top: 80,
          left: -60,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.45),
                  Colors.white.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // =====================================================
        // LARGE BACKGROUND ORB 2
        // =====================================================
        Positioned(
          bottom: 120,
          right: -80,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8BB8FF).withValues(alpha: 0.65),
                  const Color(0xFF8BB8FF).withValues(alpha: 0.10),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // =====================================================
        // SMALL GLOW DOT
        // =====================================================
        Positioned(
          top: 180,
          right: 35,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
            ),
          ),
        ),

        // =====================================================
        // PAGE CONTENT
        // =====================================================
        SafeArea(
          // Keep the scroll viewport behind the floating navigation. Scaffold
          // adds the nav height to the body's MediaQuery bottom padding.
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            child: Padding(
              padding: EdgeInsets.only(
                top: 40.0,

                // Important:
                // nav floats over this area.
                bottom: MediaQuery.paddingOf(context).bottom + 24,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // =====================================================
                  // HEADER
                  // =====================================================
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),

                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            width: 110.0,
                            height: 110.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              color: Colors.white.withValues(alpha: 0.10),

                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.20),
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(icon, size: 52.0, color: Colors.white),
                          ),

                          SizedBox(height: 20.0),

                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 8.0),

                          Text(
                            'Liquid Glass Demo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),

                          SizedBox(height: 6.0),

                          Text(
                            'Scroll vertically to explore',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40.0),

                  // =====================================================
                  // DASHBOARD GLASS CARDS
                  // =====================================================
                  const GlassDashboardShowcase(),

                  SizedBox(height: 40.0),

                  // =====================================================
                  // EXTRA SAMPLE CONTENT
                  // =====================================================
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.infinity,

                      padding: EdgeInsets.all(20.0),

                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),

                        borderRadius: BorderRadius.circular(24.0),

                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.14),
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Liquid Glass',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 8.0),

                          Text(
                            'The page continues behind the floating bottom navigation, so the liquid glass can refract the page content underneath.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.70),
                              fontSize: 14.0,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
