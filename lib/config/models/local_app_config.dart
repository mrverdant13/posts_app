import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalAppConfig extends Equatable {
  const LocalAppConfig({
    required this.postsPageSize,
    required this.defaultPostImageAspectRatio,
  });

  final int postsPageSize;
  final double defaultPostImageAspectRatio;

  @override
  List<Object> get props => [postsPageSize, defaultPostImageAspectRatio];
}

extension ContextWithLocalAppConfig on BuildContext {
  LocalAppConfig get localAppConfig => read<LocalAppConfig>();
  int get postsPageSize => localAppConfig.postsPageSize;
  double get defaultPostImageAspectRatio =>
      localAppConfig.defaultPostImageAspectRatio;
}
