// build page
import 'package:flutter/material.dart';

import '../page/gallery_page.dart';
import '../page/home/home.dart';
import '../page/pics_page.dart';
import 'bottom_navigator.dart';


typedef RouteChangeListener(RouteStatusInfo current, RouteStatusInfo pre);

pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }

  return -1;
}


// route status
enum RouteStatus {
  login,
  registration,
  home,
  gallery,
  picspage,
  unknown
}

// get routestatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is GalleryPage) {
    return RouteStatus.gallery;
  } else if (page.child is PicsPage) {
    return RouteStatus.picspage;
  } else {
    return RouteStatus.unknown;
  }
}

class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

class EhenNavigator extends _RouteJumpListener {
  static EhenNavigator? _instance;

  RouteJumpListener? _routeJump;
  List<RouteChangeListener> _listeners = [];
  RouteStatusInfo? _current;
  RouteStatusInfo? _bottomTab;
  EhenNavigator._();

  static EhenNavigator getInstance() {
    _instance ??= EhenNavigator._();
    return _instance!;
  }

  /// home page tab switch listener
  void onBottomTabChange(int index, Widget page) {
    _bottomTab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomTab!);
  }

  /// regis router jump logic
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    this._routeJump = routeJumpListener;
  }

  /// add listener
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }
  /// remove listener
  void removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

  /// notify router changes
  void notify(List<MaterialPage> currentPage, List<MaterialPage> prePage) {
    if (currentPage == prePage) return;
    var current = RouteStatusInfo(getStatus(currentPage.last), currentPage.last.child);

    _notify(current);
  }

  void _notify(RouteStatusInfo current) {
    if (current.page is BottomNavigator && _bottomTab!=null) {
      current = _bottomTab!;
    }

    print('Navigator: current => ${current.page}');
    print('Navigator: pre => ${_current?.page}');
    _listeners.forEach((listener) {
      listener(current, _current!);
    });
    _current = current;
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump?.onJumpTo(routeStatus, args: args);
  }
}

abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map? args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener({required this.onJumpTo});
}