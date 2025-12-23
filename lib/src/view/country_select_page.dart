import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/view/register_page.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/partner_logo.dart';

class CountrySelectPage extends StatefulWidget {
  final String role;
  const CountrySelectPage({super.key, required this.role});

  @override
  State<CountrySelectPage> createState() => _CountrySelectPageState();
}

class _CountrySelectPageState extends State<CountrySelectPage> {
  bool isNepal = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(elevation: 0, backgroundColor: primary),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              Center(
                child: Image.asset("assets/images/peacon_logo.png", height: 50.h)
              ),
              SizedBox(height: 60.h),
              Text(
                "Select Your Country",
                style: poppinsBold(size: 20.sp, color: black),
              ),
              SizedBox(height: 8.h),
              Text(
                "Choose your country to continue registration.",
                style: poppinsMedium(size: 14.sp, color: black),
              ),
        
              SizedBox(height: 40.h),
        
              Row(
                children: [
                  _countryCard(
                    title: "Nepal",
                    code: "+977",
                    flag: "🇳🇵",
                    selected: isNepal,
                    onTap: () {
                      setState(() => isNepal = true);
                    },
                  ),
                  SizedBox(width: 16.w),
                  _countryCard(
                    title: "India",
                    code: "+91",
                    flag: "🇮🇳",
                    selected: !isNepal,
                    onTap: () {
                      setState(() => isNepal = false);
                    },
                  ),
                ],
              ),
        
              SizedBox(height: 40.h),
        
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () {
                    Get.to(() => RegisterPage(isNepal: isNepal, role : widget.role));
                  },
                  text: "Continue",
                ),
              ),
        
              SizedBox(height: 120.h),
              partnerLogo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _countryCard({
    required String title,
    required String code,
    required String flag,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 20.h),
          decoration: BoxDecoration(
            color: selected ? white : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? purple : Colors.grey.shade400,
              width: selected ? 2 : 1,
            ),
            boxShadow:
                selected
                    ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                    : [],
          ),
          child: Column(
            children: [
              Text(flag, style: TextStyle(fontSize: 32.sp)),
              SizedBox(height: 8.h),
              Text(title, style: poppinsMedium(size: 15.sp, color: black)),
              SizedBox(height: 4.h),
              Text(code, style: poppinsRegular(size: 13.sp, color: gray)),
            ],
          ),
        ),
      ),
    );
  }
}
