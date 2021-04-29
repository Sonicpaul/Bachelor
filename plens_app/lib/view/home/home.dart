import 'package:flutter/material.dart';
import 'package:plens_app/services/auth.dart';
import 'package:plens_app/view/home/settings_Form.dart';
import 'package:plens_app/view/monthly/monthly_overview.dart';
import 'package:plens_app/view/projects/project_Widget.dart';
import 'package:plens_app/view/time/time_register.dart';
import 'package:plens_app/view/users/user_widget.dart';

// this widget is the Homepage of this app
// it provides the user with the main Features of this app
class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: SettingsForm(),
            );
          });
    }

    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Home'),
          elevation: 1.0,
          actions: <Widget>[
            ElevatedButton.icon(
              icon: Icon(Icons.person),
              label: Text(
                'Logout',
                style: TextStyle(fontSize: 15),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            ElevatedButton.icon(
                onPressed: () => _showSettingsPanel(),
                icon: Icon(Icons.account_circle_rounded),
                label: Text('Profile', style: TextStyle(fontSize: 15)))
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 150,
                  width: 150,
                  child: Material(
                    color: Colors.blue[500],
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserWidget()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.phone,
                            size: 75,
                            color: Colors.white,
                          ),
                          Text(
                            'Contacts',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  width: 150,
                  child: Material(
                    color: Colors.blue[500],
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProjectWidget()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.folder_open,
                            size: 75,
                            color: Colors.white,
                          ),
                          Text(
                            'Projects',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 150,
                  width: 150,
                  child: Material(
                    color: Colors.blue[500],
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimeRegistration()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.schedule,
                            size: 75,
                            color: Colors.white,
                          ),
                          Text(
                            'Time',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            'registration',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  width: 150,
                  child: Material(
                    color: Colors.blue[500],
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MonthlyOverview()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            size: 75,
                            color: Colors.white,
                          ),
                          Text(
                            'Monthly',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'overview',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
