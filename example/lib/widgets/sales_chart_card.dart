import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common_liquid_glass_card.dart';

class SalesChartGlassCard extends StatelessWidget {
  const SalesChartGlassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 270.w,
      height: 300.h,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF4FF00), Color(0xFFDCFF00)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _periodButton('1D'),
                _periodButton('1W', selected: true),
                _periodButton('4M'),
                _periodButton('8M'),
                _periodButton('All'),
                const Spacer(),
                Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.black,
                  size: 18.sp,
                ),
              ],
            ),

            SizedBox(height: 28.h),

            Text(
              '\$50+',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp),
            ),

            SizedBox(height: 15.h),

            Expanded(
              child: CustomPaint(
                painter: _LineChartPainter(),
                child: const SizedBox.expand(),
              ),
            ),

            SizedBox(height: 10.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _month('Jan'),
                _month('Feb'),
                _month('Mar'),
                _month('Apr'),
                _month('May'),
                _month('Jun'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _periodButton(String text, {bool selected = false}) {
    return Container(
      margin: EdgeInsets.only(right: 6.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _month(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.black54, fontSize: 10.sp),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      final y = size.height / 5 * i;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(0, size.height * .48);

    path.cubicTo(
      size.width * .10,
      size.height * .30,
      size.width * .17,
      size.height * .42,
      size.width * .26,
      size.height * .52,
    );

    path.cubicTo(
      size.width * .38,
      size.height * .65,
      size.width * .48,
      size.height * .35,
      size.width * .58,
      size.height * .48,
    );

    path.cubicTo(
      size.width * .68,
      size.height * .58,
      size.width * .80,
      size.height * .17,
      size.width,
      size.height * .30,
    );

    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = Colors.black;

    canvas.drawCircle(Offset(size.width * .58, size.height * .48), 6, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
