import 'package:spotify/spotify.dart';
import 'package:spoti_stream_music/models/modelsData.dart' as model;

class SearchService {
  final SpotifyApi _spotifyApi;

  SearchService(String clientId, String clientSecret)
      : _spotifyApi = SpotifyApi(SpotifyApiCredentials(clientId, clientSecret));
  Future<List<Track>?> albumsTracks(String albumId, Album album) async {
    try {
      var tracks = await _spotifyApi.albums.tracks(albumId).all();

      List<Track> trackList = tracks.map((element) {
        Track track = Track.fromJson(element.toJson());

        track.album ??= Album();
        track.album!.images ??= [];

        track.album!.images!.add(album.images!.first);

        return track;
      }).toList();

      return trackList;
    } catch (e) {
      print('Error fetching album tracks: $e');
      return null;
    }
  }

  Future<List<Track>?> getTrack(String trackId) async {
    List<Track> ll = [];
    try {
      var track = await _spotifyApi.tracks.get(trackId);

      ll.add(Track.fromJson(track.toJson()));

      return ll;
    } catch (e) {
      print('Error fetching album tracks: $e');
      return null;
    }
  }

  Future<List<Artist>?> getArtistRelated(String IdArtist) async {
    List<Artist> ll = [];
    try {
      var tracks = await _spotifyApi.artists.relatedArtists(IdArtist);
      tracks.forEach(
        (element) {
          print(element.name);
          ll.add(Artist.fromJson(element.toJson()));
        },
      );

      return ll;
    } catch (e) {
      print('Error fetching album tracks: $e');
      return null;
    }
  }

  Future<List<Album>?> Discografia(String idArtist, List<String> lista) async {
    List<Album> ll = [];

    var tracks = await _spotifyApi.artists.albums(
      idArtist,
      country: Market.MZ,
      includeGroups: lista,
    );

    await tracks.all().then(
      (value) {
        value.forEach(
          (element) {
            ll.add(element);
          },
        );
      },
    );
    DateTime parseDate(String date) {
      if (date.length == 4) {
        date = "$date-01-01";
      } else if (date.length == 7) {
        date = "$date-01";
      }
      return DateTime.parse(date);
    }

    ll.sort((a, b) =>
        parseDate(b.releaseDate!).compareTo(parseDate(a.releaseDate!)));

    return ll;
  }

  Future<List<PlaylistSimple>> PlayListArtist(String query) async {
    List<PlaylistSimple> searchResults = [];

    try {
      var results = await _spotifyApi.search
          .get(query, types: [SearchType.playlist]).first();

      for (var page in results) {
        if (page.items != null) {
          for (var item in page.items!) {
            if (item is PlaylistSimple) {
              searchResults.add(item);
            }
          }
        }
      }
    } catch (e) {
      print('Erro ao buscar playlists: $e');
    }

    return searchResults;
  }

  Future<List<Track>?> top10TrackArtist(String idArtist) async {
    List<Track> ll = [];

    var tracks = await _spotifyApi.artists.topTracks(idArtist, Market.MZ);
    tracks.forEach(
      (element) {
        ll.add(Track.fromJson(element.toJson()));
      },
    );

    return ll;
  }

  Future<List<Track>?> playListTrack(String playListId) async {
    try {
      var tracks =
          await _spotifyApi.playlists.getTracksByPlaylistId(playListId).all();
      return tracks.map((e) => Track.fromJson(e.toJson())).toList();
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
