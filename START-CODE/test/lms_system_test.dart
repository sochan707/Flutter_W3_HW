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

  test('create course', (){
    final lms = LmsSystem();

    lms.addCourse(courseId: 'c1', courseName: 'hello');

    expect(lms.courses.any((course) => course.id == 'c1'), isTrue);
  });

  test('duplicate course id', (){
    final lms = LmsSystem();

    lms.addCourse(courseId: "c1" , courseName: "hi");

    expect(() => lms.addCourse(courseId: "c1" , courseName: "hi"), throwsException);
    
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

    expect(lms.courses.firstWhere((c) => c.id == 'c1').studentIds.contains('s1'), isTrue);
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
 }
