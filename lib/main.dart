import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/key_player_cubit.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/play_music_bar_cubit.dart';
import 'package:melody_player/features/home/presentation/bloc/page_cubit.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/audio_player_cubit.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/artist_cubit.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/current_index_cubit.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/type_reproducer_cubit.dart';
import 'package:melody_player/features/audio_player/presentation/bloc/image_playlist_and_album_cubit.dart';
import 'package:melody_player/features/home/presentation/pages/main_layout.dart';
import 'package:melody_player/features/search/presentation/pages/playLIstScreen.dart';

import 'package:melody_player/core/services/service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ArtistCubit()),
        BlocProvider(create: (_) => KeyPlayerCubit()),
        BlocProvider(create: (_) => PageCubit()),
        BlocProvider(create: (_) => AudioPlayerCubit()),
        BlocProvider(create: (_) => CurrentIndexCubit()),
        BlocProvider(create: (_) => PlayMusicBarCubit()),
        BlocProvider(create: (_) => ImagePlayListAndAlbumCubit()),
        // ImagePlayListAndAlbumstate not needed or to be added if needed
        BlocProvider(create: (_) => TypeReproducerCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Melody Player',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const MainLayout(),
        "/playlist": (context) => const Playlistscreen()
      },
    );
  }
}
