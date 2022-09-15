import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/colors.dart';
import 'package:instagram_clone/data/network/constants.dart';
import 'package:instagram_clone/utils/like_animation.dart';
import 'package:intl/intl.dart';

class FeedItem extends StatelessWidget {
  const FeedItem({Key? key, required this.doc}) : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;

  @override
  Widget build(BuildContext context) {
    final snapData = doc.data();
    return Column(
      children: [
        _feedHeader(context,snapData),
        _content(context,snapData),
        _feedItemActions(snapData),
        _description(context,snapData),
      ],
    );
  }

  Widget _feedHeader(BuildContext context, Map<String, dynamic> snapData) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ).copyWith(right: 0),
      child: Row(
        children: [
          CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(snapData[FirebaseParameters.profImage])),
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

  Widget _content(BuildContext context, Map<String, dynamic> snapData) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      child: LikeAnimation(
        child: Image.network(
          snapData[FirebaseParameters.postUrl],
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _feedItemActions(Map<String, dynamic> snapData) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ).copyWith(right: 0),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
          const Expanded(child: SizedBox()),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_border_outlined)),
        ],
      ),
    );
  }

  Widget _description(BuildContext context, Map<String, dynamic> snapData) {
    return Padding(
      padding: const EdgeInsets.only(left: 16,bottom: 16).copyWith(right: 0),
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
                      text:  snapData[FirebaseParameters.username],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' ${ snapData[FirebaseParameters.description]}',
                    )
                  ]),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'View all 23 comments',
              style: TextStyle(fontSize: 16, color: AppColors.secondaryColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getPostDate(snapData[FirebaseParameters.datePublished]),
            style: const TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }

  String _getPostDate(String rawDate){
    final now = DateTime.now();
    final postDate = DateTime.parse(rawDate);
    final diff = postDate.difference(now).inDays;

    if(postDate.month == now.month){
      return '$diff days ago';
    }else{
      return DateFormat('dd MMM').format(postDate);
    }
  }
}
