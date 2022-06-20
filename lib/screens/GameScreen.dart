import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pirosfogo/helpers/DBHelper.dart';
import 'package:pirosfogo/main.dart';
import 'package:pirosfogo/model/Player.dart';
import 'package:pirosfogo/model/Profile.dart';
import 'package:pirosfogo/model/RowValue.dart';
import 'package:pirosfogo/screens/SelectProfileScreen.dart';
import 'package:pirosfogo/widgets/ProfileWidget.dart';
import 'package:pirosfogo/widgets/ScoreTextField.dart';

class GameScreen extends StatefulWidget {
  final int gameID;
  final List<Player> players;

  const GameScreen(this.gameID, this.players);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const soundPath = "sounds/ahhhaaa.mp3";
  final player = AudioPlayer();
  final AssetSource soundSource = AssetSource(soundPath);
  late List<TextEditingController> controllers;

  int get _rowCount {
    return widget.players[0].scores.length;
  }

  bool get _isFinished {
    for (var i = 0; i < widget.players.length; i++) {
      if (widget.players[i].scoreSum >= 24) {
        return true;
      }
    }
    return false;
  }

  int get _currentStarterIndex {
    return _rowCount % 4;
  }

  @override
  void initState() {
    super.initState();
    player.audioCache.load(soundPath);
    //TODO: check if all widget.players have same number of rows
    controllers = List.generate(
      widget.players.length,
      (playerIndex) => TextEditingController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pirosfogó"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              widget.players.length,
              (playerIndex) => Flexible(
                child: Column(
                  children: [
                    ProfileWidget(
                      image: widget.players[playerIndex].profile == null ||
                              widget.players[playerIndex].profile!.imageUri
                                  .isEmpty
                          ? null
                          : Image.file(
                              File(widget
                                  .players[playerIndex].profile!.imageUri),
                              fit: BoxFit.cover,
                            ),
                      onTap: () => _onPlayerIconPressed(context, playerIndex),
                    ),
                    FittedBox(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: playerIndex == _currentStarterIndex
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Text(widget.players[playerIndex].profile == null
                            ? "Guest"
                            : widget.players[playerIndex].profile!.name),
                      ),
                    ),
                    Text(widget.players[playerIndex].scoreSum.toString()),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isFinished ? null : () => _onAddRowPressed(context),
              child: Text("Next round"),
            ),
          ),
          Flexible(
            flex: 6,
            child: ListView.builder(
              itemCount: _isFinished ? _rowCount : _rowCount + 1,
              itemBuilder: (ctx, rowIndex) {
                return Row(
                  children: List.generate(
                    widget.players.length,
                    (playerIndex) => Flexible(
                      child: rowIndex == _rowCount
                          ? ScoreTextField(controller: controllers[playerIndex])
                          : ScoreTextField(
                              initValue:
                                  widget.players[playerIndex].scores[rowIndex],
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onPlayerIconPressed(BuildContext context, int playerIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return SelectProfileScreen(
            exceptions: widget.players
                .where((player) => player.profile != null)
                .map((player) => player.profile as Profile)
                .toList(),
          );
        },
      ),
    ).then(
      (selectedProfile) {
        _onReturnFromProfileSelection(playerIndex, selectedProfile);
      },
    );
  }

  _onReturnFromProfileSelection(int playerIndex, Profile? selectedProfile) {
    if (selectedProfile == null) {
      return;
    } else {
      int? id = selectedProfile.name.isEmpty ? null : selectedProfile.profileID;

      DBHelper.updatePlace(
        widget.gameID,
        widget.players[playerIndex].place,
        id,
      ).then(
        (player) {
          widget.players[playerIndex] = player;
        },
      ).then((value) => setState(() {}));
    }
  }

  void _onAddRowPressed(BuildContext context) {
    setState(() {
      final rowValue = _isLastRowValid();
      // Invalid input handling
      if (rowValue == RowValue.INVALID) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MyApp.primaryColor,
            content: Text(
              "Row sum must be 8!",
              style: TextStyle(color: MyApp.secondaryColor),
            ),
            duration: Duration(seconds: 1),
          ),
        );
        return;
      }

      // play ""nyolcas" sound
      if (rowValue == RowValue.VALID_EIGHT) {
        player.play(soundSource);
      }

      // update db values, add new row
      for (var i = 0; i < widget.players.length; i++) {
        try {
          int score = int.parse(controllers[i].text);
          widget.players[i].scores.add(score);
          DBHelper.addScore(widget.gameID, widget.players[i].place, score);
        } catch (e) {
          //TODO: proper error handling
          print(e);
        }
      }
      for (var i = 0; i < controllers.length; i++) {
        controllers[i].text = "0";
      }
    });
  }

  RowValue _isLastRowValid() {
    int sum = 0;
    bool hasSomeoneLost = false;
    bool isValueEight = false;
    for (var i = 0; i < controllers.length; i++) {
      try {
        int val = int.parse(controllers[i].text);
        if (val == 8) isValueEight = true;
        if (widget.players[i].scoreSum + val >= 24) {
          if (hasSomeoneLost) return RowValue.INVALID;
          hasSomeoneLost = true;
        }
        sum += val;
      } catch (e) {
        //TODO: proper error handling
      }
    }
    if (sum == 8 || (sum < 8 && hasSomeoneLost)) {
      if (isValueEight) return RowValue.VALID_EIGHT;
      return RowValue.VALID_SUM;
    } else
      return RowValue.INVALID;
  }
}
