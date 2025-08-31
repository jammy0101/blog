import 'package:blog/core/error/failures.dart';
import 'package:blog/core/usecase/usecase.dart';
import 'package:blog/features/blog/domain/repository/blog_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/src/either.dart';

import '../entites/blog.dart';


class GetAllBlogs implements UseCase<List<Blog>,NoParams>{
  final BlogRepository blogRepository;
  GetAllBlogs(this.blogRepository);

  @override
  Future<Either<Failure, List<Blog> >> call(NoParams params)async{
    return await blogRepository.getAllBlogs();
  }

}