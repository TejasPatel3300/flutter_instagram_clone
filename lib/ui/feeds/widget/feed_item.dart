import 'package:flutter/material.dart';

class FeedItem extends StatelessWidget {
  const FeedItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _feedHeader(context),
      ],
    );
  }

  Widget _feedHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ).copyWith(right: 0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1661961110372-8a7682543120?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80'),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'username',
              style: TextStyle(fontWeight: FontWeight.w600),
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
