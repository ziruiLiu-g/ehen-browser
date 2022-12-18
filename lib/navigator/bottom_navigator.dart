import 'package:flutter/material.dart';

import '../util/color.dart';
import 'ehen_navigator.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primary;
  int _currentIndex = 0;
  static int initialPage = 0;
  final PageController _controller = PageController(initialPage: initialPage);
  late List<Widget> _pages;
  bool _hasBuild = false;

  @override
  Widget build(BuildContext context) {
    _pages = [
      // HomePage(),
      // RankPage(),
      // FavoritePage(),
      // ProfilePage(),
    ];
    if (!_hasBuild) {
      EhenNavigator.getInstance().onBottomTabChange(initialPage, _pages[initialPage]);
      _hasBuild = true;
    }
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) => _onJumpTo(index, pageChange: true),
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onJumpTo(index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _activeColor,
        items: [
          _bottomItem('Home', Icons.home, 0),
          _bottomItem('Rank', Icons.local_fire_department, 0),
          _bottomItem('Favorite', Icons.favorite, 0),
          _bottomItem('Profile', Icons.person, 0),
        ],
      ),
    );
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _defaultColor,
      ),
      activeIcon: Icon(
        icon,
        color: _activeColor,
      ),
      label: title,
    );
  }

  void _onJumpTo(int index, {pageChange=false}) {

    if (!pageChange) {
      _controller.jumpToPage(index);
    } else {
      EhenNavigator.getInstance().onBottomTabChange(index, _pages[index]);
    }

    setState(() {
      _currentIndex = index;
    });
  }
}
