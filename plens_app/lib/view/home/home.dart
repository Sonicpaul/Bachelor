import 'package:flutter/material.dart';
import 'package:plens_app/services/auth.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
