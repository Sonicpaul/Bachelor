import 'package:flutter/material.dart';
import 'package:plens_app/models/user.dart';
import 'package:plens_app/view/authenticate/authentication.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);

    //return Home or Register

    return Authenticate();
  }
}
