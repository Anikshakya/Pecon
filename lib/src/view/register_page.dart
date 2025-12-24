import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/auth_controller.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/user_controller.dart';

class RegisterPage extends StatefulWidget {
  final bool isNepal;
  final String role;
  const RegisterPage({super.key, required this.isNepal, required this.role});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Get Controllers
  final AuthController authCon = Get.put(AuthController());
  final UserController userCon = Get.put(UserController());

  final formKey = GlobalKey<FormState>();

    // Text Controllers
  final TextEditingController mobileController          = TextEditingController();
  final TextEditingController nameCon                   = TextEditingController();
  final TextEditingController passwordController        = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController districtController        = TextEditingController();
  final TextEditingController cityController            = TextEditingController();

  //--- For shopkeeper ---
  final TextEditingController shopNameCon  = TextEditingController();
  final TextEditingController shopPanCon   = TextEditingController();

  // For Profile Pic
  dynamic changedProfileImage;

  bool isObscure = true;
  bool isConfirmPassObscure = true;

  List<String> roles = ["Shopkeeper", "Customer", "Technician"];
  String selectedRole = "Customer";

  int selectedDistrictIndex = 0;
  int selectedCityIndex = 0;
  int? districtId;
  int? cityId;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async{
    await userCon.getDistrictData(isNepal: widget.isNepal);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primary,
        ),
        backgroundColor: primary,
        extendBodyBehindAppBar: false,
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(30.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _registerHeading(),
                  SizedBox(height: 55.h),
                  // Profile
                  changeProfilePic(),
                  SizedBox(height: 30.h),
                  _registerForm(),
                  // ShopKeeper Section
                  _shopkeeperSection(),
                  SizedBox(height: 50.h),
                  _registerButton(),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _registerHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Register", style: poppinsBold(size: 20.sp, color: black),),
        SizedBox(height: 10.h),
        Text("Create a new account by filling up the form below.", style: poppinsMedium(size: 14.sp, color: black),),
      ],
    );
  }

  // Registration Form
  Widget _registerForm() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mobile Number
          CustomTextFormField(
            controller: mobileController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            headingText: "Mobile No.",
            validator:
                (mobile) =>
                    mobile != null && mobile.length == 10
                        ? null
                        : "Enter a valid 10-digit mobile number",
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Center(
                widthFactor: 1,
                child: Text(
                  widget.isNepal == true ? "+977" : "+91",
                  style: poppinsMedium(size: 14.sp, color: black),
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Name
          CustomTextFormField(
            controller: nameCon,
            textInputAction: TextInputAction.next,
            headingText: "Name",
          ),
          SizedBox(height: 20.h),
          //District
          Obx(()=>
            CustomTextFormField(
              readOnly: true,
              onTap: userCon.isDistrictLoading.isTrue ? (){} : (){showDistrictBottomSheet();},
              controller: districtController,
              textInputAction: TextInputAction.next,
              headingText: "District",
              suffixIcon: userCon.isDistrictLoading.isTrue 
                ? Container(
                  height: 48.h,
                  width: 48.h,
                  padding: EdgeInsets.all(14.sp),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: grey1,
                      strokeWidth: 1.5.sp,
                    ),
                  ),
                )
                : const Icon(Icons.arrow_drop_down, color: grey1,),
            ),
          ),
          SizedBox(height: 20.h),
          //City Controll
          Obx(()=>
            Visibility(
              visible: districtController.text.isNotEmpty,
              child: Column(
                children: [
                  CustomTextFormField(
                    readOnly: true,
                    onTap: userCon.isDistrictLoading.isTrue ? (){} : showCupertinoCityPicker,
                    controller: cityController,
                    textInputAction: TextInputAction.next,
                    headingText: "City",
                    suffixIcon: userCon.isDistrictLoading.isTrue || userCon.isCityLoading.isTrue
                      ? Container(
                        height: 48.h,
                        width: 48.h,
                        padding: EdgeInsets.all(14.sp),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: grey1,
                            strokeWidth: 1.5.sp,
                          ),
                        ),
                      )
                      : const Icon(Icons.arrow_drop_down, color: grey1,),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // Password
          CustomTextFormField(
            controller: passwordController,
            obscureText: isObscure,
            headingText: "Password",
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
              icon: Icon(
                isObscure ? Icons.visibility : Icons.visibility_off,
                size: 20.sp,
                color: gray,
              ),
            ),
            validator: (password) => password != null && password.length >= 6
                ? null
                : "Password must be at least 6 characters",
          ),
          SizedBox(height: 20.h),

          // Confirm Password
          CustomTextFormField(
            controller: confirmPasswordController,
            obscureText: isConfirmPassObscure,
            headingText: "Confirm Password",
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isConfirmPassObscure = !isConfirmPassObscure;
                });
              },
              icon: Icon(
                isConfirmPassObscure ? Icons.visibility : Icons.visibility_off,
                size: 20.sp,
                color: gray,
              ),
            ),
            validator: (confirmPassword) =>
                confirmPassword != null && confirmPassword == passwordController.text
                    ? null
                    : "Passwords do not match",
          ),
          SizedBox(height: 20.h),

          // Role Selection
          // GestureDetector(
          //   onTap: () {
          //     int selectedIndex = roles.indexOf(selectedRole); // Store initial selection
          //     showCupertinoModalPopup(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return Container(
          //           height: 240.h,
          //           color: Colors.white,
          //           child: Column(
          //             children: [
          //               Container(
          //                 padding: const EdgeInsets.symmetric(horizontal: 16),
          //                 height: 40,
          //                 color: Colors.grey[200],
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     TextButton(
          //                       onPressed: () => Navigator.pop(context), // Cancel
          //                       child: Text("Cancel", style: poppinsMedium(size:15.sp, color: purple),),
          //                     ),
          //                     TextButton(
          //                       onPressed: () {
          //                         setState(() {
          //                           selectedRole = roles[selectedIndex]; // Update role
          //                         });
          //                         Navigator.pop(context);
          //                       },
          //                       child: Text("Done", style: poppinsMedium(size:15.sp, color: purple),),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               SizedBox(
          //                 height: 200.h,
          //                 child: CupertinoPicker(
          //                   backgroundColor: Colors.white,
          //                   itemExtent: 40.h,
          //                   scrollController: FixedExtentScrollController(
          //                     initialItem: selectedIndex,
          //                   ),
          //                   onSelectedItemChanged: (index) {
          //                     selectedIndex = index; // Temporarily store selection
          //                   },
          //                   children: roles.map((role) => Center(child: Text(role, style: TextStyle(fontSize: 18.sp),))).toList(),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         );
          //       },
          //     );
          //   },
          //   child: AbsorbPointer(
          //     child: CustomTextFormField(
          //       headingText: "Select Role",
          //       controller: TextEditingController(text: selectedRole),
          //       validator: (value) =>
          //           value != null && value.isNotEmpty ? null : "Please select a role",
          //       suffixIcon: const Icon(Icons.arrow_drop_down, color: gray),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  //change profile pic
  changeProfilePic() {
    return Center(
      child: SizedBox(
        height: 126.sp,
        width: 126.sp,
        child: Stack(
          children: [
            Container(
              height: 120.sp,
              width: 120.sp,
              decoration: BoxDecoration(
                border: Border.all(color: black.withOpacity(0.2), width: 0.8.sp),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: changedProfileImage == "" || changedProfileImage == null
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
                  : Image.file(
                    File(changedProfileImage!.path),
                    height: 120.sp,
                    width: 120.sp,
                    fit: BoxFit.cover,
                  )
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: PopupMenuButton<int>(
                color: boxCol,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        SizedBox(
                            height: 22.sp,
                            width: 22.sp,
                            child: Icon(
                              Icons.photo_camera,
                              color: black.withOpacity(0.7),
                            )),
                        SizedBox(
                          width: 12.0.w,
                        ),
                        Text(
                          "Camera",
                          style: poppinsBold(
                              size: 14.sp, color: black.withOpacity(0.7)),
                        ),
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
                            child: Icon(
                              Icons.image,
                              color: black.withOpacity(0.7),
                            )),
                        SizedBox(
                          width: 12.0.w,
                        ),
                        Text(
                          "Gallery",
                          style: poppinsBold(
                              size: 14.sp, color: black.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) async {
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
                  }
                },
                offset: const Offset(-10, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0.r),
                ),
                constraints: BoxConstraints(minWidth: 150.w),
                icon: Container(
                  height: 26.sp,
                  width: 26.sp,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0.r),
                      color: primary),
                  padding: EdgeInsets.all(4.sp),
                  child: Center(
                      child: Icon(
                    Icons.edit,
                    color: black.withOpacity(0.8),
                    size: 16.sp,
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Register Button
  Widget _registerButton() {
    return Obx(
      () => CustomButton(
        width: double.infinity,
        isLoading: authCon.isRegisterLoading.value,
        text: "Register",
        onPressed: () async {
          if (!formKey.currentState!.validate()) return;

          await authCon.register(
            name: nameCon.text.trim(),
            number: mobileController.text.trim(),
            password: confirmPasswordController.text.trim(),
            role: widget.role,
            district: districtId,
            city: cityId,
            //--shopkeeper--
            shopName: shopNameCon.text.toString().trim(),
            shopPan: shopPanCon.text.toString().trim(),
            profile: changedProfileImage
          );
        },
      ),
    );
  }

  // Shopkeeper Section
  Visibility _shopkeeperSection() {
    return Visibility(
      visible: widget.role.toString().toLowerCase() == "shopkeeper",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shope Name
          CustomTextFormField(
            controller: shopNameCon,
            textInputAction: TextInputAction.next,
            headingText: "Shop Name",
            validator: (value) => value != "" ? null : "Required",
          ),
          SizedBox(height: 20.h),
          // PAN Name
          CustomTextFormField(
            controller: shopPanCon,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            headingText: "Shop PAN no.",
            validator: (value) => value != "" ? null : "Required",
          ),
        ],
      ),
    );
  }

  //show district bottomsheet
  showDistrictBottomSheet() {
    String searchQuery = '';
    List<dynamic> filteredDistricts = List.from(userCon.districtList);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Header with title and close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select District',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 24.sp),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  
                  // Modern search field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[50],
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search district...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14.h,
                          horizontal: 16.w,
                        ),
                      ),
                      style: TextStyle(fontSize: 16.sp),
                      onChanged: (value) {
                        setModalState(() {
                          searchQuery = value.toLowerCase();
                          filteredDistricts = userCon.districtList.where((district) {
                            return district["name"].toString().toLowerCase().contains(searchQuery);
                          }).toList();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 12.h),
                  
                  // Modern list with subtle dividers
                  Expanded(
                    child: filteredDistricts.isEmpty
                        ? Center(
                            child: Text(
                              "No districts found",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredDistricts.length,
                            itemBuilder: (context, index) {
                              final district = filteredDistricts[index];
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    setState(() {
                                      districtController.text = district["name"].toString();
                                      districtId = district["id"];

                                      // 👇 Load cities directly from selected district
                                      userCon.cityList = district["cities"] ?? [];

                                      cityController.clear();
                                      cityId = null;
                                      selectedCityIndex = 0;
                                    });

                                    Get.back();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                      horizontal: 20.w,
                                    ),
                                    child: Text(
                                      district["name"].toString(),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Show City Picker
  showCupertinoCityPicker() {
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
                      child: Text("Cancel", style: poppinsMedium(size: 15.sp, color: purple)),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if(userCon.cityList.isNotEmpty){
                            // Store selected district ID in text controller
                            cityController.text = userCon.cityList[selectedCityIndex]["name"].toString();
                            cityId = userCon.cityList[selectedCityIndex]["id"];
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Done", style: poppinsMedium(size: 15.sp, color: purple)),
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
                    initialItem: selectedCityIndex,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedCityIndex = index;
                    });
                  },
                  children: userCon.cityList
                      .map<Widget>((city) => Center(
                            child: Text(
                              city["name"].toString(), // Ensure the name is displayed
                              style: TextStyle(fontSize: 18.sp),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
