import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:course_management_app/models/course.dart';

class ApiService {
  final String baseUrl =
      'https://freetestapi.com/api/v1'; //Replace with actual base URL

  Future<List<CourseModel>> fetchCourses(int page, int limit) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/books?limit=$limit'))
          .timeout(const Duration(seconds: 30));
      debugPrint(
          "====> Course : ${response.statusCode} url: $baseUrl/books?limit=$limit");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data as List)
            .map((course) => CourseModel.fromJson(course))
            .toList();
      } else {
        throw Exception('Failed to load courses!');
      }
    } on TimeoutException catch (_) {
      throw Exception("Request timed out. Please try again.");
    }
  }

  Future<List<CourseModel>> searchCourses(String query) async {
    try {
      // https://freetestapi.com/api/v1/books?search=[query]
      final response = await http
          .get(Uri.parse('$baseUrl/books?search=$query'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data as List)
            .map((course) => CourseModel.fromJson(course))
            .toList();
      } else {
        throw Exception('Failed to search courses');
      }
    } on TimeoutException catch (_) {
      throw Exception("Request timed out. Please try again.");
    }
  }

  Future<bool> submitUserData(
      String name, String email, List<int> selectedCourseIds) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/submit'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'name': name,
              'email': email,
              'selectedCourses': selectedCourseIds,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'success';
      } else {
        throw Exception('Failed to submit user data');
      }
    } on TimeoutException catch (_) {
      throw Exception("Request timed out. Please try again.");
    }
  }
}
