import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:course_management_app/models/course.dart';
import 'package:course_management_app/services/api_service.dart';
import 'package:course_management_app/providers/course_provider.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  group('CourseProvider Search Tests', () {
    late CourseProvider courseProvider;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      courseProvider = CourseProvider();
      // courseProvider._apiService = mockApiService;
    });

    test('searchCourses should update searchResults', () async {
      // Arrange
      when(mockApiService.searchCourses("fiction")).thenAnswer(
        (_) async => [
          CourseModel(
              id: 1,
              title: "Fiction Book 1",
              author: "Author A",
              genre: [],
              description: '',
              coverImage: ''),
          CourseModel(
              id: 2,
              title: "Fiction Book 2",
              author: "Author B",
              genre: [],
              description: '',
              coverImage: ''),
        ],
      );

      // Act
      final results = await courseProvider.searchCourses('Flutter');

      expect(results, isNotEmpty);
      expect(courseProvider.isLoading, isFalse);
    });

    test('searchCourses should handle empty results', () async {
      when(mockApiService.searchCourses('NonexistentCourse'))
          .thenAnswer((_) async => []);

      await courseProvider.searchCourses('NonexistentCourse');

      expect(courseProvider.searchResults, isEmpty);
      expect(courseProvider.isLoading, isFalse);
    });

    test('searchCourses should handle errors', () async {
      when(mockApiService.searchCourses('ErrorCourse'))
          .thenThrow(Exception('API Error'));

      await courseProvider.searchCourses('ErrorCourse');

      expect(courseProvider.searchResults, isEmpty);
      expect(courseProvider.isLoading, isFalse);
    });
  });
}
