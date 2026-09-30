import 'package:flutter/material.dart';
import '../data/courses_data.dart';
import '../services/local_storage_service.dart';
import '../widgets/course_card.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _selectedCategory = 'الكل';
  late List<dynamic> _filteredCourses;

  @override
  void initState() {
    super.initState();
    _filteredCourses = CoursesData.allCourses;
    _loadFavoritesAndProgress();
  }

  Future<void> _loadFavoritesAndProgress() async {
    final favorites = await LocalStorageService.getFavorites();
    for (var course in CoursesData.allCourses) {
      course.isFavorite = favorites.contains(course.id);
      final progress = await LocalStorageService.getProgress(course.id);
      if (progress != null) {
        course.progressPercentage = progress['progressPercentage'];
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'الكل') {
        _filteredCourses = CoursesData.allCourses;
      } else {
        _filteredCourses = CoursesData.allCourses
            .where((course) => course.category == category)
            .toList();
      }
    });
  }

  Future<void> _toggleFavorite(var course) async {
    setState(() {
      course.isFavorite = !course.isFavorite;
    });
    if (course.isFavorite) {
      await LocalStorageService.addFavorite(course.id);
    } else {
      await LocalStorageService.removeFavorite(course.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      'الكل',
      'الحاسوب',
      'البرمجة',
      'البرمجيات',
      'الكهرباء',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الدورات'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: categories.map((category) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) => _filterByCategory(category),
                  ),
                )).toList(),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: _filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = _filteredCourses[index];
                  return CourseCard(
                    course: course,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(course.title)),
                      );
                    },
                    onFavoriteTap: () => _toggleFavorite(course),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
