import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String name;
  final String email;
  final String photoUrl;
  const UserProfile({
    Key? key,
    required this.name,
    required this.email,
    required this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        // add SingleChildScrollView widget here
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Text(
                  name.substring(0, 1).toUpperCase(),
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(height: 5),
              Text(
                email,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              const PerformanceWidget(
                totalQuestions: 20,
                correctAnswers: 15,
                incorrectAnswers: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text('Change Profile Picture'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PerformanceWidget extends StatelessWidget {
  const PerformanceWidget({
    Key? key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
  }) : super(key: key);

  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Column(
        children: [
          Text(
            'Overall Performance',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Questions: $totalQuestions'),
              Text('Correct Answers: $correctAnswers'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Incorrect Answers: $incorrectAnswers'),
              Text(
                'Accuracy: ${((correctAnswers / totalQuestions) * 100).toStringAsFixed(2)}%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
