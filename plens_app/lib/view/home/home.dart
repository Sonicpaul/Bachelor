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
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserWidget()));
                    },
                    icon: Icon(Icons.phone),
                    label: Text('Contacts')),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProjectWidget()));
                    },
                    icon: Icon(Icons.folder_open),
                    label: Text('Projects')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TimeRegistration()));
                    },
                    icon: Icon(Icons.schedule),
                    label: Text('Time Registration')),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MonthlyOverview()));
                    },
                    icon: Icon(Icons.calendar_today),
                    label: Text('Monthly Overview')),
              ],
            ),
          ],
        ));
  }
}
