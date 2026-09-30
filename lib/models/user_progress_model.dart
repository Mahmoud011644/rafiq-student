class UserProgress {
  final String userId;
  final DateTime lastLoginDate;
  final int totalLessonsCompleted;
  final int totalQuizzesCompleted;
  final double overallProgress;
  final Map<String, CourseProgress> courseProgress;

  UserProgress({
    required this.userId,
    required this.lastLoginDate,
    required this.totalLessonsCompleted,
    required this.totalQuizzesCompleted,
    required this.overallProgress,
    required this.courseProgress,
  });
}

class CourseProgress {
  final String courseId;
  final int completedLessons;
  final int totalLessons;
  final double progressPercentage;
  final List<int> quizScores;
  final DateTime? lastAccessDate;

  CourseProgress({
    required this.courseId,
    required this.completedLessons,
    required this.totalLessons,
    required this.progressPercentage,
    required this.quizScores,
    this.lastAccessDate,
  });
}
