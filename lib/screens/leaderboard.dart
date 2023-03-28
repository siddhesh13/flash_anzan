import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_anzan/drawer.dart';
import 'package:flash_anzan/models/resultmodel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/usermodel.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String _selectedCategory = "Addition"; // default category
  String username = "";
  String photoUrl = "";
  getUserDetails(dynamic userid) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userid);
    final userDoc = await userRef.get();
    final userData = userDoc.data();
    final username = userData!['displayName'];
    final photoUrl = userData['photoUrl'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard"),
      ),
      drawer: TrendingSidebar(
          /*username: "name", email: "email", photo: "photo.com", level: "Level"*/),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: DropdownButton<String>(
              value: _selectedCategory,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (dynamic newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: <String>[
                'Addition',
                'Addition/Subtraction',
                'Long Multiplication',
                'Multiplication',
                'Division',
                'Decimal Add/Sub',
                'Square Root',
                'Cube Root',
                'Percentage',
                'Overall',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _selectedCategory == 'Overall'
                      ? FirebaseFirestore.instance
                          .collection('quizResults')
                          .orderBy('points', descending: true)
                          .limit(15)
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('quizResults')
                          .where('category', isEqualTo: _selectedCategory)
                          .orderBy('points', descending: true)
                          .limit(15)
                          .snapshots(),
                  /*_selectedCategory == 'Overall' 
                  ? FirebaseFirestore.instance
                      .collection('quizResults')
                      :FirebaseFirestore.instance
                      .collection('quizResults').where('category', isEqualTo: _selectedCategory)
                      .orderBy('points', descending: true)
                      .snapshots(),*/
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          QuizResult quizResult = QuizResult.fromMap(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>,
                              snapshot.data!.docs[index]
                                  .id); // map data to quizResult model
                          return StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(quizResult.userId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }

                              UserModel user = UserModel.fromMap(snapshot.data!
                                  .data() as Map<String, dynamic>);

                              return LeaderboardUser(
                                index: index,
                                avatarUrl: user.photoUrl as String,
                                username: user.displayName as String,
                                category: quizResult.category,
                                points: quizResult.points,
                                date: quizResult.time.toString(),
                                marks: quizResult.marks,
                                questions: quizResult.questions,
                                rows: quizResult.rows,
                                digits: quizResult.digits,
                                timeTaken: quizResult.timeTaken,
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderboardUser extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final String category;
  final String date;
  final int points;
  final int index;
  final int marks;
  final int questions;
  final int rows;
  final String digits;
  final String timeTaken;

  LeaderboardUser({
    required this.avatarUrl,
    required this.username,
    required this.category,
    required this.date,
    required this.points,
    required this.index,
    required this.marks,
    required this.questions,
    required this.rows,
    required this.digits,
    required this.timeTaken,
  });

  @override
  Widget build(BuildContext context) {
    Color rankColor;
    Color fontColor = Colors.black;
    Widget crown;
    if (index == 0) {
      rankColor = Color.fromARGB(255, 237, 200, 18);
      crown = Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Stack(
            alignment: Alignment.center,
            children: const <Widget>[
              Center(
                  child: Icon(
                FontAwesomeIcons.crown,
                size: 36,
                color: Colors.amberAccent,
              )),
              Padding(
                padding: EdgeInsets.only(left: 6.0, top: 8),
                child: Center(
                    child: Text(
                  '1',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )),
              )
            ],
          ));
    } else if (index == 1) {
      rankColor = Colors.grey;
      crown = Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Stack(
            alignment: Alignment.center,
            children: const <Widget>[
              Center(
                  child: Icon(
                FontAwesomeIcons.crown,
                size: 36,
                color: Colors.blueGrey,
              )),
              Padding(
                padding: EdgeInsets.only(left: 6.0, top: 8),
                child: Center(
                    child: Text(
                  '2',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )),
              )
            ],
          ));
    } else if (index == 2) {
      rankColor = Color.fromARGB(255, 151, 76, 11);
      crown = Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Stack(
            alignment: Alignment.center,
            children: const <Widget>[
              Center(
                  child: Icon(
                FontAwesomeIcons.crown,
                size: 36,
                color: Color.fromARGB(255, 236, 65, 3),
              )),
              Padding(
                padding: EdgeInsets.only(left: 6.0, top: 8),
                child: Center(
                    child: Text(
                  '3',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )),
              )
            ],
          ));
    } else {
      rankColor = Colors.white;
      crown = CircleAvatar(
          backgroundColor: Colors.blueGrey,
          radius: 18,
          child: Text(
            (index + 1).toString(),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          ));
    }
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(8),
        //constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          color: rankColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black12,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 10),
                        child: crown,
                      ),
                    ),
                    const SizedBox(width: 10),
                    /*Text(
                      '${index + 1}. ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),*/
                    CircleAvatar(
                      backgroundImage: NetworkImage(avatarUrl),
                      radius: 20,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Digits",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: fontColor,
                                  ),
                                ),
                                Text(
                                  digits,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: fontColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 6),
                            Column(
                              children: [
                                Text(
                                  "Rows",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: fontColor,
                                  ),
                                ),
                                Text(
                                  "$rows",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: fontColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 6),
                            Column(
                              children: [
                                Text(
                                  "Marks",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: fontColor,
                                  ),
                                ),
                                Text(
                                  "$marks/$questions",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: fontColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 6),
                            Column(
                              children: [
                                Text(
                                  "Time",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: fontColor,
                                  ),
                                ),
                                Text(
                                  "$timeTaken",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: fontColor,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Center(
                      child: Icon(
                        FontAwesomeIcons.solidGem,
                        size: 22,
                        color: Colors.blueGrey,
                      ),
                    ),
                    /*Text(
                      "points",
                      //date,
                      // DateFormat("yMMMMd").parse(date).toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: fontColor,
                      ),
                    ),*/
                    SizedBox(height: 4),
                    Center(
                      child: Text(
                        points.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
