part of 'post_bloc.dart';

sealed class PostBlocState extends Equatable {
  const PostBlocState();
}

class PostBlocStateInitial extends PostBlocState {
  const PostBlocStateInitial();

  @override
  List<Object> get props => [];
}

class PostBlocStateLoading extends PostBlocState {
  const PostBlocStateLoading();

  @override
  List<Object> get props => [];
}

class PostBlocStateError extends PostBlocState {
  const PostBlocStateError(this.error);

  final Object error;

  @override
  List<Object> get props => [error];
}

class PostBlocStateLoaded extends PostBlocState {
  const PostBlocStateLoaded(this.post);

  final Post post;

  @override
  List<Object> get props => [post];
}
