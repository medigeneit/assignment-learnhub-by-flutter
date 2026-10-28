import 'package:flutter/material.dart';

import 'package:learnhub/models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(course.title),
          Text(course.shortSummary),
          Text('৳ ${course.price}'),
          TextButton(
            onPressed: () {}, // TODO: Course detail page
            child: const Text('Details'),
          ),
        ],
      ),
    );
  }
}
