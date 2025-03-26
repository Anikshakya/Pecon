import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/app_config/validator.dart';
import 'package:pecon/src/controllers/user_controller.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';
import 'package:pecon/src/widgets/custom_textfieldheader.dart';

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

  // Profile Text Editing Controllers 
  final TextEditingController nameController     = TextEditingController();
  final TextEditingController emailController    = TextEditingController();
  final TextEditingController numController      = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController     = TextEditingController();
  final TextEditingController genderController   = TextEditingController();
  final TextEditingController dobController      = TextEditingController();
  final TextEditingController addressController  = TextEditingController();
  //--- For shopkeeper ---
  final TextEditingController shopNameCon  = TextEditingController();
  final TextEditingController shopPanCon  = TextEditingController();
  final TextEditingController shopOwnerCon  = TextEditingController();
  // --- For Technician ---
  List shopkeeperlists = [
    TextEditingController()
  ];

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
      await userCon.getDistrictData();

      setState((){
        districtId              = userCon.user.value.data.districtId;
        cityId                  = userCon.user.value.data.cityId;
        selectedDistrictIndex   = userCon.districtList.indexWhere((item) => item["name"] == userCon.user.value.data.district.toString());
        selectedGender          = gender.indexWhere((item) => item.toLowerCase() == userCon.user.value.data.gender.toLowerCase().toString());
        selectedCityIndex       = userCon.cityList.indexWhere((item) => item["name"] == userCon.user.value.data.city.toString());
        changedProfileImage     = userCon.user.value.data.profileUrl;
        // Profile Text Editing Controllers 
        nameController.text     = userCon.user.value.data.name;
        emailController.text    = userCon.user.value.data.email;
        numController.text      = userCon.user.value.data.number;
        districtController.text = userCon.user.value.data.district;
        cityController.text     = userCon.user.value.data.city;
        genderController.text   = userCon.user.value.data.gender == "" ? "" : userCon.user.value.data.gender[0].toUpperCase() + userCon.user.value.data.gender.substring(1);
        dobController.text      = userCon.user.value.data.dob;
        addressController.text  = userCon.user.value.data.address;

        // Bank Text Editing Controllers 
        accNameController.text  = userCon.user.value.data.bank.holderName;
        bankController.text     = userCon.user.value.data.bank.name;
        accNoController.text    = userCon.user.value.data.bank.accountNumber;
        branchController.text   = userCon.user.value.data.bank.branch;
        esewaController.text    = userCon.user.value.data.bank.esewa;
        khaltiController.text   = userCon.user.value.data.bank.khalti;

        //Shopkeeper data
        displayPrice            = userCon.user.value.data.vendor!.displayPrice;
        shopNameCon.text        = userCon.user.value.data.vendor!.vendorName;
        shopPanCon.text         = userCon.user.value.data.vendor!.vendorPan;
        shopOwnerCon.text       = userCon.user.value.data.vendor!.vendorEmail;
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
              filledColor: gray.withOpacity(0.2),
              validator: (value) => value != ""
                  ? null
                  : "Required",
            ),
            SizedBox(height: 20.h),
            //number
            CustomTextFormHeaderField(
              controller: numController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              headingText: "Mobile Number",
              filledColor: gray.withOpacity(0.2),
              validator: (value) => value != "" && value!.length == 10
                  ? null
                  : "Enter a valid 10-digit mobile number",
            ),
            SizedBox(height: 20.h),
            //Email
            CustomTextFormHeaderField(
              controller: emailController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              headingText: "Email",
              filledColor: gray.withOpacity(0.2),
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
              filledColor: gray.withOpacity(0.2),
            ),
            SizedBox(height: 20.h),
            //District
            CustomTextFormHeaderField(
              readOnly: true,
              onTap: userCon.isDistrictLoading.isTrue ? (){} : showCupertinoDistrictPicker,
              controller: districtController,
              textInputAction: TextInputAction.next,
              headingText: "District",
              filledColor: gray.withOpacity(0.2),
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
            SizedBox(height: 20.h),
            //City Controll
            CustomTextFormHeaderField(
              readOnly: true,
              onTap: userCon.isDistrictLoading.isTrue ? (){} : showCupertinoCityPicker,
              controller: cityController,
              textInputAction: TextInputAction.next,
              headingText: "City",
              filledColor: gray.withOpacity(0.2),
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
            //Gender
            CustomTextFormHeaderField(
              onTap: showCupertinoGenderPicker,
              readOnly: true,
              controller: genderController,
              textInputAction: TextInputAction.next,
              headingText: "Gender",
              filledColor: gray.withOpacity(0.2),
              isDropdown: true,
            ),
            SizedBox(height: 20.h),
            //Dob
            CustomTextFormHeaderField(
              onTap: showCupertinoDatePicker,
              readOnly: true,
              controller: dobController,
              textInputAction: userCon.user.value.data.role.toLowerCase() == "customer" ? TextInputAction.done : TextInputAction.next,
              headingText: "Date of Birth",
              filledColor: gray.withOpacity(0.2),
              isDropdown: true,
            ),
            // ---------- shopkeeper ----------
            Visibility(
              visible: userCon.user.value.data.role.toLowerCase() == "shopkeeper",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  // Shope Name
                  CustomTextFormHeaderField(
                    controller: shopNameCon,
                    textInputAction: TextInputAction.next,
                    headingText: "Shop Name",
                    filledColor: gray.withOpacity(0.2),
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
                    headingText: "Shop PAN no.",
                    filledColor: gray.withOpacity(0.2),
                    validator: (value) => value != ""
                      ? null
                      : "Required",
                  ),
                  SizedBox(height: 20.h),
                  // Owner Name
                  CustomTextFormHeaderField(
                    controller: shopOwnerCon,
                    textInputAction: TextInputAction.done,
                    headingText: "Shop Owner Name",
                    filledColor: gray.withOpacity(0.2),
                    validator: (value) => value != ""
                      ? null
                      : "Required",
                  ),
                ],
              ),
            ),
            //---------- Technician --------
            Visibility(
              visible: userCon.user.value.data.role.toLowerCase() == "technician",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h,),
                  // List of shopkeeper Id
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(height: 20.h,),
                    shrinkWrap: true,
                    itemCount: shopkeeperlists.length,
                    itemBuilder: (context, index) {
                      return CustomTextFormHeaderField(
                        controller: shopkeeperlists[index],
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        headingText: "Shopkeeper Id",
                        filledColor: gray.withOpacity(0.2),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) => value != ""
                          ? null
                          : "Required",
                      );
                    },
                  ),
                 SizedBox(height: 20.h,),
                //  Add Id
                 CustomButton(
                   text: "Add Shopkeeper",
                   onPressed: (){
                     setState(() {
                       shopkeeperlists.add(TextEditingController());
                     });
                   }
                 )
                ],
              ),
            ),

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
            filledColor: gray.withOpacity(0.2),
          ),
          SizedBox(height: 20.h),
          //bank name
          CustomTextFormHeaderField(
            controller: bankController,
            textInputAction: TextInputAction.next,
            headingText: "Bank Name",
            filledColor: gray.withOpacity(0.2),
          ),
          SizedBox(height: 20.h),
          //bank acc no
          CustomTextFormHeaderField(
            controller: accNoController,
            textInputAction: TextInputAction.next,
            headingText: "Account Number",
            filledColor: gray.withOpacity(0.2),
          ),
          SizedBox(height: 20.h),
          //branchName
          CustomTextFormHeaderField(
            controller: branchController,
            textInputAction: TextInputAction.next,
            headingText: "Branch Name",
            filledColor: gray.withOpacity(0.2),
          ),
          SizedBox(height: 20.h),
          //esewa number
          CustomTextFormHeaderField(
            controller: esewaController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            headingText: "Esewa Number",
            filledColor: gray.withOpacity(0.2),
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          SizedBox(height: 20.h),
          //khalti number
          CustomTextFormHeaderField(
            controller: khaltiController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            headingText: "Khalti Number",
            filledColor: gray.withOpacity(0.2),
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
                    shopkeeperId: userCon.user.value.data.role.toLowerCase() == "technician" 
                      ? shopkeeperlists.map((e) => int.parse(e.text.toString().trim())).toList()
                      : [],
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

  //district picker
  showCupertinoDistrictPicker() {
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
                      onPressed: () async{
                        if(userCon.districtList.isNotEmpty){
                          setState(() async{
                            // Store selected district ID in text controller
                            districtController.text = userCon.districtList[selectedDistrictIndex]["name"].toString();
                            districtId = userCon.districtList[selectedDistrictIndex]["id"];

                            //clear city data
                            cityController.clear();
                            cityId = null;
                            selectedCityIndex = 0;
                            userCon.cityList = [];
                            
                            Navigator.pop(context);
                            await userCon.getcityData(districtId);
                          });
                        }else{
                          Navigator.pop(context);
                        }
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
                    initialItem: selectedDistrictIndex,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedDistrictIndex = index;
                    });
                  },
                  children: userCon.districtList
                      .map<Widget>((district) => Center(
                            child: Text(
                              district["name"].toString(), // Ensure the name is displayed
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