import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:course_management_app/screens/search_screen.dart';
import 'package:course_management_app/screens/summary_screen.dart';
import 'package:course_management_app/widgets/course_list_item.dart';
import 'package:course_management_app/providers/course_provider.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final ScrollController _scrollController = ScrollController();
  final Set<int> _selectedCourseIds = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CourseProvider>(context, listen: false).fetchCourses();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<CourseProvider>(context, listen: false).fetchCourses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _navigateToSearch(context),
          ),
        ],
      ),
      body: Consumer<CourseProvider>(
        builder: (context, courseProvider, child) {
          if (courseProvider.courses.isEmpty && courseProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return courseProvider.errorMessage != null
              ? Center(
                  child: Text(
                    courseProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ) // Show error message if present
              : courseProvider.courses.isEmpty
                  ? const Center(
                      child: Text(
                        "No courses available.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ) // Show empty state
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: courseProvider.courses.length +
                          (courseProvider.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == courseProvider.courses.length) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.amber,
                          ));
                        }

                        final course = courseProvider.courses[index];
                        return CourseListItem(
                          leading: index / 2 == 0
                              ? Hero(
                                  tag: course.id.toString(),
                                  child: const FlutterLogo())
                              : Hero(
                                  tag: course.id.toString(),
                                  child: Image.network(
                                      'https://upload.wikimedia.org/wikipedia/commons/7/7e/Dart-logo.png',
                                      height: 30,
                                      width: 30)),
                          course: course,
                          isSelected: _selectedCourseIds.contains(course.id),
                          onTap: () {
                            setState(() {
                              if (_selectedCourseIds.contains(course.id)) {
                                _selectedCourseIds.remove(course.id);
                              } else {
                                _selectedCourseIds.add(course.id);
                              }
                            });
                          },
                        );
                      },
                    );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectedCourseIds.isNotEmpty
            ? () => _navigateToSummary(context)
            : null,
        child: const Icon(Icons.check),
      ),
    );
  }

  void _navigateToSearch(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  void _navigateToSummary(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SummaryScreen(selectedCourseIds: _selectedCourseIds.toList()),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
