import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/app_controller.dart';
import 'package:pecon/src/view/country_select_page.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_markdown.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';

class RegisterTermsAndConditions extends StatefulWidget {
  final String role;
  const RegisterTermsAndConditions({super.key, required this.role});

  @override
  State<RegisterTermsAndConditions> createState() => _RegisterTermsAndConditionsState();
}

class _RegisterTermsAndConditionsState extends State<RegisterTermsAndConditions> {
  final AppController appCon = Get.put(AppController());

  bool isAccepted = false; // 👈 checkbox state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: appbar(title: "Terms and Conditions"),
      body: Scrollbar(
        trackVisibility: true,
        thumbVisibility: true,
        interactive: true,
        radius: Radius.circular(8.sp),
        thickness: 10.0.sp,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 24.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomMarkdownWidget(
                  data: appCon.termsCondition,
                  imageBuilder: (uri, title, alt) {
                    return CustomNetworkImage(
                      imageUrl: uri.toString(),
                      height: 442.0.h,
                      width: double.infinity,
                    );
                  },
                ),
        
                20.verticalSpace,
        
                /// ✅ Accept Terms Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isAccepted,
                      onChanged: (value) {
                        setState(() {
                          isAccepted = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.sp),
                        child: Text(
                          "I have read and agree to the Terms and Conditions",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ],
                ),
        
                24.verticalSpace,
        
                /// ✅ Register Button
                CustomButton(
                  width: double.infinity,
                  isDisabled: !isAccepted, 
                  onPressed: isAccepted
                      ? () {
                          Get.to(() => CountrySelectPage(role: widget.role));
                        }
                      : () {},
                  text: "Register",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}