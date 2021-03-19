import 'package:flutter/material.dart';
import 'package:plens_app/models/user.dart';
import 'package:plens_app/services/auth.dart';
import 'package:plens_app/services/database.dart';
import 'package:plens_app/view/home/user_list.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<User>>.value(
        value: DatabaseService().users,
      child: Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text('Home'),
        elevation: 1.0,
        actions: <Widget>[
          ElevatedButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
            onPressed: () async{
                await _auth.signOut();
            },
          )
        ],
      ),
        body: UserList(),
    )
    );
  }
}
