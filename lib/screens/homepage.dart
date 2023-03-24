import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../drawer.dart';

class AbacusHomePage extends StatelessWidget {
  /*final String username;
  final String email;
  final String photo;
  final String level;
  AbacusHomePage(
      {required this.username,
      required this.email,
      required this.photo,
      required this.level});*/
  //final userProvider = Provider.of<UserProvider>(context);
//final user = userProvider.user;

// Use the user information in your widgets
//Text(user?.name ?? 'Guest');
//Text(user?.email ?? '');
//Image.network(user?.profilePhotoUrl ?? 'https://example.com/default_profile.jpg');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: TrendingSidebar(
        //email: user?.email,
        //username: user?.name,
        //photo: user?.profilePhotoUrl,
        //level: user?.level,
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5),
                /*
                _buildAnimatedOption(
                  context,
                  'Addition',
                  CupertinoIcons.plus_circle_fill,
                  Colors.purple[300]!,
                  () => Navigator.pushNamed(context, '/addition'),
                ),
                SizedBox(height: 20),
                _buildAnimatedOption(
                  context,
                  'Addition/Subtraction',
                  CupertinoIcons.minus_circle_fill,
                  Colors.orange[300]!,
                  () => Navigator.pushNamed(context, '/subtraction'),
                ),
                SizedBox(height: 20),
                */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOption(
                      context,
                      "Addition",
                      FontAwesomeIcons.plus,
                      () => Navigator.pushNamed(context, '/addSetting',
                          arguments: <String, String>{
                            'operation': 'add',
                          }),
                      Colors.purple,
                    ),
                    _buildOption(
                      context,
                      "Add/Sub",
                      FontAwesomeIcons.plusMinus,
                      () => Navigator.pushNamed(context, '/addSetting',
                          arguments: <String, String>{
                            'operation': 'sub',
                          }),
                      Colors.purple,
                    ),
                  ],
                ),
                //SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOption(
                      context,
                      "Decimal\nAdd/Sub",
                      FontAwesomeIcons.plusMinus,
                      () => Navigator.pushNamed(context, '/addSetting',
                          arguments: <String, String>{
                            'operation': 'decimal',
                          }),
                      Colors.amber,
                    ),
                    _buildOption(
                      context,
                      "Long\nMultiplication",
                      FontAwesomeIcons.xmark,
                      () => Navigator.pushNamed(context, '/multSetting',
                          arguments: <String, String>{
                            'operation': 'long_multiply',
                          }),
                      Colors.amber,
                    ),
                  ],
                ),
                //SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOption(
                      context,
                      "Multiplication",
                      FontAwesomeIcons.xmark,
                      () => Navigator.pushNamed(context, '/multSetting',
                          arguments: <String, String>{
                            'operation': 'multiply',
                          }),
                      Colors.blueAccent,
                    ),
                    _buildOption(
                      context,
                      "Division",
                      FontAwesomeIcons.divide,
                      () => Navigator.pushNamed(context, '/divSetting'),
                      Colors.blueAccent,
                    ),
                  ],
                ),
                //SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOption(
                      context,
                      "Square Root",
                      FontAwesomeIcons.squareRootVariable,
                      () => Navigator.pushNamed(context, '/rootSetting',
                          arguments: <String, String>{
                            'operation': 'Square Root',
                          }),
                      Colors.green,
                    ),
                    _buildOption(
                      context,
                      "Cube Root",
                      Icons.filter_3_rounded,
                      () => Navigator.pushNamed(context, '/rootSetting',
                          arguments: <String, String>{
                            'operation': 'Cube Root',
                          }),
                      Colors.green,
                    ),
                  ],
                ),
                //SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOption(
                      context,
                      "Percentage",
                      FontAwesomeIcons.percent,
                      () => Navigator.pushNamed(
                        context,
                        '/percentSetting',
                      ),
                      Colors.redAccent,
                    ),
                    _buildOption(
                      context,
                      "Tables",
                      CupertinoIcons.list_number,
                      () => Navigator.pushNamed(
                        context,
                        '/tablesSetting',
                      ),
                      Colors.redAccent,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOption(
                      context,
                      "Falshcards",
                      Icons.style,
                      () => Navigator.pushNamed(
                        context,
                        '/flashcardSetting',
                      ),
                      Colors.deepOrange,
                    ),
                    _buildOption(
                      context,
                      "No Formula\nAdd/Sub",
                      CupertinoIcons.infinite,
                      () => Navigator.pushNamed(
                        context,
                        '/noFormulaSetting',
                      ),
                      Colors.deepOrange,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

/*
  Widget _buildAnimatedOption(BuildContext context, String label, IconData icon,
      Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              size: 50.0,
              color: Colors.white,
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 50),
          ],
        ),
      ),
    );
  }
}

Widget buildOptionButton(
    BuildContext context, String text, IconData icon, Color color) {
  return GestureDetector(
    onTap: () {
      // Navigate to next page
    },
    child: Container(
      height: 60.0,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 3.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8.0),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildOptionButton2(BuildContext context, IconData icon, String text) {
  return ElevatedButton.icon(
    onPressed: () {},
    icon: Icon(
      icon,
      color: Colors.white,
      size: 36.0,
    ),
    label: Text(
      text,
      style: TextStyle(fontSize: 24.0),
    ),
    style: ElevatedButton.styleFrom(
      primary: Colors.blue,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
    ),
  );
}
*/
  Widget _buildOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.fromLTRB(40, 10, 40, 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 50.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
