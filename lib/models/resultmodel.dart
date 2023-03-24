class QuizResult {
  late String userId;
  late DateTime time;
  late String category;
  late String digits;
  late int rows;
  late int questions;
  late int marks;
  late String timeTaken;
  late int points;

  QuizResult({
    required this.userId,
    required this.time,
    required this.category,
    required this.digits,
    required this.rows,
    required this.questions,
    required this.marks,
    required this.timeTaken,
    required this.points,
  });

  QuizResult.fromMap(Map<String, dynamic> data, String id)
      : userId = data['userId'],
        category = data['category'],
        digits = data['digits'],
        rows = data['rows'],
        questions = data['questions'],
        marks = data['marks'],
        timeTaken = data['timeTaken'],
        points = data['points'],
        time = DateTime.parse(data['time']);

  Map<String, Object> toMap() {
    return {
      'userId': userId,
      'category': category,
      'marks': marks,
      'digits': digits,
      'rows': rows,
      'questions': questions,
      'timeTaken': timeTaken,
      'points': points,
      'time': time.toIso8601String(),
    };
  }
}
