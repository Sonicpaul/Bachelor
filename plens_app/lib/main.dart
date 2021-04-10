import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plens_app/models/user.dart';
import 'package:plens_app/services/auth.dart';
import 'package:plens_app/view/wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return error;
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<User>.value(
            value: AuthService().user,
            initialData: null,
            child: MaterialApp(
              home: Wrapper(),
            ),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        // need changes else Error
        return init;
      },
    );
  }

  final Widget init = new MediaQuery(
    data: new MediaQueryData(),
    child: new MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
      ),
    ),
  );

  final Widget error = new MediaQuery(
    data: new MediaQueryData(),
    child: new MaterialApp(
        home: SizedBox(
      height: 30,
      child: Text('An Error occurred'),
    )),
  );
}
