import 'package:blog/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog App'),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewBlogPage()));
              },
              icon: Icon(CupertinoIcons.add_circled,size: 35,),
          ),
        ],
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
