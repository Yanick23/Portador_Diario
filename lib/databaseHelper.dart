import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'spotify.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Album (
        id TEXT PRIMARY KEY,
        name TEXT,
        album_type TEXT,
        href TEXT,
        release_date TEXT,
        release_date TEXT,
        release_date_precision TEXT,
        total_tracks INTEGER,
        type TEXT,
        imgPath,
        uri TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Track (
        id TEXT PRIMARY KEY,
        name TEXT,
        album_id TEXT,
        disc_number INTEGER,
        duration_ms INTEGER,
        explicit INTEGER,
        href TEXT,
        is_local INTEGER,
        popularity INTEGER,
        preview_url TEXT,
        track_number INTEGER,
        imgPath,
        type TEXT,
        uri TEXT,
        FOREIGN KEY(album_id) REFERENCES Album(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Artist (
        id TEXT PRIMARY KEY,
        name TEXT,
        href TEXT,
        type TEXT,
        uri TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Playlist (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        collaborative INTEGER,
        public INTEGER,
        snapshot_id TEXT,
        type TEXT,
        uri TEXT,
        primary_color TEXT,
        owner_id TEXT,
        FOREIGN KEY(owner_id) REFERENCES Owner(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE MusicArtist (
        music_id TEXT,
        artist_id TEXT,
        PRIMARY KEY (music_id, artist_id),
        FOREIGN KEY(music_id) REFERENCES Track(id),
        FOREIGN KEY(artist_id) REFERENCES Artist(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE PlaylistTrack (
        track_id TEXT,
        playlist_id TEXT,
        PRIMARY KEY (track_id, playlist_id),
        FOREIGN KEY(track_id) REFERENCES Track(id),
        FOREIGN KEY(playlist_id) REFERENCES Playlist(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ExternalUrls (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        spotify TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Image (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT,
        height INTEGER,
        width INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE ExternalIds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        isrc TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Followers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE Owner (
        id TEXT PRIMARY KEY,
        display_name TEXT,
        href TEXT,
        type TEXT,
        uri TEXT
      )
    ''');
  }
}
