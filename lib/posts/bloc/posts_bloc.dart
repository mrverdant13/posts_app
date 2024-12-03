import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/config/config.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsBlocEvent, PostsBlocState> {
  PostsBloc({
    required this.localAppConfig,
    required this.postsApi,
  }) : super(const PostsBlocState.initial()) {
    on<PostsBlocEvent>(_onPostsEvent);
  }

  @visibleForTesting
  final LocalAppConfig localAppConfig;

  @visibleForTesting
  final PostsApi postsApi;

  Future<void> _onPostsEvent(
    PostsBlocEvent event,
    Emitter<PostsBlocState> emit,
  ) async {
    switch (event) {
      case PostsRequested():
        await _onPostsRequested(event, emit);
      case PostsRefreshed():
        await _onPostsRefreshed(event, emit);
    }
  }

  Future<void> _onPostsRequested(
    PostsRequested event,
    Emitter<PostsBlocState> emit,
  ) async {
    if (state.isLoading) return;
    if (state.posts?.length == state.postsCount) return;
    emit(
      state.copyWith(
        isLoading: true,
        error: () => null,
      ),
    );
    try {
      final postsPage = await postsApi.getPostsPage(
        offset: state.posts?.length ?? 0,
        limit: localAppConfig.postsPageSize,
      );
      emit(
        state.copyWith(
          posts: () => [
            ...?state.posts,
            ...postsPage.posts,
          ],
          postsCount: postsPage.postsCount,
          isLoading: false,
          error: () => null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          error: () => error,
        ),
      );
    }
  }

  Future<void> _onPostsRefreshed(
    PostsRefreshed event,
    Emitter<PostsBlocState> emit,
  ) async {
    emit(const PostsBlocState.initial());
    add(const PostsRequested());
  }
}
