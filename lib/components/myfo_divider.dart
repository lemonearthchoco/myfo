import 'package:flutter/material.dart';

import '../themes/myfo_colors.dart';

class MyfoDivider extends StatelessWidget {
  final double height;
  final double dashWidth;
  final double dashHeight;
  final Color color;

  const MyfoDivider({
    Key? key,
    this.height = 10.0, // 충분한 높이를 설정
    this.dashWidth = 8.0,
    this.dashHeight = 2.0,
    this.color = MyfoColors.darkDefaultLight, // 명시적인 색상 설정
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height, // 디바이더 높이
      width: double.infinity, // 전체 가로 길이
      child: CustomPaint(
        painter: _DottedLinePainter(
          dashWidth: dashWidth,
          dashHeight: dashHeight,
          color: color,
        ),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashHeight;
  final Color color;

  _DottedLinePainter({
    required this.dashWidth,
    required this.dashHeight,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = dashHeight
      ..style = PaintingStyle.stroke;

    double startX = 0.0;
    final y = size.height / 2; // 디바이더의 y 위치를 중앙으로 설정

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y), // 점선 시작 위치
        Offset(startX + dashWidth, y), // 점선 끝 위치
        paint,
      );
      startX += dashWidth + dashWidth; // 점선과 점선 사이 간격
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
