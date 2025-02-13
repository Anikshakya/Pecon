import 'package:pecon/src/app_config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//----------Usual button ----------
// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final double? elevation;
  final Color? color;
  final double? borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? fontColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  TextStyle? style;
  final bool? isDisabled;
  final bool? isLoading; 
  final Color? bgColor; 
  final Color? loadingColor; 
  final Color borderColor; 
  final Key? buttonKey; 
  final Widget? widget;

  CustomButton({
    super.key,
    this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.elevation,
    this.color,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.fontColor = Colors.white,
    this.fontSize,
    this.fontWeight, 
    this.style, 
    this.isDisabled = false,
    this.isLoading = false,
    this.bgColor,
    this.borderColor = Colors.transparent, this.buttonKey, this.widget, this.loadingColor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? (45.h),
      width: width ?? 320,
      child: ElevatedButton(
        key: buttonKey,
        onPressed: isLoading == true ? (){} : isDisabled == true ? (){} : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled == true ? grey4 : bgColor ?? black,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
          ),
          elevation: 0,
          textStyle: poppinsSemiBold(
            color: fontColor,
            size: fontSize ?? 14.sp,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          animationDuration: const Duration(milliseconds: 200),
          side: BorderSide(
            color: borderColor
          )
        ),
        child: isLoading!?
        FittedBox(
          child: SizedBox(
            height: 24.sp,
            width: 24.sp,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: loadingColor ?? white,
            ),
          ),
        ):
        widget ??
        Text(
          text!,
          style: poppinsSemiBold(size: fontSize ?? 14.sp, color: fontColor ?? white),
        ),
      ),
    );
  }
}