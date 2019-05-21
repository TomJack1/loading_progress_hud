import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_progress_hud/loading_progress_hud.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestLoadingPage(),
    );
  }
}

class TestLoadingPage extends StatefulWidget {
  @override
  _TestLoadingPageState createState() => _TestLoadingPageState();
}

class _TestLoadingPageState extends State<TestLoadingPage> {
  LELoadingController _controller;

  @override
  void initState() {
    _controller = LELoadingController(initType: LoadingOrgStatus.none);
    super.initState();
  }

  void hudTest() async {
    _controller.show(hud: 'loading...');
    await Future.delayed(Duration(seconds: 2));
    _controller.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('loading Progress HUD Demo'),
        backgroundColor: Colors.blue,
      ),
      body: LELoadingProgressHUD(
        controller: _controller,
        child: ListView.separated(
          itemBuilder: (context, index) {
            if (index == 0) {
              return SizedBox(
                height: 20,
              );
            }

            switch (index) {
              case 1:
                return CupertinoButton(
                  child: Text(
                    'loading + empty',
                    style: TextStyle(color: Colors.white),
                  ),
                  disabledColor: Color(0xffA9A9A9),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FunctionDemo(
                        initType: LoadingOrgStatus.loading,
                        netWorkEndType: LoadingOrgStatus.empty,
                      );
                    }));
                  },
                );
              case 2:
                return CupertinoButton(
                  child: Text(
                    'loading + Error',
                    style: TextStyle(color: Colors.white),
                  ),
                  disabledColor: Color(0xffA9A9A9),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FunctionDemo(
                        initType: LoadingOrgStatus.loading,
                        netWorkEndType: LoadingOrgStatus.error,
                      );
                    }));
                  },
                );
              case 3:
                return CupertinoButton(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  child: Text(
                    'loading + refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                  disabledColor: Color(0xffA9A9A9),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FunctionDemo(
                        initType: LoadingOrgStatus.loading,
                        netWorkEndType: LoadingOrgStatus.refresh,
                      );
                    }));
                  },
                );

              case 4:
                return CupertinoButton(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  child: Text(
                    'Hud',
                    style: TextStyle(color: Colors.white),
                  ),
                  disabledColor: Color(0xffA9A9A9),
                  color: Colors.red,
                  onPressed: () {
                    hudTest();
                  },
                );
              default:
            }
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 10,
            );
          },
          itemCount: 6,
        ),
      ),
    );
  }
}

class FunctionDemo extends StatefulWidget {
  FunctionDemo({
    this.initType,
    this.netWorkEndType,
  });
  final LoadingOrgStatus netWorkEndType;
  final LoadingOrgStatus initType;
  @override
  _FunctionDemoState createState() => _FunctionDemoState();
}

class _FunctionDemoState extends State<FunctionDemo> {
  LELoadingController _controller;

  @override
  void initState() {
    _controller = LELoadingController(initType: widget.initType);
    super.initState();
  }

  Future<LoadingOrgStatus> loadData() async {
    await Future.delayed(Duration(seconds: 2));
    return widget.netWorkEndType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Demo'),
          backgroundColor: Colors.blue,
        ),
        body: LELoadingProgressHUD(
          controller: _controller,
          loadingCallBack: loadData,
          child: new Container(
            child: Center(
              child: Text('loading demo 😁😁'),
            ),
          ),
        ));
  }
}

class LoginPage extends StatefulWidget {
  final VoidCallback _onSignIn;

  LoginPage({@required onSignIn})
      : assert(onSignIn != null),
        _onSignIn = onSignIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // maintains validators and state of form fields
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  LELoadingController controller;

  bool _isInvalidAsyncUser = false; // managed after response from server
  bool _isInvalidAsyncPass = false; // managed after response from server

  String _username;
  String _password;
  bool _isLoggedIn = false;

  @override
  @override
  void initState() {
    controller = LELoadingController(initType: LoadingOrgStatus.loading);
    super.initState();
  }

  // validate user name
  String _validateUserName(String userName) {
    if (userName.length < 8) {
      return 'Username must be at least 8 characters';
    }

    if (_isInvalidAsyncUser) {
      // disable message until after next async call
      _isInvalidAsyncUser = false;
      return 'Incorrect user name';
    }

    return null;
  }

  // validate password
  String _validatePassword(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (_isInvalidAsyncPass) {
      // disable message until after next async call
      _isInvalidAsyncPass = false;
      return 'Incorrect password';
    }

    return null;
  }

  void _submit() {
    // if (_loginFormKey.currentState.validate()) {
    //   _loginFormKey.currentState.save();
    // dismiss keyboard during async call
    FocusScope.of(context).requestFocus(new FocusNode());
    controller.show();
    // Simulate a service call
    Future.delayed(Duration(seconds: 1), () {
      final _accountUsername = '1';
      final _accountPassword = '1';
      if (_username == _accountUsername) {
        _isInvalidAsyncUser = false;
        if (_password == _accountPassword) {
          // username and password are correct
          _isInvalidAsyncPass = false;
          _isLoggedIn = true;
        } else
          // username is correct, but password is incorrect
          _isInvalidAsyncPass = true;
      } else {
        // incorrect username and have not checked password result
        _isInvalidAsyncUser = true;
        // no such user, so no need to trigger async password validator
        _isInvalidAsyncPass = false;
      }
      // stop the modal progress HUD
      controller.hide();
      if (_isLoggedIn)
        // do something
        widget._onSignIn();
    });
    // }
  }

  Future<LoadingOrgStatus> _firstGetloadingData() async {
    await Future.delayed(Duration(seconds: 5));
    return LoadingOrgStatus.none;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modal Progress HUD Demo'),
        backgroundColor: Colors.blue,
      ),
      body: LELoadingProgressHUD(
        controller: controller,
        child: buildLoginForm(context),
        loadingCallBack: _firstGetloadingData,
      ),
    );
  }

  Widget buildLoginForm(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    // run the validators on reload to process async results
    _loginFormKey.currentState?.validate();
    return Form(
      key: this._loginFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              key: Key('username'),
              decoration: InputDecoration(
                  hintText: 'enter username', labelText: 'User Name'),
              style: TextStyle(fontSize: 20.0, color: textTheme.button.color),
              validator: _validateUserName,
              onSaved: (value) => _username = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              key: Key('password'),
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'enter password', labelText: 'Password'),
              style: TextStyle(fontSize: 20.0, color: textTheme.button.color),
              validator: _validatePassword,
              onSaved: (value) => _password = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: RaisedButton(
              onPressed: _submit,
              child: Text('Login'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isLoggedIn
                ? Text(
                    'Login successful!',
                    key: Key('loggedIn'),
                    style: TextStyle(fontSize: 20.0),
                  )
                : Text(
                    'Not logged in',
                    key: Key('notLoggedIn'),
                    style: TextStyle(fontSize: 20.0),
                  ),
          ),
        ],
      ),
    );
  }
}
