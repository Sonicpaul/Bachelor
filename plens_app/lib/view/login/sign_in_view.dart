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

// this is the main widget for the sign in Page
class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _resetKey = GlobalKey<FormState>();
  bool loading = false;

  // store E-mail and PW
  String email = '';
  String pass = '';
  String error = '';
  String errorReset = '';

  @override
  Widget build(BuildContext context) {
    void showPassResetDialog() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
                height: MediaQuery.of(context).size.height - 600.0,
                padding: EdgeInsets.all(20),
                child: Form(
                    key: _resetKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Enter you email adress'),
                          validator: (value) =>
                              value.isEmpty ? 'Enter an email' : null,
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                        Text(
                          errorReset,
                          style: TextStyle(color: Colors.red),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (_resetKey.currentState.validate()) {
                                dynamic result =
                                    await _authService.changePass(email);
                                if (result == null) {
                                  setState(() {
                                    errorReset = 'Wrong email adress';
                                  });
                                } else {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: Text(
                              'Reset password',
                              style: TextStyle(fontSize: 20),
                            ))
                      ],
                    )));
          });
    }

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blue[100],
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue[400],
              elevation: 0.0,
              title: Text('Sign in'),
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
                            val.isEmpty ? 'Enter an email address' : null,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _authService
                                  .signInWithEmailAndPass(email, pass);
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Could not sign in with this email and password.';
                                  loading = false;
                                });
                              }
                            }
                          },
                          child: Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have a account?",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                widget.toggleView();
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      error,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () async {
                          showPassResetDialog();
                        }),
                  ],
                ),
              ),
            ),
          );
  }
}
