import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injection/injection.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/playlist_selection/playlist_selection_bloc.dart';
import '../bloc/playlist_selection/playlist_selection_event.dart';
import '../bloc/playlist_selection/playlist_selection_state.dart';
import '../widgets/playlist_list.dart';
import '../widgets/user_profile_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PlaylistBloc>()..add(LoadUserData()),
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Playlists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LoggedOut());
            },
          ),
        ],
      ),
      body: BlocBuilder<PlaylistBloc, PlaylistState>(
        builder: (context, state) {
          if (state is PlaylistLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlaylistError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PlaylistBloc>().add(RefreshPlaylists());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is PlaylistLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PlaylistBloc>().add(RefreshPlaylists());
              },
              child: Column(
                children: [
                  // User Profile Header
                  UserProfileHeader(userProfile: state.userProfile),
                  // Playlists List
                  Expanded(child: PlaylistsList(playlists: state.playlists)),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}