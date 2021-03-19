import 'package:flutter/material.dart';
import 'package:plens_app/models/user.dart';
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

  // form values
  String _currentName;
  String _currentPhone;
  String _currentEmail;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text('Update your data',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: userData.name,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: userData.email,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? 'Please enter a email' : null,
                  onChanged: (val) => setState(() => _currentEmail = val),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: userData.phone,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? 'Please enter a phone number' : null,
                  onChanged: (val) => setState(() => _currentPhone = val),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Update'),
                  onPressed: () async {
                  },
                )
              ],
            ),
          );
        }else{
          return Loading();
        }
      }
    );
  }
}
