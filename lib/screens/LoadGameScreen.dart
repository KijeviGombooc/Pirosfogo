import 'package:flutter/material.dart';
import 'package:pirosfogo/helpers/DBHelper.dart';
import 'package:pirosfogo/helpers/Formatter.dart';
import 'package:pirosfogo/main.dart';
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
        title: Text("Load Game"),
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
                    onDismissed: (direction) => _onDismissed(context, i),
                    confirmDismiss: (direction) =>
                        _showConfirmationDialog(context),
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

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Do you want to delete this item?",
            style: TextStyle(fontSize: 24),
          ),
          backgroundColor: MyApp.primaryColor,
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(
                    Size(double.infinity, double.infinity)),
              ),
            ),
            ElevatedButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.pop(context, false);
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(
                    Size(double.infinity, double.infinity)),
              ),
            ),
          ],
        );
      },
    );
  }

  _onDismissed(BuildContext context, int listIndex) {
    setState(() {
      Game game = games!.removeAt(listIndex);
      DBHelper.deleteGame(game.gameID);
    });
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
