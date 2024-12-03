import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

/// The current state of the refresh indicator.
enum RefreshState {
  /// Initial state, when not being overscrolled into, or after the overscroll
  /// is canceled or after done and the sliver retracted away.
  inactive,

  /// While being overscrolled but not far enough yet to trigger the refresh.
  drag,

  /// Dragged far enough that the refresh task will run and the dragged
  /// displacement is not yet at the final refresh resting state.
  armed,

  /// While the refresh task is running.
  refresh,

  /// While the indicator is animating away after refreshing.
  done,
}

/// A builder that builds a sliver refresh indicator.
typedef SliverRefreshIndicatorBuilder = Widget Function(
  BuildContext context,
  RefreshState state,
  double overscroll,
);

/// {@template app_ui_sliver_refresh_indicator}
/// A sliver that shows a refresh indicator when pulled down.
/// {@endtemplate}
class SliverRefreshIndicator extends StatefulWidget {
  /// {@macro app_ui_sliver_refresh_indicator}
  const SliverRefreshIndicator({
    this.builder = defaultBuilder,
    this.onRefresh = noAction,
    super.key,
  });

  /// A builder that builds a sliver refresh indicator.
  final SliverRefreshIndicatorBuilder builder;

  /// A callback that is called when the refresh is triggered.
  final AsyncCallback onRefresh;

  /// The default builder for the refresh indicator.
  static Widget defaultBuilder(
    BuildContext context,
    RefreshState state,
    double overscroll,
  ) {
    if (state == RefreshState.inactive) {
      return const SizedBox.shrink();
    }
    return SizedBox.square(
      dimension: overscroll,
      child: Padding(
        padding: EdgeInsets.all(overscroll * 0.1),
        child: const Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }

  /// A no-op async action.
  static Future<void> noAction() async {}

  @override
  State<SliverRefreshIndicator> createState() => _SliverRefreshIndicatorState();
}

class _SliverRefreshIndicatorState extends State<SliverRefreshIndicator> {
  // Inherited instances
  ScrollPosition? scrollPosition;
  ScrollNotificationObserverState? scrollNotificationObserver;

  // Local instances
  late final ValueNotifier<RefreshState> stateNotifier;
  late bool hadDragDetails;
  late bool isManuallyDragging;

  AsyncCallback get onRefresh => widget.onRefresh;
  double get overscroll => scrollPosition?.topOverscroll ?? 0;
  ScrollDirection get userScrollDirection =>
      scrollPosition?.userScrollDirection ?? ScrollDirection.idle;

  static const overscrollIndicatorThreshold = 100.0;

  @override
  void initState() {
    super.initState();
    stateNotifier = ValueNotifier(RefreshState.inactive)
      ..addListener(updateState);
    hadDragDetails = false;
    isManuallyDragging = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newScrollPosition =
        Scrollable.maybeOf(context, axis: Axis.vertical)?.position;
    if (scrollPosition != newScrollPosition) {
      stateNotifier.value = RefreshState.inactive;
      hadDragDetails = false;
      isManuallyDragging = false;
      scrollPosition?.removeListener(updateState);
      scrollPosition = newScrollPosition;
      scrollPosition?.addListener(updateState);
    }
    final newScrollNotificationObserver =
        ScrollNotificationObserver.maybeOf(context);
    if (scrollNotificationObserver != newScrollNotificationObserver) {
      scrollNotificationObserver?.removeListener(onScrollNotification);
      scrollNotificationObserver = newScrollNotificationObserver;
      scrollNotificationObserver?.addListener(onScrollNotification);
    }
  }

  void onScrollNotification(ScrollNotification notification) {
    switch (notification) {
      case ScrollStartNotification():
        final hasDragDetails = notification.dragDetails != null;
        isManuallyDragging = hasDragDetails;
        hadDragDetails = hasDragDetails;
      case ScrollUpdateNotification():
        final hasDragDetails = notification.dragDetails != null;
        isManuallyDragging = hasDragDetails || hadDragDetails;
        hadDragDetails = hasDragDetails;
      case ScrollEndNotification():
        isManuallyDragging = false;
        hadDragDetails = false;
      case OverscrollNotification():
        final hasDragDetails = notification.dragDetails != null;
        isManuallyDragging = hasDragDetails;
        hadDragDetails = hasDragDetails;
      case UserScrollNotification():
        switch (notification.direction) {
          case ScrollDirection.idle:
            isManuallyDragging = false;
            hadDragDetails = false;
          case ScrollDirection.forward || ScrollDirection.reverse:
            isManuallyDragging = true;
            hadDragDetails = true;
        }
    }
  }

  @override
  void dispose() {
    scrollPosition?.removeListener(updateState);
    scrollPosition = null;
    scrollNotificationObserver?.removeListener(onScrollNotification);
    scrollNotificationObserver = null;
    stateNotifier.dispose();
    super.dispose();
  }

  void updateState() {
    setState(() {
      switch (stateNotifier.value) {
        case RefreshState.armed:
          if (isManuallyDragging) {
            if (userScrollDirection case ScrollDirection.reverse) {
              if (overscroll < overscrollIndicatorThreshold) {
                stateNotifier.value = RefreshState.drag;
              }
            }
          } else {
            stateNotifier.value = RefreshState.refresh;
            Future.sync(() async {
              await onRefresh();
              if (!mounted) return;
              stateNotifier.value = RefreshState.done;
            });
          }
        case RefreshState.inactive:
          if (overscroll > 0) {
            stateNotifier.value = RefreshState.drag;
          }
        case RefreshState.drag:
          if (overscroll <= 0) {
            stateNotifier.value = RefreshState.inactive;
          }
          if (overscroll >= overscrollIndicatorThreshold) {
            stateNotifier.value = RefreshState.armed;
          }
        case RefreshState.refresh:
          break;
        case RefreshState.done:
          if (overscroll <= 0) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              stateNotifier.value = RefreshState.inactive;
            });
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedOverflowBox(
        size: const Size.fromHeight(double.minPositive),
        alignment: Alignment.topCenter,
        child: Transform.translate(
          offset: Offset(0, -overscroll),
          child: SizedBox(
            height: overscroll,
            child: ListenableBuilder(
              listenable: stateNotifier,
              builder: (context, _) => widget.builder(
                context,
                stateNotifier.value,
                overscroll,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on ScrollPosition {
  double get topOverscroll {
    if (!haveDimensions) return 0;
    return min<double>(0, pixels - minScrollExtent).abs();
  }
}
