import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';
import 'package:pecon/src/widgets/custom_text_field.dart';

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final formKey = GlobalKey<FormState>();

  dynamic changedProfileImage;

  // Text Editing Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController accNoController = TextEditingController();
  final TextEditingController esewaController = TextEditingController();
  final TextEditingController khaltiController = TextEditingController();

  @override
  void initState() {
    initialise();
    super.initState();
  }

  initialise() async{
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      // await authCon.getUserProfile().then((value)
      //   {
      //     changedProfileImage       = read("profileImage") == "" ? null : read("profileImage");
      //   }
      // );
      // setState((){});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: appbar(title: "My Profile"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            children: [
              changeProfilePic(),
              SizedBox(height: 30.h,),
              profileInfoForms(),
            ],
          )
        ),
      ),
    );
  }

  //change profile pic
  changeProfilePic() {
    return SizedBox(
      height: 126.sp,
      width: 126.sp,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100.r),
            child: changedProfileImage == null
            ? Container(
                height: 120.sp,
                width: 120.sp,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 236, 236, 236),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Icon(
                  Icons.camera,
                  color: black.withOpacity(0.1),
                  size: 120 * 0.45,
                ),
            )
            : changedProfileImage.runtimeType.toString() == 'XFile'
            ? Image.file(
                File(changedProfileImage!.path),
                height: 120.sp,
                width: 120.sp,
                fit: BoxFit.cover,
              )
            : CustomNetworkImage(
              imageUrl: changedProfileImage.toString(),
              height: 120.sp,
              width: 120.sp,
              fit: BoxFit.cover,
            )
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: PopupMenuButton<int>(color: boxCol,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 22.sp,
                        width: 22.sp,
                        child: Icon(Icons.photo_camera, color: black.withOpacity(0.7),)
                      ),
                      SizedBox(width: 12.0.w,),
                      Text("Camera", style: poppinsBold(size: 14.sp, color: black.withOpacity(0.7)),),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 22.sp,
                        width: 22.sp,
                        child: Icon(Icons.image, color: black.withOpacity(0.7),)
                      ),
                      SizedBox(width: 12.0.w,),
                      Text("Gallery", style: poppinsBold(size: 14.sp, color: black.withOpacity(0.7)),),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  padding: EdgeInsets.only(left: 16.0.sp, right: 16.0.sp, top: 0.0, bottom: 0.0),
                  value: 3,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 22.sp,
                        width: 22.sp,
                        child: Icon(Icons.delete, color: changedProfileImage == null ? gray : black.withOpacity(0.7),)
                      ),
                      SizedBox(width: 12.0.w,),
                      Text("Delete", style: poppinsBold(size: 14.sp, color: changedProfileImage == null ? gray : black.withOpacity(0.7)),),
                    ],
                  ),
                ),
              ],
              onSelected: (value) async{
                switch (value) {
                  case 1:
                    var value = await ImagePicker().pickImage(source: ImageSource.camera);
                    // await profileCon.uploadProfileImage(value);
                    setState(() {
                      changedProfileImage = value;
                    });
                    break;
                  case 2:
                    var value = await ImagePicker().pickImage(source: ImageSource.gallery);
                    // await profileCon.uploadProfileImage(value);
                    setState(() {
                      changedProfileImage = value;
                    });
                    break;
                  case 3:
                    if(changedProfileImage == null){
                      break;
                    }
                    else{
                      // await profileCon.deleteProfileImage();
                      setState(() {
                        changedProfileImage = null;
                      });
                      break;
                    }
                }
              },
              offset: const Offset(-10, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0.r),
              ),
              constraints: BoxConstraints(
                minWidth: 150.w
              ),
              icon: Container(
                height: 26.sp,
                width: 26.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0.r),
                  color: primary
                ),
                padding: EdgeInsets.all(4.sp),
                child: Center(
                  child: Icon(Icons.edit, color: black.withOpacity(0.8), size: 16.sp,)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  
  //profile form
  profileInfoForms() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          //Name
          CustomTextFormField(
            controller: nameController,
            textInputAction: TextInputAction.next,
            headingText: "Account Holder Name",
            filledColor: gray.withOpacity(0.2),
          ),
          SizedBox(height: 20.h),
          //bank name
          CustomTextFormField(
            controller: bankController,
            textInputAction: TextInputAction.next,
            headingText: "Bank Name",
            filledColor: gray.withOpacity(0.2),
          ),
          SizedBox(height: 20.h),
          //bank acc no
          CustomTextFormField(
            controller: accNoController,
            textInputAction: TextInputAction.next,
            headingText: "Account Number",
            filledColor: gray.withOpacity(0.2),
          ),
          SizedBox(height: 20.h),
          //esewa number
          CustomTextFormField(
            controller: esewaController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            headingText: "Esewa Number",
            filledColor: gray.withOpacity(0.2),
          ),
          SizedBox(height: 20.h),
          //khalti number
          CustomTextFormField(
            controller: khaltiController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            headingText: "Khalti Number",
            filledColor: gray.withOpacity(0.2),
          ),
          SizedBox(height: 40.h),
          // Login Button
          // Obx(()=>
            Center(
              child: CustomButton(
                width: double.infinity,
                // isLoading: authCon.isLoginLoading.value,
                onPressed: () async {
                },
                text: "Submit",
              ),
            ),
          // ),
        ],
      ),
    );
  }
}