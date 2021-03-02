import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plens_app/view/registerView.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Register'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterView()),
            );
          },
        ),
      ),
    );
  }
}