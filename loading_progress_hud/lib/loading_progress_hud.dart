library loading_progress_hud;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum LoadingOrgStatus {
  none,
  //正在加载 转菊花
  loading,

  /// 展示空界面
  empty,

  /// 显示从新加载按钮
  refresh,

  ///数据错误
  error,
  //中间菊花
  progressHUD,
}
typedef LoadingCallback = Future<LoadingOrgStatus> Function();
typedef ChildCallback = Widget Function();

//loading Controller
class LELoadingController extends ChangeNotifier {
  LELoadingController({
    Key key,
    this.initType = LoadingOrgStatus.loading,
    this.emptyText = '暂无数据',//Empty Title
    this.refreshText = '重新获取数据',//refresh Title
    this.errorText = '数据错误',// error Title
    this.loadingText = '正在加载...',//loading title
  });
  String hudText;
  final String loadingText;
  final String emptyText;
  final String refreshText;
  final String errorText;
  final LoadingOrgStatus initType;
  LoadingOrgStatus _type;
  void show({String hud = '请稍后...'}) {
    hudText = hud;
    type = LoadingOrgStatus.progressHUD;
  }

  void hide() {
    type = LoadingOrgStatus.none;
  }

  LoadingOrgStatus get type => _type ?? initType;
  set type(LoadingOrgStatus newValue) {
    if (_type == newValue) return;
    _type = newValue;
    notifyListeners();
  }
}

class LELoadingProgressHUD extends StatefulWidget {
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
  })  : assert(controller != null, 'controller is null，"state<T>" save him'),
        assert(child != null, 'child not empty'),
        emptyIcon = Icon(Icons.hourglass_empty),
        super(key: key);
  final Widget progressIndicator;
  final Widget loadingIndicator;
  final LELoadingController controller;
  final LoadingCallback loadingCallBack;
  final Widget child;
  final Widget emptyIcon;
  final Color textColor, bacgroundColor;

  @override
  _LELoadingProgressHUDState createState() => _LELoadingProgressHUDState();
}

class _LELoadingProgressHUDState extends State<LELoadingProgressHUD> {
  LELoadingController get _effectiveController => widget.controller;
  final String unknownErrorTitle = '未知错误';
  bool _isLoading = false;
  @override
  void initState() {
    _effectiveController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (_effectiveController.type == LoadingOrgStatus.loading) {
        firstLoadingData();
      }
    });
    if (_effectiveController.type == LoadingOrgStatus.loading) {
      firstLoadingData();
    }
    super.initState();
  }

  @override
  void dispose() {
    _effectiveController.removeListener(() {});
    super.dispose();
  }

  void firstLoadingData() async {
    if (_isLoading) {
      return;
    }
    if(widget.loadingCallBack == null){
      return;
    }
    _isLoading = true;
    _effectiveController.type = await widget.loadingCallBack();
    _isLoading = false;
  }

  String _getShowTitleString() {
    String textTitle = unknownErrorTitle;
    switch (_effectiveController.type) {
      case LoadingOrgStatus.loading:
        textTitle = _effectiveController.loadingText;
        break;
      case LoadingOrgStatus.empty:
        textTitle = _effectiveController.emptyText;
        break;
      case LoadingOrgStatus.refresh:
        textTitle = _effectiveController.refreshText;
        break;
      case LoadingOrgStatus.error:
        textTitle = _effectiveController.errorText;
        break;
      case LoadingOrgStatus.progressHUD:
        textTitle = _effectiveController.hudText;
        break;
      default:
    }
    return textTitle;
  }

  //增加加载
  Widget _getLoadingWidget(
      String content, Color themeColor, Color backgroundColor) {
    return new Container(
      color: backgroundColor,
      child: new Center(
        child: Column(
          children: <Widget>[
            widget.loadingIndicator,
            new SizedBox(
              height: 8.0,
            ),
            new Text(
              content,
              style: TextStyle(color: themeColor, fontWeight: FontWeight.w500),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
  //数据为空

  Widget _getEmptyWidget(
      String content, Color themeColor, Color backgroundColor) {
    return new Container(
      color: backgroundColor,
      child: new Center(
        child: Column(
          children: <Widget>[
            widget.emptyIcon,
            new SizedBox(
              height: 8.0,
            ),
            new Text(
              content,
              style: TextStyle(color: themeColor, fontWeight: FontWeight.w500),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

  //数据为空

  Widget _getErrorWidget(
      String content, Color themeColor, Color backgroundColor) {
    return new Container(
      color: backgroundColor,
      child: new Center(
        child: Column(
          children: <Widget>[
            new Icon(
              Icons.error,
              color: themeColor,
            ),
            new SizedBox(
              height: 8.0,
            ),
            new Text(
              content,
              style: TextStyle(color: themeColor, fontWeight: FontWeight.w500),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
  ///refresh 
  Widget _getRefreshWidget(
      String content, Color themeColor, Color backgroundColor) {
    return new Container(
      color: backgroundColor,
      child: new Center(
        child: Column(
          children: <Widget>[
            new Icon(
              Icons.refresh,
              color: themeColor,
            ),
            new SizedBox(
              height: 20.0,
            ),
            CupertinoButton(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
              child: Text(
                content,
                style: TextStyle(color: backgroundColor),
              ),
              disabledColor: Color(0xffA9A9A9),
              color: themeColor,
              onPressed: () {
                _effectiveController.type = LoadingOrgStatus.loading;
              },
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

  Widget getShowContent() {
    String title = _getShowTitleString();
    Color themeColor =
        widget.textColor ?? Theme.of(context).textTheme.title.color;
    Color backgroundColor =
        widget.bacgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    switch (_effectiveController.type) {
      case LoadingOrgStatus.empty:
        return _getEmptyWidget(title, themeColor, backgroundColor);
        break;
      case LoadingOrgStatus.loading:
        return _getLoadingWidget(title, themeColor, backgroundColor);
        break;
      case LoadingOrgStatus.refresh:
        return _getRefreshWidget(title, themeColor, backgroundColor);
        break;
      case LoadingOrgStatus.error:
        return _getErrorWidget(title, themeColor, backgroundColor);
        break;
      case LoadingOrgStatus.progressHUD:
        List<Widget> widgetList = [];
        widgetList.add(widget.child);
        final modal = [
          new Opacity(
            child: new ModalBarrier(dismissible: false, color: Colors.grey),
            opacity: 0.5,
          ),
          Center(
            child: new DecoratedBox(
              child: new Padding(
                child: Column(
                  children: <Widget>[
                    widget.progressIndicator,
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      _effectiveController.hudText,
                      style: TextStyle(
                          color: themeColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              ),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ];
        widgetList += modal;
        return new Stack(
          children: widgetList,
        );
        break;
      default:
        {
          var content = widget.child;
          if (content == null) {
            return _getEmptyWidget(title, themeColor, backgroundColor);
          } else {
            return content;
          }
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return getShowContent();
  }
}
