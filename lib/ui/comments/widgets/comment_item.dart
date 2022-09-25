import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../data/network/constants.dart';
import '../../../utils/helpers.dart';
import '../../../utils/like_animation.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({Key? key, required this.doc}) : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;

  @override
  Widget build(BuildContext context) {
    final snapData = doc.data();
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(snapData[FirebaseParameters.profImage]),
            radius: 16,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      getCommentDate(snapData[FirebaseParameters.datePublished]),
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.secondaryColor),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      '10 likes',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.secondaryColor),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Reply',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.secondaryColor),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Send',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.secondaryColor),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: 16,
            width: 16,
            child: Center(
              child: LikeAnimation(
                isSmallLike: true,
                iconSize: 16,
                onLiked: () {},
                child: const Icon(
                  Icons.favorite_border,
                  color: AppColors.secondaryColor,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
