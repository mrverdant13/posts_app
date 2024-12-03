import 'package:file/local.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mocktail/mocktail.dart';

@visibleForTesting
class FakeCacheManager extends Fake implements BaseCacheManager {
  FakeCacheManager({
    required this.fixturePath,
  });

  factory FakeCacheManager.generic() {
    return FakeCacheManager(
      fixturePath: 'test/helpers/fixtures/test-image.jpg',
    );
  }

  final String fixturePath;

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool? withProgress,
  }) async* {
    final file = const LocalFileSystem().file(fixturePath);
    yield FileInfo(
      file,
      FileSource.Online,
      DateTime(2050),
      url,
    );
  }
}
