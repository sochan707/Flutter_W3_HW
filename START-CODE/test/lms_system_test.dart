import 'package:lms_layered_architecture_example/model/score.dart';
import 'package:test/test.dart';

import '../lib/service/lms_system.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");

    expect(lms.students.first.name, 'ronan');

    // Remove the student
    lms.removeStudent(studentId: 'S1');
    expect(lms.students.length, 0);
  });

  test('create course', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'c1', courseName: 'hello');

    expect(lms.courses.any((course) => course.id == 'c1'), isTrue);
  });

  test('duplicate course id', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: "c1", courseName: "hi");

    expect(
        () => lms.addCourse(courseId: "c1", courseName: "hi"), throwsException);
  });

  test("Remove none exist course", () {
    final lms = LmsSystem();

    expect(() => lms.removeCourse('c2'), throwsException);
  });

  test("Student enroll success", () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: 'nana');
    lms.addCourse(courseId: 'c1', courseName: 'dart');
    lms.enrollStudent('s1', 'c1');

    expect(
        lms.courses.firstWhere((c) => c.id == 'c1').studentIds.contains('s1'),
        isTrue);
  });

  test("Student duplicated enrollment", () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: 'nana');
    lms.addCourse(courseId: 'c1', courseName: 'dart');
    lms.enrollStudent('s1', 'c1');

    expect(() => lms.enrollStudent('s1', 'c1'), throwsException);
  });

  test("Student enroll to nonexist course", () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: 'nana');

    expect(() => lms.enrollStudent('s1', 'c1'), throwsException);
  });

  test("Nonexist student enrollment", () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'c1', courseName: 'dart');

    expect(() => lms.enrollStudent('s1', 'c1'), throwsException);
  });

  test("successful unenrollment", () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: 'nana');
    lms.addCourse(courseId: 'c1', courseName: 'dart');
    lms.enrollStudent('s1', 'c1');

    lms.discardStudentFromCourse('s1', 'c1');

    expect(lms.courses.any((c) => c.id == 'c1'), isTrue);
    expect(lms.students.any((s) => s.id == 's1'), isTrue);
    expect(
        lms.courses.firstWhere((c) => c.id == 'c1').studentIds.contains('s1'),
        isFalse);
  });

  test("Reject removal of a nonexistent enrollment", () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: 'nana');
    lms.addCourse(courseId: 'c1', courseName: 'dart');

    expect(() => lms.discardStudentFromCourse('s1', 'c1'), throwsException);
  });

  test("Testing score removal", () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: 'nana');
    lms.addCourse(courseId: 'c1', courseName: 'dart');
    lms.addCourse(courseId: 'c2', courseName: 'flutter');
    lms.enrollStudent('s1', 'c1');
    lms.enrollStudent('s1', 'c2');
    lms.scores.add(Score(id: 1, score: 43, courseId: 'c1', studentId: 's1'));
    lms.scores.add(Score(id: 2, score: 80, courseId: 'c2', studentId: 's1'));
    lms.discardStudentFromCourse('s1', 'c1');

    expect(lms.scores.any((s) => s.courseId == 'c1' && s.studentId == 's1'), isFalse);
    expect(lms.scores.any((s) => s.courseId == 'c2' && s.studentId == 's1'), isTrue);
  });

  test("removing a student who has enrollments in multiple courses", (){
    final lms = LmsSystem();

    lms.addStudent(studentId: 's1', studentName: 'mimi');
    lms.addCourse(courseId: 'c1', courseName: 'dart');
    lms.addCourse(courseId: 'c2', courseName: 'reactjs');
    lms.addCourse(courseId: 'c3', courseName: 'flutter');

    lms.enrollStudent('s1', 'c1');
    lms.enrollStudent('s1', 'c2');
    lms.enrollStudent('s1', 'c3');

    lms.discardStudentFromCourse('s1', 'c2');

    expect(lms.courses.firstWhere((c) => c.id == 'c2').studentIds.contains('s1'), isFalse);
    expect(lms.courses.firstWhere((c) => c.id == 'c1').studentIds.contains('s1'), isTrue);
    expect(lms.courses.firstWhere((c) => c.id == 'c3').studentIds.contains('s1'), isTrue);
  });
}
