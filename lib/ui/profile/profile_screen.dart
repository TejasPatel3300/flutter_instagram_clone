import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../data/network/constants.dart';
import '../../model/user.dart';
import '../../providers/user_provider.dart';
import '../../resources/firestore_manager.dart';
import '../../utils/bordered_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _boldStyle = const TextStyle(fontWeight: FontWeight.w600, fontSize: 16);

  User? user;
  bool isLoggedInUserProfile = true;
  List<Map<String, dynamic>> postList = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mobileBackGroundColor,
        title: Text(user?.username ?? ''),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (user != null)
                        CircleAvatar(
                          backgroundImage: NetworkImage(user?.photoUrl ?? ''),
                          radius: 40,
                        )
                      else
                        const CircleAvatar(
                          backgroundImage:
                              AssetImage(Assets.profilePlaceholder),
                          radius: 40,
                        ),
                      _userDataStats('posts', postList.length),
                      _userDataStats('followers', user?.followers.length ?? 0),
                      _userDataStats('following', user?.following.length ?? 0),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(user?.username ?? '', style: _boldStyle),
                  const SizedBox(height: 10),
                  Text(user?.bio ?? ''),
                  const SizedBox(height: 10),
                  BorderedButton(
                    onPressed: _followUserOrEditProfileAction,
                    buttonLabel: _isLoggedInUserProfile()
                        ? 'Edit Profile'
                        : _getFollowStatus()
                            ? 'Unfollow'
                            : 'Follow',
                    isFollowButton: !_isLoggedInUserProfile(),
                    isFollowing: _getFollowStatus(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: postList.length,
                  itemBuilder: (context, index) => SizedBox(
                    child: Image.network(
                      postList[index][FirebaseParameters.postUrl],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _userDataStats(String label, int dataCount) {
    return Column(
      children: [
        Text('$dataCount', style: _boldStyle),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  Future<void> _getData() async {
    try {
      if (mounted) {
        final userSnap = await FirebaseFirestore.instance
            .collection(FirebaseParameters.collectionUsers)
            .doc(widget.uid)
            .get();

        user = User.fromSnapshot(userSnap);

        final snapshots = await FirebaseFirestore.instance
            .collection(FirebaseParameters.collectionPosts)
            .where(FirebaseParameters.uid, isEqualTo: widget.uid)
            .get();
        final docs = snapshots.docs;
        postList = docs.map((e) => e.data()).toList();
        setState(() {});
      }
    } catch (e) {
      print(e.toString());
      // showSnackBar(context, e.toString());
    }
  }

  bool _getFollowStatus() {
    final loggedInUser = context.read<UserProvider>().user;
    return user?.followers.contains(loggedInUser?.uid) ?? false;
  }

  bool _isLoggedInUserProfile() {
    final loggedInUser = context.read<UserProvider>().user;
    return user?.uid == loggedInUser?.uid;
  }

  void _followUserOrEditProfileAction() {
    if (!_isLoggedInUserProfile()) {
      FireStoreManager().followUser(
        uid: context.read<UserProvider>().user?.uid ?? '',
        followId: user?.uid ?? '',
      );
    }else{
      // edit profile
    }
  }
}
