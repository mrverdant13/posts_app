import 'package:flutter/material.dart';

/// {@template app_ui.inherited_tab_controller}
/// A [InheritedNotifier] that passes a [TabController] down the widget tree.
/// {@endtemplate}
class InheritedTabController extends InheritedNotifier<TabController> {
  /// {@macro app_ui.inherited_tab_controller}
  const InheritedTabController({
    required TabController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  /// Returns the [TabController] from the closest [InheritedTabController], if
  /// any. If there is no [InheritedTabController] in the widget tree, `null` is
  /// returned.
  static TabController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedTabController>()
        ?.notifier;
  }

  /// Returns the [TabController] from the closest [InheritedTabController]
  /// ancestor.
  static TabController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(
      controller != null,
      'No TabController found in the widget tree',
    );
    return controller!;
  }
}
