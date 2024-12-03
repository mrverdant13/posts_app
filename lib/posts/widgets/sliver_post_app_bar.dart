import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/l10n/l10n.dart';
import 'package:posts_app/posts/posts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SliverPostAppBar extends StatelessWidget {
  const SliverPostAppBar({
    super.key,
  });

  static const titlePlaceholder = 'A Really Really Long Fake Post Title';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (isLoading, title) = context.select(
      (PostBloc bloc) => (
        bloc.state is PostBlocStateLoading,
        switch (bloc.state) {
          PostBlocStateInitial() || PostBlocStateLoading() => titlePlaceholder,
          PostBlocStateError() => l10n.genericOopsMessage,
          PostBlocStateLoaded(:final post) => post.title,
        },
      ),
    );
    return SliverAppBar.large(
      stretch: true,
      title: Skeletonizer(
        enabled: isLoading,
        child: Text(
          title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
