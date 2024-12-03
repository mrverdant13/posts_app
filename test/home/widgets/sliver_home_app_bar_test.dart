import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/home/home.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$SliverHomeAppBar', () {
    final multiSliverFinder = find.byType(MultiSliver);
    final baseAppBarFinder = find.descendant(
      of: multiSliverFinder,
      matching: find.byType(SliverBaseHomeAppBar),
    );
    final blogHeaderFinder = find.descendant(
      of: multiSliverFinder,
      matching: find.byType(SliverBlogHeader),
    );
    final pinnedTabBarFinder = find.descendant(
      of: multiSliverFinder,
      matching: find.byType(SliverPinnedHomeTabBar),
    );
    testWidgets(
        'renders a $MultiSliver with a $SliverBaseHomeAppBar, a '
        '$SliverBlogHeader and a $SliverPinnedHomeTabBar if tabLabels is not '
        'empty and there is an $InheritedTabController', (tester) async {
      const vsync = TestVSync();
      final controller = TabController(vsync: vsync, length: 2);
      addTearDown(controller.dispose);
      await tester.pumpAppWithSlivers([
        InheritedTabController(
          controller: controller,
          child: const SliverHomeAppBar(
            forceElevated: false,
            tabLabels: ['Tab 1', 'Tab 2'],
          ),
        ),
      ]);
      await tester.pumpAndSettle();
      expect(multiSliverFinder, findsOneWidget);
      expect(baseAppBarFinder, findsOneWidget);
      expect(blogHeaderFinder, findsOneWidget);
      expect(pinnedTabBarFinder, findsOneWidget);
    });

    testWidgets(
        'renders a $MultiSliver with a $SliverBaseHomeAppBar and a '
        '$SliverBlogHeader if tabLabels is empty', (tester) async {
      await tester.pumpAppWithSlivers([
        const SliverHomeAppBar(
          forceElevated: false,
        ),
      ]);
      await tester.pumpAndSettle();
      expect(multiSliverFinder, findsOneWidget);
      expect(baseAppBarFinder, findsOneWidget);
      expect(blogHeaderFinder, findsOneWidget);
      expect(pinnedTabBarFinder, findsNothing);
    });
  });

  group('$SliverPinnedHomeTabBar', () {
    testWidgets('scrolls to the top when the active tab is tapped',
        (tester) async {
      final scrollController = ScrollController(initialScrollOffset: 2500);
      addTearDown(scrollController.dispose);
      final tabController = TabController(vsync: const TestVSync(), length: 2);
      addTearDown(tabController.dispose);
      await tester.pumpAppWithSlivers(
        [
          InheritedTabController(
            controller: tabController,
            child: const SliverPinnedHomeTabBar(labels: ['Tab 1', 'Tab 2']),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 5000,
            ),
          ),
        ],
        scrollController: scrollController,
      );
      await tester.pumpAndSettle();
      expect(scrollController.offset, 2500);
      await tester.tap(find.text('Tab 1'));
      await tester.pumpAndSettle();
      expect(scrollController.offset, isZero);
    });
  });
}
