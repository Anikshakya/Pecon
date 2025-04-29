import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/notification_controller.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  //GetController
  final NotificationController notificationCon = Get.put(NotificationController());


  @override
  void initState() {
    initialise();
    super.initState();
  }

  initialise()async{
    await notificationCon.getNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: appbar(title:'Notifications'),
      body: RefreshIndicator(
        color: black,
        onRefresh: (){
          return Future.delayed(const Duration(seconds: 1),()async{
            initialise();
          });
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Obx(() => notificationCon.isLoading.isTrue
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
            : notificationCon.notificationList.isEmpty
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
                  itemCount: notificationCon.notificationList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
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
                                  imageUrl: notificationCon.notificationList[index].coverPhoto.toString(), 
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
                                  Text(notificationCon.notificationList[index].title.toString(), style: poppinsSemiBold(size: 14.sp, color: black),overflow: TextOverflow.ellipsis, maxLines: 2,),
                                  SizedBox(height: 12.h),
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