import 'dart:io';
import 'package:blog/core/error/exceptions.dart';
import 'package:blog/features/blog/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {

  //for upload blog
  Future<BlogModel> uploadBlog(BlogModel blog);

  //for upload image
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  // posterName → actual display name of that user, so your app can show:
  // "Posted by Rashid Khan" instead of "Posted by 34e1c8a7-9c…"
  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<BlogModel>> getAllBlogs()async{
    try{
      //it will select all the blogs of the blogs table
      //and also select the name of the profile table as well
      //you can also select all the rows of the profile table
     final blogs = await supabaseClient.from('blogs').select('*,profiles(name)');
     //first we will take using fromJson and after that we will add the
     //copyWith because we add the posterName there
     return blogs.map((blog) => BlogModel.fromJson(blog).copyWith(
       //we cant directly access the blog we mention it in profiles
       //by poster we will show and fetch this
       posterName: blog['profiles']['name'],
     )).toList();
    }catch(e){
      throw ServerException(e.toString());
    }
  }


  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blog.toJson())
          .select();

      return BlogModel.fromJson(blogData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
       await supabaseClient.storage.from('blogs_images').upload(blog.id, image);
      //you can also add the path here on the pro level '${blog.id}/images'
       return supabaseClient.storage.from('blogs_images').getPublicUrl(blog.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
