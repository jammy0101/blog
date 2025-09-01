import 'package:blog/core/utils/calculate_reading_time.dart';
import 'package:blog/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';
import '../../domain/entites/blog.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({super.key, required this.blog, required this.color});

  final Blog blog;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, BlogViewerPage.route(blog));
      },
      child: Container(
        height: 200,
        //control outside
        margin: EdgeInsets.all(13),
        //control inside
        padding: EdgeInsets.all(16).copyWith(
          bottom: 3,
        ),

        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blog.topics
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Chip(label: Text(e)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Text(
                  blog.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
                SizedBox(height: 50,),
                Text('${calculateReadingTime(blog.content)} min to read'),
              ],

            ),

          ],
        ),
      ),
    );
  }
}
