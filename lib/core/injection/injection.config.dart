// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../feature/spotify_connect/data/datasources/spotify_auth_remote_data_source.dart'
    as _i375;
import '../../feature/spotify_connect/data/datasources/spotify_data_source.dart'
    as _i298;
import '../../feature/spotify_connect/data/datasources/spotify_playlist_remote_data_source.dart'
    as _i1050;
import '../../feature/spotify_connect/data/repositores/spotify_impl.dart'
    as _i1000;
import '../../feature/spotify_connect/data/repositores/spotify_repo_impl.dart'
    as _i836;
import '../../feature/spotify_connect/domain/repositories/spotify.dart'
    as _i225;
import '../../feature/spotify_connect/domain/repositories/spotify_auth_repo.dart'
    as _i399;
import '../../feature/spotify_connect/domain/usecases/authenticate_user.dart'
    as _i1044;
import '../../feature/spotify_connect/domain/usecases/get_user_playlist.dart'
    as _i875;
import '../../feature/spotify_connect/domain/usecases/get_user_profile.dart'
    as _i665;
import '../../feature/spotify_connect/domain/usecases/launch_spotify.dart'
    as _i980;
import '../../feature/spotify_connect/presentation/bloc/auth/auth_bloc.dart'
    as _i484;
import '../../feature/spotify_connect/presentation/bloc/playlist_selection/playlist_selection_bloc.dart'
    as _i1066;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => registerModule.storage);
    gh.lazySingleton<_i375.SpotifyAuthRemoteDataSource>(
      () => _i375.SpotifyAuthRemoteDataSourceImpl(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i361.Dio>(),
      ),
    );
    gh.lazySingleton<_i1050.SpotifyPlaylistRemoteDataSource>(
      () => _i1050.SpotifyPlaylistRemoteDataSourceImpl(
        gh<_i361.Dio>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i298.SpotifyDataSource>(
      () => _i298.SpotifyDataSourceImpl(
        gh<_i361.Dio>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i399.SpotifyAuthRepository>(
      () => _i836.SpotifyAuthRepositoryImpl(
        gh<_i375.SpotifyAuthRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i225.SpotifyRepository>(
      () => _i1000.SpotifyRepositoryImpl(gh<_i298.SpotifyDataSource>()),
    );
    gh.factory<_i875.GetUserPlaylists>(
      () => _i875.GetUserPlaylists(gh<_i225.SpotifyRepository>()),
    );
    gh.factory<_i665.GetUserProfile>(
      () => _i665.GetUserProfile(gh<_i225.SpotifyRepository>()),
    );
    gh.factory<_i1044.AuthenticateUserWithCode>(
      () => _i1044.AuthenticateUserWithCode(gh<_i399.SpotifyAuthRepository>()),
    );
    gh.factory<_i980.LaunchSpotifyAuth>(
      () => _i980.LaunchSpotifyAuth(gh<_i399.SpotifyAuthRepository>()),
    );
    gh.factory<_i1066.PlaylistBloc>(
      () => _i1066.PlaylistBloc(
        gh<_i665.GetUserProfile>(),
        gh<_i875.GetUserPlaylists>(),
      ),
    );
    gh.factory<_i484.AuthBloc>(
      () => _i484.AuthBloc(
        gh<_i980.LaunchSpotifyAuth>(),
        gh<_i1044.AuthenticateUserWithCode>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i464.RegisterModule {}
