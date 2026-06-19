import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as nepali;
import 'package:nepali_utils/nepali_utils.dart';
import 'package:pecon_app/src/app_config/styles.dart';
import 'package:pecon_app/src/app_config/validator.dart';
import 'package:pecon_app/src/controllers/user_controller.dart';
import 'package:pecon_app/src/widgets/custom_appbar.dart';
import 'package:pecon_app/src/widgets/custom_button.dart';
import 'package:pecon_app/src/widgets/custom_network_image.dart';
import 'package:pecon_app/src/widgets/custom_textfieldheader.dart';


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
  List<String> gender = ["Male", "Female"];
  int selectedGender = 0; // Store initial selection
  int selectedDistrictIndex = 0; 
  int selectedCityIndex = 0; 
  int? districtId; 
  int? cityId;
  bool? displayPrice;

  //initial DOB
  DateTime selectedDate = DateTime.now();
  DateTime selectedEnglishDate = DateTime.now();
  NepaliDateTime selectedNepaliDate = NepaliDateTime.now();


  // Profile Text Editing Controllers 
  final TextEditingController nameController     = TextEditingController();
  final TextEditingController emailController    = TextEditingController();
  final TextEditingController numController      = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController     = TextEditingController();
  final TextEditingController genderController   = TextEditingController();
  final TextEditingController dobController      = TextEditingController();
  final TextEditingController dobNepController      = TextEditingController();
  final TextEditingController addressController  = TextEditingController();
  //--- For shopkeeper ---
  final TextEditingController shopNameCon  = TextEditingController();
  final TextEditingController shopPanCon  = TextEditingController();
  final TextEditingController shopOwnerCon  = TextEditingController();

  // Bank Text Editing Controllers 
  final TextEditingController accNameController  = TextEditingController();
  final TextEditingController bankController     = TextEditingController();
  final TextEditingController accNoController    = TextEditingController();
  final TextEditingController branchController   = TextEditingController();
  final TextEditingController esewaController    = TextEditingController();
  final TextEditingController khaltiController   = TextEditingController();

  //current form view
  bool isProfileView = true;

  // Show BS
  bool showBs = false;

  @override
  void initState() {
    initialise();
    super.initState();
  }

  initialise() async {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    // Get Logged In User data
    userCon.getUserData(true);

    await userCon.getDistrictData(isNepal: true);

    if (userCon.user.value.data.user.role.toLowerCase() == "technician") {
      if(userCon.shopkeeperIdControllers.isEmpty){
        userCon.addShopkeeperField();
      }
      await userCon.getShopkeeperList();
    }

    final user = userCon.user.value.data.user;

    setState(() {

      // ===== FLAGS =====
      if (user.number.toString().startsWith("977")) {
        showBs = true;
      }

      districtId = user.districtId;
      cityId = user.cityId;

      // ===== DISTRICT INDEX =====
      selectedDistrictIndex = userCon.districtList.indexWhere(
        (item) =>
            item["name"].toString().toLowerCase() ==
            user.district.toString().toLowerCase(),
      );

      // ===== IMPORTANT FIX: LOAD CITY LIST =====
      if (selectedDistrictIndex != -1) {
        userCon.cityList = List.from(
          userCon.districtList[selectedDistrictIndex]["cities"] ?? [],
        );
      } else {
        userCon.cityList = [];
      }

      // ===== CITY INDEX (NOW VALID) =====
      selectedCityIndex = userCon.cityList.indexWhere(
        (item) =>
            item["name"].toString().toLowerCase() ==
            user.city.toString().toLowerCase(),
      );

      if (selectedCityIndex < 0) {
        selectedCityIndex = 0;
      }

      // ===== GENDER =====
      selectedGender = gender.indexWhere(
        (item) =>
            item.toLowerCase() ==
            user.gender.toLowerCase(),
      );

      if (selectedGender < 0) selectedGender = 0;

      // ===== PROFILE IMAGE =====
      changedProfileImage = user.profileUrl;

      // ===== CONTROLLERS =====
      nameController.text = user.name;
      emailController.text = user.email;
      numController.text = user.number;
      districtController.text = user.district;
      cityController.text = user.city;
      genderController.text = user.gender.isEmpty
          ? ""
          : user.gender[0].toUpperCase() + user.gender.substring(1);

      addressController.text = user.address;
      dobController.text = user.dob;

      // ===== DOB =====
      if (user.dob.isNotEmpty) {
        final DateTime englishDate = DateTime.parse(user.dob);
        selectedDate = englishDate;

        final NepaliDateTime nepaliDate =
            englishDate.toNepaliDateTime();

        dobController.text =
            "${englishDate.year.toString().padLeft(4, '0')}-"
            "${englishDate.month.toString().padLeft(2, '0')}-"
            "${englishDate.day.toString().padLeft(2, '0')}";

        dobNepController.text =
            "${nepaliDate.year.toString().padLeft(4, '0')}-"
            "${nepaliDate.month.toString().padLeft(2, '0')}-"
            "${nepaliDate.day.toString().padLeft(2, '0')}";
      }

      // ===== BANK =====
      accNameController.text = user.bank.holderName;
      bankController.text = user.bank.name;
      accNoController.text = user.bank.accountNumber;
      branchController.text = user.bank.branch;
      esewaController.text = user.bank.esewa;
      khaltiController.text = user.bank.khalti;

      // ===== SHOP / VENDOR =====
      displayPrice = user.vendor.displayPrice;
      shopNameCon.text = user.vendor.vendorName;
      shopPanCon.text = user.vendor.vendorPan;
      shopOwnerCon.text = user.vendor.vendorEmail;
    });
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: appbar(title: "My Profile"),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: RefreshIndicator(
          color: black,
          onRefresh: (){
            return Future.delayed(const Duration(seconds: 1),()async{// Get Athlete Details Data
              initialise();
            });
          },
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
                            color: isProfileView ? primary : black.withValues(alpha:0.15)
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
                            color: isProfileView ? black.withValues(alpha:0.15) : primary
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
                  submitButton(),
                
                  SizedBox(height: 20.h),
                ],
              ),
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
          changeProfilePic(),
          SizedBox(height: 20.h,),
          profileInfoForm(),
        ],
      )
    );
  }
  
  //profile form
  profileInfoForm() {
    return Form(
      key: formKey,
      child: Obx(() =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Name
            CustomTextFormHeaderField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              headingText: "User Name",
              filledColor: gray.withValues(alpha:0.2),
              validator: (value) => value != ""
                  ? null
                  : "Required",
            ),
            SizedBox(height: 20.h),
            //number
            CustomTextFormHeaderField(
              onTap: () {},
              readOnly: true,
              controller: numController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              headingText: "Mobile Number",
              filledColor: gray.withValues(alpha:0.2),
              validator: (value) => value != "" && value!.length == (userCon.isNepaliUser.value == true ? 13 : 12)
                  ? null
                  : userCon.isNepaliUser.value == true 
                    ? "Enter a valid 13-digit mobile number"
                    : "Enter a valid 12-digit mobile number",
            ),
            SizedBox(height: 20.h),
            //Email
            CustomTextFormHeaderField(
              controller: emailController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              headingText: "Email",
              filledColor: gray.withValues(alpha:0.2),
              inputFormatters: [
                LengthLimitingTextInputFormatter(255),
              ],
              validator: (email) => validateEmail(string: email!),
            ),
            SizedBox(height: 20.h),
            //Address
            CustomTextFormHeaderField(
              controller: addressController,
              textInputAction: TextInputAction.next,
              headingText: "Address",
              filledColor: gray.withValues(alpha:0.2),
            ),
            SizedBox(height: 20.h),
            //District
          Obx(()=>
            CustomTextFormHeaderField(
              readOnly: true,
              onTap: userCon.isDistrictLoading.isTrue ? (){} : (){showDistrictBottomSheet();},
              controller: districtController,
              textInputAction: TextInputAction.next,
              headingText: "District",
              filledColor: gray.withValues(alpha:0.2),
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
                  CustomTextFormHeaderField(
                    readOnly: true,
                    onTap: userCon.isDistrictLoading.isTrue ? (){} : showCupertinoCityPicker,
                    controller: cityController,
                    textInputAction: TextInputAction.next,
                    headingText: "City",
                    filledColor: gray.withValues(alpha:0.2),
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
            //Gender
            CustomTextFormHeaderField(
              onTap: showCupertinoGenderPicker,
              readOnly: true,
              controller: genderController,
              textInputAction: TextInputAction.next,
              headingText: "Gender",
              filledColor: gray.withValues(alpha:0.2),
              isDropdown: true,
            ),
            SizedBox(height: 20.h),
            //Dob
            CustomTextFormHeaderField(
              onTap: showCupertinoDatePicker,
              readOnly: true,
              controller: dobController,
              textInputAction: userCon.user.value.data.user.role.toLowerCase() == "customer" ? TextInputAction.done : TextInputAction.next,
              headingText: "Date of Birth (AD)",
              filledColor: gray.withValues(alpha:0.2),
              isDropdown: true,
            ),

            if(showBs == true) SizedBox(height: 20.h),

            // Nepali DOB
            if(showBs == true)
              CustomTextFormHeaderField(
                onTap: showNepaliDatePicker,
                readOnly: true,
                controller: dobNepController,
                headingText: "Date of Birth (BS)",
                filledColor: gray.withValues(alpha:0.2),
                isDropdown: true,
              ),

            // ---------- shopkeeper ----------
            Visibility(
              visible: userCon.user.value.data.user.role.toLowerCase() == "shopkeeper",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  // Shope Name
                  CustomTextFormHeaderField(
                    controller: shopNameCon,
                    textInputAction: TextInputAction.next,
                    headingText: "Shop Name",
                    filledColor: gray.withValues(alpha:0.2),
                    validator: (value) => value != ""
                      ? null
                      : "Required",
                  ),
                  SizedBox(height: 20.h),
                  // PAN Name
                  CustomTextFormHeaderField(
                    controller: shopPanCon,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    headingText: userCon.isNepaliUser.value == true ? "Shop PAN no." : "GST no.",
                    filledColor: gray.withValues(alpha:0.2),
                    validator: (value) {
                      if(userCon.isNepaliUser.value == true){
                        return value != "" 
                          ? null
                          : "Required";
                      } else {
                        return value != null && value.length == 15
                          ? null
                          : "Enter a valid 15-digit GST number";
                      }
                    } 
                  ),
                  SizedBox(height: 20.h),
                  // Owner Name
                  CustomTextFormHeaderField(
                    controller: shopOwnerCon,
                    textInputAction: TextInputAction.done,
                    headingText: "Shop Owner Name",
                    filledColor: gray.withValues(alpha:0.2),
                    validator: (value) => value != ""
                      ? null
                      : "Required",
                  ),
                ],
              ),
            ),
            //---------- Technician --------
            Obx(() {
              if (userCon.isProfileLoading.isTrue) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Visibility(
                visible: userCon.user.value.data.user.role.toLowerCase() == "technician",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    Obx(() => ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 15.h),
                          shrinkWrap: true,
                          itemCount: userCon.shopkeeperIdControllers.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextFormHeaderField(
                                        headingText:
                                            "Shopkeeper Id ${index + 1}",
                                        controller: userCon
                                            .shopkeeperIdControllers[index],
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
                                        filled: true,
                                        filledColor: Colors.grey
                                            .withValues(alpha: 0.2),
                                        suffixIcon:
                                            userCon.isshopkeeperIdLoading.isTrue
                                                ? Container(
                                                    padding:
                                                        const EdgeInsets.all(14),
                                                    child: const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.grey,
                                                        strokeWidth: 1.5,
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly
                                        ],
                                        onChanged: (value) {
                                          userCon.filterShopkeepersById(
                                              value, index);
                                        },
                                      ),
                                    ),
                                    if (index > 0)
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle,
                                            color: Colors.red),
                                        onPressed: () => userCon
                                            .removeShopkeeperField(index),
                                      ),
                                  ],
                                ),

                                Obx(() {
                                  if (userCon.showNameDisplays.length <= index ||
                                      !userCon.showNameDisplays[index]) {
                                    return const SizedBox.shrink();
                                  }

                                  final name =
                                      userCon.shopkeeperNames.length > index
                                          ? userCon.shopkeeperNames[index]
                                          : "";

                                  if (name.isEmpty) {
                                    return const Padding(
                                      padding:
                                          EdgeInsets.only(top: 8, left: 8),
                                      child: Text(
                                        "N/A",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  }

                                  final isError =
                                      name.startsWith('No shopkeeper');

                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, left: 8),
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isError
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  );
                                })
                              ],
                            );
                          },
                        )),

                    const SizedBox(height: 20),

                    Center(
                      child: CustomButton(
                        text: "Add Shopkeeper",
                        onPressed: () {
                          userCon.addShopkeeperField();
                        },
                      ),
                    )
                  ],
                ),
              );
            })
          ],
        ),
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
          CustomTextFormHeaderField(
            controller: accNameController,
            textInputAction: TextInputAction.next,
            headingText: "Account Holder Name",
            filledColor: gray.withValues(alpha:0.2),
          ),
          SizedBox(height: 20.h),
          //bank name
          CustomTextFormHeaderField(
            controller: bankController,
            textInputAction: TextInputAction.next,
            headingText: "Bank Name",
            filledColor: gray.withValues(alpha:0.2),
          ),
          SizedBox(height: 20.h),
          //bank acc no
          CustomTextFormHeaderField(
            controller: accNoController,
            textInputAction: TextInputAction.next,
            headingText: "Account Number",
            filledColor: gray.withValues(alpha:0.2),
          ),
          SizedBox(height: 20.h),
          //branchName
          CustomTextFormHeaderField(
            controller: branchController,
            textInputAction: TextInputAction.next,
            headingText: "Branch Name",
            filledColor: gray.withValues(alpha:0.2),
          ),
          SizedBox(height: 20.h),
          //esewa number
          CustomTextFormHeaderField(
            controller: esewaController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            headingText: userCon.isNepaliUser.value != true ? "IFSC CODE" : "Esewa Number",
            filledColor: gray.withValues(alpha:0.2),
            inputFormatters: [
              LengthLimitingTextInputFormatter(userCon.isNepaliUser.value != true ? 11 : 10),
            ],
          ),
          SizedBox(height: 20.h),
          //khalti number
          CustomTextFormHeaderField(
            controller: khaltiController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            headingText: userCon.isNepaliUser.value != true ? "UPI no./id" : "Khalti Number",
            filledColor: gray.withValues(alpha:0.2),
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
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
          Container(
            height: 120.sp,
            width: 120.sp,
            decoration: BoxDecoration(
              border: Border.all(color: black.withValues(alpha:0.2), width: 0.8.sp),
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
                    color: black.withValues(alpha:0.1),
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
                        child: Icon(Icons.photo_camera, color: black.withValues(alpha:0.7),)
                      ),
                      SizedBox(width: 12.0.w,),
                      Text("Camera", style: poppinsBold(size: 14.sp, color: black.withValues(alpha:0.7)),),
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
                        child: Icon(Icons.image, color: black.withValues(alpha:0.7),)
                      ),
                      SizedBox(width: 12.0.w,),
                      Text("Gallery", style: poppinsBold(size: 14.sp, color: black.withValues(alpha:0.7)),),
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
                  child: Icon(Icons.edit, color: black.withValues(alpha:0.8), size: 16.sp,)
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
                    district : districtId == 0 ? null : districtId,
                    city : cityId,
                    gender: genderController.text.toLowerCase().toString().trim(),
                    dob: dobController.text.toString().trim(),
                    address: addressController.text.toString().trim(),
                    image : changedProfileImage.runtimeType.toString() == 'XFile' ? changedProfileImage : null,
                    //--shopkeeper--
                    shopName: shopNameCon.text.toString().trim(),
                    panNum: shopPanCon.text.toString().trim(),
                    ownerName: shopOwnerCon.text.toString().trim(),
                    displayPrice: displayPrice,
                    //--technician--
                    shopkeeperId: userCon.user.value.data.user.role.toLowerCase() == "technician" 
                      ? userCon.shopkeeperIdControllers.map((e) => e.text.toString().trim()).toList()
                      : [],
                  );
                  setState(() {
                    changedProfileImage = userCon.user.value.data.user.profileUrl;
                  });
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
                    initialItem: userCon.cityList.isEmpty
                        ? 0
                        : selectedCityIndex.clamp(0, userCon.cityList.length - 1) as int,
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
                          genderController.text = gender[selectedGender]; // Update gender
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
                    initialItem: selectedGender,
                  ),
                  onSelectedItemChanged: (index) {
                    selectedGender = index;
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
                          // English date (AD)
                          dobController.text =
                              "${selectedDate.year.toString().padLeft(4, '0')}-"
                              "${selectedDate.month.toString().padLeft(2, '0')}-"
                              "${selectedDate.day.toString().padLeft(2, '0')}";

                          // Convert to Nepali (BS)
                          final NepaliDateTime nepaliDate =
                              selectedDate.toNepaliDateTime();

                          dobNepController.text =
                              "${nepaliDate.year.toString().padLeft(4, '0')}-"
                              "${nepaliDate.month.toString().padLeft(2, '0')}-"
                              "${nepaliDate.day.toString().padLeft(2, '0')}";
                        });

                        Navigator.pop(context);
                      },
                      child: Text(
                        "Done",
                        style: poppinsMedium(size: 15.sp, color: purple),
                      ),
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

  void showNepaliDatePicker() async {
    final pickedDate = await nepali.showMaterialDatePicker(
      context: context,
      initialDate: selectedNepaliDate,
      firstDate: NepaliDateTime(1980, 1, 1),
      lastDate: NepaliDateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedNepaliDate = pickedDate;
        selectedEnglishDate = pickedDate.toDateTime();

        dobNepController.text =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
        dobController.text =
            "${selectedEnglishDate.year}-${selectedEnglishDate.month}-${selectedEnglishDate.day}";
      });
    }
  }



}