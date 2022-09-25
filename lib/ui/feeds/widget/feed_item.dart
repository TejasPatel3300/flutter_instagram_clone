import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../data/network/constants.dart';
import '../../../model/user.dart';
import '../../../providers/user_provider.dart';
import '../../../resources/firestore_manager.dart';
import '../../../utils/helpers.dart';
import '../../../utils/like_animation.dart';
import '../../comments/comments_screen.dart';

class FeedItem extends StatelessWidget {
  const FeedItem({Key? key, required this.doc}) : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final snapData = doc.data();
    print(snapData);
    return Column(
      children: [
        _FeedHeader(snapData: snapData, user: user),
        _FeedContent(snapData: snapData, user: user),
        _FeedActions(snapData: snapData, user: user),
        _FeedDescription(snapData: snapData, user: user),
      ],
    );
  }
}

class _FeedActions extends StatelessWidget {
  const _FeedActions({
    Key? key,
    required this.snapData,
    required this.user,
  }) : super(key: key);
  final Map<String, dynamic> snapData;
  final User? user;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('build feed-action-buttons');
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ).copyWith(right: 0),
      child: Row(
        children: [
          LikeAnimation(
            isSmallLike: true,
            onLiked: () {
              FireStoreManager().likePost(
                postId: snapData[FirebaseParameters.postId],
                userId: user?.uid??'',
                likes: snapData[FirebaseParameters.likes] as List,
              );
            },
            child: Icon(
              (snapData[FirebaseParameters.likes] as List).contains(user?.uid??'')
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CommentsScreen(snap: snapData),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
          ),
          const Expanded(child: SizedBox()),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border_outlined),
          ),
        ],
      ),
    );
  }
}

class _FeedHeader extends StatelessWidget {
  const _FeedHeader({
    Key? key,
    required this.snapData,
    required this.user,
  }) : super(key: key);
  final Map<String, dynamic> snapData;
  final User? user;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('build feed-header');
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ).copyWith(right: 0),
      child: Row(
        children: [
          CircleAvatar(
              radius: 16,
              backgroundImage:
                  NetworkImage(snapData[FirebaseParameters.profImage])),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              snapData[FirebaseParameters.username],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      children: ['delete', 'save']
                          .map((e) => InkWell(
                                onTap: () {},
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    child: Text(e)),
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.more_vert))
        ],
      ),
    );
  }
}

class _FeedContent extends StatelessWidget {
  const _FeedContent({
    Key? key,
    required this.snapData,
    required this.user,
  }) : super(key: key);
  final Map<String, dynamic> snapData;
  final User? user;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('build feed-content');
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      child: LikeAnimation(
        isSmallLike: false,
        iconSize: 100,
        onLiked: () {
          FireStoreManager().likePost(
            postId: snapData[FirebaseParameters.postId],
            userId: user?.uid??'',
            likes: snapData[FirebaseParameters.likes] as List,
          );
        },
        child: Center(
          child: Image.network(
            snapData[FirebaseParameters.postUrl],
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}

class _FeedDescription extends StatelessWidget {
  const _FeedDescription({Key? key, required this.snapData, required this.user})
      : super(key: key);
  final Map<String, dynamic> snapData;
  final User? user;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('build feed-description');
    }
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16).copyWith(right: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTextStyle(
            style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(fontWeight: FontWeight.bold) ??
                const TextStyle(),
            child: Text('${snapData[FirebaseParameters.likes].length} likes'),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(
                  style: const TextStyle(color: AppColors.primaryColor),
                  children: [
                    TextSpan(
                      text: snapData[FirebaseParameters.username],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' ${snapData[FirebaseParameters.description]}',
                    )
                  ]),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CommentsScreen(snap: snapData),
              ));
            },
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(FirebaseParameters.collectionPosts)
                  .doc(snapData[FirebaseParameters.postId])
                  .collection(FirebaseParameters.collectionComments)
                  .orderBy(FirebaseParameters.datePublished,descending: true)
                  .snapshots(),
              builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'View all comments',
                    style: TextStyle(fontSize: 16, color: AppColors.secondaryColor),
                  );
                }
                final docs = snapshot.data?.docs ?? [];
                return Text(
                  'View all ${docs.length} comments',
                  style: const TextStyle(fontSize: 16, color: AppColors.secondaryColor),
                );
              }
            ),
          ),
          const SizedBox(height: 8),
          Text(
            getPostDate(snapData[FirebaseParameters.datePublished]),
            style: const TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
