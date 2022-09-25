import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../providers/user_provider.dart';
import '../add_post/add_post_screen.dart';
import '../feeds/feeds_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  final PageController _pageController = PageController();

  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      bottomNavigationBar: _bottomNav(),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        children: [
          FeedsScreen(),
          SearchScreen(),
          AddPostScreen(),
          Center(child:Text('follow')),
          ProfileScreen(uid: context.read<UserProvider>().user?.uid??''),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return CupertinoTabBar(
      currentIndex: _pageIndex,
      backgroundColor: AppColors.mobileBackGroundColor,
      onTap: _navigate,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: _pageIndex == 0
                ? AppColors.primaryColor
                : AppColors.secondaryColor,
          ),
          label: '',
          backgroundColor: AppColors.primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color: _pageIndex == 1
                ? AppColors.primaryColor
                : AppColors.secondaryColor,
          ),
          label: '',
          backgroundColor: AppColors.primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle,
            color: _pageIndex == 2
                ? AppColors.primaryColor
                : AppColors.secondaryColor,
          ),
          label: '',
          backgroundColor: AppColors.primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite,
            color: _pageIndex == 3
                ? AppColors.primaryColor
                : AppColors.secondaryColor,
          ),
          label: '',
          backgroundColor: AppColors.primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: _pageIndex == 4
                ? AppColors.primaryColor
                : AppColors.secondaryColor,
          ),
          label: '',
          backgroundColor: AppColors.primaryColor,
        ),
      ],
    );
  }

  void _navigate(int pageIndex){
    _pageController.jumpToPage(pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
