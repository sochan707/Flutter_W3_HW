import 'package:lms_layered_architecture_example/model/score.dart';

import '../model/student.dart';
import '../model/course.dart';
import '../model/Result.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<Score> scores = [];
  final List<Result> results = [];
 
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

  Result? _findResult({required String courseId, required String studentId}){
    for(var r in results){
      if(r.courseId == courseId && r.studentId == studentId){
        return r;
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

  void discardStudentFromCourse(String studentId, String courseId){
    Student? student = _findStudentOrNull(studentId);
    Course? course = _findCourse(courseId: courseId);

    if (course == null){
      throw Exception("Course does not existed.");
    }

    if(student == null){
      throw Exception("Student done not existed.");
    }

    bool studentInCourse = course.studentIds.any((id) => id == studentId);

    if(!studentInCourse){
      throw Exception("student $studentId is not in course $courseId");
    } else {
      scores.removeWhere((score) => score.studentId == studentId && score.courseId == courseId);
      course.studentIds.remove(studentId);
    }
  }

  void addResult(String resultId, String studentId, String courseId, int score){
    Student? student = _findStudentOrNull(studentId);
    Course? course = _findCourse(courseId: courseId);
    Result? result = _findResult(courseId: courseId, studentId: studentId);
    bool studentIsEnrolled = courses.any((c) => c.id == courseId && c.studentIds.contains(studentId));

    if(course == null){
      throw Exception("This course does not exist");
    } else if (student == null){
      throw Exception("Student does not exist");
    }

    if(!studentIsEnrolled){
      throw Exception("Student $studentId is not in course $courseId");
    }

    if(score < 0 || score > 100){
      throw Exception("The score must be between 0-100");
    }

    if(result == null){
      results.add(Result(resultId: resultId, studentId: studentId, courseId: courseId, score: score));
    } else {
      throw Exception("The result is already exist");
    }
    
  }

  void removeResult(String resultId){
    bool resultExist = results.any((r) => r.resultId == resultId);
    if (resultExist){
      results.removeWhere((r) => r.resultId == resultId);
    } else {
      throw Exception("Result does not exist.");
    }
  
  }


}
