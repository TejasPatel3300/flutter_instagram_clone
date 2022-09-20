import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../data/network/constants.dart';
import '../../model/user.dart';
import '../../providers/user_provider.dart';
import '../../resources/firestore_manager.dart';
import 'widgets/comment_item.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  final Map<String, dynamic> snap;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.comments),
        backgroundColor: AppColors.mobileBackGroundColor,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user?.photoUrl ?? ''),
                radius: 16,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _commentsController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: Strings.commentHint,
                  ),
                  textInputAction: TextInputAction.send,
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () => _postComment(user),
                child: const Text(
                  Strings.post,
                  style: TextStyle(color: AppColors.blueColor),
                ),
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap[FirebaseParameters.postId])
              .collection('comments')
              .orderBy(FirebaseParameters.datePublished, descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final docs = snapshot.data?.docs ?? [];
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) => CommentItem(
                doc: docs[index],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _postComment(User? user) async {
    if (_commentsController.text.isNotEmpty) {
      FireStoreManager().postComment(
        postId: widget.snap[FirebaseParameters.postId],
        userId: user?.uid ?? '',
        commentText: _commentsController.text,
        profImage: widget.snap[FirebaseParameters.profImage],
        username: user?.username ?? '',
      );
      _commentsController.clear();
    }
  }
}
