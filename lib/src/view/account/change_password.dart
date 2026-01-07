import 'package:pecon_app/src/app_config/styles.dart';
import 'package:pecon_app/src/controllers/auth_controller.dart';
import 'package:pecon_app/src/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pecon_app/src/widgets/custom_textfieldheader.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // Get Controllers
  final AuthController authCon = Get.put(AuthController());

  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController oldPasswordCon     = TextEditingController();
  final TextEditingController newPasswordCon     = TextEditingController();
  final TextEditingController confirmPasswordCon = TextEditingController();

  bool isOldObscure = true;
  bool isNewObscure = true;
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
        backgroundColor: white,
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
                  _registerHeading(),
                  SizedBox(height: 55.h),
                  _passwordForm(),
                  SizedBox(height: 50.h),
                  _changePass(),
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
        Text("Change Password", style: poppinsBold(size: 20.sp, color: black),),
        SizedBox(height: 10.h),
        Text("Change Your password using the form below", style: poppinsMedium(size: 14.sp, color: black),),
      ],
    );
  }

  // Registration Form
  Widget _passwordForm() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Old Password
          // Password
          CustomTextFormHeaderField(
            filledColor: gray.withValues(alpha:0.2),
            controller: oldPasswordCon,
            obscureText: isOldObscure,
            headingText: "Old Password",
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isOldObscure = !isOldObscure;
                });
              },
              icon: Icon(
                isOldObscure ? Icons.visibility : Icons.visibility_off,
                size: 20.sp,
                color: gray,
              ),
            ),
            validator: (password) => password != null && password.length >= 6
                ? null
                : "Password must be at least 6 characters",
          ),

          SizedBox(height: 20.h),

          // Password
          CustomTextFormHeaderField(
            filledColor: gray.withValues(alpha:0.2),
            controller: newPasswordCon,
            obscureText: isNewObscure,
            headingText: "New Password",
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isNewObscure = !isNewObscure;
                });
              },
              icon: Icon(
                isNewObscure ? Icons.visibility : Icons.visibility_off,
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
          CustomTextFormHeaderField(
            filledColor: gray.withValues(alpha:0.2),
            controller: confirmPasswordCon,
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
                confirmPassword != null && confirmPassword == newPasswordCon.text
                    ? null
                    : "Passwords do not match",
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // Register Button
  Widget _changePass() {
    return Obx(()=>
      Center(
        child: CustomButton(
          width: double.infinity,
          isLoading: authCon.isChangePasswordLoading.value,
          onPressed: () async {
            final isValid = formKey.currentState!.validate();
            if (!isValid) return;
            await authCon.changePassword(
              currentPass: oldPasswordCon.text.trim(),
              newPass: newPasswordCon.text.trim(),
              newPassConfirm: confirmPasswordCon.text.trim(),
            );
          },
          text: "Change Pasword",
        ),
      ),
    );
  }
}
