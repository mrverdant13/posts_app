import 'package:flutter/widgets.dart';

/// An extension on [BuildContext] that provides a way to get the
/// [SliverOverlapAbsorberHandle] from a [NestedScrollView].
extension SliverOverlapContext on BuildContext {
  /// Returns the [SliverOverlapAbsorberHandle] from the nearest
  /// [NestedScrollView].
  SliverOverlapAbsorberHandle get sliverOverlapAbsorberHandle {
    return NestedScrollView.sliverOverlapAbsorberHandleFor(this);
  }
}

/// {@template app_ui.default_sliver_overlap_absorber}
/// A widget that wraps a [SliverOverlapAbsorber] binding it to the
/// [SliverOverlapAbsorberHandle] from the nearest [NestedScrollView].
/// {@endtemplate}
class DefaultSliverOverlapAbsorber extends StatelessWidget {
  /// {@macro app_ui.default_sliver_overlap_absorber}
  const DefaultSliverOverlapAbsorber({
    super.key,
    this.sliver,
  });

  /// The sliver that will be absorbed by the [SliverOverlapAbsorber].
  final Widget? sliver;

  @override
  Widget build(BuildContext context) {
    return SliverOverlapAbsorber(
      handle: context.sliverOverlapAbsorberHandle,
      sliver: sliver,
    );
  }
}

/// {@template app_ui.default_sliver_overlap_injector}
/// A widget that wraps a [SliverOverlapInjector] binding it to the
/// [SliverOverlapAbsorberHandle] from the nearest [NestedScrollView].
/// {@endtemplate}
class DefaultSliverOverlapInjector extends StatelessWidget {
  /// {@macro app_ui.default_sliver_overlap_injector}
  const DefaultSliverOverlapInjector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverOverlapInjector(
      handle: context.sliverOverlapAbsorberHandle,
    );
  }
}
