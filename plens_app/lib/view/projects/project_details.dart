import 'package:flutter/material.dart';
import 'package:plens_app/models/project.dart';
import 'package:plens_app/models/user.dart';
import 'package:plens_app/services/auth.dart';
import 'package:plens_app/services/database.dart';
import 'package:plens_app/shared/loading.dart';
import 'package:plens_app/view/projects/project_Widget.dart';
import 'package:plens_app/view/projects/project_edit.dart';
import 'package:plens_app/view/users/user_tile.dart';

class ProjectDetails extends StatefulWidget {
  final user = AuthService().loggedInUser;
  final Project project;
  ProjectDetails({this.project});
  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

// this widget is used to display all information stored in a project object
class _ProjectDetailsState extends State<ProjectDetails> {
  String error = '';
  double size = 0.0;
  bool isLeader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          actions: <Widget>[
            ElevatedButton.icon(
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                onPressed: () {
                  for (String employee in widget.project.employees) {
                    if (widget.user.uid == employee) {
                      showAlertDialog(context);
                      isLeader = true;
                    }
                  }
                  if (widget.user.uid == widget.project.leader) {
                    if (!isLeader) {
                      showAlertDialog(context);
                    }
                  } else {
                    setState(() {
                      error = 'You are not allowed to delete this project';
                      size = 20;
                    });
                  }
                }),
            ElevatedButton.icon(
                icon: Icon(Icons.edit),
                label: Text('Edit'),
                onPressed: () {
                  for (String employee in widget.project.employees) {
                    if (widget.user.uid == employee) {
                      _showEditProject();
                      isLeader = true;
                    }
                  }
                  if (widget.user.uid == widget.project.leader) {
                    if (!isLeader) {
                      _showEditProject();
                    }
                  } else {
                    setState(() {
                      error = 'You are not allowed to edit this project';
                      size = 20;
                    });
                  }
                })
          ],
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: size),
                ),
                Container(
                  color: Colors.blue[900],
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text(
                    widget.project.name + ' - ' + widget.project.abbreviation,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: displayLeader(),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Flexible(
                        flex: 2,
                        child: Text('Address:' +
                            '\n' +
                            widget.project.addressStreetAndNumber +
                            '\n' +
                            widget.project.addressPostcodeAndCity),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.blue[900],
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text(
                    'Customer & Contact',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  child: Card(
                      margin: EdgeInsets.fromLTRB(20, 6, 20, 6),
                      child: ListTile(
                        title: Text(
                          widget.project.customer +
                              '\n' +
                              widget.project.contact,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
                Container(
                  color: Colors.blue[900],
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text(
                    'Employees',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                displayEmployees(),
              ],
            ),
          ],
        ));
  }

  // an function that makes it possible to edit this specific project
  void _showEditProject() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            height: MediaQuery.of(context).size.height * 0.95,
            child: EditProject(
              project: widget.project,
            ),
          );
        });
  }

  // this widget displays a list of all employees working on this project
  Widget displayEmployees() {
    List<User> employees = [];
    return FutureBuilder<List<User>>(
        future: DatabaseService().getUserList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<User> users = snapshot.data;
            for (User user in users) {
              for (String uid in widget.project.employees) {
                if (user.uid == uid) {
                  employees.add(user);
                }
              }
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: employees.length,
              itemBuilder: (context, index) {
                return UserTile(
                  user: employees[index],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          } else {
            return Loading();
          }
        });
  }

  // this widget is used to dispaly the leader of this project
  Widget displayLeader() {
    return FutureBuilder<List<User>>(
        future: DatabaseService().getUserList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<User> users = snapshot.data;
            for (User leader in users) {
              if (leader.uid == widget.project.leader) {
                return Text('Leader: ' +
                    leader.name +
                    '\n' +
                    'phone: ' +
                    leader.phone +
                    '\n' +
                    'email: ' +
                    leader.email);
              }
            }
            return Container();
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          } else {
            return Loading();
          }
        });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Yes"),
      onPressed: () {
        DatabaseService().deleteProject(widget.project.uid);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (conext) => ProjectWidget()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Stop!"),
      content: Text("Do you really want to delete this project?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
