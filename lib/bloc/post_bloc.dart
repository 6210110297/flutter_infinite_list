import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_try/post.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;
  PostBloc({@required this.httpClient}) : super(PostInitial());

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    final curState = state;
    if (event is PostFetched && !_hasReachMax(state)) {
      try {
        if (curState is PostInitial) {
          final posts = await _fetch(0, 20);
          yield PostSuccess(posts: posts, hasReachMax: false);
          return;
        }
        if (curState is PostSuccess) {
          final posts = await _fetch(curState.posts.length, 20);
          yield posts.isEmpty
              ? curState.copyWith(hasReachMax: true)
              : PostSuccess(posts: curState.posts + posts, hasReachMax: false);
        }
      } catch (_) {
        yield PostFailure();
      }
    }
  }

  bool _hasReachMax(PostState state) {
    return (state is PostSuccess && state.hasReachMax);
  }

  Future<List<Post>> _fetch(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((raw) {
        return Post(
          id: raw['id'],
          title: raw['title'],
          body: raw['body'],
        );
      }).toList();
    } else {
      throw Exception('eror fetching posts');
    }
  }
}
