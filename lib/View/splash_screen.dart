import 'dart:async';
import 'package:covid_19_tracker/View/world_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _rotationController = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  late final AnimationController _fadeController = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  )..forward();

  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _fadeController,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WorldView()),
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade900,
              Colors.grey.shade800,
              Colors.grey.shade700,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    AnimatedBuilder(
                      animation: _rotationController,
                      child: Container(
                        width: size.width * 0.4,
                        height: size.width * 0.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Image(
                          image: AssetImage('images/virus.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                      builder: (BuildContext context, Widget? child) {
                        return Transform.rotate(
                          angle: _rotationController.value * 2 * math.pi,
                          child: child,
                        );
                      },
                    ),
                    Spacer(),
                    Text(
                      '🦠 Covid-19 Tracker 🔍',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      'Stay Safe • Stay Informed 🛡️',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '📊 Real-time Global Statistics',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}