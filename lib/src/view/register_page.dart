import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/auth_controller.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Get Controllers
  final AuthController authCon = Get.put(AuthController());

  final formKey = GlobalKey<FormState>();

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isObscure = true;
  bool isConfirmPassObscure = true;

  List<String> roles = ["Shopkeeper", "Electrician", "Customer"];
  String selectedRole = "Shopkeeper";

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
        body: Padding(
          padding: EdgeInsets.all(30.sp),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _registerHeading(),
                  SizedBox(height: 55.h),
                  _registerForm(),
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
            validator: (mobile) => mobile != null && mobile.length == 10
                ? null
                : "Enter a valid 10-digit mobile number",
          ),
          SizedBox(height: 20.h),

          // Name
          CustomTextFormField(
            controller: nameCon,
            textInputAction: TextInputAction.next,
            headingText: "Name",
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
          GestureDetector(
            onTap: () {
              int selectedIndex = roles.indexOf(selectedRole); // Store initial selection
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 240.h,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
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
                                    selectedRole = roles[selectedIndex]; // Update role
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
                              selectedIndex = index; // Temporarily store selection
                            },
                            children: roles.map((role) => Center(child: Text(role, style: TextStyle(fontSize: 18.sp),))).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: AbsorbPointer(
              child: CustomTextFormField(
                headingText: "Select Role",
                controller: TextEditingController(text: selectedRole),
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : "Please select a role",
                suffixIcon: const Icon(Icons.arrow_drop_down, color: gray),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Register Button
  Widget _registerButton() {
    return Obx(()=>
      Center(
        child: CustomButton(
          width: double.infinity,
          isLoading: authCon.isRegisterLoading.value,
          onPressed: () async {
            final isValid = formKey.currentState!.validate();
            if (!isValid) return;

            await authCon.register(
              name: nameCon.text.toString().trim(),
              number: mobileController.text.toString().trim(),
              password: confirmPasswordController.text.toString().trim(),
              role: selectedRole.toString().trim()
            );
          },
          text: "Register",
        ),
      ),
    );
  }
}
