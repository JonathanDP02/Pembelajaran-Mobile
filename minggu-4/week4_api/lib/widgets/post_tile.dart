import 'package:flutter/material.dart';
import '../data/models/post.dart';

class PostTile extends StatelessWidget {
  const PostTile({super.key, required this.post, required this.onTap});

  final Post post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(post.id.toString()),
        ),
        title: Text(
          post.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          post.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
      ),
    );
  }
}