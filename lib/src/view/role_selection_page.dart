import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/view/login.dart';
import 'package:pecon/src/view/register_termscondition.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/partner_logo.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  List<String> roles = ["Shopkeeper", "Customer", "Technician"];
  String selectedRole = "Customer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
      ),
      backgroundColor: primary,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100.h),
              Center(
                child: Image.asset("assets/images/peacon_logo.png", height: 50.h)
              ),
              SizedBox(height: 70.h),
        
              Text('If you are new here, please select your role to continue',
                style: poppinsRegular(size: 15.sp, color: black),
              ),
              SizedBox(height: 30.h),
              _rolePickerField(),
        
              SizedBox(height: 30.h),
        
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: CustomButton(
                  width: double.infinity,
                  onPressed:  selectedRole.isEmpty
                      ? () {}
                      : () {
                          Get.to(()=> RegisterTermsAndConditions(role: selectedRole,));
                        },
                  text: "Continue",
                ),
              ),
        
              SizedBox(height: 50.h,),
              //already have an account
              Text('Already have an account?',
                style: poppinsRegular(size: 15.sp, color: black),
              ),
              SizedBox(height: 10.h,),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: CustomButton(
                  onPressed: (){
                    Get.to(() => const LoginPage());
                  },
                  text: "Login",
                ),
              ),
              
              SizedBox(height: 134.h),
              partnerLogo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rolePickerField() {
    return DropdownButtonFormField<String>(
      value: selectedRole.isEmpty ? null : selectedRole,
      items: roles
          .map(
            (role) => DropdownMenuItem<String>(
              value: role,
              child: Text(
                role,
                style: TextStyle(fontSize: 15.sp),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedRole = value ?? "";
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        hintText: "Select Category",
        hintStyle: TextStyle(color: gray, fontSize: 15.sp),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: gray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: gray),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: gray),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
    );
  }

  // Cupertion Picker
  // Widget _rolePickerField() {
  //   return GestureDetector(
  //     onTap: () {
  //       int selectedIndex =
  //           selectedRole.isEmpty ? 0 : roles.indexOf(selectedRole);

  //       showCupertinoModalPopup(
  //         context: context,
  //         builder: (_) {
  //           return Container(
  //             height: 240.h,
  //             color: Colors.white,
  //             child: Column(
  //               children: [
  //                 Container(
  //                   height: 40,
  //                   color: Colors.grey[200],
  //                   padding: const EdgeInsets.symmetric(horizontal: 16),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       TextButton(
  //                         onPressed: () => Navigator.pop(context),
  //                         child: Text(
  //                           "Cancel",
  //                           style:
  //                               poppinsMedium(size: 15.sp, color: purple),
  //                         ),
  //                       ),
  //                       TextButton(
  //                         onPressed: () {
  //                           setState(() {
  //                             selectedRole = roles[selectedIndex];
  //                           });
  //                           Navigator.pop(context);
  //                         },
  //                         child: Text(
  //                           "Done",
  //                           style:
  //                               poppinsMedium(size: 15.sp, color: purple),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 200.h,
  //                   child: CupertinoPicker(
  //                     itemExtent: 40.h,
  //                     scrollController: FixedExtentScrollController(
  //                       initialItem: selectedIndex,
  //                     ),
  //                     onSelectedItemChanged: (index) {
  //                       selectedIndex = index;
  //                     },
  //                     children: roles
  //                         .map(
  //                           (role) => Center(
  //                             child: Text(
  //                               role,
  //                               style: TextStyle(fontSize: 18.sp),
  //                             ),
  //                           ),
  //                         )
  //                         .toList(),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 16.w),
  //       height: 50.h,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(color: gray),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             selectedRole.isEmpty ? "Select Category" : selectedRole,
  //             style: TextStyle(
  //               color: selectedRole.isEmpty ? gray : Colors.black,
  //               fontSize: 15.sp,
  //             ),
  //           ),
  //           const Icon(Icons.arrow_drop_down, color: gray),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
