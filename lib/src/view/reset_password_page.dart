import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/auth_controller.dart';
import 'package:pecon/src/view/login.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  // Get Controllers
  final AuthController authCon = Get.put(AuthController());

  final formKey = GlobalKey<FormState>();
  final TextEditingController passwordController        = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isObscure = true;
  bool isConfirmPassObscure = true;

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
        extendBodyBehindAppBar: true,
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(30.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _resetHeading(),
                  SizedBox(height: 55.h),
                  _resetForm(),
                  SizedBox(height: 50.h),
                  _resetPasswordButton(),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _resetHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Reset Password", style: poppinsBold(size: 20.sp, color: black),),
        SizedBox(height: 10.h),
        Text("You can reset your password using the form below.", style: poppinsMedium(size: 14.sp, color: black),),
      ],
    );
  }

  // Registration Form
  Widget _resetForm() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
    );
  }

  // Register Button
  Widget _resetPasswordButton() {
    return Obx(()=>
      Center(
        child: CustomButton(
          width: double.infinity,
          isLoading: authCon.isRegisterLoading.value,
          onPressed: () async {
            final isValid = formKey.currentState!.validate();
            if (!isValid) return;
            
            Get.offAll(()=> const LoginPage());
          },
          text: "Reset Password",
        ),
      ),
    );
  }
}
