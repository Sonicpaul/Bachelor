import 'package:flutter/material.dart';
import 'package:plens_app/models/project.dart';
import 'package:plens_app/services/database.dart';
import 'package:plens_app/view/projects/project_add.dart';
import 'package:plens_app/view/projects/project_list.dart';
import 'package:plens_app/view/wrapper.dart';
import 'package:provider/provider.dart';

// this Widget is the main Widget for the Project Page
// this Widget provides the next Widgets with information from the database
class ProjectWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _addANewProject() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              height: MediaQuery.of(context).size.height * 0.95,
              child: AddAProject(),
            );
          });
    }

    return StreamProvider<List<Project>>.value(
        value: DatabaseService().projects,
        initialData: [],
        child: Scaffold(
          backgroundColor: Colors.blue[100],
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.house,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Wrapper())),
            ),
            title: Text('Projects'),
            elevation: 1.0,
            actions: <Widget>[
              ElevatedButton.icon(
                  icon: Icon(Icons.folder),
                  label: Text('Add a project'),
                  onPressed: () => _addANewProject()),
            ],
          ),
          body: ProjectList(),
        ));
  }
}
