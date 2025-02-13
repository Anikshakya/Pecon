import 'package:pecon/src/app_config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomTextFormField extends StatelessWidget {
  final String headingText;
  final String? infoText;
  final String? initialValue;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? isRequired ;
  final bool? isOptional ;
  final bool? isDropdown;
  final bool readOnly;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final OutlineInputBorder? errorBorder;
  final InputBorder? disabledBorder;
  final Color? cursorColor;
  final Color? filledColor;
  final bool? filled;
  final int? maxLines;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final AutovalidateMode? autoValidateMode;
  final bool? isDisabled;
  final FocusNode? focusNode;
  final bool? autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? infoTextStyle;
  final int? maxLength;

  const CustomTextFormField({
    super.key,
    this.initialValue,
    this.controller,
    this.labelText,
    this.hintText,
    this.labelStyle,
    this.hintStyle,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
    this.cursorColor,
    this.maxLines,
    this.width,
    this.height, 
    this.filledColor, 
    this.filled, 
    this.autofocus = false, 
    this.readOnly = false, 
    this.onTap, 
    this.autoValidateMode, 
    this.isDisabled, 
    this.inputFormatters, 
    this.onFieldSubmitted,
    this.focusNode,
    required this.headingText, 
    this.isRequired, 
    this.isDropdown, this.isOptional, this.infoText, this.infoTextStyle, this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading Text and Required
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     // SizedBox(
        //     //   // width: width != null ? width!/2 : null,
        //     //   child: Text(headingText, style: poppinsSemiBold(size: 14.sp, color: black))
        //     // ),
        //     SizedBox(width: 8.w,),
        //     //Reauired Indicator
        //     Visibility(
        //       visible: isRequired == true,
        //       child: Container(
        //         height: 20.h,
        //         padding: EdgeInsets.symmetric(horizontal: 5.0.w),
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(4.r),
        //           color: black
        //         ),
        //         child: Text(
        //           "required".tr, 
        //           style: poppinsMedium(size: 13.sp, color: white),
        //           textAlign: TextAlign.center,
        //         )
        //       ),
        //     ),
        //     // Optional Indicator
        //     Visibility(
        //       visible: isOptional == true,
        //       child: Container(
        //         height: 20.h,
        //         padding: EdgeInsets.symmetric(horizontal: 5.0.w,),
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(4.r),
        //           color: grey9
        //         ),
        //         child: Text(
        //           "any".tr, 
        //           style: poppinsMedium(size: 13.sp, color: white),
        //           textAlign: TextAlign.center,
        //         )
        //       ),
        //     ),
        //     SizedBox(width: 4.w,),
        //     Visibility(
        //       visible: infoText != null,
        //       child: Text(infoText?? "", style: infoTextStyle ?? poppinsMedium(size: 12.sp, color: grey1))
        //     ),
        //   ],
        // ),
        // SizedBox(height: 4.0.h,),
        // TextField
        SizedBox(
          width: width,
          height: height,
          child: TextFormField(
            focusNode: focusNode,
            inputFormatters: inputFormatters ?? [],
            onTap: onTap,
            autofocus: autofocus!,
            autovalidateMode: autoValidateMode ?? AutovalidateMode.onUserInteraction,
            initialValue: initialValue,
            controller: controller,
            obscureText: obscureText,
            readOnly: isDropdown == true ? true : readOnly,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            cursorColor: cursorColor,
            maxLines: maxLines ?? 1,
            maxLength: maxLength,
            decoration: InputDecoration(
              errorMaxLines: 3,
              labelText: labelText,
              hintText: headingText,
              labelStyle: labelStyle,
              errorStyle: poppinsMedium(size: 11.sp,color: const Color.fromARGB(255, 139, 47, 47)),
              hintStyle: hintStyle ?? poppinsMedium(size: 12.sp, color: grey10.withOpacity(0.8)),
              prefixIcon: prefixIcon,
              suffixIcon: isDropdown == true 
                ? const Icon(Icons.arrow_drop_down, color: grey1,)
                :suffixIcon,
              border: border ??  OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.2
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.2
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.6
                ),
              ),
              fillColor: filledColor ?? white.withOpacity(0.9),
              filled: true,
              errorBorder: errorBorder ?? const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 139, 47, 47),  
                  width: 1.2
                ),
              ),
              focusedErrorBorder: errorBorder ?? const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 139, 47, 47), 
                  width: 1.2
                ),
              ),
              disabledBorder: disabledBorder,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomPasswordTextFormField extends StatelessWidget {
  final String headingText;
  final String? infoText;
  final String? initialValue;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? isRequired ;
  final bool? isOptional ;
  final bool? isDropdown;
  final bool readOnly;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final OutlineInputBorder? errorBorder;
  final InputBorder? disabledBorder;
  final Color? cursorColor;
  final Color? filledColor;
  final bool? filled;
  final int? maxLines;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final AutovalidateMode? autoValidateMode;
  final bool? isDisabled;
  final FocusNode? focusNode;
  final bool? autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? infoTextStyle;
  final int? maxLength;

  const CustomPasswordTextFormField({
    super.key,
    this.initialValue,
    this.controller,
    this.labelText,
    this.hintText,
    this.labelStyle,
    this.hintStyle,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
    this.cursorColor,
    this.maxLines,
    this.width,
    this.height, 
    this.filledColor, 
    this.filled, 
    this.autofocus = false, 
    this.readOnly = false, 
    this.onTap, 
    this.autoValidateMode, 
    this.isDisabled, 
    this.inputFormatters, 
    this.onFieldSubmitted,
    this.focusNode,
    required this.headingText, 
    this.isRequired, 
    this.isDropdown, this.isOptional, this.infoText, this.infoTextStyle, this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading Text and Required
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width != null ? width!/2 : null,
              child: Text(headingText, style: poppinsSemiBold(size: 14.sp, color: black))
            ),
            SizedBox(width: 8.w,),
            //Reauired Indicator
            Visibility(
              visible: isRequired == true,
              child: Container(
                height: 20.h,
                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: const Color.fromARGB(255, 87, 29, 29)
                ),
                child: Text(
                  "required".tr, 
                  style: poppinsMedium(size: 13.sp, color: white),
                  textAlign: TextAlign.center,
                )
              ),
            ),
            // Optional Indicator
            Visibility(
              visible: isOptional == true,
              child: Container(
                height: 20.h,
                padding: EdgeInsets.symmetric(horizontal: 5.0.w,),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: grey9
                ),
                child: Text(
                  "any".tr, 
                  style: poppinsMedium(size: 13.sp, color: white),
                  textAlign: TextAlign.center,
                )
              ),
            ),
            SizedBox(width: 4.w,),
            Visibility(
              visible: infoText != null,
              child: SizedBox(
                width: 211.w,
                child: Text(infoText?? "", style: infoTextStyle ?? poppinsMedium(size: 12.sp, color: grey1))
              )
            ),
          ],
        ),
        SizedBox(height: 4.0.h,),
        // TextField
        SizedBox(
          width: width,
          height: height,
          child: TextFormField(
            focusNode: focusNode,
            inputFormatters: inputFormatters ?? [],
            onTap: onTap,
            autofocus: autofocus!,
            autovalidateMode: autoValidateMode ?? AutovalidateMode.onUserInteraction,
            initialValue: initialValue,
            controller: controller,
            // obscureText: obscureText,
            readOnly: isDropdown == true ? true : readOnly,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            cursorColor: cursorColor,
            maxLines: maxLines ?? 1,
            maxLength: maxLength,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              labelStyle: labelStyle,
              hintStyle: hintStyle ?? poppinsMedium(size: 12.sp, color: grey1),
              prefixIcon: prefixIcon,
              suffixIcon: isDropdown == true 
                ? const Icon(Icons.arrow_drop_down, color: grey1,)
                :suffixIcon,
              border: border ??  OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: grey3,
                  width: 1.2
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: grey3 ,
                  width: 1.2
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: grey1,
                  width: 1.6
                ),
              ),
              fillColor:gray,
              filled: true,
              errorBorder: errorBorder ?? const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 139, 47, 47),  
                  width: 1.2
                ),
              ),
              focusedErrorBorder: errorBorder ?? const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 139, 47, 47),  
                  width: 1.2
                ),
              ),
              disabledBorder: disabledBorder,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}