import 'package:flutter/material.dart';

class PerformanceWidget extends StatelessWidget {
  final int totalQuizzes;
  final int totalScore;

  const PerformanceWidget(
      {required this.totalQuizzes, required this.totalScore});

  double get averageScore => totalScore / totalQuizzes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Performance',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Quizzes:',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '$totalQuizzes',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Score:',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '$totalScore',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Average Score:',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '${averageScore.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
