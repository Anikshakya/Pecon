import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

customAppbar(){
  return PreferredSize(
    preferredSize: Size(double.infinity, 62.0.h),
    child: Container(
      color: primary,
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 12.0.sp),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            Row(
              children: [
                SizedBox(
                  height: 34.0.h,
                  child: Image.asset("assets/images/peacon_logo.png"),
                ),
                const Spacer(),
                Icon(Icons.headphones, color: black, size: 20.sp),
              ],
            ),
          ],
        ),
      ),
    )
  );
}


productAppbar(context){
  return PreferredSize(
    preferredSize: Size(double.infinity, 131.0.h),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 12.0.sp),
      decoration: const BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 34.h,
                  child: Image.asset("assets/images/peacon_logo.png"),
                ),
                const Spacer(),
                Icon(Icons.headphones, color: black, size: 20.sp),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 280.w,
                  height: 48.h,
                  child:  CustomTextFormField(
                    headingText: "Search", 
                    prefixIcon: Icon(Icons.search, color: grey10.withOpacity(0.8),),
                    filledColor: white,
                  )
                ),
                const Spacer(),
                GestureDetector(
                  onTap: (){
                    showFilterDialog(context);

                  },
                  child: const Icon(Icons.filter_alt_outlined, color: black)
                ),
              ],
            ),
          ],
        ),
      ),
    )
  );
}

showFilterDialog(BuildContext context) {
  String selectedCategory1 = "Category 1";
  String selectedCategory2 = "Category 2";

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.all(30.0.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Filter Search Results",
                  style: poppinsBold(size: 18.sp, color: black)
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  value: selectedCategory1,
                  items: ["Category 1", "Option A", "Option B"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedCategory1 = value!);
                  },
                  decoration: const InputDecoration(labelText: "Filter Category"),
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  value: selectedCategory2,
                  items: ["Category 2", "Option X", "Option Y"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedCategory2 = value!);
                  },
                  decoration: const InputDecoration(labelText: "Filter Price"),
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  width: double.infinity,
                  onPressed: () {
                    // Handle the selected values here if needed
                    Navigator.pop(context);
                  },
                  text: "Apply",
                  bgColor: black,
                  fontColor: white,
                ),
              ],
            ),
          );
        },
      );
    },
  );
}