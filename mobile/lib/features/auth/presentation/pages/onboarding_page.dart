import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar with Skip ("Omitir")
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text(
                      'Omitir',
                      style: TextStyle(
                        color: Color(0xFF6750A4),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Center Illustration Stack
                Center(
                  child: SizedBox(
                    width: 260,
                    height: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Decorative dots
                        Positioned(
                          left: 20,
                          top: 100,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 30,
                          top: 90,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF6750A4),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 60,
                          top: 210,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF6750A4),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        // Large backdrop circle
                        Container(
                          width: 190,
                          height: 190,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEADDFF).withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                        ),

                        // Purple Shopping Bag
                        Positioned(
                          bottom: 45,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Handle
                              Container(
                                width: 44,
                                height: 24,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF6750A4),
                                    width: 5,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(22),
                                    topRight: Radius.circular(22),
                                  ),
                                ),
                              ),
                              // Bag Body
                              Container(
                                width: 90,
                                height: 84,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6750A4),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6750A4).withOpacity(0.3),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: CustomPaint(
                                  size: const Size(40, 24),
                                  painter: BirdPainter(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // SALE badge (left)
                        Positioned(
                          left: 10,
                          top: 75,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'SALE',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFD97706),
                              ),
                            ),
                          ),
                        ),

                        // NEW IN badge (right)
                        Positioned(
                          right: 10,
                          top: 85,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1FAE5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'NEW IN',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // Welcome text Left Aligned
                const Text(
                  'Descubre moda que se adapta a ti',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C1B1F),
                    height: 1.25,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Explora miles de prendas seleccionadas por expertos en estilo. Encuentra looks únicos para cada ocasión, directo desde tu móvil.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF49454F),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 48),

                // CTA Button (Centered full-width or pill-shaped centered)
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/login'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF6750A4),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28), // Pill shape
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Siguiente',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BirdPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.6)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.25,
        size.width * 0.5,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.65,
        size.height * 0.25,
        size.width * 0.85,
        size.height * 0.6,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
