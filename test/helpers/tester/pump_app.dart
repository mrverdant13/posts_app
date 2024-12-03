import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/l10n/l10n.dart';
import 'package:posts_app/routing/routing.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget home, {
    List<RepositoryProvider<dynamic>> repositoryProviders = const [],
    List<BlocProvider> blocProviders = const [],
  }) async {
    Widget widget = MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );
    if (blocProviders.isNotEmpty) {
      widget = MultiBlocProvider(
        providers: blocProviders,
        child: widget,
      );
    }
    if (repositoryProviders.isNotEmpty) {
      widget = MultiRepositoryProvider(
        providers: repositoryProviders,
        child: widget,
      );
    }
    await pumpWidget(widget);
  }

  Future<void> pumpAppWithRouter({
    AppRouter? appRouter,
    RouterConfig<UrlState> Function(AppRouter router)? configBuilder,
    List<RepositoryProvider<dynamic>> repositoryProviders = const [],
    List<BlocProvider> blocProviders = const [],
  }) async {
    final router = appRouter ?? AppRouter();
    if (appRouter == null) addTearDown(router.dispose);
    Widget child = MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: configBuilder?.call(router) ?? router.config(),
    );
    if (blocProviders.isNotEmpty) {
      child = MultiBlocProvider(
        providers: blocProviders,
        child: child,
      );
    }
    if (repositoryProviders.isNotEmpty) {
      child = MultiRepositoryProvider(
        providers: repositoryProviders,
        child: child,
      );
    }
    await pumpWidget(child);
  }

  Future<void> pumpAppWithScaffold(
    Widget body, {
    List<RepositoryProvider<dynamic>> repositoryProviders = const [],
    List<BlocProvider> blocProviders = const [],
  }) async {
    await pumpApp(
      Scaffold(
        body: body,
      ),
      repositoryProviders: repositoryProviders,
      blocProviders: blocProviders,
    );
  }

  Future<void> pumpAppWithSlivers(
    List<Widget> slivers, {
    ScrollPhysics? physics,
    ScrollController? scrollController,
    List<RepositoryProvider<dynamic>> repositoryProviders = const [],
    List<BlocProvider> blocProviders = const [],
  }) async {
    await pumpAppWithScaffold(
      CustomScrollView(
        physics: physics,
        controller: scrollController,
        slivers: slivers,
      ),
      repositoryProviders: repositoryProviders,
      blocProviders: blocProviders,
    );
  }

  Future<void> pumpAppWithNestedScrollViewBody(
    Widget body, {
    double fakeHeaderHeight = 0,
    ScrollPhysics? physics,
    ScrollController? scrollController,
    List<RepositoryProvider<dynamic>> repositoryProviders = const [],
    List<BlocProvider> blocProviders = const [],
  }) async {
    await pumpAppWithScaffold(
      NestedScrollView(
        physics: physics,
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          DefaultSliverOverlapAbsorber(
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: fakeHeaderHeight,
              ),
            ),
          ),
        ],
        body: body,
      ),
      repositoryProviders: repositoryProviders,
      blocProviders: blocProviders,
    );
  }
}
