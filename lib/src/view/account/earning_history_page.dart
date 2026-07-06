import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pecon_app/src/app_config/styles.dart';
import 'package:pecon_app/src/controllers/user_controller.dart';
import 'package:pecon_app/src/widgets/custom_appbar.dart';

class EarningHistoryPage extends StatefulWidget {
  const EarningHistoryPage({super.key});

  @override
  State<EarningHistoryPage> createState() => _EarningHistoryPageState();
}

class _EarningHistoryPageState extends State<EarningHistoryPage> {
  final NumberFormat formatter = NumberFormat("#,##0", "en_US");
  //GetController
  final UserController userCon = Get.put(UserController());

  DateTime? _startDate;
  DateTime? _endDate;

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
            : Column(
              children: [
                 Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 12.0.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async{
                              await _pickDateRange(context);
                              await userCon.getEarningHistory(startDate: formatDate(_startDate!.toLocal()), endDate: formatDate(_endDate!.toLocal()));
                            }, 
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 4.0.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: grey1,
                                  width: 1.sp,
                                ),
                                borderRadius: BorderRadius.circular(8.r)
                              ),
                              child: Row(
                                children: [
                                  Text(_startDate != null && _endDate != null ? "${formatDate(_startDate!.toLocal())} - ${formatDate(_endDate!.toLocal())}" : "Date Filter", style: poppinsRegular(size: 12.sp, color: grey1),),
                                  SizedBox(width: 8.0.w,),
                                  Icon(Icons.date_range, size: 16.sp, color: grey1,)
                                ],
                              ),
                            )
                          ),
                          SizedBox(width: 12.0.w,)
                        ],
                      ),
                    ],
                  ),

                  userCon.earningList.isEmpty
                  ? SizedBox(
                    height: 650.0.h,
                    child: const Center(
                      child: Text("No Data")
                    ),
                  ) 
                  : ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: gray.withValues(alpha: 0.25),
                      thickness: 0.8.sp,
                      height: 0,
                    ),
                    itemCount: userCon.earningList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = userCon.earningList[index];

                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.sp, vertical: 16.0.sp),
                        decoration: BoxDecoration(
                          // Added a subtle, beautiful gradient that preserves your "white" base theme
                          gradient: LinearGradient(
                            colors: [
                              white,
                              white.withValues(alpha: 0.96), 
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.sp), // Slightly softened card corners
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min, // Fixes layout size constraints
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Index Number
                                Text(
                                  "${index + 1}.",
                                  style: poppinsSemiBold(size: 14.sp, color: black),
                                ),
                                SizedBox(width: 10.w),
                                
                                // Product Title
                                Expanded(
                                  child: Text(
                                    item.product.title.toString(),
                                    style: poppinsSemiBold(size: 16.sp, color: black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2, 
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 4.h),
                            
                            Padding(
                              padding: EdgeInsets.only(left: 24.w), 
                              child: Text(
                                "CODE : ${item.code.toString()}", 
                                style: poppinsSemiBold(size: 14.sp, color: black.withValues(alpha: 0.6)),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1, 
                              ),
                            ),
                            
                            SizedBox(height: 14.h),
                            
                            // Cash & Points Badges Row
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: Row(
                                children: [
                                  /// GREEN CARD (Total Cash)
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            green.withValues(alpha: 0.95),
                                            green.withValues(alpha: 0.8),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(14.sp),
                                        boxShadow: [
                                          BoxShadow(
                                            color: green.withValues(alpha: 0.25),
                                            blurRadius: 12,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Cash",
                                            style: poppinsSemiBold(
                                              size: 13.sp,
                                              color: white.withValues(alpha: 0.8),
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Rs. ",
                                                    style: poppinsBold(
                                                      size: 13.sp,
                                                      color: white,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: formatter.format(double.parse(item.cash.toString())),
                                                    style: poppinsBold(
                                                      size: 16.sp,
                                                      color: white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              
                                  SizedBox(width: 12.w),
                              
                                  /// RED CARD (Total Points)
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            red.withValues(alpha: 0.95),
                                            red.withValues(alpha: 0.8),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(14.sp),
                                        boxShadow: [
                                          BoxShadow(
                                            color: red.withValues(alpha: 0.25),
                                            blurRadius: 12,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Points",
                                            style: poppinsSemiBold(
                                              size: 13.sp,
                                              color: white.withValues(alpha: 0.8),
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                "assets/images/golden_star.png",
                                                height: 14.sp,
                                                width: 14.sp,
                                              ),
                                              SizedBox(width: 6.w),
                                              Expanded(
                                                child: FittedBox(
                                                  alignment: Alignment.centerLeft,
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    formatter.format(double.parse(item.redeemPoint.toString())),
                                                    style: poppinsBold(
                                                      size: 16.sp,
                                                      color: white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                Divider(
                  color: gray.withValues(alpha:0.25),
                  thickness: 0.8.sp,
                  height: 0,
                ),
                SizedBox(
                  height: 600.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //formatDate
  String formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }


  //date range picker
  Future<void> _pickDateRange(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year - 5);
    final DateTime lastDate = DateTime(now.year + 5);

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }
}