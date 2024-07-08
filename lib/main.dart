import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoti_stream_music/pages/mainScreen.dart';
import 'package:spoti_stream_music/pages/playLIstScreen.dart';
import 'package:spoti_stream_music/providers/pageState.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PageState(),
      child: MyApp(),
    ),
  );
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
