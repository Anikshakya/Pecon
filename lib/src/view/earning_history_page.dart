import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/user_controller.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';

class EarningHistoryPage extends StatefulWidget {
  const EarningHistoryPage({super.key});

  @override
  State<EarningHistoryPage> createState() => _EarningHistoryPageState();
}

class _EarningHistoryPageState extends State<EarningHistoryPage> {
  final NumberFormat formatter = NumberFormat("#,##0", "en_US");
  //GetController
  final UserController userCon = Get.put(UserController());

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
      appBar: appbar(title:'My Earnings'),
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
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.sp,vertical: 16.0.sp),
                      color: white,
                      child: Row(
                        children: [
                          //products index
                          Text("  ${index+1}.  ", style: poppinsSemiBold(size: 14.sp, color: black),),
                          SizedBox(width: 24.w,),
                          //products name and desc
                          SizedBox(
                            width: 292.w,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 200.w,
                                  child: Text(userCon.earningList[index].product.title.toString(), style: poppinsSemiBold(size: 14.sp, color: black),overflow: TextOverflow.ellipsis, maxLines: 5,)),
                                //products price and rewar points
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Points", style: poppinsSemiBold(size: 11.sp, color: black.withOpacity(0.5)),),
                                    SizedBox(height: 4.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                                      decoration: BoxDecoration(
                                        color: green.withOpacity(0.95),
                                        borderRadius: BorderRadius.circular(6.sp),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          style: poppinsSemiBold(size: 11.sp, color: black),
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding: EdgeInsets.only(right: 4.sp),
                                                child: Image.asset("assets/images/golden_star.png", height: 14.sp, width: 14.sp)
                                              ),
                                            ),
                                            TextSpan(
                                              text: formatter.format(double.parse(userCon.earningList[index].redeemPoint.toString())),
                                              style: poppinsSemiBold(color: white, size: 12.sp ),
                                            ),
                                          ],
                                        ),
                                      )
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
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