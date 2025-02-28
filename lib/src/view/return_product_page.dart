import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/product_controller.dart';
import 'package:pecon/src/controllers/user_controller.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';

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

  @override
  void initState() {
    initialise();
    super.initState();
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
                                        "Are you sure you want to return this product?",
                                        style: TextStyle(
                                          fontSize: 19.sp,
                                          fontWeight: FontWeight.bold,
                                          color: black,
                                        ),
                                      ),
                                      SizedBox(height: 24.h),
                                      // Submit Button
                                      Obx(()=>
                                        CustomButton(
                                          isLoading: userCon.isChecoutLoading.isTrue,
                                          onPressed: () async{
                                            Get.back();
                                            // productCon.returnProduct(productId: userCon.earningList[index].id.toString());
                                          },
                                          text: "Confirm",
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
                        padding: EdgeInsets.symmetric(horizontal: 16.0.sp,vertical: 16.0.sp),
                        color: white,
                        child: Row(
                          children: [
                            //products image
                            Container(
                              decoration: BoxDecoration(
                                color: gray.withOpacity(0.1),
                                border: Border.all(
                                  color: gray.withOpacity(0.25), width: 0.8.sp
                                ),
                                borderRadius: BorderRadius.circular(6.sp),
                              ),
                              height: 80.sp,
                              width: 80.sp,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.sp),
                                child: CustomNetworkImage(
                                  imageUrl: "", //userCon.earningList[index].images[0].toString(), 
                                  height: 80.sp,
                                  width: 80.sp,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Spacer(),
                            //products name and desc
                            SizedBox(
                              width: 244.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 3.h),
                                  Text(userCon.earningList[index].product.title.toString(), style: poppinsSemiBold(size: 14.sp, color: black),overflow: TextOverflow.ellipsis, maxLines: 2,),
                                  SizedBox(height: 12.h),
                                  //products price and rewar points
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     Text("MRP", style: poppinsSemiBold(size: 10.sp, color: black.withOpacity(0.5)),),
                                  //     SizedBox(height: 4.h),
                                  //     Container(
                                  //       padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                                  //       decoration: BoxDecoration(
                                  //         color: gray.withOpacity(0.2),
                                  //         borderRadius: BorderRadius.circular(6.sp),
                                  //       ),
                                  //       child: RichText(
                                  //         text: TextSpan(
                                  //           style: poppinsSemiBold(size: 11.sp, color: black.withOpacity(0.5)),
                                  //           children: [
                                  //             const TextSpan(text: "₹  "),
                                  //             TextSpan(
                                  //               text: formatter.format(double.parse(productCon.productList[index].price)),
                                  //               style: poppinsSemiBold(color: green, size: 13.sp ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       )
                                  //     )
                                  //   ],
                                  // )
                                ],
                              ),
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