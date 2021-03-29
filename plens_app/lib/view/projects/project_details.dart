import 'package:flutter/material.dart';
import 'package:plens_app/models/project.dart';

class ProjectDetails extends StatelessWidget {
  final Project project;
  ProjectDetails({this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name + " - " + project.abbreviation),
        actions: <Widget>[
          ElevatedButton(
              child: Text('Edit'),
              onPressed:  (){
                //TODO Contextmenü zum ändern
          })
        ],
      ),
      body: Column(
        children: <Widget>[

        ],
      ),
    );
  }
}
