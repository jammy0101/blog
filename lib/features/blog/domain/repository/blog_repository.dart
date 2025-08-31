import 'dart:io';
import 'package:blog/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import '../entites/blog.dart';

abstract interface class BlogRepository{

  // The id should not come from the client/UI.
  //That why it is not here

  Future<Either<Failure,Blog>>  uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
});

  Future<Either<Failure,List<Blog>>> getAllBlogs();

}