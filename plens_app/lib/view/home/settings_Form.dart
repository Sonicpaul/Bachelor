import 'package:flutter/material.dart';
import 'package:plens_app/models/user.dart';
import 'package:plens_app/services/auth.dart';
import 'package:plens_app/services/database.dart';
import 'package:plens_app/shared/constants.dart';
import 'package:plens_app/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  // form values
  String _currentName;
  String _currentPhone;
  String _currentEmail;

  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your profile',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: userData.email,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a email' : null,
                    onChanged: (val) => setState(() => _currentEmail = val),
                  ),
                  Text(error,
                      style: TextStyle(color: Colors.red, fontSize: 10)),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: userData.phone,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a phone number' : null,
                    onChanged: (val) => setState(() => _currentPhone = val),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('Update'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result = await _authService
                            .updateUserEmail(_currentEmail ?? userData.email);

                        if (result == null) {
                          setState(() => error =
                              'Check the Email address please or try to log out and sign in again.');
                        } else {
                          print(result);
                          await DatabaseService(uid: user.uid).updateUserData(
                              _currentName ?? userData.name,
                              _currentEmail ?? userData.email,
                              _currentPhone ?? userData.phone);
                          Navigator.pop(context);
                        }
                      }
                    },
                  )
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
