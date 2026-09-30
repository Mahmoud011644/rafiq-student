import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../data/courses_data.dart';
import '../widgets/course_card.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = CoursesData.allCourses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدورات'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
          ),
          itemCount: _courses.length,
          itemBuilder: (context, index) {
            final course = _courses[index];
            return CourseCard(
              course: course,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم فتح: ${course.title}')),
                );
              },
              onFavoriteTap: () {
                setState(() {
                  course.isFavorite = !course.isFavorite;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
