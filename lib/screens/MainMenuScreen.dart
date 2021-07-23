import 'package:flutter/material.dart';
import 'package:pirosfogo/helpers/DBHelper.dart';
import 'package:pirosfogo/screens/GameScreen.dart';
import 'package:pirosfogo/screens/LoadGameScreen.dart';
import 'package:pirosfogo/screens/ProfilesScreen.dart';
import 'package:pirosfogo/screens/RulesScreen.dart';

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pirosfogó"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _onNewGamePressed(context),
              child: Text("New Game"),
            ),
            ElevatedButton(
              onPressed: () => _onLoadGamePressed(context),
              child: Text("Load Game"),
            ),
            ElevatedButton(
              onPressed: () => _onProfilesPressed(context),
              child: Text("Profiles"),
            ),
            ElevatedButton(
              onPressed: () => _onRulesPressed(context),
              child: Text("Rules"),
            ),
          ],
        ),
      ),
    );
  }

  _onNewGamePressed(BuildContext context) {
    DBHelper.newGame(4).then((gameID) {
      DBHelper.getPlayers(gameID).then((players) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(gameID, players),
          ),
        );
      });
    });
  }

  _onLoadGamePressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadGameScreen(),
      ),
    );
  }

  _onProfilesPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilesScreen(),
      ),
    );
  }

  _onRulesPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RulesScreen(),
      ),
    );
  }
}
