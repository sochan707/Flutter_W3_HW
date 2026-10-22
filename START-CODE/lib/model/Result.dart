import 'package:lms_layered_architecture_example/model/score.dart';

class Result {
  final String studentId;
  final String courseId;
  final int score;

  Result({required String this.studentId, required String this.courseId, required int this.score});
}