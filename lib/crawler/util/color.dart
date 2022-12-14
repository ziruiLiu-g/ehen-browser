import 'package:flutter/material.dart';

const MaterialColor primary = const MaterialColor(
  0xffff9db5,
  const <int, Color>{
    50: Color(0xffff9db5),
    100: Color(0xffff9db5),
    200: Color(0xffff9db5),
    300: Color(0xffff9db5),
    400: Color(0xffff9db5),
    500: Color(0xffff9db5),
    600: Color(0xffff9db5),
    700: Color(0xffff9db5),
    800: Color(0xffff9db5),
    900: Color(0xffff9db5),
  },
);

 MaterialColor darkPrimary = MaterialColor(
  dark, <int, Color>{
    50: Color(dark),
    100: Color(dark),
    200: Color(dark),
    300: Color(dark),
    400: Color(dark),
    500: Color(dark),
    600: Color(dark),
    700: Color(dark),
    800: Color(dark),
    900: Color(dark),
  },
);


const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);

final dark = hexOfRGBA(48,48,48);

int hexOfRGBA(int r,int g,int b,{double opacity=1})
{
  r = (r<0)?-r:r;
  g = (g<0)?-g:g;
  b = (b<0)?-b:b;
  opacity = (opacity<0)?-opacity:opacity;
  opacity = (opacity>1)?255:opacity*255;
  r = (r>255)?255:r;
  g = (g>255)?255:g;
  b = (b>255)?255:b;
  int a = opacity.toInt();
  return int.parse('0x${a.toRadixString(16)}${r.toRadixString(16)}${g.toRadixString(16)}${b.toRadixString(16)}');
}


final cataMap = {
  'Doujinshi': {
    "value": 2,
    "activeColor": Colors.red[400],
    "checkColor": Colors.red[200]
  },
  'Manga': {
    "value": 4,
    "activeColor": Colors.orange[400],
    "checkColor": Colors.orange[200]
  },
  'Artist CG': {
    "value": 8,
    "activeColor": Colors.yellow[600],
    "checkColor": Colors.yellow[200]
  },
  'Game CG': {
    "value": 16,
    "activeColor": Colors.green[400],
    "checkColor": Colors.green[200]
  },
  'Western': {
    "value": 512,
    "activeColor": Colors.lightGreen[300],
    "checkColor": Colors.lightGreen[100]
  },
  'Non-H': {
    "value": 256,
    "activeColor": Colors.lightBlue[300],
    "checkColor": Colors.lightBlue[100]
  },
  'Image Set': {
    "value": 32,
    "activeColor": Colors.blueAccent[400],
    "checkColor": Colors.blueAccent[100]
  },
  'Cosplay': {
    "value": 64,
    "activeColor": Colors.deepPurple[400],
    "checkColor": Colors.deepPurple[200]
  },
  'Asian Porn': {
    "value": 128,
    "activeColor": Colors.pink[300],
    "checkColor": Colors.red[100]
  },
  'Misc': {
    "value": 1,
    "activeColor": Colors.grey[700],
    "checkColor": Colors.grey[400]
  },
};