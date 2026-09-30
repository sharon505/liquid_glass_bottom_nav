import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_bottom_nav/liquid_glass_bottom_nav.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

const items = [
  LiquidGlassNavItem(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    label: 'Home',
    tooltip: 'Go home',
  ),
  LiquidGlassNavItem(
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    label: 'Customers with a very long name',
  ),
  LiquidGlassNavItem(
    icon: Icons.alarm_outlined,
    selectedIcon: Icons.alarm,
    label: 'Reminders',
  ),
  LiquidGlassNavItem(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    label: 'Settings',
  ),
];

Widget host(
  Widget nav, {
  double textScale = 1,
  bool reduceMotion = false,
  double bottomInset = 0,
}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(
      textScaler: TextScaler.linear(textScale),
      disableAnimations: reduceMotion,
      padding: EdgeInsets.only(bottom: bottomInset),
    ),
    child: Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: const ColoredBox(color: Colors.blue, child: SizedBox.expand()),
      bottomNavigationBar: nav,
    ),
  ),
);

Finder item(String label) => find.byWidgetPredicate(
  (w) => w is Semantics && w.properties.label == label,
);

void main() {
  testWidgets('renders all items, one selected destination, and tooltips', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(LiquidGlassBottomNav(currentIndex: 1, items: items, onTap: (_) {})),
    );
    await tester.pumpAndSettle();
    expect(find.byType(LiquidGlassLayer), findsOneWidget);
    expect(find.byType(Icon), findsNWidgets(4));
    expect(find.text('Home'), findsNothing);
    expect(find.byTooltip('Go home'), findsOneWidget);
    for (var i = 0; i < items.length; i++) {
      final node = tester.getSemantics(item(items[i].label!));
      expect(node.flagsCollection.isSelected == Tristate.isTrue, i == 1);
      expect(node.flagsCollection.isButton, isTrue);
      expect(node.flagsCollection.isEnabled == Tristate.isTrue, isTrue);
    }
  });

  testWidgets('reports correct index, including explicit reselection', (
    tester,
  ) async {
    final taps = <int>[];
    await tester.pumpWidget(
      host(
        LiquidGlassBottomNav(currentIndex: 0, items: items, onTap: taps.add),
      ),
    );
    await tester.tap(item(items[2].label!));
    await tester.tap(item(items[0].label!));
    expect(taps, [2, 0]);
  });

  testWidgets('individual and global disabled items have no tap action', (
    tester,
  ) async {
    var taps = 0;
    for (final globalEnabled in [true, false]) {
      await tester.pumpWidget(
        host(
          LiquidGlassBottomNav(
            currentIndex: 0,
            enableItemTap: globalEnabled,
            onTap: (_) => taps++,
            items: const [
              LiquidGlassNavItem(icon: Icons.home, label: 'Home'),
              LiquidGlassNavItem(
                icon: Icons.lock,
                label: 'Locked',
                enabled: false,
              ),
            ],
          ),
        ),
      );
      await tester.tap(item('Locked'));
      expect(
        tester.getSemantics(item('Locked')).flagsCollection.isEnabled ==
            Tristate.isTrue,
        isFalse,
      );
      expect(
        tester
            .getSemantics(item('Locked'))
            .getSemanticsData()
            .hasAction(SemanticsAction.tap),
        isFalse,
      );
      if (!globalEnabled) await tester.tap(item('Home'));
    }
    expect(taps, 0);
  });

  testWidgets('action callback, disable switches, opacity and overrides', (
    tester,
  ) async {
    var taps = 0;
    for (final enabled in [true, false]) {
      for (final globalEnabled in [true, false]) {
        await tester.pumpWidget(
          host(
            LiquidGlassBottomNav(
              currentIndex: 0,
              items: items,
              onTap: (_) {},
              enableActionButtonTap: globalEnabled,
              theme: const LiquidGlassNavTheme(
                actionButtonFrost: 9,
                actionButtonVisibility: .7,
                actionButtonRadius: 25,
              ),
              actionButton: LiquidGlassActionButton(
                icon: Icons.add,
                onTap: () => taps++,
                enabled: enabled,
                tooltip: 'Add',
                glassColor: Colors.red,
                iconColor: Colors.green,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final canTap = enabled && globalEnabled;
        final before = taps;
        await tester.tap(item('Add'));
        expect(taps, before + (canTap ? 1 : 0));
        expect(
          tester.getSemantics(item('Add')).flagsCollection.isEnabled ==
              Tristate.isTrue,
          canTap,
        );
        expect(
          tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
          canTap ? 1 : .45,
        );
        expect(find.byTooltip('Add'), findsOneWidget);
        expect(tester.widget<Icon>(find.byIcon(Icons.add)).color, Colors.green);
        final layers = tester
            .widgetList<LiquidGlassLayer>(find.byType(LiquidGlassLayer))
            .toList();
        expect(layers.length, 2);
        expect(layers.last.settings.glassColor, Colors.red);
        expect(layers.last.settings.blur, 9);
        expect(layers.last.settings.visibility, .7);
      }
    }
  });

  testWidgets(
    'action without tooltip falls back to theme colors and settings',
    (tester) async {
      await tester.pumpWidget(
        host(
          LiquidGlassBottomNav(
            currentIndex: 0,
            items: items,
            onTap: (_) {},
            enableActionButtonOpacity: false,
            theme: const LiquidGlassNavTheme(glassColor: Colors.orange),
            actionButton: LiquidGlassActionButton(
              icon: Icons.add,
              onTap: () {},
            ),
          ),
        ),
      );
      expect(
        tester
            .widgetList<LiquidGlassLayer>(find.byType(LiquidGlassLayer))
            .last
            .settings
            .glassColor,
        Colors.orange,
      );
      expect(find.byType(AnimatedOpacity), findsNothing);
      expect(item('Action button'), findsOneWidget);
    },
  );

  for (final size in [
    const Size(320, 568),
    const Size(360, 800),
    const Size(375, 812),
    const Size(412, 915),
    const Size(1024, 1366),
    const Size(812, 375),
  ]) {
    for (final style in LiquidGlassNavStyle.values) {
      for (final labels in [false, true]) {
        testWidgets(
          '$size $style labels=$labels stays bounded during rapid selection',
          (tester) async {
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);
            var selected = 0;
            late StateSetter update;
            final config = LiquidGlassActionButton(
              icon: Icons.add,
              onTap: () {},
            );
            await tester.pumpWidget(
              host(
                StatefulBuilder(
                  builder: (context, setState) {
                    update = setState;
                    return LiquidGlassBottomNav(
                      currentIndex: selected,
                      items: items,
                      onTap: (index) => setState(() => selected = index),
                      navStyle: style,
                      showLabels: labels,
                      actionButton: config,
                    );
                  },
                ),
              ),
            );
            final glassSettings = tester
                .widget<LiquidGlassLayer>(find.byType(LiquidGlassLayer).first)
                .settings;
            final initialPositions = [
              for (final entry in items) tester.getCenter(item(entry.label!)),
            ];
            for (final next in [1, 2, 3, 0]) {
              update(() => selected = next);
              await tester.pump();
              await tester.pump(const Duration(milliseconds: 45));
              expect(tester.takeException(), isNull);
              // Fixed hit slots prevent neighboring destinations jumping during animation.
              expect([
                for (final entry in items) tester.getCenter(item(entry.label!)),
              ], initialPositions);
              expect(find.byType(Icon).evaluate().length, lessThanOrEqualTo(9));
            }
            await tester.pumpAndSettle();
            expect(
              identical(
                tester
                    .widget<LiquidGlassLayer>(
                      find.byType(LiquidGlassLayer).first,
                    )
                    .settings,
                glassSettings,
              ),
              isTrue,
            );
            expect(tester.takeException(), isNull);
            expect(find.text('Home'), labels ? findsOneWidget : findsNothing);
          },
        );
      }
    }
  }

  testWidgets('circle labels reserve height at large text scales', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        LiquidGlassBottomNav(
          currentIndex: 0,
          items: items,
          onTap: (_) {},
          showLabels: true,
          theme: const LiquidGlassNavTheme(
            selectedLabelStyle: TextStyle(fontSize: 24),
          ),
        ),
        textScale: 2,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('safeArea adds device inset once', (tester) async {
    final heights = <double>[];
    for (final safe in [false, true]) {
      await tester.pumpWidget(
        host(
          LiquidGlassBottomNav(
            currentIndex: 0,
            items: items,
            onTap: (_) {},
            safeArea: safe,
          ),
          bottomInset: 34,
        ),
      );
      heights.add(tester.getSize(find.byType(LiquidGlassBottomNav)).height);
    }
    expect(heights[1] - heights[0], 34);
  });

  testWidgets(
    'reduced motion settles immediately and keyboard activation works',
    (tester) async {
      var selected = 0;
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) => LiquidGlassBottomNav(
              currentIndex: selected,
              items: items,
              onTap: (index) => setState(() => selected = index),
            ),
          ),
          reduceMotion: true,
        ),
      );
      await tester.tap(item(items[1].label!));
      await tester.pump();
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsNothing);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('out of range index fails with a clear RangeError', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(LiquidGlassBottomNav(currentIndex: 4, items: items, onTap: (_) {})),
    );
    expect(tester.takeException(), isA<RangeError>());
  });
}
