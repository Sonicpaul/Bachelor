import 'package:flutter/material.dart';
import 'package:plens_app/services/auth.dart';
import 'package:plens_app/view/home/settings_Form.dart';
import 'package:plens_app/view/monthly/monthly_overview.dart';
import 'package:plens_app/view/projects/project_Widget.dart';
import 'package:plens_app/view/time/time_register.dart';
import 'package:plens_app/view/users/user_widget.dart';

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
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            ElevatedButton.icon(
                onPressed: () => _showSettingsPanel(),
                icon: Icon(Icons.account_circle_rounded),
                label: Text('Profile'))
          ],
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.deepPurple,
                        child: Text('Contacts'),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserWidget()));
                      }),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.red,
                        child: Text('Projects'),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProjectWidget()));
                      }),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.pink,
                      child: Text('Time Registration'),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TimeRegistration()));
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.green,
                      child: Text('Monthly Overview'),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MonthlyOverview()));
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
