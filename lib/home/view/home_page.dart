import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/config/config.dart';
import 'package:posts_app/home/home.dart';
import 'package:posts_app/l10n/l10n.dart';
import 'package:posts_app/posts/posts.dart';
import 'package:posts_app/routing/routing.dart';

@RoutePage(
  name: 'HomeRoute',
)
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsBloc(
        localAppConfig: context.read<LocalAppConfig>(),
        postsApi: context.read<PostsApi>(),
      )..add(const PostsRequested()),
      child: const HomeView(),
    );
  }
}

@visibleForTesting
class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });

  @visibleForTesting
  static final routeGroups = {
    (
      (AppLocalizations l10n) => l10n.postsTabLabel,
      const PostsRoute(),
    ),
    (
      (AppLocalizations l10n) => l10n.favPostsTabLabel,
      const FavPostsRoute(),
    ),
  };

  @visibleForTesting
  static final routes = [for (final (_, route) in routeGroups) route];

  @visibleForTesting
  static final tabLabelBuilders = [
    for (final (labelBuilder, _) in routeGroups) labelBuilder,
  ];

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: routes,
      builder: (context, child, controller) => InheritedTabController(
        controller: controller,
        child: Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              DefaultSliverOverlapAbsorber(
                sliver: Builder(
                  builder: (context) => SliverHomeAppBar(
                    forceElevated: innerBoxIsScrolled,
                    tabLabels: [
                      for (final labelBuilder in tabLabelBuilders)
                        labelBuilder(context.l10n),
                    ],
                  ),
                ),
              ),
            ],
            body: child,
          ),
        ),
      ),
    );
  }
}
