import 'package:flash_anzan/screens/homepage.dart';
import 'package:flash_anzan/screens/studentProfile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flash_anzan/provider/userProvider.dart';

class TrendingSidebar extends StatelessWidget {
  /* final String username;
  final String email;
  final String photo;
  final String level;
  TrendingSidebar(
      {required this.username,
      required this.email,
      required this.photo,
      required this.level});
  */
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _handleSignOut(BuildContext context) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userP = userProvider.user;
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.purple.shade500,
                  Colors.purple.shade900,
                ],
              )),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40.0,
                      backgroundImage: NetworkImage(userP?.photoUrl ??
                          "https://firebasestorage.googleapis.com/v0/b/abacusplusflash.appspot.com/o/asset%2Favatar.jpg?alt=media&token=64ab58be-1567-42a3-be6f-af81de791a1f"),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      userP?.displayName?.toUpperCase() ?? 'Guest',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      userP?.email ?? '',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Navigate to home screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AbacusHomePage(
                        /* email: email,
                      username: username,
                      photo: photo,
                      level: level,*/
                        ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                // Navigate to home screen
              },
            ),
            Visibility(
              visible: (userP?.displayName ?? '').isNotEmpty,
              child: ListTile(
                leading: const Icon(Icons.add_chart_rounded),
                title: Text('Leaderboard'),
                onTap: () {
                  // Navigate to home screen
                  Navigator.pushNamed(context, '/leaderboard');
                },
              ),
            ),
            /*
            ListTile(
              leading: const Icon(Icons.card_giftcard_rounded),
              title: Text('Flashcards'),
              onTap: () {
                // Navigate to home screen
                Navigator.pushNamed(context, '/flashcardSetting');
              },
            ),*/
            Visibility(
              visible: (userP?.displayName ?? '').isNotEmpty,
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  // Navigate to profile screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfile(
                            /* email: email,
                          name: username,
                          photoUrl: photo,
                          level: level,*/
                            ),
                      ));
                },
              ),
            ),
            /* ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings screen
                Navigator.pushNamed(context, '/noFormulaQuiz');
              },
            ),*/
            ListTile(
              leading: Icon(Icons.call_rounded),
              title: Text('About Us'),
              onTap: () {
                // Navigate to home screen
                Navigator.pushNamed(context, '/aboutus');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign out'),
              onTap: () => _handleSignOut(context),
            ),
          ],
        ),
      ),
    );
  }
}
   
   /* return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(email),
          ),
          ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Navigate to home screen
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Dashboard'),
              onTap: () {
                // Navigate to home screen
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Navigate to profile screen
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings screen
              },
            ),
            Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign out'),
            onTap: () => _handleSignOut(context),
          ),
        ],
      ),
    );
  }
}
*/