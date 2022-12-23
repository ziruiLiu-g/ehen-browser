import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/const.dart';
import '../controller/theme_controller.dart';
import '../util/color.dart';
import '../widget/dark_mode_switcher.dart';

class BookOpenPage extends StatefulWidget {
  final Widget child;

  const BookOpenPage({Key? key, required this.child}) : super(key: key);

  static BookOpenPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<BookOpenPageState>();

  @override
  BookOpenPageState createState() => new BookOpenPageState();
}

class BookOpenPageState extends State<BookOpenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool _canBeDragged = false;
  final double maxSlide = 300.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

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
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        gradient:
                            bgGradientColor(ThemeController.isLightTheme)),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, -0.001)
                      ..rotateY(math.pi * animationController.value / 10),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(
                                40 * animationController.value)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            // spreadRadius: 3,
                            blurRadius: 10,
                            offset:
                                Offset(10, 15), // changes position of shadow
                          ),
                        ],
                      ),
                      child: MyDrawer(),
                    ),
                  ),
                ),
                Transform.translate(
                  // offset: Offset(100, 0),
                  offset: Offset(0, 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, -0.001)
                      // ..scale(contentScale, contentScale, contentScale)
                      ..translate(
                        animationController.value * -50,
                        animationController.value * -250,
                        animationController.value * -25,
                      )
                      ..rotateY(-math.pi / 3.6 * (animationController.value))
                      ..scale(
                        1.0 - (0.65 * animationController.value),
                        1.0 - (0.8 * animationController.value),
                        1.0 - (0.65 * animationController.value),
                      ),
                    alignment: Alignment.centerRight,
                    child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              (40 * animationController.value)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              // spreadRadius: 3,
                              blurRadius: 10,
                              offset:
                                  Offset(30, 30), // changes position of shadow
                            ),
                          ],
                        ),
                        child: IgnorePointer(
                          child: widget.child,
                          ignoring:
                              animationController.value == 1.0 ? true : false,
                        )
                        // child: widget.child,
                        ),
                  ),
                ),
                Positioned(
                  top: 4.0 + MediaQuery.of(context).padding.top,
                  left: 4 +
                      animationController.value * maxSlide -
                      (40 * animationController.value),
                  // left: ((1 - animationController.value )* 4) + animationController.value * maxSlide,
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: toggle,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  top: 4.0 + MediaQuery.of(context).padding.top,
                  // right: 4.0 + animationController.value * maxSlide,
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
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }
}

class MyDrawer extends StatelessWidget {
  final textShadow = const Shadow(
    offset: Offset(5.0, 4.0),
    blurRadius: 10.0,
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white,
                          shadows: [textShadow]),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      shadows: <Shadow>[textShadow],
                    ),
                    title: Text(
                      'HOME',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[textShadow],
                      ),
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
