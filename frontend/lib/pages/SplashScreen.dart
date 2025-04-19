import 'package:flutter/material.dart';
import 'dart:async';
import 'package:frontend/pages/LoginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _titleVisible = false;
  bool _subtitleVisible = false;

  @override
  void initState() {
    super.initState();

    // Trigger title animation immediately
    Future.delayed(Duration.zero, () {
      setState(() => _titleVisible = true);
    });

    // Trigger subtitle animation after 300ms
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _subtitleVisible = true);
    });

    // Navigate after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 80),
                  // Animated Title
                  AnimatedOpacity(
                    opacity: _titleVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 1000),
                    child: AnimatedSlide(
                      offset:
                          _titleVisible ? Offset.zero : const Offset(0, 0.5),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOut,
                      child: const Text(
                        "Odyssey Hub",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Animated Subtitle
                  AnimatedOpacity(
                    opacity: _subtitleVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: AnimatedSlide(
                      offset:
                          _subtitleVisible ? Offset.zero : const Offset(0, 0.2),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      child: const Text(
                        "Your personal trip planner",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              // Animated Powered By section
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    AnimatedText(
                      text: 'Powered By',
                      delay: 0.4,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedLetter('G', Colors.blue, 0.5),
                        AnimatedLetter('o', Colors.red, 0.6),
                        AnimatedLetter('o', Colors.yellow, 0.7),
                        AnimatedLetter('g', Colors.blue, 0.8),
                        AnimatedLetter('l', Colors.green, 0.9),
                        AnimatedLetter("e's ", Colors.red, 1.0),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AnimatedText(
                      text: "Gemini | Services",
                      delay: 1.1,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedLetter extends StatefulWidget {
  final String letter;
  final Color color;
  final double delay;

  const AnimatedLetter(this.letter, this.color, this.delay, {super.key});

  @override
  State<AnimatedLetter> createState() => _AnimatedLetterState();
}

class _AnimatedLetterState extends State<AnimatedLetter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scale = Tween(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).round()), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(scale: _scale.value, child: child),
        );
      },
      child: Text(
        widget.letter,
        style: TextStyle(
          color: widget.color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  final String text;
  final double delay;
  final TextStyle style;

  const AnimatedText({
    super.key,
    required this.text,
    required this.delay,
    this.style = const TextStyle(),
  });

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).round()), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(opacity: _opacity.value, child: child);
      },
      child: Text(widget.text, style: widget.style),
    );
  }
}
