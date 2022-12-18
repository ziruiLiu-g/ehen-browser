import 'package:flutter/material.dart';

import '../util/color.dart';

String THEME_IS_LIGHT_KEY = 'isLight';

double BOTTOM_BAR_HEIGHT = 50.0;
double HOME_APP_BAR_HEIGHT = 96.0;

galleryTitleColor(bool x) {
  return x ? Colors.black : Colors.white;
}

galleryPageButtonColor(bool x) {
  return x ? primary : Colors.white;
}

themeColor(bool x) {
  return x ? primary : darkPrimary;
}

galleryStartPageBgColor(bool x) {
  return x ? Colors.white : Colors.black;
}

picsLoadHintColor(bool x) {
  return x ? primary : Colors.grey;
}

loadingCircleColr(bool x) {
  return x ?primary : Colors.white60;
}