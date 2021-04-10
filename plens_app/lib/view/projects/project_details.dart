import 'package:flutter/material.dart';
import 'package:plens_app/models/project.dart';
import 'package:plens_app/models/user.dart';
import 'package:plens_app/services/database.dart';
import 'package:plens_app/shared/loading.dart';
import 'package:plens_app/view/projects/project_edit.dart';
import 'package:plens_app/view/users/user_tile.dart';

class ProjectDetails extends StatefulWidget {
  final Project project;
  ProjectDetails({this.project});

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.project.abbreviation),
          actions: <Widget>[
            ElevatedButton(
                child: Text('Edit'),
                onPressed: () {
                  _showEditProject();
                })
          ],
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  color: Colors.blue[900],
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text(
                    widget.project.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
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
                        child: Text('Address' +
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
                    'Customer',
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
                    'E-mail: ' +
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
}
