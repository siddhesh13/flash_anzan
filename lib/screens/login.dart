import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../models/usermodel.dart';
import 'homepage.dart';
import 'package:provider/provider.dart';
import 'package:flash_anzan/provider/userProvider.dart';

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

    final String fileName = '${googleUser.id}.jpg';

    final Reference storageReference =
        FirebaseStorage.instance.ref().child('profile_photos/$fileName');
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
        level: "",
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
        'level': userModel.level,
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
        title: Text('Abacus Plus Flash'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/abacusplusflash.appspot.com/o/asset%2Flogin_family.png?alt=media&token=d4b3d200-8668-447a-beb6-6576237d6b24"),
                      height: 300,
                      width: 200,
                    ),
                    Container(
                      height: 50.0,
                      width: 300,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 211, 95, 250),
                              Color.fromARGB(255, 145, 0, 164),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(FontAwesomeIcons.google),
                        label: const Text('Sign in with Google',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          try {
                            UserCredential? userCredential =
                                await _signInWithGoogle();
                            if (userCredential?.user != null) {
                              print('Logged in');
                              final user = FirebaseAuth.instance.currentUser;
                              //print(user!.uid);
                              //print(userCredential?.user?.displayName);
                              //print(userCredential?.user?.email);
                              //print(downloadUrl);
                              // print("${user.displayName}, ${user.email}");
                              // print("${user.photoURL}");
                              final userRef = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user!.uid);
                              final userDoc = await userRef.get();
                              // Now you can access the user's data using the `data()` method on the DocumentSnapshot
                              final userData = userDoc.data();
                              // For example, if your user data contains a `name` field, you can access it like this:
                              final userName = userData!['displayName'];
                              final email = userData['email'];
                              final photoUrl = userData['photoUrl'];
                              final level = userData['level'];
                              print("level: $level");
                              //print("$userName, $email");
                              // ignore: use_build_context_synchronously
                              final userProvider = Provider.of<UserProvider>(
                                  context,
                                  listen: false);

                              // After successful login
                              final userP = UserModel(
                                  uid: user.uid,
                                  displayName: userName,
                                  email: email,
                                  photoUrl: photoUrl,
                                  level: level);
                              userProvider.setUser(userP);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AbacusHomePage(
                                          /* username: userCredential
                                              ?.user?.displayName as String,
                                          email: userCredential?.user?.displayName
                                              as String,
                                          //level: userCredential?.user?.level as String,
                                          photo: downloadUrl,*/
                                          /* username: userName,
                                            email: email,
                                            photo: photoUrl,
                                            level: level,*/
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
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 50.0,
                      width: 300,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF9945),
                              Color(0xFFFc6076),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.account_circle),
                        label: const Text('Log In as a Guest',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          final userProvider =
                              Provider.of<UserProvider>(context, listen: false);

                          // After successful login
                          //final userP = UserModel(uid:"",displayName: "Guest", email:"",
                          //photoUrl: "https://firebasestorage.googleapis.com/v0/b/abacusplusflash.appspot.com/o/asset%2Favatar.jpg?alt=media&token=64ab58be-1567-42a3-be6f-af81de791a1f",
                          // level:"");
                          //userProvider.setUser(userP);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AbacusHomePage(
                                      /* username: "Guest",
                                        email: "",
                                        photo:
                                            "https://firebasestorage.googleapis.com/v0/b/abacusplusflash.appspot.com/o/asset%2Favatar.jpg?alt=media&token=64ab58be-1567-42a3-be6f-af81de791a1f",
                                        level: "",*/
                                      )));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Powered By: The Learnsers Hub',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
