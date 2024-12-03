import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:posts_app/posts/posts.dart';
import 'package:posts_app/routing/routing.gr.dart';

export 'routing.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({
    @visibleForTesting this.testRoutes = const [],
  });

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  late final List<AutoRoute> routes = [
    if (testRoutes.isEmpty)
      AdaptiveRoute<void>(
        path: '/',
        page: RootWrapperRoute.page,
        children: [
          AdaptiveRoute<void>(
            path: '',
            page: HomeRoute.page,
            children: [
              RedirectRoute(
                path: '',
                redirectTo: 'posts',
              ),
              AdaptiveRoute<void>(
                path: 'posts',
                page: PostsRoute.page,
              ),
              AdaptiveRoute<void>(
                path: 'fav-posts',
                page: FavPostsRoute.page,
              ),
            ],
          ),
          AdaptiveRoute<void>(
            path: 'posts/:${PostPage.postIdPathParamKey}',
            page: PostRoute.page,
          ),
        ],
      )
    else
      ...testRoutes,
  ];

  @visibleForTesting
  final List<AutoRoute> testRoutes;
}
