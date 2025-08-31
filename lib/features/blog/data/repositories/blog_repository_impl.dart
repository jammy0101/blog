

import 'dart:io';

import 'package:blog/core/error/exceptions.dart';
import 'package:blog/core/error/failures.dart';
import 'package:blog/features/blog/data/data_source/blog_remote_data_source.dart';
import 'package:blog/features/blog/data/model/blog_model.dart';
import 'package:blog/features/blog/domain/entites/blog.dart';
import 'package:fpdart/src/either.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repository/blog_repository.dart';

class BlogRepositoryImpl implements BlogRepository{
  final BlogRemoteDataSource blogRemoteDataSource;
  BlogRepositoryImpl(this.blogRemoteDataSource);

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics
  })async{
    try{

      BlogModel blogModel = BlogModel(
          id: Uuid().v1(),
          posterId: posterId,
          title: title,
          content: content,
          imageUrl: '',
          topics: topics,
          updatedAt: DateTime.now()
      );
      //first of all i will send the image to supabase
      //first i will find the imageUrl by copy method
      //after that i will send this to the blogModel
      // and after that to the supabase

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
          image: image,
          blog: blogModel,
      );
      //first you will do this and after that upload to the supabase
      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

     //uploaded to the supabase
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(
        blogModel
      );

      return right(uploadedBlog);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Blog> >> getAllBlogs()async{
    try{
      final blogs = await blogRemoteDataSource.getAllBlogs();
      return right(blogs);
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

}