import 'package:ehentai_browser/util/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/cata_controller.dart';

class EhenCheck extends StatefulWidget {
  Function(int) getCataFunc;

  @override
  State<EhenCheck> createState() => _EhenCheckState();

  EhenCheck(this.getCataFunc);
}

class _EhenCheckState extends State<EhenCheck> {
  final ctaController = Get.put(CataController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      alignment: Alignment.center,
      height: 30.0,
      child: _createAllChecks(),
    );
  }

  Widget _createAllChecks() {
    Widget content;
    List<Widget> ww = [];
    for (var k in ctaController.cataCheck.keys) {
      var values = cataMap[k];
      ww.add(_buildCheckBox(k, values));
      ww.add(
        SizedBox(width: 20),
      );
    }
    content = ListView(
      scrollDirection: Axis.horizontal,
      children: ww,
    );

    return content;
  }

  Widget _buildCheckBox(key, values) {
    return Obx(() => InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          key: Key(key.toString()),
          onTap: () {
            var curKey = key.toString();
            Map<String, Object?>? curNum = cataMap[curKey];
            var checkValue = (curNum!['value'] as int?)!;
            ctaController.changeCheck(curKey);
            ctaController.updateNum(ctaController.cataCheck[curKey]! ? 0 - checkValue : checkValue);

            widget.getCataFunc(ctaController.cataNum);
          },
          child: Container(
            width: 110,
            alignment: Alignment.center,
            //设置了 decoration 就不能设置color，两者只能存在一个
            decoration: BoxDecoration(
                color: ctaController.cataCheck[key.toString()]!
                    ? values['activeColor'] as Color
                    : values['checkColor'] as Color,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(width: 2.0, color: Colors.grey)),
            child: Text(
              key.toString(),
              style: TextStyle(
                color: ctaController.cataCheck[key.toString()]! ? Colors.white : Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ));
  }
}
