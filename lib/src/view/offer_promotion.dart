import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/settings_controller.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';
class OfferPage extends StatefulWidget {
  const OfferPage({super.key});

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  //GetController
  final SettingsController settingCon = Get.put(SettingsController());

  @override
  void initState() {
    initialise();
    super.initState();
  }

  initialise()async{
    await settingCon.getOfferPromotion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: appbar(title: "Offers And Promotions"),
      body: RefreshIndicator(color: black,
        onRefresh: (){
          return Future.delayed(const Duration(seconds: 1),()async{// Get Athlete Details Data
            initialise(); 
          });
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 24.sp),
            child: Obx(() => settingCon.isLoading.isTrue
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
              : settingCon.offersList.isEmpty
              ? SizedBox(
                height: 650.0.h,
                child: const Center(
                  child: Text("No Offers and Promotions")
                ),
              )
              : ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 12.0.h,),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: settingCon.offersList.length,
                itemBuilder: (context,index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: gray.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        height: 220.h, 
                        width: double.infinity,
                        child: CustomNetworkImage(
                          imageUrl: settingCon.offersList[index]["image"] ?? "", 
                          height: 220.h, 
                          width: double.infinity
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0.sp),
                        child: Text(settingCon.offersList[index]["title"] ?? "", style: poppinsMedium(size: 14.sp, color: black),),
                      )
                    ],
                  );
                }
              )
            ),
          ),
        ),
      ),
    );
  }
}