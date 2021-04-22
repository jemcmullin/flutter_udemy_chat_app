import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthWidget(),
    );
  }
}

//Stateful Widget seperated to contain authentication Form
class AuthWidget extends StatefulWidget {
  const AuthWidget({
    Key? key,
  }) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      //TODO: login to app
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Email address entry
                  TextFormField(
                    key: ValueKey('email'), //neccessary for toggle signup
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    autofocus: true,
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                  ),
                  //Username entry
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'), //neccessary for toggle signup
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return 'Please enter username > 6 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                      onSaved: (newValue) {
                        _userName = newValue!;
                      },
                    ),
                  //Password entry
                  TextFormField(
                    key: ValueKey('password'), //neccessary for toggle signup
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Please enter password > 6 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (newValue) {
                      _userPassword = newValue!;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  //Login button
                  ElevatedButton(
                    child: Text(_isLogin ? 'Login' : 'Create Account'),
                    onPressed: _trySubmit,
                  ),
                  //New account button
                  TextButton(
                    child: Text(_isLogin
                        ? 'Create new account'
                        : 'Login with existing account'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
