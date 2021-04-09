import 'package:flutter/material.dart';
import 'package:plens_app/models/user.dart';

class UserTile extends StatelessWidget {
  final User user;
  UserTile({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          title: Text(user.name),
          subtitle: Text(
              'Phone number: ' + user.phone + '\n' + 'E-mail: ' + user.email),
        ),
      ),
    );
  }
}
