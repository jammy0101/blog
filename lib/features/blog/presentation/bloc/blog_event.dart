part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

//blogUpload is the event
//and UploadBlog is the usecase
final class BlogUpload extends BlogEvent {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  BlogUpload({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}

final class BlogFetchBlogsEvent extends BlogEvent {}
