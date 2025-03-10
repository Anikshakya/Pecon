import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/product_controller.dart';
import 'package:pecon/src/controllers/user_controller.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_text_field.dart';
class ReturnProductPage extends StatefulWidget {
  const ReturnProductPage({super.key});

  @override
  State<ReturnProductPage> createState() => _ReturnProductPageState();
}

class _ReturnProductPageState extends State<ReturnProductPage> {
  final NumberFormat formatter = NumberFormat("#,##0", "en_US");
  //GetController
  final UserController userCon = Get.put(UserController());
  final ProductsController productCon = Get.put(ProductsController());

  final TextEditingController codeCon = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initialise();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    codeCon.dispose();
  }

  initialise()async{
    await userCon.getEarningHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: appbar(title:'Warranty Replacement'),
      body: RefreshIndicator(
        color: black,
        onRefresh: (){
          return Future.delayed(const Duration(seconds: 1),()async{// Get Athlete Details Data
            initialise();
          });
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Obx(() => userCon.isEarningLoading.isTrue
            ? SizedBox(
              height: 650.0.h,
              child: Center(
                child: SizedBox(
                  height: 30.sp,
                  width: 30.sp,
                  child: CircularProgressIndicator(
                    color: black,
                    strokeWidth: 1.5.sp,
                  ),
                ),
              ),
            )
            : userCon.earningList.isEmpty
            ? SizedBox(
              height: 650.0.h,
              child: const Center(
                child: Text("Nothing to Show")
              ),
            )
            : 
            Column(
              children: [
                ListView.separated(
                  separatorBuilder: (context, index) => 
                    Divider(
                      color: gray.withOpacity(0.25),
                      thickness: 0.8.sp,
                      height: 0,
                    ),
                  itemCount: userCon.earningList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Get.defaultDialog(
                          backgroundColor: boxCol,
                          title: '',
                          titlePadding: EdgeInsets.symmetric(horizontal: 20.0.w),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0.w),
                          content: StatefulBuilder(
                            builder: (context, setState) {
                              return SizedBox(
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Title
                                      Text(
                                        "Enter the Code of the New Product to Exchange.",
                                        style: TextStyle(
                                          fontSize: 19.sp,
                                          fontWeight: FontWeight.bold,
                                          color: black,
                                        ),
                                      ),
                                      SizedBox(height: 10.h,),
                                      // Manual Code Input Field
                                      Form(
                                        key: formKey,
                                        child: CustomTextFormField(
                                          controller: codeCon,
                                          headingText: "Ënter Code",
                                          validator: (value) => value != ""
                                            ? null
                                            : "Please Enter a valid code first.",
                                        ),
                                      ),
                                      SizedBox(height: 24.h),
                                      // Submit Button
                                      Obx(()=>
                                        CustomButton(
                                          isLoading: productCon.isProductReturnLoading.isTrue,
                                          onPressed: () async{
                                            final isValid = formKey.currentState!.validate();
                                            if (!isValid) return;
                                            Get.back();
                                            productCon.returnProduct(
                                              currentCode: codeCon.text.toString().trim(),
                                              previousCode: userCon.earningList[index].code.toString()
                                            );
                                          },
                                          text: "Exchange",
                                          bgColor: black,
                                          fontColor: white,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      // Cancel Button
                                      CustomButton(
                                        onPressed: () {
                                          // Handle manual code submission
                                          Get.back();
                                        },
                                        text: "Cancel",
                                        bgColor: Colors.transparent,
                                        fontColor: black,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.sp,vertical: 28.0.sp),
                        color: white,
                        child: Row(
                          children: [
                            //products index
                            Text("  ${index+1}.  ", style: poppinsSemiBold(size: 14.sp, color: black),),
                            SizedBox(width: 24.w,),
                            //products name and desc
                            SizedBox(
                              width: 290.w,
                              child: Text(userCon.earningList[index].product.title.toString(), style: poppinsSemiBold(size: 14.sp, color: black),overflow: TextOverflow.ellipsis, maxLines: 5,),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Divider(
                  color: gray.withOpacity(0.25),
                  thickness: 0.8.sp,
                  height: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}