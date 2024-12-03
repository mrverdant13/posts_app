import 'dart:math';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:posts_app/l10n/l10n.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SliverHomeAppBar extends StatelessWidget {
  const SliverHomeAppBar({
    required this.forceElevated,
    this.tabLabels = const [],
    super.key,
  });

  final bool forceElevated;
  final List<String> tabLabels;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverBaseHomeAppBar(forceElevated: forceElevated),
        const SliverBlogHeader(),
        if (tabLabels.isNotEmpty) SliverPinnedHomeTabBar(labels: tabLabels),
      ],
    );
  }
}

@visibleForTesting
class SliverBaseHomeAppBar extends SliverAppBar {
  const SliverBaseHomeAppBar({
    super.key,
    super.forceElevated = false,
  }) : super(
          floating: true,
          title: const SliverHomeAppBarTitle(),
        );
}

@visibleForTesting
class SliverHomeAppBarTitle extends StatelessWidget {
  const SliverHomeAppBarTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Text(
      l10n.homeAppBarTitle,
    );
  }
}

@visibleForTesting
class SliverBlogHeader extends StatelessWidget {
  const SliverBlogHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    return SliverToBoxAdapter(
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.blogSectionTitle,
                style: textTheme.headlineMedium,
              ),
              Text(
                l10n.blogSectionSummary,
                textAlign: TextAlign.justify,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class SliverPinnedHomeTabBar extends StatelessWidget {
  const SliverPinnedHomeTabBar({
    required this.labels,
    super.key,
  });

  final List<String> labels;

  static void onTabTap(BuildContext context, int index) {
    final tabController = InheritedTabController.of(context);
    if (tabController.indexIsChanging) return;
    final currentTabIndex = tabController.index;
    if (currentTabIndex != index) return;
    final scrollable = Scrollable.of(context);
    final position = scrollable.position;
    if (position.pixels == 0) return;
    position.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  static double computeTopPadding(BuildContext context) {
    final topViewPadding = MediaQuery.viewPaddingOf(context).top;
    final renderSliver = context.findRenderObject() as RenderSliver?;
    final y = renderSliver?.globalCoordinates?.dy;
    if (y == null) return 0;
    return max<double>(0, topViewPadding - y);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return DecoratedSliver(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
      ),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final topPadding = computeTopPadding(context);
          return SliverPinnedHeader(
            child: AnnotatedRegion(
              value: SystemUiOverlayStyle.dark,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 100),
                padding: EdgeInsets.only(top: topPadding),
                child: TabBar(
                  controller: InheritedTabController.of(context),
                  tabs: [
                    for (final label in labels) Tab(text: label),
                  ],
                  onTap: (index) => onTabTap(context, index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

extension on RenderSliver {
  Offset? get globalCoordinates {
    if (geometry == null) return null;
    return MatrixUtils.transformPoint(getTransformTo(null), Offset.zero);
  }
}
