import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pirosfogo/helpers/DBHelper.dart';
import 'package:pirosfogo/model/Profile.dart';
import 'package:pirosfogo/screens/ProfileEditScreen.dart';
import 'package:pirosfogo/widgets/ProfileWidget.dart';

class ProfilesScreen extends StatefulWidget {
  @override
  _ProfilesScreenState createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  Profile? lastDismissed;
  int? lastDismissedIndex;
  ScaffoldMessengerState? scaffoldMessengerState;
  List<Profile>? profiles;

  @override
  void initState() {
    super.initState();
    _deleteDismissed();
    _loadPlayers();
  }

  @override
  void dispose() {
    _deleteDismissed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pirosfogó"),
        centerTitle: true,
      ),
      body: profiles == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: profiles!.length,
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Dismissible(
                        key: UniqueKey(),
                        onDismissed: (_) => _onDismissed(context, i),
                        child: SizedBox(
                          height: 100,
                          child: InkWell(
                            onTap: () => _editPlayer(context, i),
                            child: Card(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ProfileWidget(
                                    image: profiles![i].imageUri.isEmpty
                                        ? null
                                        : Image.file(
                                            File(profiles![i].imageUri),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(profiles![i].name),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        )),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddPlayerPressed,
        child: const Icon(Icons.add),
      ),
    );
  }

  _onDismissed(BuildContext context, int listIndex) {
    setState(() {
      _deleteDismissed();
      lastDismissed = profiles!.removeAt(listIndex);
      lastDismissedIndex = listIndex;
      scaffoldMessengerState = ScaffoldMessenger.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: SnackBarAction(
            label: "undo",
            onPressed: () => _undoDismiss(lastDismissed),
          ),
          content: Text("Deleted: ${lastDismissed!.name}"),
        ),
      );
    });
  }

  _onAddPlayerPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditScreen(),
      ),
    ).then((value) => _loadPlayers());
  }

  _editPlayer(BuildContext ctx, int listIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditScreen(
          profile: profiles![listIndex],
        ),
      ),
    ).then((value) => _loadPlayers());
  }

  void _loadPlayers() {
    List<Profile>? exceptions =
        lastDismissed == null ? null : [lastDismissed as Profile];
    DBHelper.getAllProfiles(except: exceptions).then(
      (profiles) => setState(
        () {
          this.profiles = profiles;
        },
      ),
    );
  }

  _undoDismiss(Profile? toUndo) {
    if (lastDismissed == null || lastDismissedIndex == null) {
      //TODO: proper error handling
    } else if (toUndo == lastDismissed) {
      print(toUndo!.name);
      setState(() {
        profiles!.insert(lastDismissedIndex!, lastDismissed!);
        lastDismissed = null;
        lastDismissedIndex = null;
      });
    }
  }

  void _deleteDismissed() {
    if (lastDismissed != null &&
        lastDismissedIndex != null &&
        scaffoldMessengerState != null) {
      scaffoldMessengerState!.hideCurrentSnackBar();
      DBHelper.deletePlayer(lastDismissed!.profileID);
      lastDismissed = null;
      lastDismissedIndex = null;
    }
  }
}
