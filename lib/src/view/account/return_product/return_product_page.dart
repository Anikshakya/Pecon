import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pecon_app/src/app_config/styles.dart';
import 'package:pecon_app/src/controllers/product_controller.dart';
import 'package:pecon_app/src/controllers/user_controller.dart';
import 'package:pecon_app/src/view/account/return_product/return_qr_scanner.dart';
import 'package:pecon_app/src/widgets/custom_appbar.dart';
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

  final TextEditingController remarksCon = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initialise();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    remarksCon.dispose();
  }

  initialise()async{
    await userCon.getEarningHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: appbar(title:'Product Return'),
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
                      color: gray.withValues(alpha:0.25),
                      thickness: 0.8.sp,
                      height: 0,
                    ),
                  itemCount: userCon.earningList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Get.to(()=> const ReturnQRScannerPage());
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
                  color: gray.withValues(alpha:0.25),
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