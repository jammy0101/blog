import 'dart:io';
import 'package:blog/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import '../entites/blog.dart';


abstract interface class BlogRepository{


  Future<Either<Failure,Blog>>  uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
});
}