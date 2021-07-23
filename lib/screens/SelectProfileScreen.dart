import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pirosfogo/helpers/DBHelper.dart';
import 'package:pirosfogo/model/Profile.dart';
import 'package:pirosfogo/screens/ProfileEditScreen.dart';
import 'package:pirosfogo/widgets/ProfileWidget.dart';

class SelectProfileScreen extends StatefulWidget {
  final List<Profile>? exceptions;

  const SelectProfileScreen({this.exceptions});

  @override
  _SelectProfileScreenState createState() => _SelectProfileScreenState();
}

class _SelectProfileScreenState extends State<SelectProfileScreen> {
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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () => _deselectPlayer(context),
                      child: Text("Clear Player")),
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: profiles!.length,
                    itemBuilder: (ctx, i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 100,
                          child: InkWell(
                            onTap: () => _selectPlayer(context, i),
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
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddPlayerPressed,
        child: const Icon(Icons.add),
      ),
    );
  }

  _onAddPlayerPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditScreen(),
      ),
    ).then((value) => _loadPlayers());
  }

  _selectPlayer(BuildContext ctx, int listIndex) {
    if (profiles == null) {
      //TODO: proper error handling
      return;
    }
    Navigator.pop<Profile?>(context, profiles![listIndex]);
  }

  void _loadPlayers() {
    DBHelper.getAllProfiles(except: widget.exceptions)
        .then((profiles) => setState(() {
              this.profiles = profiles;
            }));
  }

  _deselectPlayer(BuildContext context) {
    Navigator.pop<Profile?>(context, Profile(-1, "", ""));
  }
}
