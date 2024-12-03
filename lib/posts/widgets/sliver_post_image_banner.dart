import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/config/config.dart';
import 'package:posts_app/posts/posts.dart';

class SliverPostImageBanner extends StatelessWidget {
  const SliverPostImageBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PostBloc>().state;
    final defaultAspectRatio =
        context.watch<LocalAppConfig>().defaultPostImageAspectRatio;
    return SliverToBoxAdapter(
      child: switch (state) {
        PostBlocStateInitial() || PostBlocStateLoading() => PostImage.skeleton(
            aspectRatio: defaultAspectRatio,
          ),
        PostBlocStateError() => PostImage.errored(
            aspectRatio: defaultAspectRatio,
          ),
        PostBlocStateLoaded(post: Post(:final image)) => PostImage(
            aspectRatio: image.aspectRatio,
            imageUrl: image.url,
          ),
      },
    );
  }
}
