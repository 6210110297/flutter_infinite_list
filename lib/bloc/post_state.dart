part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostFailure extends PostState {}

class PostSuccess extends PostState {
  final List<Post> posts;
  final bool hasReachMax;

  const PostSuccess({this.posts, this.hasReachMax});

  PostSuccess copyWith({posts, hasReachMax}) {
    return PostSuccess(
        posts: posts ?? this.posts,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }

  @override
  List<Object> get props => [posts, hasReachMax];
  @override
  String toString() =>
      'PostSuccess {posts: ${posts.length},hasReachMax: $hasReachMax}';
}
