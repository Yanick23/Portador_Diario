import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:spotify/spotify.dart';

class SearchService {
  Future<void> aaa() async {
    var keyJson = await File('example/.apikeys').readAsString();
    var keyMap = json.decode(keyJson);

    var credentials = SpotifyApiCredentials(keyMap['id'], keyMap['secret']);
    var spotify = SpotifyApi(credentials);

    print("\nSearching for 'Metallica':");
    var search = await spotify.search.get('metallica').first();

    for (var pages in search) {
      if (pages.items == null) {
        print('Empty items');
      }

      for (var item in pages.items!) {
        if (item is PlaylistSimple) {
          print('Playlist: \n'
              'id: ${item.id}\n'
              'name: ${item.name}:\n'
              'collaborative: ${item.collaborative}\n'
              'href: ${item.href}\n'
              'trackslink: ${item.tracksLink!.href}\n'
              'owner: ${item.owner}\n'
              'public: ${item.owner}\n'
              'snapshotId: ${item.snapshotId}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              'images: ${item.images!.length}\n'
              '-------------------------------');
        }
        if (item is Artist) {
          print('Artist: \n'
              'id: ${item.id}\n'
              'name: ${item.name}\n'
              'href: ${item.href}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              'popularity: ${item.popularity}\n'
              '-------------------------------');
        }
        if (item is Track) {
          print('Track:\n'
              'id: ${item.id}\n'
              'name: ${item.name}\n'
              'href: ${item.href}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              'isPlayable: ${item.isPlayable}\n'
              'artists: ${item.artists!.length}\n'
              'availableMarkets: ${item.availableMarkets!.length}\n'
              'discNumber: ${item.discNumber}\n'
              'trackNumber: ${item.trackNumber}\n'
              'explicit: ${item.explicit}\n'
              'popularity: ${item.popularity}\n'
              '-------------------------------');
        }
        if (item is AlbumSimple) {
          print('Album:\n'
              'id: ${item.id}\n'
              'name: ${item.name}\n'
              'href: ${item.href}\n'
              'type: ${item.type}\n'
              'uri: ${item.uri}\n'
              'albumType: ${item.albumType}\n'
              'artists: ${item.artists!.length}\n'
              'availableMarkets: ${item.availableMarkets!.length}\n'
              'images: ${item.images!.length}\n'
              'releaseDate: ${item.releaseDate}\n'
              'releaseDatePrecision: ${item.releaseDatePrecision}\n'
              '-------------------------------');
        }
      }
    }
  }
}
