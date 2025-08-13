import 'dart:math';
import 'package:flutter/material.dart';

class PaymentSuccessPage extends StatefulWidget {
  const PaymentSuccessPage({super.key});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _confettiController;
  late AnimationController _pulseController;
  late Animation<double> _iconScale;
  late Animation<double> _iconOpacity;
  late Animation<double> _pulseAnimation;

  List<Offset> _confettiPositions = [];

  @override
  void initState() {
    super.initState();

    // ✅ Icon pop-in animation
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );

    _iconOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _iconController, curve: Curves.easeIn));

    // ✅ Icon pulse animation (continuous)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // ✅ Confetti animation (continuous loop)
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _confettiController.addListener(() {
      setState(() {
        _confettiPositions = List.generate(
          80,
          (index) => Offset(
            Random().nextDouble() * MediaQuery.of(context).size.width,
            Random().nextDouble() *
                MediaQuery.of(context).size.height *
                _confettiController.value,
          ),
        );
      });
    });

    // Start icon animation
    _iconController.forward();
  }

  @override
  void dispose() {
    _iconController.dispose();
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF43cea2), Color(0xFF185a9d)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // 🎉 Confetti Effect
            Positioned.fill(
              child: CustomPaint(painter: _ConfettiPainter(_confettiPositions)),
            ),

            // ✅ Main Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated Icon with Pulse
                  ScaleTransition(
                    scale: _iconScale,
                    child: FadeTransition(
                      opacity: _iconOpacity,
                      child: ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.6),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.green,
                            size: 100,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  FadeTransition(
                    opacity: _iconOpacity,
                    child: const Text(
                      'Payment Successful!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 5,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle
                  FadeTransition(
                    opacity: _iconOpacity,
                    child: const Text(
                      'Thank you for your purchase.\nYour transaction is complete.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Back to Home Button
                  FadeTransition(
                    opacity: _iconOpacity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                      ),
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      },
                      child: const Text(
                        'Back to Home',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

// 🎨 Confetti Painter
class _ConfettiPainter extends CustomPainter {
  final List<Offset> positions;
  _ConfettiPainter(this.positions);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final colors = [
      Colors.red,
      Colors.yellow,
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
    ];

    for (final pos in positions) {
      paint.color = colors[Random().nextInt(colors.length)];
      canvas.drawCircle(pos, 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
