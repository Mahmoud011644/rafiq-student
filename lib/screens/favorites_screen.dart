import 'package:flutter/material.dart';
import '../data/courses_data.dart';
import '../services/local_storage_service.dart';
import '../widgets/course_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<dynamic> _favoriteCourses = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await LocalStorageService.getFavorites();
    setState(() {
      _favoriteCourses = CoursesData.allCourses
          .where((course) => favorites.contains(course.id))
          .toList();
    });
  }

  Future<void> _toggleFavorite(var course) async {
    await LocalStorageService.removeFavorite(course.id);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _favoriteCourses.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد دورات مفضلة',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: _favoriteCourses.length,
                itemBuilder: (context, index) {
                  final course = _favoriteCourses[index];
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
    );
  }
}
