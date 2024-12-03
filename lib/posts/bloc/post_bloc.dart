import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:posts_api/posts_api.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostBlocEvent, PostBlocState> {
  PostBloc({
    required this.postsApi,
  }) : super(const PostBlocStateInitial()) {
    on<PostBlocEvent>(_onPostEvent);
  }

  @visibleForTesting
  final PostsApi postsApi;

  Future<void> _onPostEvent(
    PostBlocEvent event,
    Emitter<PostBlocState> emit,
  ) async {
    switch (event) {
      case PostSet():
        await _onPostSet(event, emit);
      case PostRequested():
        await _onPostRequested(event, emit);
    }
  }

  Future<void> _onPostSet(
    PostSet event,
    Emitter<PostBlocState> emit,
  ) async {
    emit(PostBlocStateLoaded(event.post));
  }

  Future<void> _onPostRequested(
    PostRequested event,
    Emitter<PostBlocState> emit,
  ) async {
    if (state is PostBlocStateLoading) return;
    emit(const PostBlocStateLoading());
    try {
      final post = await postsApi.getPostById(event.postId);
      emit(PostBlocStateLoaded(post));
    } catch (error) {
      emit(PostBlocStateError(error));
    }
  }
}
