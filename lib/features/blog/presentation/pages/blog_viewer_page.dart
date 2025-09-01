import 'package:flutter/material.dart';

import '../../domain/entites/blog.dart';

class BlogViewerPage extends StatelessWidget {
  static route(Blog blog) => MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog,));
  const BlogViewerPage({super.key, required this.blog});

  final Blog blog;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          children: [
//Now from here i will start
      ]
      ),
    );
  }
}
