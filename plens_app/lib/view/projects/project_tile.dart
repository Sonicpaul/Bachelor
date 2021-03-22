import 'package:flutter/material.dart';
import 'package:plens_app/models/project.dart';

class ProjectTile extends StatelessWidget {

  final Project project;
  ProjectTile({this.project});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          title: Text(project.abbreviation + ' - ' + project.name),
          subtitle: Text(project.customer + ' - ' +  project.contact),
        ),
      ),
    );
  }
}
