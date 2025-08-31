import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:blog/core/usecase/usecase.dart';
import 'package:blog/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/entites/blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  }) :

      _uploadBlog = uploadBlog,
  _getAllBlogs = getAllBlogs,


super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchBlogsEvent>(_onFetchAllBlogs);
  }


  void _onFetchAllBlogs(BlogFetchBlogsEvent event,Emitter<BlogState> emit)async{
    final res = await _getAllBlogs(
      NoParams(),
    );
    
    res.fold(
            (failure) =>
                emit(BlogFailure(failure.message)),
            (result) => emit(BlogDisplaySuccess(result)),
    );
  }

//blogUpload is an event not a usecase
  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit)async{
    //here i will use the usecase
   final res =  await _uploadBlog(
        UploadBlogParams(
          posterId: event.posterId,
          title: event.title,
          content: event.content,
          image: event.image,
          topics: event.topics
      )
    );
   res.fold(
         (failure) => emit(BlogFailure(failure.message)),
         (blog) => emit(BlogSuccess()),
   );
  }

}
