import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
    this.imageUrl,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: backgroundColor,
      height: extent,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: imageUrl != null
            ? Image.network(imageUrl!, fit: BoxFit.cover)
            : Container(color: AppColors.secondaryColor),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}
