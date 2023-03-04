import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../models/usermodel.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _isLoading = false;
  String downloadUrl = "";
  Future<UserCredential?> _signInWithGoogle() async {
    // Sign in with Google
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    // Authenticate with Firebase
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    final String? photoUrl = googleUser.photoUrl;

    final String fileName = '${googleUser.id}-profile-photo.jpg';

    final Reference storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    final response = await http.get(Uri.parse(photoUrl!));
    final bytes = response.bodyBytes;

    final UploadTask uploadTask = storageReference.putData(bytes);
    await uploadTask.whenComplete(() => null);
    downloadUrl = await storageReference.getDownloadURL();

    // Check if the user already exists in Firestore.
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user?.uid)
        .get();
    if (!userSnapshot.exists) {
      // User does not exist, create a new user document.
      UserModel userModel = UserModel(
        uid: userCredential.user?.uid as String,
        email: userCredential.user?.email,
        displayName: userCredential.user?.displayName,
        photoUrl: downloadUrl,
      );

      await addUserToFirestore(userModel);
    }
    // Create the user in the database
    //final user = userCredential.user!;
    //await createUserInDatabase(user.uid, user.displayName, user.email);

    return userCredential;
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> addUserToFirestore(UserModel userModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel.uid)
          .set({
        'uid': userModel.uid,
        'displayName': userModel.displayName,
        'email': userModel.email,
        'photoUrl': userModel.photoUrl,
      });
    } catch (e) {
      print(e);
    }
  }

/*
  Future<void> createUserInDatabase(
      String uid, String? name, String? email) async {
    // Create the user in the database
    // You can customize this function to suit your needs
    // For example, you could use Firestore to store user data
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.account_circle),
                    label: const Text('Sign in with Google'),
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      try {
                        UserCredential? userCredential =
                            await _signInWithGoogle();
                        if (userCredential?.user != null) {
                          print('Logged in');
                          print(userCredential?.user?.displayName);
                          print(userCredential?.user?.email);
                          print(downloadUrl);

                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AbacusHomePage(
                                        username: userCredential
                                            ?.user?.displayName as String,
                                        email: userCredential?.user?.displayName
                                            as String,
                                        photo: downloadUrl,
                                      )));
                        }
                      } catch (e) {
                        print(e.toString());
                        setState(() => _isLoading = false);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Error'),
                            content: Text(e.toString()),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Close'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Sign out'),
                    onPressed: () async {
                      await _signOut();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
