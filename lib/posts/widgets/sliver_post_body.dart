import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/l10n/l10n.dart';
import 'package:posts_app/posts/bloc/post_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SliverPostBody extends StatelessWidget {
  const SliverPostBody({
    super.key,
  });

  static final bodyPlaceholder = 'This is a fake post body. ' * 10;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (isLoading, content) = context.select(
      (PostBloc bloc) => (
        bloc.state is PostBlocStateLoading,
        switch (bloc.state) {
          PostBlocStateInitial() || PostBlocStateLoading() => bodyPlaceholder,
          PostBlocStateError(:final error) => switch (error) {
              GetPostByIdFailureNotFound() => l10n.postNotFoundErrorMessage,
              GetPostByIdFailureUnexpected() =>
                l10n.genericUnexpectedFailureMessage,
              _ => l10n.genericUnexpectedErrorMessage,
            },
          PostBlocStateLoaded(:final post) => post.body,
        },
      ),
    );
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Skeletonizer(
          enabled: isLoading,
          child: Text(content),
        ),
      ),
    );
  }
}
