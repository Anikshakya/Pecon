import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon_app/src/app_config/styles.dart';
import 'package:pecon_app/src/controllers/settings_controller.dart';
import 'package:pecon_app/src/widgets/custom_appbar.dart';
import 'package:pecon_app/src/widgets/custom_network_image.dart';
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
                separatorBuilder: (context, index) => SizedBox(height: 30.0.h,),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: settingCon.offersList.length,
                itemBuilder: (context,index){
                  return Column(
                    children: [
                      CustomNetworkImage(
                        imageUrl: settingCon.offersList[index]["image"] ?? "",
                        width: 335.0.w,
                      ),
                      SizedBox(height: 8.h,),
                      Text(settingCon.offersList[index]["title"] ?? "", style: poppinsMedium(size: 14.sp, color: black), textAlign: TextAlign.center,)
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