import 'package:get_it/get_it.dart';
import 'package:melody_player/core/config/app_config.dart';
import 'package:melody_player/features/audio_player/data/data_sources/trackService.dart';
import 'package:melody_player/features/home/data/data_sources/ArtistService.dart';
import 'package:melody_player/features/search/data/data_sources/searchService.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => SearchService(
        AppConfig.spotifyClientId,
        AppConfig.spotifyClientSecret,
      ));

  // Data sources
  sl.registerLazySingleton(() => ArtistService());
  sl.registerLazySingleton(() => TrackService());

  // Features - Audio Player
  // Bloc
  // Use cases
  // Repository

  // Features - Home
  // ...

  // Core
  // ...
}

