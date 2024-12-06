import 'package:flutter/material.dart';
import 'package:course_management_app/models/course.dart';

class CourseListItem extends StatelessWidget {
  final CourseModel course;
  final bool isSelected;
  final Function()? onTap;
  final Widget leading;

  const CourseListItem({
    super.key,
    required this.course,
    required this.isSelected,
    required this.onTap,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(course.title),
      subtitle: Text(course.description),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
      onTap: onTap,
    );
  }
}
