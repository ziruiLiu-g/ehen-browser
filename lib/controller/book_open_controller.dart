import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BookOpenController extends GetxController {
  static BookOpenController? _bookOpenController;

  @override
  void onInit() {
    super.onInit();
    _bookOpenController = BookOpenController();
  }

  final _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;
  set currentIndex(int c) => _currentIndex.value = c;
}
