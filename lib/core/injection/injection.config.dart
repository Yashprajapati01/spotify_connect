// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

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
import '../../feature/spotify_connect/data/services/gemini_service.dart'
    as _i411;
import '../../feature/spotify_connect/data/services/taste_profile_cache_service.dart'
    as _i248;
import '../../feature/spotify_connect/domain/repositories/spotify.dart'
    as _i225;
import '../../feature/spotify_connect/domain/repositories/spotify_auth_repo.dart'
    as _i399;
import '../../feature/spotify_connect/domain/usecases/analyze_user_taste.dart'
    as _i21;
import '../../feature/spotify_connect/domain/usecases/authenticate_user.dart'
    as _i1044;
import '../../feature/spotify_connect/domain/usecases/create_playlist.dart'
    as _i808;
import '../../feature/spotify_connect/domain/usecases/generate_enhanced_playlist.dart'
    as _i202;
import '../../feature/spotify_connect/domain/usecases/generate_mood_playlist.dart'
    as _i785;
import '../../feature/spotify_connect/domain/usecases/get_user_playlist.dart'
    as _i875;
import '../../feature/spotify_connect/domain/usecases/get_user_profile.dart'
    as _i665;
import '../../feature/spotify_connect/domain/usecases/launch_spotify.dart'
    as _i980;
import '../../feature/spotify_connect/domain/usecases/save_generated_playlist.dart'
    as _i185;
import '../../feature/spotify_connect/presentation/bloc/auth/auth_bloc.dart'
    as _i484;
import '../../feature/spotify_connect/presentation/bloc/explore_mode/explore_mode_bloc.dart'
    as _i22;
import '../../feature/spotify_connect/presentation/bloc/playlist_generation/playlist_generation_bloc.dart'
    as _i127;
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
    gh.factory<_i185.SaveGeneratedPlaylist>(
      () => _i185.SaveGeneratedPlaylist(),
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => registerModule.storage);
    gh.lazySingleton<_i411.GeminiService>(
      () => _i411.GeminiServiceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i375.SpotifyAuthRemoteDataSource>(
      () => _i375.SpotifyAuthRemoteDataSourceImpl(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i361.Dio>(),
      ),
    );
    gh.lazySingleton<_i298.SpotifyDataSource>(
      () => _i298.SpotifyDataSourceImpl(
        gh<_i361.Dio>(),
        gh<_i558.FlutterSecureStorage>(),
        gh<_i375.SpotifyAuthRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1050.SpotifyPlaylistRemoteDataSource>(
      () => _i1050.SpotifyPlaylistRemoteDataSourceImpl(
        gh<_i361.Dio>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i225.SpotifyRepository>(
      () => _i1000.SpotifyRepositoryImpl(gh<_i298.SpotifyDataSource>()),
    );
    gh.factory<_i808.CreateSpotifyPlaylist>(
      () => _i808.CreateSpotifyPlaylist(gh<_i225.SpotifyRepository>()),
    );
    gh.factory<_i21.AnalyzeUserTaste>(
      () => _i21.AnalyzeUserTaste(gh<_i225.SpotifyRepository>()),
    );
    gh.factory<_i202.GenerateEnhancedPlaylist>(
      () => _i202.GenerateEnhancedPlaylist(gh<_i225.SpotifyRepository>()),
    );
    gh.factory<_i248.TasteProfileCacheService>(
      () => _i248.TasteProfileCacheService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i875.GetUserPlaylists>(
      () => _i875.GetUserPlaylists(gh<_i225.SpotifyRepository>()),
    );
    gh.factory<_i665.GetUserProfile>(
      () => _i665.GetUserProfile(gh<_i225.SpotifyRepository>()),
    );
    gh.lazySingleton<_i399.SpotifyAuthRepository>(
      () => _i836.SpotifyAuthRepositoryImpl(
        gh<_i375.SpotifyAuthRemoteDataSource>(),
      ),
    );
    gh.factory<_i785.GenerateMoodPlaylist>(
      () => _i785.GenerateMoodPlaylist(
        gh<_i225.SpotifyRepository>(),
        gh<_i411.GeminiService>(),
      ),
    );
    gh.factory<_i1066.PlaylistBloc>(
      () => _i1066.PlaylistBloc(
        gh<_i665.GetUserProfile>(),
        gh<_i875.GetUserPlaylists>(),
      ),
    );
    gh.factory<_i22.ExploreModeBloc>(
      () => _i22.ExploreModeBloc(
        gh<_i21.AnalyzeUserTaste>(),
        gh<_i202.GenerateEnhancedPlaylist>(),
        gh<_i808.CreateSpotifyPlaylist>(),
        gh<_i875.GetUserPlaylists>(),
        gh<_i248.TasteProfileCacheService>(),
      ),
    );
    gh.factory<_i127.PlaylistGenerationBloc>(
      () => _i127.PlaylistGenerationBloc(
        gh<_i785.GenerateMoodPlaylist>(),
        gh<_i808.CreateSpotifyPlaylist>(),
        gh<_i21.AnalyzeUserTaste>(),
        gh<_i202.GenerateEnhancedPlaylist>(),
        gh<_i875.GetUserPlaylists>(),
      ),
    );
    gh.factory<_i1044.AuthenticateUserWithCode>(
      () => _i1044.AuthenticateUserWithCode(gh<_i399.SpotifyAuthRepository>()),
    );
    gh.factory<_i980.LaunchSpotifyAuth>(
      () => _i980.LaunchSpotifyAuth(gh<_i399.SpotifyAuthRepository>()),
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
