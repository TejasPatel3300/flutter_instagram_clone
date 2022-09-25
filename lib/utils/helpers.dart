import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

String getPostDate(String rawDate) {
  final now = DateTime.now();
  final postDate = DateTime.parse(rawDate);
  final diff = now.difference(postDate).inDays;

  if (postDate.month == now.month) {
    return '$diff days ago';
  } else {
    return DateFormat('dd MMM').format(postDate);
  }
}

String getCommentDate(String rawDate) {
  final now = DateTime.now();
  final postDate = DateTime.parse(rawDate);
  final diff = now.difference(postDate).inDays;

  if (diff >= 7) {
    return '${diff ~/ 7} w';
  }
  return '$diff d';
}
