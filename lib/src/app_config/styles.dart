import 'package:flutter/material.dart';

const primary  =  Color(0xffffca0a);
const white    =  Color(0xffffffff);
const black    =  Color(0xff000000);
const darkGray =  Color(0xff45414A);
const purple   =  Color(0xff7C6BA7);
const gray     =  Color(0xff9F9B9B);
const gray1    =  Color(0xffF5F5F5);
const black1   =  Color(0xff242425);
const purple1  =  Color(0xffF7F5FF);
const purple2  =  Color(0xffA395E8);
const yellow   =  Color(0xffF4BE37);
const yellowL  = Color(0xfffff9d4);
const green    =  Color.fromARGB(255, 79, 192, 122);
const red      =  Color.fromARGB(255, 247, 106, 106);
const maroon   =  Color.fromARGB(255, 202, 81, 81);


const grey1  =  Color(0xFF707070);
const grey2  =  Color(0xFFeaeaea);
const grey3  =  Color(0xFFE3E3E3);
const grey4  =  Color(0xFFC9C9C9);
const grey5  =  Color(0xFF818181);
const grey6  =  Color(0xFFD9D9D9);
const grey7  =  Color(0xFF404040);
const grey8  =  Color(0xFF1E1E1E);
const grey9  =  Color(0xFFE9E9E9);
const grey10 =  Color(0xff7F7B7F);
const grey11 =  Color(0xffA5A5A5);

//------- Fonts --------
isStandardFont(){
  var type = "standard";
  if(type == "standard" ||  type == ""){
    return true;
  } else{
    return false;
  }
}

poppinsBold({required double size, Color? color = const Color(0x00707070), double? charSpacing = 0.0, double? lineSpacing = 0.0, decoration}) => TextStyle(
  fontFamily: 'Inter-Bold',
  fontSize: size,
  decoration: decoration,
  color: color,
  letterSpacing: charSpacing,       // character spacing
  height: lineSpacing               // line spacing
);

poppinsSemiBold({required double size, Color? color = const Color(0x00707070), double? charSpacing = 0.0, double? lineSpacing = 0.0, decoration}) => TextStyle(
  fontFamily: 'Inter-SemiBold',
  fontSize: size,
  decoration: decoration,
  color: color,
  letterSpacing: charSpacing,       // character spacing
  height: lineSpacing               // line spacing
);


poppinsRegular({required double size, Color? color = const Color(0x00707070), double? charSpacing = 0.0, double? lineSpacing = 0.0}) => TextStyle(
  fontFamily: 'Inter-Regular',
  fontSize: size,
  color: color,
  letterSpacing: charSpacing,       // character spacing
  height: lineSpacing               // line spacing
);

poppinsMedium({required double size, Color? color = const Color(0x00707070), double? charSpacing = 0.0, double? lineSpacing = 0.0}) => TextStyle(
  fontFamily: 'Inter-Medium',
  fontSize: size,
  color: color,
  letterSpacing: charSpacing,       // character spacing
  height: lineSpacing               // line spacing
);

class NoGlowScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}