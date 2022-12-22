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

LinearGradient bgGradientColor(bool x) {
  return x ? const LinearGradient(
    colors: [Color(0xFF66C2F3), Color(0xFF2188DE), Color(0xFF473BF5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ) : const LinearGradient(
    colors: [Color(0xFFfbab66), Color(0xFFf7418c)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
