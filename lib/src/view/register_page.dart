import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/auth_controller.dart';
import 'package:pecon/src/controllers/user_controller.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_text_field.dart';
import 'package:pecon/src/widgets/custom_textfieldheader.dart';

class RegisterPage extends StatefulWidget {
  final bool isNepal;
  final String role;

  const RegisterPage({
    super.key,
    required this.isNepal,
    required this.role,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers
  final AuthController authCon = Get.put(AuthController());
  final UserController userCon = Get.put(UserController());

  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  bool isObscure = true;
  bool isConfirmPassObscure = true;

  int? districtId;
  int? cityId;

  int selectedCityIndex = 0;

  /// ✅ LOCAL CITY LIST (FILTERED FROM DISTRICT)
  List<dynamic> filteredCityList = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async{
    await userCon.getDistrictCityData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: primary,
        appBar: AppBar(
          backgroundColor: primary,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(30.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _registerHeading(),
                  SizedBox(height: 55.h),
                  _registerForm(),
                  SizedBox(height: 50.h),
                  _registerButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Register",
          style: poppinsBold(size: 20.sp, color: black),
        ),
        SizedBox(height: 10.h),
        Text(
          "Create a new account by filling up the form below.",
          style: poppinsMedium(size: 14.sp, color: black),
        ),
      ],
    );
  }

  Widget _registerForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Mobile
          CustomTextFormField(
            controller: mobileController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            headingText: "Mobile No.",
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Center(
                child: Text(
                  widget.isNepal ? "+977" : "+91",
                  style: poppinsMedium(size: 14.sp, color: black),
                ),
              ),
            ),
            validator: (v) =>
                v != null && v.length == 10 ? null : "Invalid mobile number",
          ),

          SizedBox(height: 20.h),

          // Name
          CustomTextFormField(
            controller: nameCon,
            textInputAction: TextInputAction.next,
            headingText: "Name",
          ),

          SizedBox(height: 20.h),

          // District
          CustomTextFormHeaderField(
            readOnly: true,
            controller: districtController,
            headingText: "District",
            filledColor: gray.withOpacity(0.2),
            suffixIcon: const Icon(Icons.arrow_drop_down, color: grey1),
            onTap: showDistrictBottomSheet,
          ),

          SizedBox(height: 20.h),

          // City
          if (districtController.text.isNotEmpty)
            CustomTextFormHeaderField(
              readOnly: true,
              controller: cityController,
              headingText: "City",
              filledColor: gray.withOpacity(0.2),
              suffixIcon: const Icon(Icons.arrow_drop_down, color: grey1),
              onTap: filteredCityList.isEmpty ? null : showCupertinoCityPicker,
            ),

          SizedBox(height: 20.h),

          // Password
          CustomTextFormField(
            controller: passwordController,
            obscureText: isObscure,
            headingText: "Password",
            suffixIcon: IconButton(
              icon: Icon(
                isObscure ? Icons.visibility : Icons.visibility_off,
                color: gray,
              ),
              onPressed: () => setState(() => isObscure = !isObscure),
            ),
            validator: (v) =>
                v != null && v.length >= 6 ? null : "Min 6 characters",
          ),

          SizedBox(height: 20.h),

          // Confirm Password
          CustomTextFormField(
            controller: confirmPasswordController,
            obscureText: isConfirmPassObscure,
            headingText: "Confirm Password",
            suffixIcon: IconButton(
              icon: Icon(
                isConfirmPassObscure ? Icons.visibility : Icons.visibility_off,
                color: gray,
              ),
              onPressed: () =>
                  setState(() => isConfirmPassObscure = !isConfirmPassObscure),
            ),
            validator: (v) =>
                v == passwordController.text ? null : "Passwords do not match",
          ),
        ],
      ),
    );
  }

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
          );
        },
      ),
    );
  }

  // ---------------- DISTRICT BOTTOM SHEET ----------------

  void showDistrictBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView.builder(
          padding: EdgeInsets.all(16.sp),
          itemCount: userCon.districtList.length,
          itemBuilder: (_, index) {
            final district = userCon.districtList[index];
            return ListTile(
              title: Text(district["name"]),
              onTap: () {
                setState(() {
                  districtController.text = district["name"];
                  districtId = district["id"];

                  // RESET CITY
                  cityController.clear();
                  cityId = null;
                  selectedCityIndex = 0;

                  // FILTER CITIES FROM DISTRICT
                  filteredCityList = List.from(district["cities"] ?? []);
                });

                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  // ---------------- CITY PICKER ----------------

  void showCupertinoCityPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return Container(
          height: 240.h,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: poppinsMedium(size: 15.sp, color: purple),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          final city = filteredCityList[selectedCityIndex];
                          cityController.text = city["name"];
                          cityId = city["id"];
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
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40.h,
                  onSelectedItemChanged: (i) => selectedCityIndex = i,
                  children: filteredCityList
                      .map<Widget>(
                        (c) => Center(
                          child: Text(
                            c["name"],
                            style: TextStyle(fontSize: 18.sp),
                          ),
                        ),
                      )
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
