import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../data/courses_data.dart';
import '../services/local_storage_service.dart';
import '../widgets/course_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/lesson_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Course> _displayedCourses;
  late List<Course> _allCourses;

  @override
  void initState() {
    super.initState();
    _allCourses = CoursesData.allCourses;
    _displayedCourses = _allCourses;
    _loadFavoritesAndProgress();
  }

  Future<void> _loadFavoritesAndProgress() async {
    final favorites = await LocalStorageService.getFavorites();
    for (var course in _allCourses) {
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

  void _handleSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _displayedCourses = _allCourses;
      });
    } else {
      setState(() {
        _displayedCourses = _allCourses
            .where((course) =>
                course.title.contains(query) ||
                course.description.contains(query) ||
                course.category.contains(query))
            .toList();
      });
    }
  }

  Future<void> _toggleFavorite(Course course) async {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('رفيق الطالب'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اهلا بك رب الطالب 👋',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'ابدأ رحلتك التعليمية اليوم',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomSearchBar(
                  controller: _searchController,
                  onChanged: _handleSearch,
                  onClear: () {
                    _searchController.clear();
                    _handleSearch('');
                  },
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'النمناص المتاحة',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              _buildCategoriesSection(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'الدورات المقترحة',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              _buildCoursesGrid(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to AI assistant
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('المساعد الذكي')),
                    );
                  },
                  icon: const Icon(Icons.smart_toy),
                  label: const Text('المساعد الذكي'),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to lesson summarizer
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تلخيص الدرس')),
                    );
                  },
                  icon: const Icon(Icons.summarize),
                  label: const Text('تلخيص درس'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = ['الحاسوب', 'البرمجة', 'البرمجيات', 'الكهرباء'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: categories.map((category) => Padding(
          padding: const EdgeInsets.only(left: 8),
          child: FilterChip(
            label: Text(category),
            onSelected: (selected) {},
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildCoursesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: _displayedCourses.length,
      itemBuilder: (context, index) {
        final course = _displayedCourses[index];
        return CourseCard(
          course: course,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailScreen(course: course),
              ),
            );
          },
          onFavoriteTap: () => _toggleFavorite(course),
        );
      },
    );
  }
}

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late List<bool> _completedLessons;

  @override
  void initState() {
    super.initState();
    _completedLessons = List.filled(widget.course.lessons.length, false);
    _loadCompletedLessons();
  }

  Future<void> _loadCompletedLessons() async {
    for (int i = 0; i < widget.course.lessons.length; i++) {
      final isCompleted = await LocalStorageService.isLessonCompleted(
        widget.course.lessons[i].id,
      );
      if (mounted) {
        setState(() {
          _completedLessons[i] = isCompleted;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey[200],
                child: Center(
                  child: Text(
                    widget.course.imageUrl,
                    style: const TextStyle(fontSize: 64),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.course.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(widget.course.difficulty),
                        ),
                        Chip(
                          label: Text(
                            '${widget.course.lessons.length} درس',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: widget.course.progressPercentage / 100,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'التقدم: ${widget.course.progressPercentage.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'الدروس',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      widget.course.lessons.length,
                      (index) {
                        final lesson = widget.course.lessons[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(lesson.title),
                            subtitle: Text(
                              _completedLessons[index]
                                  ? '✅ مكتمل'
                                  : 'قيد المراجعة',
                            ),
                            trailing: _completedLessons[index]
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : const Icon(Icons.circle_outlined),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LessonContentScreen(
                                    lesson: lesson,
                                    onMarkAsCompleted: () async {
                                      await LocalStorageService
                                          .markLessonCompleted(
                                        lesson.id,
                                        widget.course.id,
                                      );
                                      final completedCount =
                                          _completedLessons.where((c) => c)
                                              .length +
                                              1;
                                      await LocalStorageService.saveProgress(
                                        widget.course.id,
                                        completedCount,
                                        widget.course.lessons.length,
                                      );
                                      if (mounted) {
                                        setState(() {
                                          _completedLessons[index] = true;
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
