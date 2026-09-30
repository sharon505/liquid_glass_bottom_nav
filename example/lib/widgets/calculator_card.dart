import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common_liquid_glass_card.dart';

class CalculatorGlassCard extends StatelessWidget {
  const CalculatorGlassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 270.w,
      height: 370.h,
      child: Padding(
        padding: EdgeInsets.all(18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '\$56,000',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFFF00),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'USD',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.h),

            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 1,
                children: [
                  _button('1'),
                  _button('2'),
                  _button('3'),
                  _button('⌫', light: true),

                  _button('4'),
                  _button('5'),
                  _button('6'),
                  _button('C', light: true),

                  _button('7'),
                  _button('8'),
                  _button('9'),
                  _button('✓', accent: true, tall: true),

                  _button('\$', light: true),
                  _button('0'),
                  _button('.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button(
    String text, {
    bool light = false,
    bool accent = false,
    bool tall = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accent
            ? const Color(0xFFEFFF00)
            : light
            ? const Color(0xFFFFF3C4)
            : Colors.white.withValues(alpha: 0.09),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: accent || light ? Colors.black : Colors.white,
          fontSize: 19.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
