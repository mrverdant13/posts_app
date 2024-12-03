import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_posts_api/dio_posts_api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/config/config.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final dio = Dio(
    BaseOptions(
      // ignore: avoid_redundant_argument_values
      baseUrl: mainRestApiBaseUrl,
      contentType: 'application/json',
    ),
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LocalAppConfig>(
          create: (_) => const LocalAppConfig(
            postsPageSize: 10,
            defaultPostImageAspectRatio: 3,
          ),
        ),
        RepositoryProvider<PostsApi>(
          create: (_) => DioPostsApi(
            dio: dio,
            postsImagesBaseUrl: postsImagesBaseUrl,
          ),
        ),
      ],
      child: await builder(),
    ),
  );
}
