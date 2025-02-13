import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/auth_controller.dart';
import 'package:pecon/src/view/register_page.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authCon = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: EdgeInsets.all(30.sp),
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 160.h),
                  Center(
                    child: Image.asset("assets/images/peacon_logo.png", height: 50.h)
                  ),
                  SizedBox(height: 70.h),
                  _loginForm(),
                  _forgotPassword(),
                  SizedBox(height: 26.h),
                  _loginButton(),
                  SizedBox(height: 24.h),
                  _registerButton(),
                  SizedBox(height: 134.h),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("A PRODUCT OF", style: poppinsRegular(size: 12.sp, color: black)),
                        Image.asset("assets/images/logo.png", height: 40.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Login Form Section
  Widget _loginForm() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mobile No.
          CustomTextFormField(
            controller: mobileNoController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            headingText: "Mobile No.",
            validator: (value) => value != null && value.length == 10
                ? null
                : "Enter a valid 10-digit mobile number",
          ),
          SizedBox(height: 20.h),
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
          )
        ],
      ),
    );
  }

  // Login Button
  _loginButton() {
    return Obx(()=>
      Center(
        child: CustomButton(
          width: double.infinity,
          isLoading: authCon.isLoginLoading.value,
          onPressed: () async {
            // Remove Keyboard Focus
            FocusManager.instance.primaryFocus?.unfocus();
      
            final isValid = formKey.currentState!.validate();
            if (!isValid) return;
      
            await authCon.login();
          },
          text: "Log In",
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
