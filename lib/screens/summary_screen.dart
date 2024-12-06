import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:course_management_app/providers/course_provider.dart';

class SummaryScreen extends StatefulWidget {
  final List<int> selectedCourseIds;

  const SummaryScreen({super.key, required this.selectedCourseIds});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Selected Courses:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: Consumer<CourseProvider>(
                  builder: (context, courseProvider, child) {
                    final selectedCourses = courseProvider.courses
                        .where((course) =>
                            widget.selectedCourseIds.contains(course.id))
                        .toList();

                    return ListView.builder(
                      itemCount: selectedCourses.length,
                      itemBuilder: (context, index) {
                        final course = selectedCourses[index];
                        return ListTile(
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
                          title: Text(course.title),
                          subtitle: Text(course.description),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _submitForm,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.amber,
                  ),
                  child: const Center(child: Text('Submit')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final courseProvider =
          Provider.of<CourseProvider>(context, listen: false);
      final success = await courseProvider.submitUserData(
        _nameController.text,
        _emailController.text,
        widget.selectedCourseIds,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data submitted successfully')),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to submit data. Please try again.')),
        );
      }
    }
  }
}
