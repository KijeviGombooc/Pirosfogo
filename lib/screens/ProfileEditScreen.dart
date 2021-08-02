import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pirosfogo/helpers/DBHelper.dart';
import 'package:pirosfogo/model/Profile.dart';
import 'package:pirosfogo/widgets/ProfileWidget.dart';

class ProfileEditScreen extends StatefulWidget {
  final Profile? profile;

  const ProfileEditScreen({this.profile});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController controller = TextEditingController();
  String imagePath = "";

  @override
  void initState() {
    super.initState();
    if (widget.profile != null) {
      setState(() {
        controller.text = widget.profile!.name;
        imagePath = widget.profile!.imageUri;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pirosfogó"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: ProfileWidget(
              onTap: () => _onImageTapped(context),
              image: imagePath.isEmpty
                  ? null
                  : Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              controller: controller,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(hintText: "Name"),
            ),
          ),
          ElevatedButton(
            onPressed: () => _onSavePressed(context),
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _onImageTapped(BuildContext context) {
    _selectImageOption(context).then(
      (imageSource) {
        if (imageSource == null)
          return;
        else {
          ImagePicker imagePicker = ImagePicker();
          imagePicker.pickImage(source: imageSource).then(
            (selectedXFile) {
              if (selectedXFile == null) {
                //TODO: error handling
                return;
              }
              File selectedFile = File(selectedXFile.path);

              if (imagePath.isNotEmpty) {
                File oldFile = File(imagePath);
                oldFile.delete().then(
                      (fileSystemEntity) => _saveImage(
                        selectedFile,
                        basename(selectedFile.path),
                      ),
                    );
              }

              _saveImage(
                selectedFile,
                basename(selectedFile.path),
              );
            },
          ).onError<PlatformException>(
            (error, stackTrace) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error.message as String),
                ),
              );
              print("Error: ${error.message}");
            },
          ).catchError(
            (ex) {
              print(ex); //TODO: proper error handling
            },
          );
        }
      },
    );
  }

  void _saveImage(File img, String name) {
    getApplicationDocumentsDirectory().then((appDocsDir) {
      return join(appDocsDir.path, name);
    }).then((destPath) {
      img.copy(destPath).then((destFile) {
        setState(() {
          imagePath = destFile.path;
        });
      });
    });
  }

  void _onSavePressed(BuildContext context) {
    final String name = controller.text.trim();
    if (name.isEmpty) return;
    Profile? profile = widget.profile;
    if (profile == null) {
      DBHelper.createProfile(name, imagePath).then((player) {
        Navigator.pop(context);
      });
    } else {
      DBHelper.updatePlayer(profile.profileID, name, imagePath).then((_) {
        Navigator.pop(context);
      });
    }
  }

  Future<ImageSource?> _selectImageOption(BuildContext context) async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("Image source"),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ImageSource.camera);
              },
              child: const Text("ImageSource.camera"),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ImageSource.gallery);
              },
              child: const Text("ImageSource.gallery"),
            ),
          ],
        );
      },
    );
  }
}
