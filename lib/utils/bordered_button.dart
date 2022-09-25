import 'package:flutter/material.dart';

import '../constants/colors.dart';


class BorderedButton extends StatelessWidget {
  const BorderedButton({
    Key? key,
    required this.onPressed,
    required this.buttonLabel,
    required this.isFollowButton,
    this.isFollowing = false,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String buttonLabel;
  final bool isFollowButton;
  final bool isFollowing;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isFollowButton
              ? isFollowing
                  ? Colors.grey[800]
                  : AppColors.blueColor
              : null,
          borderRadius: BorderRadius.circular(5),
          border: isFollowButton
              ? null
              : Border.all(color: AppColors.secondaryColor),
        ),
        child: Center(
          child: Text(
            buttonLabel,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
