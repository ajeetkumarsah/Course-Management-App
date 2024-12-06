import 'package:flutter/foundation.dart';
import 'package:course_management_app/models/course.dart';
import 'package:course_management_app/services/api_service.dart';

class CourseProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final List<CourseModel> _courses = [];
  List<CourseModel> _searchResults = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _limit = 12;
  String? _errorMessage;

  List<CourseModel> get courses => _courses;
  List<CourseModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  Future<void> fetchCourses() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newCourses = await _apiService.fetchCourses(
          _currentPage, (_courses.length + _limit));
      // debugPrint('===>RESP:- ${newCourses.toString()}');
      if (newCourses.isEmpty) {
        _errorMessage = "No courses available.";
      } else {
        _courses.clear();
        _courses.addAll(newCourses);
        _currentPage++;
        _hasMore = newCourses.length == _courses.length;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<CourseModel>> searchCourses(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchCourses(query);
      return _searchResults;
    } catch (e) {
      debugPrint('Error searching courses: $e');
      _searchResults = [];
      return _searchResults;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitUserData(
      String name, String email, List<int> selectedCourseIds) async {
    try {
      return await _apiService.submitUserData(name, email, selectedCourseIds);
    } catch (e) {
      debugPrint('Error submitting user data: $e');
      return false;
    }
  }
}
