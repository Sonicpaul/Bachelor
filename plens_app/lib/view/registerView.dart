import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loginView.dart';

class RegisterView extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return snapshot.error;
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return register(context);
        }
        return blueScreen(context);
      },
    );
  }


  Widget register(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Login'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView()),
            );
          },
        ),
      ),
    );
  }

  Widget blueScreen(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Waiting to connect'),
      ),
      body: Center(
        child: BlueBox()
        ),
      );
  }
}

class BlueBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(),
      ),
    );
  }
}