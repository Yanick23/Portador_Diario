import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoti_stream_music/pages/mainScreen.dart';
import 'package:spoti_stream_music/pages/playLIstScreen.dart';
import 'package:spoti_stream_music/providers/artistsProvider.dart';
import 'package:spoti_stream_music/providers/audioPlayerProvider.dart';
import 'package:spoti_stream_music/providers/currentIndexMusicState.dart';
import 'package:spoti_stream_music/providers/imagePlayListAndAlbumState.dart';
import 'package:spoti_stream_music/providers/pageState.dart';
import 'package:spoti_stream_music/providers/playListState.dart';
import 'package:spoti_stream_music/providers/playMusicBarState.dart';
import 'package:spoti_stream_music/providers/typeReproducer.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ArtistProvider()),
      ChangeNotifierProvider(
        create: (context) => PageState(),
      ),
      ChangeNotifierProvider(
        create: (context) => PlaylistState(),
      ),
      ChangeNotifierProvider(
        create: (context) => CurrentIndexMusicState(),
      ),
      ChangeNotifierProvider(
        create: (context) => PlayMusicBarState(),
      ),
      ChangeNotifierProvider(
        create: (context) => ImagePlayListAndAlbumstate(),
      ),
      ChangeNotifierProvider(
        create: (context) => TypereproducerState(),
      ),
      ChangeNotifierProvider(
        create: (context) => AudioPLayerProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: const ColorScheme.dark()),
      initialRoute: "/",
      routes: {
        "/": (context) => const MainScreen(),
        "/playlist": (context) => const Playlistscreen()
      },
    );
  }
}
