import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../login/loginView.dart';

class RegisterView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Login'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Login()),
            );
          },
        ),
      ),
    );
  }
}