import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class EditProfilePage extends StatefulWidget {
  //final String userId;
  //final String photoUrl;
  //EditProfilePage({required this.userId, required this.photoUrl});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _abacusLevelController = TextEditingController();
  final _imagePicker = ImagePicker();
  File? _profilePhoto;
  dynamic bytes;
  String? _profilePhotoUrl;
  bool _isLoading = false;
  String _selectedLevel = "";
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _profilePhotoUrl = user!.photoURL;
    // Load user data from Firestore and populate the form fields
    _getUserData();
  }

  dynamic pngBytes;
  Future<void> _selectProfilePhoto() async {
    //print("show image picker");
    //File? file;
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    //print("pick image");
    if (pickedFile != null) {
      //print("set state");
      bytes = await pickedFile.readAsBytes();
      // decode image bytes
      final image = img.decodeImage(bytes)!;
      // encode image to png format
      pngBytes = img.encodePng(image);

      setState(() {
        // print("image picked");
        _profilePhoto = File(pickedFile.path);
        //print(_profilePhoto);
        // convert file to bytes

        // use the encoded bytes to create Image widget
        //final imageWidget = Image.memory(pngBytes);
      });
    }
  }

  void _getUserData() async {
    setState(() {
      _isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    setState(() {
      _usernameController.text = userData['displayName'];
      _abacusLevelController.text = userData['level'];
      _selectedLevel = userData["level"];
      _profilePhotoUrl = userData['photoUrl'];
      _isLoading = false;
    });
  }

  Future<void> _updateProfile() async {
    //print("update profile");
    if (_formKey.currentState!.validate()) {
      //print("key validated");
      final user = FirebaseAuth.instance.currentUser;
      // Upload profile photo to Firebase Storage if a new one was selected
      if (_profilePhoto != null) {
        //print("upload ploto");
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_photos/${user!.uid}.jpg');
        final uploadTask = storageRef.putData(pngBytes!);
        //print("send to storage");
        final snapshot = await uploadTask.whenComplete(() => null);
        //print("task completed");
        _profilePhotoUrl = await snapshot.ref.getDownloadURL();
        //print("got download url");
      }
      //print("photo uploaded");

      // Update user data in Firestore
      FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'displayName': _usernameController.text,
        'level': _selectedLevel,
        'photoUrl': _profilePhotoUrl,
      }).then((_) {
        Navigator.pop(context);
      });
      print("data updated");
    }
  }

  @override
  Widget build(BuildContext context) {
    //final String userId = ModalRoute.of(context)!.settings.arguments as String;
    //print("build: $userId");
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: _profilePhoto == null
                                  ? NetworkImage(_profilePhotoUrl!)
                                  : MemoryImage(pngBytes)
                                      as ImageProvider<Object>?,
                              radius: 50,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: _selectProfilePhoto,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /* Center(
                  child: GestureDetector(
                    onTap: () {
                      _showImagePicker();
                    },
                    child: CircleAvatar(
                      backgroundImage: // _profilePhoto == null
                          //?
                          NetworkImage(_profilePhotoUrl!),
                      // : FileImage(_profilePhoto!) as ImageProvider<Object>?,
                      radius: 50,
                    ),
                  ),
                ),*/
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your username',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                      DropdownButton<String>(
                        value: _selectedLevel,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _selectedLevel = newValue;
                          });
                        },
                        items: <String>[
                          'Level 1',
                          'Level 2',
                          'Level 3',
                          'Level 4',
                          'Level 5',
                          'Level 6',
                          'Level 7',
                          'Level 8',
                          'Level 9',
                          'Level 10',
                          'Foundation Level 1',
                          'Foundation Level 2',
                          'Foundation Level 3',
                          'Intermediate Level 1',
                          'Intermediate Level 2',
                          'Intermediate Level 3',
                          'Intermediate Level 4',
                          'Advance Level 1',
                          'Advance Level 2',
                          'Advance Level 3',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      /* TextFormField(
                  controller: _abacusLevelController,
                  decoration: InputDecoration(
                    labelText: 'Abacus Level',
                    hintText: 'Enter your abacus level',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your abacus level';
                    }
                    return null;
                  },
                ),*/
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _updateProfile,
                          child: Text('Update Profile'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

/*
DropdownButton<String>(
                        value: _selectedLevel,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _selectedLevel = newValue;
                          });
                        },
                        items: <String>[
                          'Level 1',
                          'Level 2',
                          'Level 3',
                          'Level 4',
                          'Level 5',
                          'Level 6',
                          'Level 7',
                          'Level 8',
                          'Level 9',
                          'Level 10',
                          'Foundation Level 1',
                          'Foundation Level 2',
                          'Foundation Level 3',
                          'Intermediate Level 1',
                          'Intermediate Level 2',
                          'Intermediate Level 3',
                          'Intermediate Level 4',
                          'Advance Level 1',
                          'Advance Level 2',
                          'Advance Level 3',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
*/
