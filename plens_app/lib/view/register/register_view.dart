import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plens_app/services/auth.dart';
import 'package:plens_app/shared/constants.dart';
import 'package:plens_app/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // store E-mail and PW
  String email = '';
  String pass = '';
  String passSecond = '';
  String error = '';

  // building the main Widget
  // using a form to evaluate the users input
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blue[100],
            appBar: AppBar(
              backgroundColor: Colors.blue[400],
              elevation: 0.0,
              title: Text('Register'),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Enter email'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an E-mail' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        }),
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Enter password'),
                        validator: (val) => val.length < 6
                            ? 'Enter a password with 6 or more characters'
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => pass = val);
                        }),
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Confirm password'),
                        validator: (val) => val.length < 6
                            ? 'Enter a password with 6 or more characters'
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => passSecond = val);
                        }),
                    SizedBox(height: 20.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              if (pass == passSecond) {
                                setState(() {
                                  loading = true;
                                });
                              } else {
                                setState(() {
                                  error = 'passwords are not matching';
                                });
                              }

                              dynamic result = await _authService
                                  .registerWithEmailAndPass(email, pass);
                              if (result == null) {
                                setState(
                                    () => error = 'please enter a valid Email');
                                loading = false;
                              }
                            }
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Already have an account?'),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                widget.toggleView();
                              },
                              child: Text('Sign in'),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
