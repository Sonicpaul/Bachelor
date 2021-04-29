import 'package:flutter/material.dart';
import 'package:plens_app/models/user.dart';

class UserTile extends StatelessWidget {
  // setting the User Object given by another Widget
  final User user;
  UserTile({this.user});

  // creating a Card with the information given by the user object
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          title: Text(
            user.name,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            'Phone: ' + user.phone + '\n' + 'email: ' + user.email,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
