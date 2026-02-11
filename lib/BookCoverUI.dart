import 'package:flutter/material.dart';

class BookCoverUI extends StatelessWidget {
  const BookCoverUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF004D40), // Dark Teal Base
      ),
      child: Stack(
        children: [
          // 1. The White Wave Bottom
          Positioned.fill(
            child: CustomPaint(
              painter: WavePainter(),
            ),
          ),

          // 2. The 3D Spine Shadow (Left Side)
          Container(
            width: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // 3. The Text Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "E-Commerce Book",
                  style: TextStyle(
                    color: const Color(0xFFD4E157), // Lime Yellow
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const Text(
                  "creative Business",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Text(
                      "Harshvardhan",
                      style: TextStyle(
                        color: Colors.teal[900],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var path = Path();

    // Start from the middle-left
    path.moveTo(0, size.height * 0.4);

    // Create the "S" curve
    path.quadraticBezierTo(
      size.width * 0.35, size.height * 0.95, // Control point
      size.width, size.height * 0.75,         // End point
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}