import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassDashboardShowcase extends StatelessWidget {
  const GlassDashboardShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _BalanceCard(),

          SizedBox(height: 18.0),

          const _ChartCard(),

          SizedBox(height: 18.0),

          const _CalendarCard(),

          SizedBox(height: 18.0),

          const _StatisticsCard(),
        ],
      ),
    );
  }
}

// =====================================================
// COMMON GLASS CARD
// =====================================================

class _GlassCard extends StatelessWidget {
  static final _settings = LiquidGlassSettings.figma(
    refraction: 80,
    depth: 20,
    dispersion: 50,
    frost: 4,
    lightAngle: -math.pi / 4,
    lightIntensity: 80,
    glassColor: const Color(0x10FFFFFF),
    visibility: 0.9,
  );

  final double height;
  final Widget child;

  const _GlassCard({required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: LiquidGlassLayer(
        settings: _settings,
        child: LiquidGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: 32.0),
          child: SizedBox(width: double.infinity, height: height, child: child),
        ),
      ),
    );
  }
}

// =====================================================
// BALANCE / CALCULATOR CARD
// =====================================================

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      height: 390.0,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================
            // TOP BALANCE
            // =================================================

            Row(
              children: [
                Expanded(
                  child: Text(
                    '\$56,000',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 7.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8FF2C),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    'USD',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 28.0),

            // =================================================
            // KEYPAD
            // =================================================
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _keyRow([
                    const _KeyData('1'),
                    const _KeyData('2'),
                    const _KeyData('3'),
                    const _KeyData('⌫', type: _KeyType.light),
                  ]),

                  _keyRow([
                    const _KeyData('4'),
                    const _KeyData('5'),
                    const _KeyData('6'),
                    const _KeyData('C', type: _KeyType.light),
                  ]),

                  _keyRow([
                    const _KeyData('7'),
                    const _KeyData('8'),
                    const _KeyData('9'),
                    const _KeyData('✓', type: _KeyType.accent),
                  ]),

                  _keyRow([
                    const _KeyData('\$', type: _KeyType.light),
                    const _KeyData('0'),
                    const _KeyData('.'),
                    const _KeyData('+', type: _KeyType.dark),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _keyRow(List<_KeyData> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items
          .map((item) => _CalculatorButton(text: item.text, type: item.type))
          .toList(),
    );
  }
}

enum _KeyType { normal, light, accent, dark }

class _KeyData {
  final String text;
  final _KeyType type;

  const _KeyData(this.text, {this.type = _KeyType.normal});
}

class _CalculatorButton extends StatelessWidget {
  final String text;
  final _KeyType type;

  const _CalculatorButton({required this.text, required this.type});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = switch (type) {
      _KeyType.light => const Color(0xFFFFF1C5),
      _KeyType.accent => const Color(0xFFE8FF2C),
      _KeyType.dark => Colors.black.withValues(alpha: 0.22),
      _KeyType.normal => Colors.white.withValues(alpha: 0.10),
    };

    final Color textColor = switch (type) {
      _KeyType.light => Colors.black,
      _KeyType.accent => Colors.black,
      _KeyType.dark => Colors.white,
      _KeyType.normal => Colors.white,
    };

    return Container(
      width: 54.0,
      height: 54.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// =====================================================
// CHART CARD
// =====================================================

class _ChartCard extends StatelessWidget {
  const _ChartCard();

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      height: 390.0,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================
            // HEADER
            // =================================================

            Text(
              'Revenue',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 4.0),

            Text(
              'Performance Overview',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 11.0,
              ),
            ),

            SizedBox(height: 18.0),

            // =================================================
            // PERIOD FILTER
            // =================================================
            Row(
              children: [
                const _PeriodChip(title: '1D'),

                SizedBox(width: 7.0),

                const _PeriodChip(title: '1W', selected: true),

                SizedBox(width: 7.0),

                const _PeriodChip(title: '4M'),

                SizedBox(width: 7.0),

                const _PeriodChip(title: '8M'),

                SizedBox(width: 7.0),

                const _PeriodChip(title: 'All'),
              ],
            ),

            SizedBox(height: 22.0),

            // =================================================
            // VALUE
            // =================================================
            Text(
              '\$58.4K',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 4.0),

            Text(
              '+12.6% this week',
              style: TextStyle(
                color: const Color(0xFFE8FF2C),
                fontSize: 11.0,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 18.0),

            // =================================================
            // GRAPH
            // =================================================
            Expanded(
              child: CustomPaint(
                painter: _LineChartPainter(),
                child: const SizedBox.expand(),
              ),
            ),

            SizedBox(height: 12.0),

            // =================================================
            // LABELS
            // =================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _month('Mon'),
                _month('Tue'),
                _month('Wed'),
                _month('Thu'),
                _month('Fri'),
                _month('Sat'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _month(String value) {
    return Text(
      value,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.45),
        fontSize: 9.0,
      ),
    );
  }
}

// =====================================================
// PERIOD CHIP
// =====================================================

class _PeriodChip extends StatelessWidget {
  final String title;
  final bool selected;

  const _PeriodChip({required this.title, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: selected
            ? Colors.white.withValues(alpha: 0.18)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: selected
              ? Colors.white.withValues(alpha: 0.20)
              : Colors.transparent,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.50),
          fontSize: 9.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// =====================================================
// CHART PAINTER
// =====================================================

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // =================================================
    // GRID
    // =================================================

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      final y = size.height / 5 * i;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // =================================================
    // GRAPH LINE
    // =================================================

    final linePaint = Paint()
      ..color = const Color(0xFFE8FF2C)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(0, size.height * 0.67);

    path.cubicTo(
      size.width * 0.12,
      size.height * 0.55,
      size.width * 0.19,
      size.height * 0.72,
      size.width * 0.30,
      size.height * 0.54,
    );

    path.cubicTo(
      size.width * 0.41,
      size.height * 0.38,
      size.width * 0.49,
      size.height * 0.64,
      size.width * 0.60,
      size.height * 0.48,
    );

    path.cubicTo(
      size.width * 0.72,
      size.height * 0.30,
      size.width * 0.82,
      size.height * 0.36,
      size.width,
      size.height * 0.19,
    );

    canvas.drawPath(path, linePaint);

    // =================================================
    // ACTIVE POINT
    // =================================================

    final dotPaint = Paint()..color = const Color(0xFFE8FF2C);

    canvas.drawCircle(
      Offset(size.width * 0.60, size.height * 0.48),
      5,
      dotPaint,
    );

    final innerDotPaint = Paint()..color = Colors.black;

    canvas.drawCircle(
      Offset(size.width * 0.60, size.height * 0.48),
      2,
      innerDotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// =====================================================
// CALENDAR CARD
// =====================================================

class _CalendarCard extends StatelessWidget {
  const _CalendarCard();

  @override
  Widget build(BuildContext context) {
    final days = List.generate(30, (index) => index + 1);

    return _GlassCard(
      height: 370.0,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================
            // HEADER
            // =================================================

            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'September ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: '2026',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.48),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),

                const _CalendarArrow(icon: Icons.chevron_left_rounded),

                SizedBox(width: 6.0),

                const _CalendarArrow(icon: Icons.chevron_right_rounded),
              ],
            ),

            SizedBox(height: 24.0),

            // =================================================
            // WEEK LABEL
            // =================================================
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _DayLabel('Mon'),
                _DayLabel('Tue'),
                _DayLabel('Wed'),
                _DayLabel('Thu'),
                _DayLabel('Fri'),
                _DayLabel('Sat'),
                _DayLabel('Sun'),
              ],
            ),

            SizedBox(height: 14.0),

            // =================================================
            // CALENDAR GRID
            // =================================================
            Expanded(
              child: Column(
                children: [
                  for (var row = 0; row < 5; row++)
                    Expanded(
                      child: Row(
                        children: [
                          for (var column = 0; column < 7; column++)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(3.5),
                                child: row * 7 + column < days.length
                                    ? _CalendarDay(day: days[row * 7 + column])
                                    : const SizedBox.shrink(),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({required this.day});
  final int day;

  @override
  Widget build(BuildContext context) {
    final selected = day == 16;
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected
                ? const Color(0xFFE8FF2C)
                : day == 18
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.transparent,
          ),
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: 10,
              color: selected
                  ? Colors.black
                  : Colors.white.withValues(alpha: 0.76),
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// CALENDAR ARROW
// =====================================================

class _CalendarArrow extends StatelessWidget {
  final IconData icon;

  const _CalendarArrow({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Icon(
        icon,
        size: 18.0,
        color: Colors.white.withValues(alpha: 0.75),
      ),
    );
  }
}

// =====================================================
// DAY LABEL
// =====================================================

class _DayLabel extends StatelessWidget {
  final String title;

  const _DayLabel(this.title);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.40),
            fontSize: 8.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// =====================================================
// STATISTICS CARD
// =====================================================

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard();

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      height: 420.0,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================
            // TITLE
            // =================================================

            Text(
              'Statistic Overview',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              ),
            ),

            SizedBox(height: 5.0),

            Text(
              'Sep 1, 2026 - Sep 30, 2026',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.40),
                fontSize: 10.0,
              ),
            ),

            SizedBox(height: 20.0),

            // =================================================
            // FILTERS
            // =================================================
            Row(
              children: [
                const _PeriodChip(title: '1D'),

                SizedBox(width: 6.0),

                const _PeriodChip(title: '1W', selected: true),

                SizedBox(width: 6.0),

                const _PeriodChip(title: '4M'),

                SizedBox(width: 6.0),

                const _PeriodChip(title: '8M'),

                SizedBox(width: 6.0),

                const _PeriodChip(title: 'All'),
              ],
            ),

            SizedBox(height: 24.0),

            // =================================================
            // BARS
            // =================================================
            const Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatisticBar(label: 'Jan', value: 0.48),

                  _StatisticBar(label: 'Feb', value: 0.70, light: true),

                  _StatisticBar(label: 'Mar', value: 0.60),

                  _StatisticBar(label: 'Apr', value: 0.86, light: true),

                  _StatisticBar(label: 'May', value: 0.76, accent: true),

                  _StatisticBar(label: 'Jun', value: 0.62, accent: true),
                ],
              ),
            ),

            SizedBox(height: 22.0),

            // =================================================
            // GET STARTED
            // =================================================
            Container(
              height: 58.0,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42.0,
                    height: 42.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.black,
                      size: 19.0,
                    ),
                  ),

                  SizedBox(width: 14.0),

                  const Expanded(
                    child: Text(
                      'Get Started',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Icon(
                    Icons.keyboard_double_arrow_right_rounded,
                    color: Colors.white.withValues(alpha: 0.30),
                    size: 28.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// STATISTIC BAR
// =====================================================

class _StatisticBar extends StatelessWidget {
  final String label;
  final double value;
  final bool accent;
  final bool light;

  const _StatisticBar({
    required this.label,
    required this.value,
    this.accent = false,
    this.light = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color barColor;

    if (accent) {
      barColor = const Color(0xFFE8FF2C);
    } else if (light) {
      barColor = Colors.white.withValues(alpha: 0.75);
    } else {
      barColor = Colors.white.withValues(alpha: 0.13);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: value,
              child: Container(
                width: 28.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: barColor,
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 9.0),

        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.42),
            fontSize: 9.0,
          ),
        ),
      ],
    );
  }
}
