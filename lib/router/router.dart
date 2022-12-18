import 'package:ehentai_browser/page/gallery_page.dart';
import 'package:ehentai_browser/page/pics_page.dart';
import 'package:ehentai_browser/router/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../page/home/home.dart';

abstract class EhenRouters {
  static final pages = [
    GetPage(
      name: Routes.Home,
      page: () => HomePage(),
    ),
    GetPage(
      name: Routes.Gallery,
      page: () => GalleryPage(),
    ),
    GetPage(
      name: Routes.PicsPage,
      page: () => PicsPage(),
    ),
  ];
}