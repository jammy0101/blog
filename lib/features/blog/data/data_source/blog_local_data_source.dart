//So,the new work will be start from here
//here i will use the local data base for the blogs

import 'package:blog/features/blog/data/model/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlog({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);
  // @override
  // List<BlogModel> loadBlogs() {
  //   List<BlogModel> blogs = [];
  //   box.read(() {
  //     for (int i = 0; i < box.length; i++) {
  //       box.add(BlogModel.fromJson(box.get(i.toString())));
  //     }
  //   });
  //
  //   return blogs;
  // }

  @override
  List<BlogModel> loadBlogs() {
    // Convert every stored map back into a BlogModel
    return box.values
        .map((e) => BlogModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // @override
  // void uploadLocalBlog({required List<BlogModel> blogs}) {
  //   box.write(() {
  //     for (int i = 0; i < blogs.length; i++) {
  //       box.put(i.toString(), blogs[i].toJson());
  //     }
  //   });
  // }
  @override
  Future<void> uploadLocalBlog({required List<BlogModel> blogs}) async {
    // Optional: clear old data before inserting
    await box.clear();

    // Save each blog with an index as the key
    for (int i = 0; i < blogs.length; i++) {
      await box.put(i.toString(), blogs[i].toJson());
    }
  }
}
