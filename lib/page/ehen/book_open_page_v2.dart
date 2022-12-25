import 'dart:math' as math;
import 'dart:ui';

import 'package:ehentai_browser/controller/book_open_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/theme_controller.dart';
import '../../util/color.dart';
import '../../widget/dark_mode_switcher.dart';

class BookOpenPageV2 extends StatefulWidget {
  final List<Widget> child;

  const BookOpenPageV2({Key? key, required this.child}) : super(key: key);

  static BookOpenPageV2State? of(BuildContext context) => context.findAncestorStateOfType<BookOpenPageV2State>();

  @override
  BookOpenPageV2State createState() => new BookOpenPageV2State();
}

class BookOpenPageV2State extends State<BookOpenPageV2> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late PageController pageController;
  BookOpenController bookOpenController = Get.put(BookOpenController());

  bool _canBeDragged = false;
  final double maxSlide = 300.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    pageController = PageController(
      initialPage: 0,
      keepPage: true,
      viewportFraction: 1,
    );

    // pageController.addListener(() {
    //   //PageView滑动的距离
    //   double offset = pageController.offset;
    //   //当前显示的页面的索引
    //   double? page = pageController.page;
    // });
  }

  @override
  void dispose() {
    pageController.dispose();
    animationController.dispose();
    super.dispose();
  }

  void toggle() => animationController.isDismissed ? animationController.forward() : animationController.reverse();

  void backWardtoggle() => animationController.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      behavior: HitTestBehavior.opaque,
      // onTap: toggle,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Container(
            color: Colors.red.withOpacity(0),
            child: Stack(
              children: <Widget>[
                Obx(
                  () => AnimatedContainer(
                    duration: Duration(milliseconds: 50),
                    decoration: BoxDecoration(gradient: bgGradientColor(ThemeController.isLightTheme)),
                  ),
                ),

                PageView(
                  onPageChanged: (int index) {
                    bookOpenController.currentIndex = index;
                  },
                  controller: pageController,
                  scrollDirection: Axis.vertical,
                  allowImplicitScrolling: true,
                  children: _buildPageViewChildren(),
                  padEnds: false,
                  physics: animationController.value == 0
                      ? NeverScrollableScrollPhysics()
                      : BouncingScrollPhysics(),
                ),
                AnimatedOpacity(
                  curve: Curves.fastLinearToSlowEaseIn,
                  opacity: animationController.value,
                  duration: Duration(milliseconds: 0),
                  child: Transform.translate(
                    offset: Offset(0, 0),
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, -0.001)
                        ..rotateY(math.pi * (1 - animationController.value) + (math.pi * animationController.value / 10)),
                      // ..rotateY(math.pi * animationController.value /10),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(40 * animationController.value)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              // spreadRadius: 3,
                              blurRadius: 10,
                              offset: Offset(10, 15), // changes position of shadow
                            ),
                          ],
                        ),
                        child: MyDrawer(pageController),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4.0 + MediaQuery.of(context).padding.top,
                  left: 4 + animationController.value * maxSlide - (40 * animationController.value),
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: toggle,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  top: 4.0 + MediaQuery.of(context).padding.top,
                  right: 4.0,
                  child: DarkModeSwitch(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildPageViewChildren() {
    List<Widget> res = [];
    for (var child in widget.child) {
      res.add(
        Transform.translate(
          offset: Offset(0, 0),
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, -0.001)
              ..translate(
                animationController.value * -(MediaQuery.of(context).size.width / 12),
                // animationController.value * -(MediaQuery.of(context).size.height / 12),
              )
              ..rotateY(-math.pi / 3.4 * (animationController.value))
              ..scale(
                1.0 - (0.6 * animationController.value),
                1.0 - (0.7 * animationController.value),
                1.0 - (0.65 * animationController.value),
              ),
            alignment: Alignment.centerRight,
            child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular((40 * animationController.value)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      // spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(30, 30), // changes position of shadow
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () => backWardtoggle(),
                  child: IgnorePointer(
                    child: child,
                    ignoring: animationController.value == 1.0 ? true : false,
                  ),
                )),
          ),
        ),
      );
    }

    return res;
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed;
    bool isDragCloseFromRight = animationController.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }
}

class MyDrawer extends StatelessWidget {
  PageController pageController;
  BookOpenController bookOpenController = Get.put(BookOpenController());

  MyDrawer(this.pageController);

  final textShadow = const Shadow(
    offset: Offset(2.0, 2.0),
    blurRadius: 8.0,
    color: Color.fromARGB(255, 0, 0, 0),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: double.infinity,
      child: Obx(
        () => AnimatedContainer(
          color: themeColor(ThemeController.isLightTheme),
          duration: Duration(milliseconds: 200),
          child: SafeArea(
            child: Theme(
              data: ThemeData(brightness: Brightness.dark),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: Text(
                      'EH BROWSER',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white, shadows: [textShadow]),
                    ),
                  ),
                  _menuWidget(0, Icons.photo_size_select_actual_outlined, 'Ehentai'),
                  _menuWidget(1, Icons.video_library_outlined, 'Video'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _menuWidget(int index, IconData icon, String title) {
    return Obx(
      () => Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 20),
        child: AnimatedScale(
          alignment: Alignment.centerLeft,
          scale: bookOpenController.currentIndex == index ? 1.5 : 1,
          duration: Duration(milliseconds: 100),
          child: AnimatedContainer(
            alignment: Alignment.center,
            height: 40,
            decoration: BoxDecoration(
              color: ThemeController.isLightTheme
                  ? Color(0xffe5dacd).withOpacity(bookOpenController.currentIndex == index ? 1 : 0)
                  : const Color(0xffe5664d).withOpacity(bookOpenController.currentIndex == index ? 1 : 0),
              boxShadow: [
                BoxShadow(
                  color: ThemeController.isLightTheme
                      ? Colors.black.withOpacity(bookOpenController.currentIndex == index ? 0.7 : 0)
                      : Colors.black.withOpacity(bookOpenController.currentIndex == index ? 1 : 0),
                  blurRadius: 7,
                  offset: Offset(0, 5), // changes position of shadow
                ),
              ],
            ),
            duration: Duration(milliseconds: 100),
            child: InkWell(
              onTap: () {
                pageController.animateToPage(
                  index,
                  curve: Curves.easeInCubic,
                  duration: Duration(milliseconds: 300),
                );
                HapticFeedback.mediumImpact();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    icon,
                    size: 20,
                    shadows: <Shadow>[textShadow],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      shadows: <Shadow>[textShadow],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
