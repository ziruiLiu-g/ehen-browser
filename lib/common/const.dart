import 'package:flutter/material.dart';

import '../util/color.dart';

String THEME_IS_LIGHT_KEY = 'isLight';

double HOME_APP_BAR_HEIGHT = 96.0;
double BOTTOM_BLUR_BAR_MARGIN_BOTTOM = 10.0;
double BOTTOM_BAR_HEIGHT = 50.0;
double MULTI_SELECT_CATA_BAR_HEIGHT = 40.0;


Color galleryTitleColor(bool x) {
  return x ? Colors.black : Colors.white;
}

Color galleryPageButtonColor(bool x) {
  return x ? primary : Colors.white;
}

Color themeColor(bool x) {
  return x ? primary : darkPrimary;
}

Color galleryStartPageBgColor(bool x) {
  return x ? Colors.white : Colors.black;
}

Color picsLoadHintColor(bool x) {
  return x ? primary : Colors.grey;
}

Color loadingCircleColr(bool x) {
  return x ? primary : Colors.white60;
}
