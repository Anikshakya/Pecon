import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/user_controller.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';

class WithdrawalRequestPage extends StatefulWidget {
  const WithdrawalRequestPage({super.key});

  @override
  State<WithdrawalRequestPage> createState() => _WithdrawalRequestPageState();
}

class _WithdrawalRequestPageState extends State<WithdrawalRequestPage> {
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
    await userCon.getWithDrawlRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: appbar(title:'Withdrawal Request'),
      body: RefreshIndicator(
        color: black,
        onRefresh: (){
          return Future.delayed(const Duration(seconds: 1),()async{// Get Athlete Details Data
            initialise();
          });
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Obx(() => userCon.isWithdrawalLoading.isTrue
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
            : userCon.withdrawalList.isEmpty
            ? SizedBox(
              height: 650.0.h,
              child: const Center(
                child: Text("Nothing to Show")
              ),
            )
            : 
            Column(
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
                            await userCon.getWithDrawlRequest(startDate: formatDate(_startDate!.toLocal()), endDate: formatDate(_endDate!.toLocal()));
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
                    SizedBox(height: 12.0.h,),
                  ],
                ),
                ListView.separated(
                  separatorBuilder: (context, index) => 
                    Divider(
                      color: gray.withOpacity(0.25),
                      thickness: 0.8.sp,
                      height: 0,
                    ),
                  itemCount: userCon.withdrawalList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
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
                                imageUrl: userCon.withdrawalList[index].redeeminformation.image.toString(),
                                height: 80.sp,
                                width: 80.sp,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.0.w,),
                          //products name and desc
                          SizedBox(
                            width: 176.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 3.h),
                                Text(userCon.withdrawalList[index].redeeminformation.title.toString(), style: poppinsSemiBold(size: 14.sp, color: black),overflow: TextOverflow.ellipsis, maxLines: 2,),
                                SizedBox(height: 12.h),
                                Visibility(
                                  visible: userCon.withdrawalList[index].customerPaymentOption != "",
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 190.w,
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                                    decoration: BoxDecoration(
                                      color: gray.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6.sp),
                                    ),
                                    child: Text(
                                      "Payment Type: ${userCon.withdrawalList[index].customerPaymentOption.toString().toUpperCase()}",
                                      style: poppinsSemiBold(color: black.withOpacity(.5), size: 11.sp ),
                                    )
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Visibility(
                                  visible: userCon.withdrawalList[index].status!= "",
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 190.w,
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                                    decoration: BoxDecoration(
                                      color: gray.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6.sp),
                                    ),
                                    child: Text(
                                      "Status: ${userCon.withdrawalList[index].status.toString().toUpperCase()}",
                                      style: poppinsSemiBold(color: black.withOpacity(.5), size: 11.sp ),
                                    )
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Visibility(
                                  visible: userCon.withdrawalList[index].remarks!= "",
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 190.w,
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                                    decoration: BoxDecoration(
                                      color: gray.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6.sp),
                                    ),
                                    child: Text(
                                      "Remarks: ${userCon.withdrawalList[index].remarks.toString()}",
                                      style: poppinsSemiBold(color: black.withOpacity(.5), size: 11.sp ),
                                    )
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          //products price and rewar points
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Used Points", style: poppinsSemiBold(size: 11.sp, color: black.withOpacity(0.5)),),
                                  SizedBox(height: 4.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                                    decoration: BoxDecoration(
                                      color: maroon.withOpacity(0.95),
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
                                            text: formatter.format(double.parse(userCon.withdrawalList[index].redeemPointsUsed.toString())),
                                            style: poppinsSemiBold(color: white, size: 12.sp ),
                                          ),
                                        ],
                                      ),
                                    )
                                  )
                                ],
                              ),
                            ],
                          )
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