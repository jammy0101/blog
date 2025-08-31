import 'dart:io';
import 'package:blog/core/error/failures.dart';
import 'package:blog/core/usecase/usecase.dart';
import 'package:blog/features/blog/domain/entites/blog.dart';
import 'package:blog/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

//blogUpload is the event
//and UploadBlog is the usecase

class UploadBlog implements UseCase<Blog, UploadBlogParams>{
  final  BlogRepository blogRepository;
  UploadBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params)async{
   return await blogRepository.uploadBlog(
        image: params.image,
        title: params.title,
        content: params.content,
        posterId: params.posterId,
        topics: params.topics,
    );

  }
}

class UploadBlogParams{

  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;



  UploadBlogParams( {
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
});

}