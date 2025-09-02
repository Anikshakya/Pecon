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
      appBar: appbar(title:'Notifications', showArrow: false),
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
                  separatorBuilder: (context, index) => Divider(
                    color: gray.withOpacity(0.25),
                    thickness: 0.8.sp,
                    height: 0,
                  ),
                  itemCount: notificationCon.notificationList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Theme(
                        data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent
                      ),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.symmetric(horizontal: 16.0.sp, vertical: 8.0.sp),
                        backgroundColor: white,
                        collapsedBackgroundColor: white,
                        childrenPadding: EdgeInsets.only(left: 16.0.sp, right: 16.0.sp, bottom: 12.0.sp),
                        
                        title: Row(
                          children: [
                            Container(
                              height: 70.0.sp,
                              width: 70.0.sp,
                              decoration: BoxDecoration(
                                color: gray.withOpacity(0.1),
                                border: Border.all(
                                  color: gray.withOpacity(0.25),
                                  width: 0.8.sp,
                                ),
                                borderRadius: BorderRadius.circular(8.sp),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0.r),
                                child: CustomNetworkImage(
                                  imageUrl: notificationCon.notificationList[index]["image"] ?? "",
                                  height: 70.0.sp,
                                  width: 70.0.sp,
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 220.0.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // notification title
                                  Text(
                                    notificationCon.notificationList[index]["title"] ?? "",
                                    style: poppinsSemiBold(size: 16.sp, color: black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 4.0.h),
                                  // hide desc here (move to expanded content)
                                  SizedBox(height: 10.0.h),
                                  Text(
                                    notificationCon.notificationList[index]["created_at"] ?? "",
                                    style: poppinsRegular(size: 10.sp, color: black.withOpacity(0.7)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      
                        // Expanded description (only visible when expanded)
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              notificationCon.notificationList[index]["description"] ?? "",
                              style: poppinsRegular(size: 14.sp, color: black.withOpacity(0.7)),
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