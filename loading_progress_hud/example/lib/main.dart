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
