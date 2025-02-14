import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/user_controller.dart';
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
  //Get controller
  final UserController userCon =Get.put(UserController());

  //Form keys
  final formKey = GlobalKey<FormState>();
  final bankFormKey = GlobalKey<FormState>();

  dynamic changedProfileImage;

  //gender selection
  List<String> gender = ["Male", "Female", "Others"];
  int selectedIndex = 0; // Store initial selection

  //initial DOB
  DateTime selectedDate = DateTime.now(); 

  // Profile Text Editing Controllers 
  final TextEditingController nameController     = TextEditingController();
  final TextEditingController emailController    = TextEditingController();
  final TextEditingController numController      = TextEditingController();
  final TextEditingController addressController  = TextEditingController();
  final TextEditingController genderController   = TextEditingController();
  final TextEditingController dobController      = TextEditingController();

  // Bank Text Editing Controllers 
  final TextEditingController accNameController  = TextEditingController();
  final TextEditingController bankController     = TextEditingController();
  final TextEditingController accNoController    = TextEditingController();
  final TextEditingController branchController   = TextEditingController();
  final TextEditingController esewaController    = TextEditingController();
  final TextEditingController khaltiController   = TextEditingController();

  //current form view
  bool isProfileView = true;

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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.0.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //get profile form button
                    InkWell(
                      onTap: () {
                        setState(() {
                          isProfileView = true;
                        });
                      },
                      child: Container(
                        height: 50.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: isProfileView ? primary : black.withOpacity(0.15)
                        ),
                        child: Center(child: Text("Personal Details", style: poppinsSemiBold(size: 14.sp, color: black),)),
                      ),
                    ),
                    //get bank form button
                    InkWell(
                      onTap: () {
                        setState(() {
                          isProfileView = false;
                        });
                      },  
                      child: Container(
                        height: 50.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: isProfileView ? black.withOpacity(0.15) : primary
                        ),
                        child: Center(child: Text("Bank Details", style: poppinsSemiBold(size: 14.sp, color: black),)),
                      ),
                    ),
                  ],
                ),
                //form
                isProfileView 
                  ? profileView()
                  : bankView(),
                //submitButton
                submitButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  //profileView
  profileView(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.0.h),
      child: Column(
        children: [
          // changeProfilePic(),
          // SizedBox(height: 20.h,),
          profileInfoForm(),
        ],
      )
    );
  }
  
  //profile form
  profileInfoForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          //Name
          CustomTextFormField(
            controller: nameController,
            textInputAction: TextInputAction.next,
            headingText: "User Name",
            filledColor: gray.withOpacity(0.2),
            validator: (value) => value != ""
                ? null
                : "Required",
          ),
          SizedBox(height: 20.h),
          //number
          CustomTextFormField(
            controller: numController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            headingText: "Mobile Number",
            filledColor: gray.withOpacity(0.2),
            validator: (value) => value != ""
                ? null
                : "Required",
          ),
          SizedBox(height: 20.h),
          //Email
          CustomTextFormField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            headingText: "Email",
            filledColor: gray.withOpacity(0.2),
          ),
          SizedBox(height: 20.h),
          //Address
          CustomTextFormField(
            controller: addressController,
            textInputAction: TextInputAction.next,
            headingText: "Address",
            filledColor: gray.withOpacity(0.2),
          ),
          SizedBox(height: 20.h),
          //Gender
          CustomTextFormField(
            onTap: showCupertinoGenderPicker,
            readOnly: true,
            controller: genderController,
            textInputAction: TextInputAction.next,
            headingText: "Gender",
            filledColor: gray.withOpacity(0.2),
          ),
          SizedBox(height: 20.h),
          //Dob
          CustomTextFormField(
            onTap: showCupertinoDatePicker,
            readOnly: true,
            controller: dobController,
            textInputAction: TextInputAction.done,
            headingText: "Date of Birth",
            filledColor: gray.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  //bankView
  bankView(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.0.h),
      child: Column(
        children: [
          bankInfoForm(),
        ],
      )
    );
  }
  
  //bank form
  bankInfoForm() {
    return Form(
      key: bankFormKey,
      child: Column(
        children: [
          //Name
          CustomTextFormField(
            controller: accNameController,
            textInputAction: TextInputAction.next,
            headingText: "Account Holder Name",
            filledColor: gray.withOpacity(0.2),
            validator: (value) => value != ""
                ? null
                : "Required",
          ),
          SizedBox(height: 20.h),
          //bank name
          CustomTextFormField(
            controller: bankController,
            textInputAction: TextInputAction.next,
            headingText: "Bank Name",
            filledColor: gray.withOpacity(0.2),
            validator: (value) => value != ""
                ? null
                : "Required",
          ),
          SizedBox(height: 20.h),
          //bank acc no
          CustomTextFormField(
            controller: accNoController,
            textInputAction: TextInputAction.next,
            headingText: "Account Number",
            filledColor: gray.withOpacity(0.2),
            validator: (value) => value != ""
                ? null
                : "Required",
          ),
          SizedBox(height: 20.h),
          //branchName
          CustomTextFormField(
            controller: branchController,
            textInputAction: TextInputAction.next,
            headingText: "Branch Name",
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
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            headingText: "Khalti Number",
            filledColor: gray.withOpacity(0.2),
          ),
        ],
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
  
  //submit button
  submitButton() {
    // Submit Button
    return Obx(()=>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w),
        child: Center(
          child: CustomButton(
            width: double.infinity,
            isLoading: isProfileView ? userCon.isProfileBtnLoading.value : userCon.isBankBtnLoading.value,
            onPressed: isProfileView 
              ? () async {
                final isValid = formKey.currentState!.validate();
                  if (!isValid) return;
                  await userCon.updateProfile(
                    name: nameController.text.toString().trim(),
                    number: numController.text.toString().trim(),
                    email: emailController.text.toString().trim(),
                    address: addressController.text.toString().trim(),
                    gender: genderController.text.toString().trim(),
                    dob: dobController.text.toString().trim(),
                  );
              }
              : () async {
                final isValid =  bankFormKey.currentState!.validate();
                  if (!isValid) return;
                  await userCon.updateBank(
                    accName: accNameController.text.toString().trim(),
                    bankName: bankController.text.toString().trim(),
                    accNum: accNoController.text.toString().trim(),
                    branchName: branchController.text.toString().trim(),
                    esewaNum: esewaController.text.toString().trim(),
                    khaltiNum: khaltiController.text.toString().trim()
                  );
              },
            text: "Submit",
          ),
        ),
      ),
    );
  }

  //gender picker
  showCupertinoGenderPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 240.h,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                height: 40.h,
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // Cancel
                      child: Text("Cancel", style: poppinsMedium(size:15.sp, color: purple),),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          genderController.text = gender[selectedIndex]; // Update gender
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Done", style: poppinsMedium(size:15.sp, color: purple),),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200.h,
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 40.h,
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedIndex,
                  ),
                  onSelectedItemChanged: (index) {
                    selectedIndex = index;
                  },
                  children: gender.map((role) => Center(child: Text(role, style: TextStyle(fontSize: 18.sp),))).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //DOB picker
  showCupertinoDatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 280.h,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                height: 40.h,
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // Cancel
                      child: Text("Cancel", style: poppinsMedium(size:15.sp, color: purple),),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          dobController.text = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Done", style: poppinsMedium(size:15.sp, color: purple),),
                    ),
                  ],
                ),
              ),
              // Date Picker
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: selectedDate, // Default selection
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: DateTime(1925, 1, 1), // Start from 1950
                  maximumDate: DateTime.now(),       // Until today
                  onDateTimeChanged: (DateTime newDate) {
                    if (newDate.isAfter(DateTime.now())) {
                      setState(() => selectedDate = DateTime.now()); // Reset if beyond today
                    } else {
                      setState(() => selectedDate = newDate);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}