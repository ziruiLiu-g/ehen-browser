import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomBlurNavigator extends StatefulWidget {
  List<Widget>? widgets;

  @override
  State<BottomBlurNavigator> createState() => _BottomBlurNavigatorState();

  BottomBlurNavigator({this.widgets});
}

class _BottomBlurNavigatorState extends State<BottomBlurNavigator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20, right: 20),
      margin: EdgeInsets.only(bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            color: Colors.grey.withOpacity(0.4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.widgets!,
            ),
          ),
        ),
      ),
    );
  }
}
