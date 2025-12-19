part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

sealed class BlogUpload extends BlogEvent {
  final String posterId;
  final String title;
  final String content;
  final List<String> topics;
  final File image;

  BlogUpload({
    required this.posterId,
    required this.title,
    required this.content,
    required this.topics,
    required this.image,
  });
}

final class BlogUploadRequested extends BlogUpload {
  BlogUploadRequested({
    required super.posterId,
    required super.title,
    required super.content,
    required super.topics,
    required super.image,
  });
}
final class BlogFetchAllBlogs extends BlogEvent{}