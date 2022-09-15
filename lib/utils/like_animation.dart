import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  const LikeAnimation({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation =
        Tween<double>(begin: 1, end: 1.5).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _animate,
      child: Stack(
        children: [
          widget.child,
          AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 400),
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: const Icon(Icons.favorite, size: 100),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _animate() async {
    setState(() {
      _opacity = 1;
    });
    print('animating ${_animationController.status}');
    await _animationController.forward();
    print('animating ${_animationController.status}');
    await _animationController.reverse();
    print('animating ${_animationController.status}');
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _opacity = 0;
    });
    print('animating ${_animationController.status}');

    // }
  }
}
