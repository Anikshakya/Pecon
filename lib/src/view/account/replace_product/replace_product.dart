import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon_app/src/app_config/styles.dart';
import 'package:pecon_app/src/controllers/product_controller.dart';
import 'package:pecon_app/src/view/account/replace_product/replace_qr_scanner.dart';
import 'package:pecon_app/src/widgets/custom_appbar.dart';
import 'package:pecon_app/src/widgets/custom_button.dart';
import 'package:pecon_app/src/widgets/custom_text_field.dart';

class ReplaceProductPage extends StatefulWidget {
  const ReplaceProductPage({super.key});

  @override
  State<ReplaceProductPage> createState() => _ReplaceProductPageState();
}

class _ReplaceProductPageState extends State<ReplaceProductPage> {
  // Get Controllers
   final ProductsController productCon = Get.put(ProductsController());
   
  // Text Editing Controllers
  final TextEditingController previousCodeCon = TextEditingController();
  final TextEditingController currentCodeCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(title:'Warrenty Replacement'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(30.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text("Scan the previous and current product to proceed with the replacement.", style: poppinsMedium(size: 14.sp, color: black)),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CustomTextFormField(
                      width: 280.w,
                      controller: previousCodeCon,
                      readOnly: true,
                      headingText: "Scan Previous QR",
                      onTap: () async{
                        var data = await Get.to(()=> const ReplaceQRScannerPage());
                        previousCodeCon.text = data;
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CustomTextFormField(
                      width: 280.w,
                      controller: currentCodeCon,
                      readOnly: true,
                      headingText: "Scan Current QR",
                      onTap: () async{
                        var data = await Get.to(()=> const ReplaceQRScannerPage());
                        currentCodeCon.text = data;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Center(
            child: Obx(()=>
              CustomButton(
                isLoading: productCon.isProductReturnLoading.isTrue,
                onPressed: () async{
                  await productCon.replaceProduct(
                    previousCode: previousCodeCon.text.trim(),
                    currentCode: currentCodeCon.text.trim(),
                  );
                },
                text: "Return",
                bgColor: black,
                fontColor: white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}