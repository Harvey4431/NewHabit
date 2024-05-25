import 'dart:math';
import 'package:flutter/material.dart';

class HabitProgress extends StatelessWidget {
  final double progress;

  HabitProgress({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: CustomPaint(
        painter: _HabitProgressPainter(progress),
        child: Center(
          child: Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _HabitProgressPainter extends CustomPainter {
  final double progress;

  _HabitProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 10;
    final backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    final progressPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HabitProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
