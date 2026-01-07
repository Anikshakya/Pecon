import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:pecon_app/src/app_config/styles.dart';
import 'package:pecon_app/src/controllers/auth_controller.dart';
import 'package:pecon_app/src/view/role_selection_page.dart';
import 'package:pecon_app/src/widgets/custom_button.dart';
import 'package:pecon_app/src/widgets/custom_text_field.dart';
import 'package:pecon_app/src/widgets/custom_toast.dart';
import 'package:pecon_app/src/widgets/partner_logo.dart';

enum Country { nepal, india }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers
  final AuthController authCon = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();

  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isObscure = true;
  Country selectedCountry = Country.nepal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(30.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 160.h),
                  Center(
                    child: Image.asset(
                      "assets/images/peacon_logo.png",
                      height: 50.h,
                    ),
                  ),
                  SizedBox(height: 70.h),
                  _loginForm(),
                  _forgotPassword(),
                  SizedBox(height: 26.h),
                  _loginButton(),
                  SizedBox(height: 24.h),
                  _registerButton(),
                  SizedBox(height: 134.h),
                  partnerLogo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────── Login Form ─────────────────
  Widget _loginForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Mobile Number
          CustomTextFormField(
            controller: mobileNoController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            headingText: "Mobile No.",
            prefixIcon: _countryPicker(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter mobile number";
              }
              if (value.length != 10) {
                return "Enter valid 10-digit number";
              }
              return null;
            },
          ),

          SizedBox(height: 20.h),

          /// Password
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
            validator: (password) {
              if (password == null || password.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // ───────────────── Country Picker ─────────────────
  Widget _countryPicker() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0.w, right: 4.0.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Country>(
          value: selectedCountry,
          icon: const Icon(Icons.arrow_drop_down, color: gray),
          onChanged: (value) {
            setState(() {
              selectedCountry = value!;
            });
          },
          items: const [
            DropdownMenuItem(
              value: Country.nepal,
              child: Row(
                children: [
                  Text("🇳🇵"),
                  SizedBox(width: 6),
                  Text("+977"),
                ],
              ),
            ),
            DropdownMenuItem(
              value: Country.india,
              child: Row(
                children: [
                  Text("🇮🇳"),
                  SizedBox(width: 6),
                  Text("+91"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────── Login Button ─────────────────
  Widget _loginButton() {
    return Obx(
      () => Center(
        child: CustomButton(
          width: double.infinity,
          isLoading: authCon.isLoginLoading.value,
          text: "Log In",
          onPressed: () async {
            final isValid = formKey.currentState!.validate();
            if (!isValid) return;

            final countryCode = selectedCountry == Country.nepal ? "977" : "91";

            await authCon.login(
              number: countryCode + mobileNoController.text.trim(),
              password: passwordController.text.trim(),
            );
          },
        ),
      ),
    );
  }

  // ───────────────── Forgot Password ─────────────────
  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {
        showToast(
          isSuccess: false,
          message: "Please Contact Nearest Dealer.",
        );
      },
      child: Text(
        'Forgot password?',
        style: poppinsMedium(size: 13.sp, color: purple),
      ),
    );
  }

  // ───────────────── Register Button ─────────────────
  Widget _registerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?  ",
          style: poppinsRegular(size: 14.sp, color: Colors.black),
        ),
        InkWell(
          onTap: () {
            Get.to(() => const RoleSelectionPage());
          },
          child: Text(
            'Register here',
            style: poppinsRegular(size: 14.sp, color: purple),
          ),
        ),
      ],
    );
  }
}
