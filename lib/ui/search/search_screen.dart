import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../data/network/constants.dart';
import '../profile/profile_screen.dart';
import 'widgets/tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _isSerchingUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    hintText: 'Search...',
                    filled: true,
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      _isSerchingUser = true;
                      setState(() {});
                    } else {
                      _isSerchingUser = false;
                      setState(() {});
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _isSerchingUser
                    ? FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection(FirebaseParameters.collectionUsers)
                            .where(FirebaseParameters.username,
                                isGreaterThanOrEqualTo: _searchController.text)
                            .get(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return ListView.builder(
                            itemCount: snapshot.data?.docs.length ?? 0,
                            itemBuilder: (context, index) => ListTile(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    uid: (snapshot.data?.docs[index]
                                        .data()[FirebaseParameters.uid]),
                                  ),
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(snapshot
                                    .data?.docs[index]
                                    .data()[FirebaseParameters.photoUrl]),
                                radius: 12,
                              ),
                              title: Text(snapshot.data?.docs[index]
                                  .data()[FirebaseParameters.username]),
                            ),
                          );
                        },
                      )
                    : _postsGrid(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _postsGrid() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection(FirebaseParameters.collectionPosts)
          .get(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final snapData = snapshot.data;
        final docList = snapData?.docs ?? [];

        return GridView.custom(
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            repeatPattern: QuiltedGridRepeatPattern.inverted,
            pattern: [
              const QuiltedGridTile(2, 2),
              const QuiltedGridTile(1, 1),
              const QuiltedGridTile(1, 1),
              const QuiltedGridTile(1, 2),
            ],
          ),
          childrenDelegate: SliverChildBuilderDelegate(
            childCount: docList.length,
            (context, index) {
              final postUrl = docList[index].data()[FirebaseParameters.postUrl];
              return Tile(index: index, imageUrl: postUrl);
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
