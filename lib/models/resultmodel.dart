class QuizResult {
  late String id;
  late String userId;
  late String category;
  late String level;
  late int marks;
  late DateTime time;

  QuizResult({
    required this.category,
    required this.level,
    required this.marks,
    required this.time,
  });

  QuizResult.fromMap(Map<String, dynamic> data, String id)
      : id = id,
        userId = data['userId'],
        category = data['category'],
        level = data['level'],
        marks = data['marks'],
        time = DateTime.parse(data['time']);

  Map<String, Object> toMap() {
    return {
      'userId': userId,
      'category': category,
      'level': level,
      'marks': marks,
      'time': time.toIso8601String(),
    };
  }
}
