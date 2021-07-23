import 'package:flutter/material.dart';
import 'package:pirosfogo/helpers/DBHelper.dart';
import 'package:pirosfogo/helpers/Formatter.dart';
import 'package:pirosfogo/model/Game.dart';

import 'GameScreen.dart';

class LoadGameScreen extends StatefulWidget {
  @override
  _LoadGameScreenState createState() => _LoadGameScreenState();
}

class _LoadGameScreenState extends State<LoadGameScreen> {
  List<Game>? games;

  @override
  void initState() {
    super.initState();
    DBHelper.getGames().then((games) => setState(() {
          this.games = games;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pirosfogó"),
        centerTitle: true,
      ),
      body: games == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: games!.length,
              itemBuilder: (ctx, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        Game game = games!.removeAt(i);
                        DBHelper.deleteGame(game.gameID);
                      });
                    },
                    child: ElevatedButton(
                      onPressed: () => _loadGame(context, i),
                      child: Text(
                        Formatter.date(
                            games![i].dateTime, "yyyy MMM dd - hh:mm:ss"),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  _loadGame(BuildContext ctx, int listIndex) {
    if (games == null) return; //TODO: proper error check here
    int gameID = games![listIndex].gameID;
    DBHelper.getPlayers(gameID).then((players) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(gameID, players),
        ),
      );
    });
  }
}
