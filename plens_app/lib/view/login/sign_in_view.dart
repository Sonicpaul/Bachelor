import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plens_app/services/auth.dart';
import 'package:plens_app/shared/constants.dart';
import 'package:plens_app/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // store E-mail and PW
  String email = '';
  String pass = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Sign in'),
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text('Register'),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val.isEmpty ? 'Enter an E-mail': null,
                  onChanged: (val) {
                  setState(() => email = val);
              }
              ),
              SizedBox(height: 20.0),
              TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val) => val.length < 6 ? 'Enter a password with 6 or more characters': null,
                  obscureText: true,
                  onChanged: (val) {
                  setState(() => pass = val);
                }
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() => loading = true);
                      dynamic result = await _authService.signInWithEmailAndPass(email, pass);
                      if(result == null){
                        setState(() {
                          error = 'Could not Sign in with these credentials!';
                          loading = false;
                        });
                      }
                    }
                  },
                  child: Text('Sign in',
                  style: TextStyle(color: Colors.white),
                  ),
              ),
              SizedBox(height: 20,),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
