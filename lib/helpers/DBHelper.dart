import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:pirosfogo/helpers/Formatter.dart';
import 'package:pirosfogo/model/Game.dart';
import 'package:pirosfogo/model/Player.dart';
import 'package:pirosfogo/model/Profile.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static late Database _db;
  static String _dbName = "pirosfogo.db";

  static Future<void> init() async {
    var path = join(await getDatabasesPath(), _dbName);

    // Check if the database exists
    bool exists = await databaseExists(path);
    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", _dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
  }

  static Future<void> openDB() async {
    _db = await openDatabase(join(await getDatabasesPath(), _dbName),
        readOnly: false, onConfigure: _onConfigure);
  }

  static _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  static Future<int> newGame(int playerCount) async {
    String dateTime = Formatter.date(DateTime.now(), "yyyyMMddhhmmsseee");
    int gameID = await _db.insert("games", {"date_time": dateTime});
    for (var i = 0; i < playerCount; i++) {
      await _db.insert("places", {
        "game_id": gameID,
        "player_id": null,
        "place_id": i,
      });
    }
    return gameID;
  }

  static Future<List<Game>> getGames() async {
    List<Map> resultMaps = await _db.query(
      "games",
      columns: ["game_id", "date_time"],
      orderBy: "date_time DESC",
    );
    return List.generate(
      resultMaps.length,
      (i) => Game(
        gameID: resultMaps[i]["game_id"],
        dateTime: Formatter.parseDate(resultMaps[i]["date_time"]),
      ),
    );
  }

  static Future<Profile> createProfile(String name, String imageUri) async {
    int profileID =
        await _db.insert("players", {"name": name, "img_uri": imageUri});
    return Profile(profileID, name, imageUri);
  }

  static Future<Profile> getProfile(int profileID) async {
    List<Map> resultMaps = await _db.query(
      "players",
      columns: ["name", "image_uri"],
      where: "player_id = ?",
      whereArgs: [profileID],
    );
    if (resultMaps.length <= 0) {
      //TODO handle error
    }
    return Profile(
      profileID,
      resultMaps[0]["name"],
      resultMaps[0]["image_uri"],
    );
  }

  static Future<void> updatePlayer(
      int playerID, String name, String? imageUri) async {
    await _db.update(
      "players",
      {
        "name": name,
        "img_uri": imageUri,
      },
      where: "player_id = ?",
      whereArgs: [playerID],
    );
  }

  static Future<void> deletePlayer(int playerID) async {
    //TODO: replace all occurences with null
    await _db.update(
      "places",
      {"player_id": null},
      where: "player_id = ?",
      whereArgs: [playerID],
    );
    await _db.delete(
      "players",
      where: "player_id = ?",
      whereArgs: [playerID],
    );
  }

  static Future<void> deleteGame(int gameID) async {
    await _db.delete(
      "scores",
      where: "game_id = ?",
      whereArgs: [gameID],
    );
    await _db.delete(
      "places",
      where: "game_id = ?",
      whereArgs: [gameID],
    );
    await _db.delete(
      "games",
      where: "game_id = ?",
      whereArgs: [gameID],
    );
  }

  static Future<List<Profile>> getAllProfiles({List<Profile>? except}) async {
    if (except == null) except = const [];
    List<Map> resultMaps = await _db.query(
      "players",
      columns: ["player_id", "name", "img_uri"],
    );
    List<Profile> profiles = List.generate(
      resultMaps.length,
      (i) => Profile(
        resultMaps[i]["player_id"],
        resultMaps[i]["name"],
        resultMaps[i]["img_uri"],
      ),
    );

    profiles.removeWhere((profile) => except!
        .where((exception) => profile.profileID == exception.profileID)
        .isNotEmpty);
    return profiles;
  }

  static Future<List<Player>> getPlayers(int gameID) async {
    List<Map> resultMaps = await _db.query(
      "places LEFT OUTER JOIN players ON places.player_id = players.player_id",
      columns: [
        "players.player_id",
        "place_id",
        "name",
        "img_uri",
      ],
      where: "game_id = ?",
      whereArgs: [gameID],
      orderBy: "place_id",
    );

    List<List<Map>> scores = [];

    for (var i = 0; i < resultMaps.length; i++) {
      scores.add(await _db.query(
        "scores",
        columns: ["score"],
        where: "game_id = ? AND place_id = ?",
        whereArgs: [gameID, resultMaps[i]["place_id"]],
        orderBy: "row_id",
      ));
    }

    return List.generate(
      resultMaps.length,
      (i) {
        int? playerID = resultMaps[i]["player_id"];
        return Player(
          playerID == null
              ? null
              : Profile(
                  resultMaps[i]["player_id"],
                  resultMaps[i]["name"],
                  resultMaps[i]["img_uri"],
                ),
          resultMaps[i]["place_id"],
          List.generate(scores[i].length, (j) => scores[i][j]["score"]),
        );
      },
    );
  }

  static Future<Player> getPlayer(int gameID, int placeID) async {
    List<Map> resultMaps = await _db.query(
      "places LEFT OUTER JOIN players ON places.player_id = players.player_id",
      columns: [
        "players.player_id",
        "place_id",
        "name",
        "img_uri",
      ],
      where: "game_id = ? AND place_id = ?",
      whereArgs: [gameID, placeID],
      orderBy: "place_id",
    );

    if (resultMaps.length < 0) {
      //TODO: proper error handling
    }

    List<Map> scores = await _db.query(
      "scores",
      columns: ["score"],
      where: "game_id = ? AND place_id = ?",
      whereArgs: [gameID, resultMaps[0]["place_id"]],
      orderBy: "row_id",
    );

    return Player(
      resultMaps[0]["player_id"] == null
          ? null
          : Profile(
              resultMaps[0]["player_id"],
              resultMaps[0]["name"],
              resultMaps[0]["img_uri"],
            ),
      resultMaps[0]["place_id"],
      List.generate(scores.length, (i) => scores[i]["score"]),
    );
  }

  static Future<void> addScore(int gameID, int placeID, int score) async {
    List<Map> resultMaps = await _db.query(
      "scores",
      columns: ["row_id"],
      where: "game_id = ? AND place_id = ?",
      whereArgs: [gameID, placeID],
      orderBy: "row_id DESC LIMIT 1",
    );
    int rowID = -1;
    if (resultMaps.length > 0) {
      rowID = resultMaps[0]["row_id"];
    }
    await _db.insert("scores", {
      "game_id": gameID,
      "place_id": placeID,
      "score": score,
      "row_id": rowID + 1,
    });
  }

  static Future<Player> updatePlace(
      int gameID, int placeID, int? playerID) async {
    await _db.update(
      "places",
      {
        "player_id": playerID,
      },
      where: "game_id = ? AND place_id = ?",
      whereArgs: [gameID, placeID],
    );

    return await getPlayer(gameID, placeID);
  }
}
