import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/config/config.dart';
import 'package:posts_app/posts/posts.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$SliverPostImageBanner', () {
    late LocalAppConfig localAppConfig;
    late PostBloc postBloc;

    setUp(() {
      localAppConfig = MockLocalAppConfig();
      postBloc = MockPostBloc();
      when(() => localAppConfig.defaultPostImageAspectRatio).thenReturn(16 / 9);
    });

    Widget buildSubject() => RepositoryProvider<LocalAppConfig>.value(
          value: localAppConfig,
          child: BlocProvider<PostBloc>.value(
            value: postBloc,
            child: const SliverPostImageBanner(),
          ),
        );

    testWidgets(
        'renders ${PostImage.skeleton} when state is $PostBlocStateInitial or '
        '$PostBlocStateLoading', (tester) async {
      when(() => postBloc.state).thenReturn(const PostBlocStateInitial());
      await tester.pumpAppWithSlivers([buildSubject()]);
      expect(find.byType(SkeletonPostImage), findsOneWidget);
    });

    testWidgets(
        'renders ${PostImage.errored} when state is $PostBlocStateError',
        (tester) async {
      when(() => postBloc.state).thenReturn(const PostBlocStateError('error'));
      await tester.pumpAppWithSlivers([buildSubject()]);
      expect(find.byType(ErroredPostImage), findsOneWidget);
    });

    testWidgets('renders $PostImage when state is $PostBlocStateLoaded',
        (tester) async {
      const post = Post(
        id: 1,
        title: 'title',
        body: 'body',
        category: PostCategory.events,
        image: ImageData(
          url: 'url',
          width: 1,
          height: 1,
        ),
      );
      when(() => postBloc.state).thenReturn(const PostBlocStateLoaded(post));
      await tester.pumpAppWithSlivers([buildSubject()]);
      expect(find.byType(PostImage), findsOneWidget);
    });
  });
}
