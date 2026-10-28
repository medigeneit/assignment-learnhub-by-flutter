import 'package:flutter/material.dart';

import 'package:learnhub/models/category.dart';
import 'package:learnhub/models/course.dart';
import 'package:learnhub/services/api_service.dart';
import 'package:learnhub/widgets/course_card.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final ApiService _api = ApiService();

  late Future<List<Category>> _categoriesFuture;
  late Future<List<Course>> _coursesFuture;

  // null means "All"
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _api.getCategories();
    _coursesFuture = _api.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LearnHub')),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(child: _buildCourseList()),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return FutureBuilder<List<Category>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Could not load categories'),
          );
        }

        if (!snapshot.hasData) {
          return const SizedBox(height: 56);
        }

        final categories = snapshot.data!;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              _buildChip('All', null),
              for (final category in categories)
                _buildChip(category.name, category.id),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(String label, int? categoryId) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _selectedCategoryId == categoryId,
        onSelected: (_) {
          _selectedCategoryId = categoryId;
          _coursesFuture = _api.getCourses(categoryId: categoryId);
        },
      ),
    );
  }

  Widget _buildCourseList() {
    return FutureBuilder<List<Course>>(
      future: _coursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Something went wrong.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final courses = snapshot.data!;

        if (courses.isEmpty) {
          return const Center(child: Text('No courses found'));
        }

        return ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return CourseCard(course: courses[index]);
          },
        );
      },
    );
  }
}
