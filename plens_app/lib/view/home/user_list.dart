import 'package:flutter/material.dart';
import 'package:plens_app/models/user.dart';
import 'package:plens_app/view/home/user_tile.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {

    // fallback for errors
    final users = Provider.of<List<User>>(context) ?? [];

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return UserTile(user: users[index]);
      },
    );
  }
}