import 'dart:io';

import 'package:chat_app/widgets/pickers/usage_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitfn, this.isloading);

  final bool isloading;
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitfn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _islogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPass = '';
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_islogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pic an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();

      //user thoes values to send our auth request
      widget.submitfn(
        _userEmail.trim(),
        _userName.trim(),
        _userPass.trim(),
        _userImageFile,
        _islogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!_islogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email Address'),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    if (!_islogin)
                      TextFormField(
                        key: ValueKey('userName'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'Please enter at least 4 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Username'),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('pass'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters long';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true, //hides the text from user
                      onSaved: (value) {
                        _userPass = value;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isloading) CircularProgressIndicator(),
                    if (!widget.isloading)
                      RaisedButton(
                        child: Text(_islogin ? 'Login' : 'Signup'),
                        onPressed: _trySubmit,
                      ),
                    if (!widget.isloading)
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          setState(() {
                            _islogin = !_islogin;
                          });
                        },
                        child: Text(_islogin
                            ? 'Create New Account'
                            : 'I already have an account'),
                      )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
