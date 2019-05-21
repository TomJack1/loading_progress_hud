# loading_progress_hud

a simple widget wrapper to enable modal progress HUD (a modal progress indicator, HUD = Heads Up Display)

![Demo](https://github.com/TomJack1/loading_progress_hud/blob/master/hud.gif)

## Usage
Add the package to your `pubspec.yml` file.

```yml
dependencies:
  loading_progress_hud: ^0.0.1
```
Next, import the library into your widget.

```dart
import 'package:loading_progress_hud/loading_progress_hud.dart';
```
eg:

```dart
    LELoadingController _controller;

  @override
  void initState() {
    _controller = LELoadingController(initType: LoadingOrgStatus.none);
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

```





## Options

The current parameters are customizable in the constructor

```dart
LELoadingProgressHUD({
    Key key,
    @required this.controller,
    @required this.child,
    this.loadingCallBack,
    emptyIcon,
    this.textColor,
    this.bacgroundColor,
    this.progressIndicator = const CircularProgressIndicator(),
    this.loadingIndicator = const CircularProgressIndicator(),
  }) 
```
controller hud

```dart
LELoadingController({
    Key key,
    this.initType = LoadingOrgStatus.loading,
    this.emptyText = '暂无数据',//Empty Title
    this.refreshText = '重新获取数据',//refresh Title
    this.errorText = '数据错误',// error Title
    this.loadingText = '正在加载...',//loading title
  });
```



