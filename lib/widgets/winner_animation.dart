import 'package:flutter/material.dart';
import 'package:tic_tak_toe/constants/app_constants.dart';

class WinnerAnimation extends StatefulWidget {
  final String winner;
  final double maxSize;

  const WinnerAnimation({super.key, required this.winner, required this.maxSize});

  @override
  WinnerAnimationState createState() => WinnerAnimationState();
}

class WinnerAnimationState extends State<WinnerAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    _scaleAnimation = TweenSequence<double>([TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.5), weight: 50), TweenSequenceItem(tween: Tween<double>(begin: 1.5, end: 1.0), weight: 100)]).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnimation = Tween<double>(begin: 0.0, end: 20.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (mounted) _controller.forward();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  void resetGlowAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final animationSize = widget.maxSize * 0.8;
    return Container(
      width: animationSize,
      height: animationSize,
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(width: animationSize, height: animationSize, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: widget.winner == 'X' ? AppConstants.xColor.withOpacity(0.2) : AppConstants.oColor.withOpacity(0.5), blurRadius: _glowAnimation.value, spreadRadius: _glowAnimation.value / 2)])),
              Transform.rotate(angle: _rotateAnimation.value, child: Transform.scale(scale: _scaleAnimation.value, child: Text(widget.winner, style: TextStyle(fontSize: animationSize * 0.4, fontWeight: FontWeight.bold, color: widget.winner == 'X' ? AppConstants.xColor : AppConstants.oColor)))),
            ],
          );
        },
      ),
    );
  }
}
