import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/l10n/l10n.dart';
import 'package:posts_app/posts/posts.dart';

class SliverPostsRefreshIndicator extends StatefulWidget {
  const SliverPostsRefreshIndicator({
    super.key,
  });

  @override
  State<SliverPostsRefreshIndicator> createState() =>
      _SliverPostsRefreshIndicatorState();
}

class _SliverPostsRefreshIndicatorState
    extends State<SliverPostsRefreshIndicator> {
  Completer<void>? completer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<PostsBloc, PostsBlocState>(
      listenWhen: (previous, current) =>
          previous.isLoading != current.isLoading,
      listener: (context, state) {
        if (state.isLoading) return;
        completer?.complete();
        completer = null;
      },
      child: SliverRefreshIndicator(
        builder: (context, state, overscroll) => ColoredBox(
          color: AppColors.mainBlue,
          child: Center(
            child: Text(
              l10n.pullToRefreshInnerMessage(state),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.white,
              ),
            ),
          ),
        ),
        onRefresh: () async {
          context.read<PostsBloc>().add(const PostsRefreshed());
          await (completer ??= Completer()).future;
        },
      ),
    );
  }
}

extension on AppLocalizations {
  String pullToRefreshInnerMessage(RefreshState state) => switch (state) {
        RefreshState.inactive => '',
        RefreshState.drag => pullToRefreshMessage,
        RefreshState.armed => releaseToRefreshMessage,
        RefreshState.refresh => refreshingMessage,
        RefreshState.done => doneRefreshingMessage,
      };
}
