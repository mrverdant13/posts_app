import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template posts_api.image_data}
/// Image data.
/// {@endtemplate}
@immutable
class ImageData extends Equatable {
  /// {@macro posts_api.image_data}
  const ImageData({
    required this.url,
    required this.width,
    required this.height,
  });

  /// The image URL.
  final String url;

  /// The image width.
  final int width;

  /// The image height.
  final int height;

  /// The aspect ratio of the image.
  double get aspectRatio => width / height;

  @override
  List<Object> get props => [url, width, height];
}
