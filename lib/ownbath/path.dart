import 'package:flutter/material.dart';

class PathNew extends StatelessWidget {
  const PathNew({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(
          child: Opacity(
            opacity: 0.2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "https://images.pexels.com/photos/301599/pexels-photo-301599.jpeg?_gl=1*p4v69b*_ga*MTYwNDI4MjY4NC4xNzUyNzY0MDg2*_ga_8JE65Q40S6*czE3NTI3NjQwODUkbzEkZzEkdDE3NTI3NjQwOTAkajU1JGwwJGgw",
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // CustomPaint(
    // size: Size(300, 200),
    // painter: MyCustomPainter(40.0),
    // child: Container(
    //   decoration: BoxDecoration(
    //     image: DecorationImage(
    //       image: NetworkImage(
    //         "https://images.pexels.com/photos/301599/pexels-photo-301599.jpeg?_gl=1*1pqg0te*_ga*MTYwNDI4MjY4NC4xNzUyNzY0MDg2*_ga_8JE65Q40S6*czE3NTI3NjQwODUkbzEkZzEkdDE3NTI3NjQwOTAkajU1JGwwJGgw",
    //       ),
    //     ),
    //   ),
    // ),
    // ),
  }
}

class MyCustomPainter extends CustomPainter {
  final double borderRadius;
  final Paint _paint =
      Paint()
        ..color =
            Colors
                .white // Example color
        ..style =
            PaintingStyle
                .fill // Example style
        ..strokeWidth = 1.0;

  final Paint _borderPaint =
      Paint()
        ..color =
            Colors
                .grey
                .shade200 // Example color
        ..style =
            PaintingStyle
                .stroke // Example style
        ..strokeWidth = 1.0;

  MyCustomPainter(this.borderRadius); // Example stroke width

  @override
  void paint(Canvas canvas, Size size) {
    // Changed return type to void
    double x = size.width;
    double y = size.height;
    double yFactor = y * 0.4;
    double xFactor = x * 0.5;
    final path = Path();

    path.moveTo(borderRadius, 0);
    path.lineTo((xFactor) - borderRadius, 0);
    path.quadraticBezierTo(xFactor, 0, xFactor, borderRadius);
    path.lineTo(xFactor, yFactor - borderRadius);
    path.quadraticBezierTo(xFactor, yFactor, xFactor + borderRadius, yFactor);
    path.lineTo(x - borderRadius, yFactor);
    path.quadraticBezierTo(x, yFactor, x, yFactor + borderRadius);
    path.lineTo(x, y - borderRadius);
    path.quadraticBezierTo(x, y, x - borderRadius, y);
    path.lineTo(borderRadius, y);
    path.quadraticBezierTo(0, y, 0, y - borderRadius);
    path.lineTo(0, borderRadius);
    path.quadraticBezierTo(0, 0, borderRadius, 0);
    // ... your other path commands

    canvas.drawPath(path, _paint);
    canvas.drawPath(path, _borderPaint);
    // No return statement needed here
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
