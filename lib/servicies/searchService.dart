import 'package:spotify/spotify.dart';
import 'package:spoti_stream_music/models/modelsData.dart' as model;

class SearchService {
  final SpotifyApi _spotifyApi;

  SearchService(String clientId, String clientSecret)
      : _spotifyApi = SpotifyApi(SpotifyApiCredentials(clientId, clientSecret));
  Future<List<model.Track>?> albumsTracks(String albumId) async {
    List<model.Track> ll = [];
    try {
      var tracks = await _spotifyApi.albums.tracks(albumId).all();
      tracks.forEach(
        (element) {
          ll.add(model.Track.fromJson(element.toJson()));
        },
      );

      return ll;
    } catch (e) {
      print('Error fetching album tracks: $e');
      return null;
    }
  }

  Future<List<model.Track>?> playListTrack(String playListId) async {
    try {
      var tracks =
          await _spotifyApi.playlists.getTracksByPlaylistId(playListId).all();
      return tracks.map((e) => model.Track.fromJson(e.toJson())).toList();
    } catch (e) {
      print('Error fetching playlist tracks: $e');
      return null;
    }
  }

  Future<List<Object>> search(String query) async {
    var results = await _spotifyApi.search.get(query).first();

    List<Object> searchResults = [];

    for (var page in results) {
      if (page.items != null) {
        for (var item in page.items!) {
          if (item is PlaylistSimple) {
            searchResults.add(PlaylistSimple.fromJson(item.toJson()));
          } else if (item is Artist) {
            searchResults.add(Artist.fromJson(item.toJson()));
          } else if (item is Track) {
            searchResults.add(Track.fromJson(item.toJson()));
          } else if (item is AlbumSimple) {
            searchResults.add(AlbumSimple.fromJson(item.toJson()));
          }
        }
      }
    }
    return searchResults;
  }
}

class SearchResult {
  final String type;
  final String id;
  final String name;
  final String href;
  final List<Image>? images;
  final Map<String, dynamic> additionalInfo;

  SearchResult({
    required this.type,
    required this.id,
    required this.name,
    required this.href,
    this.images,
    this.additionalInfo = const {},
  });

  @override
  String toString() {
    return 'Type: $type\nID: $id\nName: $name\nHref: $href\nImages: ${images?.length ?? 0}\nAdditional Info: $additionalInfo\n';
  }
}
