import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  const LikeAnimation({
    Key? key,
    required this.child,
    required this.isSmallLike,
    required this.onLiked,
    this.iconSize,
  }) : super(key: key);

  final bool isSmallLike;
  final double? iconSize;
  final Widget child;
  final VoidCallback onLiked;

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
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward ||
          status == AnimationStatus.reverse) {
        _opacity = 1;
        setState(() {});
      } else {
        _opacity = 0;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('build Like Animation');
    }
    return GestureDetector(
      onDoubleTap: !widget.isSmallLike ? _animate : null,
      onTap: widget.isSmallLike ? _animate : null,
      child: Stack(
        children: [
          widget.child,
          AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 400),
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(Icons.favorite, size: widget.iconSize),
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
    widget.onLiked();
    await _animationController.forward();
    await _animationController.reverse();
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
