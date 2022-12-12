import 'package:get/get.dart';

class CataController extends GetxController {
  var cataCheck = <String, bool>{
    "Doujinshi": true,
    "Manga": true,
    "Artist CG": true,
    "Game CG": true,
    "Western": true,
    "Non-H": true,
    "Image Set": true,
    "Cosplay": true,
    "Asian Porn": true,
    "Misc": true,
  }.obs;

  var cataNum = 0;

  void changeCheck(String key) {
    cataCheck[key] = !cataCheck[key]!;
    update();
  }

  void updateNum(int cur) {
    cataNum += cur;
    update();
  }
}
