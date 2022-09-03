import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/dimensions.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({
    Key? key,
    required this.webLayout,
    required this.mobileLayout,
  }) : super(key: key);

  final Widget webLayout;
  final Widget mobileLayout;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    super.initState();
    _addData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > Dimensions.webScreenSize) {
          return widget.webLayout;
        }
        return widget.mobileLayout;
      },
    );
  }

  Future<void> _addData()async{
    final userProvider = Provider.of<UserProvider>(context,listen: false);
    await userProvider.refreshUser();
  }
}
