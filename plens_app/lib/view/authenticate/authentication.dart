import 'package:flutter/material.dart';
import 'package:plens_app/view/login/sign_in_view.dart';
import 'package:plens_app/view/register/register_view.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

// this class is used to switch between the Register and signin Page
class _AuthenticateState extends State<Authenticate>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  bool showSignIn = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }

  // toggle the Flag
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }
}
