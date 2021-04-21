import 'package:flutter/material.dart';
import 'package:plens_app/models/project.dart';
import 'package:plens_app/view/projects/project_tile.dart';
import 'package:provider/provider.dart';

class ProjectList extends StatefulWidget {
  @override
  _ProjectListState createState() => _ProjectListState();
}

// this widget creates a list of projects
class _ProjectListState extends State<ProjectList> {
  @override
  Widget build(BuildContext context) {
    //fallback for errors
    final projects = Provider.of<List<Project>>(context) ?? [];

    return ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return ProjectTile(
            project: projects[index],
          );
        });
  }
}
