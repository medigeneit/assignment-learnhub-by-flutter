import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:learnhub/config/api_config.dart';
import 'package:learnhub/models/category.dart';
import 'package:learnhub/models/course.dart';

class ApiService {
  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories (${response.statusCode})');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Category.fromJson(item)).toList();
  }

  Future<List<Course>> getCourses({int? categoryId}) async {
    final uri = categoryId == null
        ? Uri.parse('$baseUrl/courses')
        : Uri.parse('$baseUrl/courses?category=$categoryId');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load courses (${response.statusCode})');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Course.fromJson(item)).toList();
  }
}
