import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// {@template app_ui.inherited_images_cache_manager}
/// A [InheritedWidget] that passes a [BaseCacheManager] down the widget tree.
/// {@endtemplate}
class InheritedImagesCacheManager extends InheritedWidget {
  /// {@macro app_ui.inherited_images_cache_manager}
  const InheritedImagesCacheManager({
    required this.cacheManager,
    required super.child,
    super.key,
  });

  /// The [BaseCacheManager] to provide to the widget tree.
  final BaseCacheManager cacheManager;

  /// Returns the [BaseCacheManager] from the closest
  /// [InheritedImagesCacheManager], if any. If there is no
  /// [InheritedImagesCacheManager] in the widget tree, `null` is returned.
  static BaseCacheManager? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedImagesCacheManager>()
        ?.cacheManager;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return cacheManager !=
        (oldWidget as InheritedImagesCacheManager).cacheManager;
  }
}
