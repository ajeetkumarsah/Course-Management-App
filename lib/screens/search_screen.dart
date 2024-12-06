import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:course_management_app/providers/course_provider.dart';
import 'package:course_management_app/widgets/course_list_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
 
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    Provider.of<CourseProvider>(context, listen: false).searchCourses(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Search Courses'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Consumer<CourseProvider>(
              builder: (context, courseProvider, child) {
                if (courseProvider.isLoading) {
                  return  const Center(child: CircularProgressIndicator());
                }

                if (courseProvider.searchResults.isEmpty) {
                  return const Center(child: Text('No results found'));
                }

                return ListView.builder(
                  itemCount: courseProvider.searchResults.length,
                  itemBuilder: (context, index) {
                    final course = courseProvider.searchResults[index];
                    return CourseListItem(
                      leading: index/2==0?const FlutterLogo():Image.network('https://upload.wikimedia.org/wikipedia/commons/7/7e/Dart-logo.png',height: 30,width:30),
                      course: course,
                      isSelected: false,
                      onTap: () {
                        // Handle course selection if needed
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

