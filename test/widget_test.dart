import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_bottom_nav/liquid_glass_bottom_nav.dart';

// The example shares the root pubspec, so it has no package import URI.
// ignore: avoid_relative_lib_imports
import '../example/lib/main.dart';
// ignore: avoid_relative_lib_imports
import '../example/lib/widgets/glass_dashboard_showcase.dart';

void main() {
  testWidgets(
    'dashboard scrolls behind the nav and keeps page selection in sync',
    (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.extendBody, isTrue);
      expect(scaffold.backgroundColor, Colors.transparent);
      expect(scaffold.bottomNavigationBar, isA<LiquidGlassBottomNav>());
      expect(find.byType(GlassDashboardShowcase), findsOneWidget);

      final scroll = find.byType(SingleChildScrollView).first;
      expect(tester.getBottomLeft(scroll).dy, 812);
      await tester.drag(scroll, const Offset(0, -650));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.tap(find.byIcon(Icons.contacts_outlined));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<LiquidGlassBottomNav>(find.byType(LiquidGlassBottomNav))
            .currentIndex,
        1,
      );
      expect(
        tester.widget<PageView>(find.byType(PageView)).controller!.page,
        1,
      );

      await tester.drag(find.byType(PageView), const Offset(-350, 0));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<LiquidGlassBottomNav>(find.byType(LiquidGlassBottomNav))
            .currentIndex,
        2,
      );
      expect(tester.takeException(), isNull);
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
    testWidgets('dashboard cards stay bounded at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(GridView), findsNothing);
      final scroll = find.byType(SingleChildScrollView).first;
      for (var i = 0; i < 4; i++) {
        await tester.drag(scroll, const Offset(0, -500));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      expect(find.text('30'), findsOneWidget);
    });
  }

  testWidgets(
    'latest rapid tap wins and a user drag can interrupt navigation',
    (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();
      LiquidGlassBottomNav nav() => tester.widget<LiquidGlassBottomNav>(
        find.byType(LiquidGlassBottomNav),
      );
      PageController controller() =>
          tester.widget<PageView>(find.byType(PageView)).controller!;
      for (final index in [1, 2, 3, 0]) {
        nav().onTap(index);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 45));
        expect(nav().currentIndex, index);
        expect(tester.takeException(), isNull);
      }
      await tester.pumpAndSettle();
      expect(controller().page, 0);
      expect(nav().currentIndex, 0);
      nav().onTap(3);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      await tester.drag(find.byType(PageView), const Offset(250, 0));
      await tester.pumpAndSettle();
      expect(nav().currentIndex, controller().page!.round());
      expect(tester.takeException(), isNull);
    },
  );
}
