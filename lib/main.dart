import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoti_stream_music/pages/mainScreen.dart';
import 'package:spoti_stream_music/pages/playLIstScreen.dart';
import 'package:spoti_stream_music/providers/currentIndexMusicState.dart';
import 'package:spoti_stream_music/providers/pageState.dart';
import 'package:spoti_stream_music/providers/playListState.dart';
import 'package:spoti_stream_music/providers/playMusicBarState.dart';

void main() {
  runApp(MultiProvider(
    providers: [
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
