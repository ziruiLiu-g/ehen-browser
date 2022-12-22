import 'package:ehentai_browser/localdb/local_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../common/const.dart';

class ThemeController extends GetxController {
  static ThemeController? _themeController;

  @override
  void onInit() {
    super.onInit();
    _themeController = ThemeController();
  }

  final RxBool _isLightTheme = (LocalStorage.getInstance().get(THEME_IS_LIGHT_KEY) as bool).obs;

  static bool get isLightTheme => _themeController!._isLightTheme.value;

  static void setIsLightTheme(bool x) {
    _themeController!._isLightTheme.value = x;
  }
}
