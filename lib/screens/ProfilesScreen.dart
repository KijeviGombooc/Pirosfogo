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
  List<Profile>? profiles;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
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
                        onDismissed: (_) => _onDismissed(i),
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

  _onDismissed(int listIndex) {
    setState(() {
      DBHelper.deletePlayer(profiles!.removeAt(listIndex).profileID);
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
    DBHelper.getAllProfiles().then(
      (profiles) => setState(
        () {
          this.profiles = profiles;
        },
      ),
    );
  }
}
