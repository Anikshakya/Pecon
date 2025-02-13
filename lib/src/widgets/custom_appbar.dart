import 'package:get/get.dart';
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
    preferredSize: Size(double.infinity, 124.0.h),
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
                    filterDialog();
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

  // Show manual code entry dialog
  filterDialog() {
    List catItems = ["Category 1", "Option X", "Option Y"];
    String selectedCategory1 = "Category 1";
    List productItems = ["Product 1", "Option X", "Option Y"];
    String selectedProduct = "Product 1";
    Get.defaultDialog(
      backgroundColor: boxCol,
      title: '',
      titlePadding: EdgeInsets.symmetric(horizontal: 20.0.w),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0.w),
      content: StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    "Filter Search Results",
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: black,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Filter Category",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: black,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() {
                        selectedCategory1 = value;
                      });
                    },
                    itemBuilder: (context) => catItems
                        .map((item) => PopupMenuItem<String>(
                              value: item,
                              child: SizedBox(
                                width: 200.w,
                                child: Text(item)
                              ),
                            ))
                        .toList(),
                    offset: Offset(4.w,0),
                    position: PopupMenuPosition.under, // Ensures the menu appears below
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.transparent, width: 0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selectedCategory1),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Filter Product",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: black,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() {
                        selectedProduct = value;
                      });
                    },
                    itemBuilder: (context) => productItems
                        .map((item) => PopupMenuItem<String>(
                              value: item,
                              child: SizedBox(
                                width: 200.w,
                                child: Text(item)
                              ),
                            ))
                        .toList(),
                    offset: Offset(4.w,0),
                    position: PopupMenuPosition.under, // Ensures the menu appears below
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.transparent, width: 0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selectedProduct),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Submit Button
                  CustomButton(
                    onPressed: () {
                      // Handle manual code submission
                      Get.back();
                    },
                    text: "Apply",
                    bgColor: black,
                    fontColor: white,
                  ),
                  SizedBox(height: 10.h),
                  // Cancel Button
                  CustomButton(
                    onPressed: () {
                      // Handle manual code submission
                      Get.back();
                    },
                    text: "Cancel",
                    bgColor: Colors.transparent,
                    fontColor: black,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }