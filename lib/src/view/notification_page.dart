import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon_app/src/app_config/styles.dart';
import 'package:pecon_app/src/controllers/notification_controller.dart';
import 'package:pecon_app/src/utils/app_utils.dart';
import 'package:pecon_app/src/widgets/custom_appbar.dart';
import 'package:pecon_app/src/widgets/custom_network_image.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController notificationCon =
      Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    initialise();
  }

  Future<void> initialise() async {
    await notificationCon.getNotificationList();
  }

  Future<void> _refreshNotifications() async {
    await notificationCon.getNotificationList();
  }

  void _openNotificationLink(String description) {
    final String url = description.trim();

    if (url.contains('http')) {
      AppUtils().openLinkWithUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: appbar(
        title: 'Notifications',
        showArrow: false,
      ),
      body: RefreshIndicator(
        color: black,
        onRefresh: _refreshNotifications,
        child: Obx(() {
          if (notificationCon.isLoading.isTrue) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 650.h,
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
                ),
              ],
            );
          }

          if (notificationCon.notificationList.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 650.h,
                  child: Center(
                    child: Text(
                      'Nothing to Show',
                      style: poppinsRegular(
                        size: 14.sp,
                        color: black.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.only(
              top: 8.h,
              bottom: 50.h,
            ),
            itemCount: notificationCon.notificationList.length,
            separatorBuilder: (context, index) {
              return Divider(
                color: gray.withValues(alpha: 0.25),
                thickness: 0.8.sp,
                height: 1,
              );
            },
            itemBuilder: (context, index) {
              final notification =
                  notificationCon.notificationList[index];

              final String title = notification['title'] ?? '';
              final String description =
                  notification['description'] ?? '';
              final String image = notification['image'] ?? '';
              final String createdAt =
                  notification['created_at'] ?? '';

              return InkWell(
                onTap: () {
                  _openNotificationLink(description);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Notification image
                      Container(
                        height: 70.sp,
                        width: 70.sp,
                        decoration: BoxDecoration(
                          color: gray.withValues(alpha: 0.1),
                          border: Border.all(
                            color: gray.withValues(alpha: 0.25),
                            width: 0.8.sp,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: CustomNetworkImage(
                            imageUrl: image,
                            height: 70.sp,
                            width: 70.sp,
                            isFrom: 'notification',
                          ),
                        ),
                      ),

                      SizedBox(width: 14.w),

                      // Notification details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              title,
                              style: poppinsSemiBold(
                                size: 15.sp,
                                color: black,
                              ),
                            ),

                            // Full description
                            if (description.trim().isNotEmpty) ...[
                              SizedBox(height: 8.h),
                              Text(
                                description,
                                style: poppinsRegular(
                                  size: 13.sp,
                                  color: black.withValues(alpha: 0.75),
                                ),
                              ),
                            ],

                            // Creation date
                            if (createdAt.trim().isNotEmpty) ...[
                              SizedBox(height: 10.h),
                              Text(
                                createdAt,
                                style: poppinsRegular(
                                  size: 10.sp,
                                  color: black.withValues(alpha: 0.55),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}