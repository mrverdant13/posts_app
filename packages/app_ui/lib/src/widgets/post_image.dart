import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// {@template app_ui.post_image}
/// A widget that displays a post image.
/// {@endtemplate}
class PostImage extends StatelessWidget {
  /// {@macro app_ui.post_image}
  PostImage({
    required this.aspectRatio,
    required String imageUrl,
    VoidCallback? onTap,
    super.key,
  }) : data = AvailablePostImageData(imageUrl: imageUrl, onTap: onTap);

  const PostImage._({
    required this.aspectRatio,
    required this.data,
    super.key,
  });

  /// {@macro app_ui.skeleton_post_image}
  const factory PostImage.skeleton({
    required double aspectRatio,
    Key? key,
  }) = SkeletonPostImage;

  /// {@macro app_ui.errored_post_image}
  factory PostImage.errored({
    required double aspectRatio,
    WidgetBuilder builder,
    Key? key,
  }) = ErroredPostImage;

  /// The aspect ratio of the image.
  final double aspectRatio;

  /// The image data.
  final PostImageData data;

  /// The internal transition duration.
  static const transitionDuration = Duration(milliseconds: 500);

  /// The internal placeholder.
  static const placeholder = Skeletonizer(
    child: Skeleton.leaf(
      child: ColoredBox(
        color: AppColors.grey,
        child: SizedBox.expand(),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: transitionDuration,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: AnimatedSwitcher(
          duration: transitionDuration,
          child: switch (data) {
            SkeletonPostImageData() => const KeyedSubtree(
                key: ValueKey('<app_ui.posts.post-image.skeleton>'),
                child: placeholder,
              ),
            AvailablePostImageData(:final imageUrl, :final onTap) =>
              CachedNetworkImage(
                key: ValueKey('<app_ui.posts.post-image.available.$imageUrl>'),
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                fadeOutDuration: transitionDuration,
                placeholderFadeInDuration: transitionDuration,
                placeholder: (context, url) => placeholder,
                imageBuilder: (context, imageProvider) => Material(
                  child: Ink.image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    child: InkWell(
                      splashColor: AppColors.opaqueWhite,
                      highlightColor: AppColors.opaqueWhite,
                      onTap: onTap,
                    ),
                  ),
                ),
                cacheManager: InheritedImagesCacheManager.maybeOf(context),
              ),
            ErroredPostImageData(:final builder) => KeyedSubtree(
                key: const ValueKey('<app_ui.posts.post-image.errored>'),
                child: builder(context),
              ),
          },
        ),
      ),
    );
  }
}

/// {@template app_ui.skeleton_post_image}
/// A skeleton [PostImage].
/// {@endtemplate}
class SkeletonPostImage extends PostImage {
  /// {@macro app_ui.skeleton_post_image}
  const SkeletonPostImage({
    required super.aspectRatio,
    super.key,
  }) : super._(
          data: const SkeletonPostImageData(),
        );
}

/// {@template app_ui.errored_post_image}
/// An errored [PostImage].
/// {@endtemplate}
class ErroredPostImage extends PostImage {
  /// {@macro app_ui.errored_post_image}
  ErroredPostImage({
    required super.aspectRatio,
    WidgetBuilder builder = defaultErrorBuilder,
    super.key,
  }) : super._(
          data: ErroredPostImageData(
            builder: builder,
          ),
        );

  /// The default error builder.
  static Widget defaultErrorBuilder(BuildContext context) {
    return ColoredBox(
      color: context.colorScheme.error.withOpacity(0.2),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: context.colorScheme.error,
        ),
      ),
    );
  }
}

/// {@template app_ui.post_image_data}
/// The data for a [PostImage].
/// {@endtemplate}
sealed class PostImageData extends Equatable {
  /// {@macro app_ui.post_image_data}
  const PostImageData();
}

/// {@template app_ui.skeleton_post_image_data}
/// The data for a [PostImage] that is a skeleton.
/// {@endtemplate}
class SkeletonPostImageData extends PostImageData {
  /// {@macro app_ui.skeleton_post_image_data}
  const SkeletonPostImageData();

  @override
  List<Object> get props => [];
}

/// {@template app_ui.available_post_image_data}
/// The data for a [PostImage] that is available.
/// {@endtemplate}
class AvailablePostImageData extends PostImageData {
  /// {@macro app_ui.available_post_image_data}
  const AvailablePostImageData({
    required this.imageUrl,
    this.onTap,
  });

  /// The image URL.
  final String imageUrl;

  /// The action to take when the image is tapped.
  final VoidCallback? onTap;

  @override
  List<Object?> get props => [imageUrl, onTap];
}

/// {@template app_ui.errored_post_image_data}
/// The data for a [PostImage] that has errored.
/// {@endtemplate}
class ErroredPostImageData extends PostImageData {
  /// {@macro app_ui.errored_post_image_data}
  const ErroredPostImageData({
    required this.builder,
  });

  /// The builder for the errored state.
  final WidgetBuilder builder;

  @override
  List<Object> get props => [builder];
}
