import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/constants/assets.dart';
import 'package:instagram_clone/constants/colors.dart';
import 'package:instagram_clone/ui/feeds/widget/feed_item.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mobileBackGroundColor,
        centerTitle: false,
        title: SvgPicture.asset(Assets.logo,color: Colors.white,height: 40),
        actions: [
          IconButton(onPressed: (){}, icon:const Icon(Icons.messenger_outline))
        ],
      ),
      body: FeedItem(),
    );
  }
}
