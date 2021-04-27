import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(),
    );
  }
}

//--------
//Stateful Widget seperated to contain authentication Form

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key? key,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _isLoading = false;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  Future<void> _trySubmit() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      UserCredential userCredential;
      try {
        if (_isLogin) {
          userCredential = await _auth.signInWithEmailAndPassword(
            email: _userEmail.trim(),
            password: _userPassword.trim(),
          );
        } else {
          userCredential = await _auth.createUserWithEmailAndPassword(
            email: _userEmail.trim(),
            password: _userPassword.trim(),
          );
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user?.uid)
              .set({
            'username': _userName.trim(),
            'email': _userEmail.trim(),
          });
        }
      } on PlatformException catch (err) {
        final message = err.message ??
            'An error has occured. Please check your credentials';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ));
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ));
        print(err);
        setState(() {
          _isLoading = false;
        });
      }
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
                    child: _isLoading
                        ? CircularProgressIndicator.adaptive()
                        : Text(_isLogin ? 'Login' : 'Create Account'),
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
