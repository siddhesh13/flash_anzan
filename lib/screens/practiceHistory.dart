import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_anzan/drawer.dart';
import 'package:flash_anzan/models/resultmodel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/usermodel.dart';
import 'package:intl/intl.dart';

class PracticeDetailsPage extends StatefulWidget {
  @override
  _PracticeDetailsState createState() => _PracticeDetailsState();
}

class _PracticeDetailsState extends State<PracticeDetailsPage> {
  String _selectedCategory = "Addition"; // default category
  String username = "";
  String photoUrl = "";
  String userId = "";
  getUserDetails(dynamic userid) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userid);
    final userDoc = await userRef.get();
    final userData = userDoc.data();
    //final userId = userData!['userId'];
    final username = userData!['displayName'];
    final photoUrl = userData['photoUrl'];
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    userId = arguments['userId'];
    print(userId);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Practice Details"),
      ),
      drawer: TrendingSidebar(
         /* username: "name", email: "email", photo: "photo.com", level: "Level"*/),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: DropdownButton<String>(
              value: _selectedCategory,
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
                'Tables',
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
                constraints: const BoxConstraints(maxWidth: 600),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _selectedCategory == 'Overall'
                      ? FirebaseFirestore.instance
                          .collection('quizResults')
                          .where('userId', isEqualTo: userId)
                          .orderBy('time', descending: true)
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('quizResults')
                          .where('userId', isEqualTo: userId)
                          .where('category', isEqualTo: _selectedCategory)
                          .orderBy('time', descending: true)
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
                      print(snapshot.hasData);
                      print(userId);
                      print(_selectedCategory);
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
                                date: quizResult.time,
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
  final DateTime date;
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
    rankColor = Colors.white;
    String currentPhoneDate = DateFormat('EEE d MMMy, hh:mm:ss a').format(date);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(maxWidth: 600),
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
              offset: const Offset(0, 2),
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
                    Text(
                      '${index + 1}. ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(avatarUrl),
                      radius: 20,
                    ),
                    const SizedBox(width: 16),
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
                        const SizedBox(height: 4),
                        //Column(
                        // children: [
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          currentPhoneDate,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        //],
                        //),
                      ],
                    ),
                  ],
                ),
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
                    const SizedBox(width: 6),
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
                    const SizedBox(width: 6),
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
                    const SizedBox(width: 6),
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
                          timeTaken,
                          style: TextStyle(
                            fontSize: 12,
                            color: fontColor,
                          ),
                        ),
                      ],
                    )
                  ],
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
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        points.toString(),
                        style: const TextStyle(
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
