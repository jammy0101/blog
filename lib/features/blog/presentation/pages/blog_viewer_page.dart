import 'package:blog/core/theme/app_pallete.dart';
import 'package:blog/core/utils/calculate_reading_time.dart';
import 'package:blog/core/utils/format_date.dart';
import 'package:flutter/material.dart';

import '../../domain/entites/blog.dart';

class BlogViewerPage extends StatelessWidget {
  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));
  const BlogViewerPage({super.key, required this.blog});

  final Blog blog;
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 5.0,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Text(
                  'By ${blog.posterName}',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19),
                ),
                SizedBox(height: 8),
                Text(
                  "${formatDataBydMMMYYYY(blog.updatedAt)} .  ${calculateReadingTime(blog.content)} min to read",
                  style: TextStyle(
                    color: AppPallete.greyColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: Image.network(blog.imageUrl),
                ),
                SizedBox(height: 30,),
                Text(blog.content,style: TextStyle(fontSize: 19,height: 1.9),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
