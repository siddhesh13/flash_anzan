import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_anzan/models/resultmodel.dart';
import 'package:intl/intl.dart';

// ignore: non_constant_identifier_names
Future<String> send_result_to_firebase(String operation, String digits,
    int rows, int marks, int point, time, int totalQuestions) async {
  String currentPhoneDate =
      DateFormat('EEE d MMMy, hh:mm:ss a').format(DateTime.now());
  final user = FirebaseAuth.instance.currentUser;
  //print(user!.uid);
  // Then, get the user's data from Firestore based on their user ID
  final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

  // Now you can access the user's data using the `data()` method on the DocumentSnapshot
  final userData = userDoc.data();

  // For example, if your user data contains a `name` field, you can access it like this:
  final userName = userData!['displayName'];

  final quizResult = QuizResult(
    category: operation,
    digits: digits,
    rows: rows,
    questions: totalQuestions,
    marks: marks,
    points: point,
    time: DateTime.now(),
    userId: user.uid,
    timeTaken: time,
  );
  final quizResultCollection =
      FirebaseFirestore.instance.collection('quizResults');
  await quizResultCollection
      .doc("$userName-$currentPhoneDate")
      .set(quizResult.toMap()); //.add(quizResult.toMap());

  return userName;
}
