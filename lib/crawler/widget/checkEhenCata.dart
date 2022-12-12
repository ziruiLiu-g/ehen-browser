import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final cataMap = {
  'Doujinshi': {"value": 2, "activeColor": Colors.red[400], "checkColor": Colors.red[200]},
  'Manga': {"value": 4, "activeColor": Colors.orange[400], "checkColor": Colors.orange[200]},
  'Artist CG': {"value": 8, "activeColor": Colors.yellow[600], "checkColor": Colors.yellow[200]},
  'Game CG': {"value": 16, "activeColor": Colors.green[400], "checkColor": Colors.green[200]},
  'Western': {"value": 512, "activeColor": Colors.lightGreen[300], "checkColor": Colors.lightGreen[100]},
  'Non-H': {"value": 256, "activeColor": Colors.lightBlue[300], "checkColor": Colors.lightBlue[100]},
  'Image Set': {"value": 32, "activeColor": Colors.blueAccent[400], "checkColor": Colors.blueAccent[100]},
  'Cosplay': {"value": 64, "activeColor": Colors.deepPurple[400], "checkColor": Colors.deepPurple[200]},
  'Asian Porn': {"value": 128, "activeColor": Colors.pink[300], "checkColor": Colors.red[100]},
  'Misc': {"value": 1, "activeColor": Colors.grey[700], "checkColor": Colors.grey[400]},
};

class EhenCheck extends StatefulWidget {

  Function(int) getCataFunc;

  @override
  State<EhenCheck> createState() => _EhenCheckState();

  EhenCheck(this.getCataFunc);
}

class _EhenCheckState extends State<EhenCheck> {
  Map<String, bool> checkMap = {
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
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      alignment: Alignment.center,
      height: 30.0,
      child: _createAllChecks(),
    );
  }

  _createAllChecks() {
    Widget content;
    List<Widget> ww = [];
    for (var k in checkMap.keys) {
      var values = cataMap[k];
      ww.add(_buildCheckBox(k, values));
      ww.add(SizedBox(width: 20),);
    }
    content = ListView(
      scrollDirection: Axis.horizontal,
      children: ww,
    );

    return content;
  }

  _buildCheckBox(key, values) {
    return InkWell(
      key: Key(key),
      onTap: () {
        bool ch = !checkMap[key.toString()]!;
        checkMap[key.toString()] = ch;
        widget.getCataFunc(calculateCataNum()!);
        setState(() {});
      },
      child: Container (
        width: 110,
        alignment: Alignment.center,
        //设置了 decoration 就不能设置color，两者只能存在一个
        decoration: BoxDecoration(
          color: checkMap[key.toString()]! ? values['activeColor'] : values['checkColor'],
          // border: Border(left: BorderSide(width: 1, color: Color(0x3D3B3BFF))),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(width: 2.0, color: Colors.grey)
        ),
        child: Text(
          key,
          style: TextStyle(
            color: checkMap[key.toString()]! ? Colors.white : Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  int? calculateCataNum() {
    int? num = 0;
    for (var k in checkMap.keys) {
      if (!checkMap[k]!) {
        Map<String, Object?>? curNum = cataMap[k];
        num = num! +  (curNum!['value'] as int?)!;
      }
    }

    return num;
  }
}
