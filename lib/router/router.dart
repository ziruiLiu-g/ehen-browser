import 'package:ehentai_browser/page/ehen/gallery_page.dart';
import 'package:ehentai_browser/router/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../page/ehen/home/home.dart';
import '../page/ehen/pics_page.dart';

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
