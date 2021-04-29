import 'package:flutter/material.dart';
import 'package:plens_app/models/project.dart';
import 'package:plens_app/view/projects/project_details.dart';

class ProjectTile extends StatelessWidget {
  // setting the project object given by a previous Widget
  final Project project;
  ProjectTile({this.project});

  // this Widgets builds a Card filled with the information given by the project object
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          title: Text(
            project.abbreviation + ' - ' + project.name,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            project.customer + ' - ' + project.contact,
            style: TextStyle(fontSize: 15),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProjectDetails(
                          project: project,
                        )));
          },
        ),
      ),
    );
  }
}
