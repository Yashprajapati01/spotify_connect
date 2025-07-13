import 'package:connectspotify/core/injection/injection.config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

/// Call this in `main()`
@InjectableInit(initializerName: 'init', preferRelativeImports: true)
void configureDependencies() => getIt.init();

/// All module-level singletons
@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  FlutterSecureStorage get storage => const FlutterSecureStorage();
}
