import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_anzan/models/resultmodel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flash_anzan/provider/userProvider.dart';

class UserProfile extends StatefulWidget {
  /* final String name;
  final String email;
  final String photoUrl;
  final String level;

  const UserProfile({
    Key? key,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.level,
  }) : super(key: key);
*/
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int _totalEntries = 0;
  int _totalPoints = 0;
  int _totalQuestions = 0;
  int _correct = 0;
  int _currentStreak = 0;
  int _maxStreak = 0;
  int _typeTotalEntries = 0;
  int _typeTotalPoints = 0;
  int _typeTotalQuestions = 0;
  int _typeTotalCorrect = 0;
  String _selectedCategory = "Overall";
  @override
  void initState() {
    super.initState();
    _getQuizResults(_selectedCategory);
  }

  Future<Map<String, int>> getQuizResults(
      String userId, String category) async {
    final querySnapshot;
    if (category == "Overall") {
      querySnapshot = await FirebaseFirestore.instance
          .collection('quizResults')
          .where('userId', isEqualTo: userId)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('quizResults')
          .where('userId', isEqualTo: userId)
          .where('category', isEqualTo: _selectedCategory)
          .get();
    }

    final quizResults = querySnapshot.docs
        .map((documentSnapshot) =>
            QuizResult.fromMap(documentSnapshot.data(), documentSnapshot.id))
        .toList();
    int totalEntries = 0;
    dynamic totalPoints = 0;
    dynamic totalQuestions = 0;
    dynamic correct = 0;
    for (final quizResult in quizResults) {
      totalEntries += 1;
      totalPoints += quizResult.points;
      totalQuestions += quizResult.questions;
      correct += quizResult.marks;
    }

    return {
      'totalEntries': totalEntries,
      'totalPoints': totalPoints,
      'totalQuestions': totalQuestions,
      'correct': correct
    };
  }

  Future<void> _getQuizResults(String category) async {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    // Get the quiz results for the current user and category
    final Map<String, dynamic> results =
        await getQuizResults(user.uid, category);

    // Extract the total entries and points from the returned results
    int totalEntries = results['totalEntries'];
    int totalPoints = results['totalPoints'];
    int totalQuestion = results['totalQuestions'];
    int correct = results['correct'];

    final practiceStreak = await calculateStreak(user.uid);

    //print('Current practice streak: $practiceStreak');
    //print(practiceStreak.currentStreak);
    //print(practiceStreak.maxStreak);
    setState(() {
      _totalEntries = totalEntries;
      _totalPoints = totalPoints;
      _totalQuestions = totalQuestion;
      _correct = correct;
      _currentStreak = practiceStreak.currentStreak;
      _maxStreak = practiceStreak.maxStreak;
    });
  }

  Future<Streak> calculateStreak(String userId) async {
    final sessionsSnapshot = await FirebaseFirestore.instance
        .collection('quizResults')
        .where('userId', isEqualTo: userId)
        .orderBy('time', descending: true)
        .get();
    //print("map session: ");
    final sessions = sessionsSnapshot.docs
        .map((doc) => PracticeSession.fromMap(doc.data()))
        .toList();
    //print(sessions);
    final streak = Streak();
    final today = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    bool firstStreak = true;
    int streakTemp = 0;
    int currentDay = today.day;
    int first = DateTime.parse(sessions[0].timestamp).day;
    if (currentDay == first) {
      streak.currentStreak++;
      firstStreak = true;
    }
    for (int i = 0; i < sessions.length - 1; i++) {
      //print("${sessions[i].timestamp},-->${sessions[i].id}");
      final sessionDate = DateTime.parse(sessions[i].timestamp);
      final nextSessionDate = DateTime.parse(sessions[i + 1].timestamp);
      final hoursSince = sessionDate.difference(nextSessionDate).inHours;
      //final currentDay = today.day;
      int day = sessionDate.day;
      int nextDay = nextSessionDate.day;

      if (firstStreak) {
        if ((currentDay - day).abs() == 1) {
          streak.currentStreak++;
          currentDay = day;
        } else if (currentDay == day) {
        } else {
          firstStreak = false;
        }
      }
      if (day == nextDay) {
        continue;
      } else {
        if ((day - nextDay).abs() == 1) {
          streakTemp++;
        } else {
          if (hoursSince <= 24) {
            streakTemp++;
          } else {
            streakTemp = 0;
          }
        }
      }
      if (streakTemp > streak.maxStreak) {
        streak.maxStreak = streakTemp;
      }
    }
    //print(streak.currentStreak);
    //print(streak.maxStreak);
    return streak;
  }

  void _showPopup(String title) {
    //_getQuizTypeStats(_selectedCategory);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        //int accuracy = (_typeTotalCorrect ~/ _typeTotalQuestions) * 100;
        return AlertDialog(
          title: Text(title),
          content: Text(
              '$title Quiz:$_typeTotalEntries\nTotal Questions:$_typeTotalQuestions\nCorrect Answers:$_typeTotalCorrect\nAccuracy:0\nPoints:$_typeTotalPoints'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userP = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      CircleAvatar(
                        backgroundImage: NetworkImage(userP?.photoUrl ??
                            "https://firebasestorage.googleapis.com/v0/b/abacusplusflash.appspot.com/o/asset%2Favatar.jpg?alt=media&token=64ab58be-1567-42a3-be6f-af81de791a1f"),
                        radius: 40,
                        //backgroundColor: Colors.grey[300],
                        /* child: Text(
                          widget.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),*/
                      ),
                      SizedBox(height: 10),
                      Text(
                        userP?.displayName?.toUpperCase() ?? 'Guest',
                        style: TextStyle(fontSize: 22),
                      ),
                      Text(
                        userP?.level ?? '',
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange, // background
                          onPrimary: Colors.white, // foreground
                          shape: RoundedRectangleBorder(
                              //to set border radius to button
                              borderRadius: BorderRadius.circular(4)),
                          padding:
                              const EdgeInsets.fromLTRB(52.0, 12.0, 52.0, 12.0),
                        ),
                        onPressed: () {
                          final user = FirebaseAuth.instance.currentUser;
                          Navigator.pushNamed(context, "/editProfile");
                          // arguments: user!.uid);
                        },
                        child: Text('Edit Profile'),
                      ),
                      const SizedBox(height: 25),
                      DropdownButton<String>(
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
                            _getQuizResults(_selectedCategory);
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
                      const SizedBox(height: 10),
                      PerformanceWidget(
                        title: _selectedCategory,
                        totalQuestions: _totalQuestions,
                        correctAnswers: _correct,
                        totalEntries: _totalEntries,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange, // background
                          onPrimary: Colors.white, // foreground
                          shape: RoundedRectangleBorder(
                              //to set border radius to button
                              borderRadius: BorderRadius.circular(4)),
                          padding:
                              const EdgeInsets.fromLTRB(52.0, 12.0, 52.0, 12.0),
                        ),
                        onPressed: () {
                          final user = FirebaseAuth.instance.currentUser;

                          Navigator.pushNamed(
                            context,
                            "/practiceDetails",
                            arguments: <String, String>{
                              'userId': user!.uid,
                            },
                          );
                        },
                        child: Text('Practice Details'),
                      ),
                      SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              StatsWidget(
                                icon: FontAwesomeIcons.fire,
                                statName: 'Current Streak',
                                statVal: _currentStreak,
                              ),
                              StatsWidget(
                                icon: FontAwesomeIcons.solidGem,
                                statName: 'Total Points',
                                statVal: _totalPoints,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              StatsWidget(
                                icon: FontAwesomeIcons.fire,
                                statName: 'Best Streak',
                                statVal: _maxStreak,
                              ),
                              const StatsWidget(
                                icon: Icons.fire_extinguisher,
                                statName: 'Badges',
                                statVal: 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange, // background
                          onPrimary: Colors.white, // foreground
                          shape: RoundedRectangleBorder(
                              //to set border radius to button
                              borderRadius: BorderRadius.circular(4)),
                          padding:
                              const EdgeInsets.fromLTRB(52.0, 12.0, 52.0, 12.0),
                        ),
                        onPressed: () {},
                        child: Text('Your Achievements'),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class PracticeSession {
  final String id;
  final String userId;
  final String timestamp;

  PracticeSession({
    required this.id,
    required this.userId,
    required this.timestamp,
  });

  factory PracticeSession.fromMap(Map<String, dynamic> map) {
    return PracticeSession(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      timestamp: map['time'] ?? Timestamp(0, 0),
    );
  }
}

class Streak {
  int currentStreak = 0;
  int maxStreak = 0;
}

class QuizTypeDetail {
  int totalQuizs = 0;
  int totalQuestions = 0;
  int marks = 0;
  int points = 0;
}

class PerformanceWidget extends StatefulWidget {
  const PerformanceWidget({
    Key? key,
    required this.title,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalEntries,
  }) : super(key: key);
  final String title;
  final int totalEntries;
  final int totalQuestions;
  final int correctAnswers;

  @override
  State<PerformanceWidget> createState() => _PerformanceWidgetState();
}

class _PerformanceWidgetState extends State<PerformanceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.purple,
      ),
      child: Column(
        children: [
          Text(
            '${widget.title} Performance',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Quiz: ${widget.totalEntries}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                'Total Questions: ${widget.totalQuestions}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Accuracy: ${((widget.correctAnswers / widget.totalQuestions) * 100).toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                'Correct Answers: ${widget.correctAnswers}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatsWidget extends StatelessWidget {
  const StatsWidget({
    Key? key,
    required this.icon,
    required this.statName,
    required this.statVal,
  }) : super(key: key);

  final IconData icon;
  final String statName;
  final int statVal;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(maxWidth: 150),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              Column(
                children: [
                  Text(
                    "$statVal",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    statName,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
