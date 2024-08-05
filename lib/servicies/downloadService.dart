import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spoti_stream_music/databaseHelper.dart';
import 'package:spotify/spotify.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class Downloadservice {
  Future<void> startDownload(
      String url, String fileName, Track track, Album album) async {
    try {
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: (await getApplicationDocumentsDirectory()).path,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
        headers: {},
      );

      await _saveDownloadProgress(taskId!, 0);

      FlutterDownloader.registerCallback((id, status, progress) async {
        if (status == DownloadTaskStatus.complete) {
          await saveAlbum(album);
          await saveArtist(track!.artists!.first);
          await _addTrackToDatabase(track, fileName);
        } else if (status == DownloadTaskStatus.failed) {
          print('Download failed for task: $id');
        } else {
          await _saveDownloadProgress(id, progress);
        }
      });
    } catch (e) {
      print("Error starting download: $e");
    }
  }

  Future<void> _saveDownloadProgress(String taskId, int progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(taskId, progress);
  }

  Future<int?> _getDownloadProgress(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(taskId);
  }

  Future<void> _addTrackToDatabase(Track track, String filePath) async {
    track.href = filePath;
    final db = await DatabaseHelper().database;

    try {
      await db.insert(
        'Track',
        track.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error saving track to database: $e");
    }
  }

  Future<void> saveArtist(Artist artist) async {
    final db = await DatabaseHelper().database;
    try {
      final result = await db.query(
        'Artist',
        where: 'id = ?',
        whereArgs: [artist.id],
      );

      if (result.isEmpty) {
        await db.insert(
          'Artist',
          artist.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        print('Artista já existe na base de dados');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveAlbum(AlbumSimple album) async {
    final db = await DatabaseHelper().database;

    try {
      await db.insert(
        'Album',
        album.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
  }
}
