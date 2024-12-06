import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:course_management_app/models/course.dart';
import 'package:course_management_app/services/api_service.dart';
import 'package:course_management_app/providers/course_provider.dart';

// Mock class for ApiService using mockito
class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;
  late CourseProvider courseProvider;

  // This is executed before each test runs
  setUp(() {
    mockApiService = MockApiService();
    courseProvider = CourseProvider();
    courseProvider.apiService = mockApiService; // Inject mock service
  });

  // This is executed after each test runs
  tearDown(() {
    // Optionally reset any state after each test (if necessary)
  });

  group('searchCourses', () {
    // Test: Successfully fetching search results
    test('should return a list of courses when the search is successful', () async {
      // Arrange: Mock response from the API service
      final List<CourseModel> mockCourses = [
        CourseModel(
          id: 1,
          title: 'Flutter Development',
          author: 'John Doe',
          description: 'Learn Flutter from scratch',
          coverImage: 'flutter_cover.jpg',
        ),
        CourseModel(
          id: 2,
          title: 'Dart for Beginners',
          author: 'Jane Smith',
          description: 'Introductory course on Dart',
          coverImage: 'dart_cover.jpg',
        ),
      ];
      when(mockApiService.searchCourses('flutter'))
          .thenAnswer((_) async => mockCourses);

      // Act: Perform the search operation
      final result = await courseProvider.searchCourses('flutter');

      // Assert: Check that the result is a list of courses
      expect(result, isA<List<CourseModel>>());
      expect(result.length, 2);
      expect(result[0].title, 'Flutter Development');
      expect(result[1].title, 'Dart for Beginners');
      expect(courseProvider.isLoading, false); // Ensure loading state is false after search completes
    });

    // Test: No results found (empty response)
    test('should return an empty list when no courses match the query', () async {
      // Arrange: Mock API response for an empty list
      when(mockApiService.searchCourses('unknown'))
          .thenAnswer((_) async => []);

      // Act: Perform the search operation
      final result = await courseProvider.searchCourses('unknown');

      // Assert: Check that no courses are returned
      expect(result, isA<List<CourseModel>>());
      expect(result.isEmpty, true);
      expect(courseProvider.isLoading, false); // Ensure loading state is false after search completes
    });

    // Test: Error handling when the API call fails
    test('should handle errors and return an empty list when the API call fails', () async {
      // Arrange: Simulate an exception in the API
      when(mockApiService.searchCourses('error'))
          .thenThrow(Exception('Failed to fetch courses'));

      // Act: Perform the search operation
      final result = await courseProvider.searchCourses('error');

      // Assert: Ensure an empty list is returned and isLoading is false
      expect(result, isA<List<CourseModel>>());
      expect(result.isEmpty, true);
      expect(courseProvider.isLoading, false); // Ensure loading state is false after search completes
      expect(courseProvider.errorMessage, isNotNull); // Error message should be set
    });

    // Test: Verify that `isLoading` is set to true during search
    test('should set isLoading to true while searching and false after search completes', () async {
      // Arrange: Mock the API response
      final List<CourseModel> mockCourses = [
        CourseModel(
          id: 1,
          title: 'Flutter for Beginners',
          author: 'Alice',
          description: 'Beginner course on Flutter',
          coverImage: 'beginner_flutter_cover.jpg',
        ),
      ];
      when(mockApiService.searchCourses('flutter'))
          .thenAnswer((_) async => mockCourses);

      // Act: Perform the search operation
      final future = courseProvider.searchCourses('flutter');

      // Assert: Ensure isLoading is true before the search finishes
      expect(courseProvider.isLoading, true);

      await future;

      // Assert: Ensure isLoading is false after the search finishes
      expect(courseProvider.isLoading, false);
    });

    test('should not initiate a search if already loading', () async {
  // Arrange: Mock API response
  final List<CourseModel> mockCourses = [
    CourseModel(
      id: 1,
      title: 'Advanced Flutter',
      author: 'Robert',
      description: 'Deep dive into Flutter',
      coverImage: 'advanced_flutter_cover.jpg',
    ),
  ];
  
  when(mockApiService.searchCourses('flutter')).thenAnswer((_) async => mockCourses);

  // Act: Perform the first search that will set isLoading to true
  final firstSearch = courseProvider.searchCourses('flutter');
  
  // Attempt to perform a second search while the provider is loading
  await courseProvider.searchCourses('flutter');
  
  // Assert: Ensure that the search is not triggered a second time
  verify(mockApiService.searchCourses('flutter')).called(1);  // Search should be called only once
  
  // Wait for the first search to complete
  await firstSearch;
});

  });
}
