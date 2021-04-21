import 'package:flutter/material.dart';
import 'package:plens_app/services/database.dart';
import 'package:plens_app/view/users/user_list.dart';
import 'package:provider/provider.dart';
import 'package:plens_app/models/user.dart';

class UserWidget extends StatefulWidget {
  @override
  _UserWidgetState createState() => _UserWidgetState();
}

// this Widget builds the base of the Contacts Page
// getting all Users from the database and provide them to the UserList Widget
class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<User>>.value(
        value: DatabaseService().users,
        initialData: [],
        child: Scaffold(
          backgroundColor: Colors.blue[100],
          appBar: AppBar(
            title: Text('Contacts'),
            elevation: 1.0,
          ),
          body: UserList(),
        ));
  }
}
