import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/auth_controller.dart';
import 'package:pecon/src/view/register_page.dart';
import 'package:pecon/src/view/reset_password_page.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pecon/src/widgets/partner_logo.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  // Get Controllers
  final AuthController authCon = Get.put(AuthController());

  final formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final TextEditingController optCon = TextEditingController();

  // Bool helper
  bool isObscure = true;

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
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
                    child: Image.asset("assets/images/peacon_logo.png", height: 50.h)
                  ),
                  SizedBox(height: 70.h),
                  _otpForm(),
                  SizedBox(height: 26.h),
                  _otpButton(),
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

  // Login Form Section
  Widget _otpForm() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mobile No.
          CustomTextFormField(
            controller: optCon,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            headingText: "OTP",
            validator: (value) => value != null && value.length == 10
                ? null
                : "Enter a valid OTP",
          ),
        ],
      ),
    );
  }

  // Login Button
  _otpButton() {
    return Obx(()=>
      Center(
        child: CustomButton(
          width: double.infinity,
          isLoading: authCon.isLoginLoading.value,
          onPressed: () async {
      
            final isValid = formKey.currentState!.validate();
            if (!isValid) return;

            Get.to(()=> const ResetPassword());
          },
          text: "Verify",
        ),
      ),
    );
  }

  // Forgot Password
  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {},
      child: Text('Forgot password?', style: poppinsMedium(size: 13.sp, color: purple),),
    );
  }

  // Register Button
  Widget _submitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?  ",
          style: poppinsRegular(size: 14.sp, color: Colors.black),
        ),
        InkWell(
          onTap: () {
            Get.to(() => const RegisterPage());
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
