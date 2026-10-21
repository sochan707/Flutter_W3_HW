import 'package:lms_layered_architecture_example/model/score.dart';

import '../model/student.dart';
import '../model/course.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<Score> scores = [];
 
  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }
 
  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);
 
  }

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null; // not found
  }

  Course? _findCourse({required String courseId}){
    for(var c in courses){
      if (c.id == courseId){
        return c;
      }
    }
    return null;
  }

  void addCourse({required String courseId, required String courseName}){
    Course? course = _findCourse(courseId: courseId);

    if (course != null){
      throw Exception("The course already exist : $course");
    } else {
      courses.add(Course(id: courseId, name: courseName));
    }
  }

  void removeCourse(String courseId){
    Course? course = _findCourse(courseId: courseId);

    if (course != null){
      scores.removeWhere((score) => score.courseId == courseId);
      courses.remove(course);
    } else {
      throw Exception("The course is not exit.");
    }
  }

  void enrollStudent(String studentId, String courseId){
    Course? course = _findCourse(courseId: courseId);
    Student? student = _findStudentOrNull(studentId);

    if (course == null){
      throw Exception("Course does not existed.");
    }

    if(student == null){
      throw Exception("Student done not existed.");
    }

    bool studentEnrolled = course.studentIds.any((id) => id == studentId);

    if(!studentEnrolled){
      course.studentIds.add(studentId);
    } else {
      throw Exception("student $studentId already enrolled.");
    }
  }
}
