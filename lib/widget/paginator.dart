import 'package:flutter/material.dart';

import 'bottom_blur_navigator.dart';

Widget nextPrevButton(VoidCallback prev, VoidCallback next,
    {Widget? middle, VoidCallback? selector}) {
  return BottomBlurNavigator(
    widgets: <Widget>[
      TextButton(
        child: Text(
          "<< PREV",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        onPressed: prev,
      ),
      middle ??
      TextButton(
        onPressed: selector,
        child: Text(
          "JUMP",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      TextButton(
        child: Text(
          "NEXT >>",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        onPressed: next,
      ),
    ],
  );
}