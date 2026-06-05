
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pecon_app/src/app_config/styles.dart';
import 'package:pecon_app/src/controllers/app_controller.dart';
import 'package:pecon_app/src/controllers/home_controller.dart';
import 'package:pecon_app/src/controllers/user_controller.dart';
import 'package:pecon_app/src/widgets/custom_appbar.dart';
import 'package:pecon_app/src/widgets/custom_button.dart';
import 'package:pecon_app/src/widgets/custom_network_image.dart';
import 'package:pecon_app/src/widgets/custom_toast.dart';
import 'package:pecon_app/src/widgets/invalid_user_widget.dart';
import 'package:pecon_app/src/widgets/partner_logo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Get Controller
  final UserController userCon = Get.put(UserController());
  final HomeController homeCon = Get.put(HomeController());
  final AppController  appCon  = Get.put(AppController());

  // Formate Number to US standard
  final NumberFormat formatter = NumberFormat("#,##0", "en_US");
  
  int _currentIndex = 0;

  var isLoading  = false;

  @override
  void initState() {
    super.initState();
    if(mounted){
      getData();
    }
  }

  // Get Initial Data
  getData() async{
    // Get AdBanner/Slider data
    await homeCon.getAdBanner();
    // Get Prize List
    await homeCon.getRedeemInformation();
    // Get Top 5 Performer
    await homeCon.getTop5Performers();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: customAppbar(),
      body: RefreshIndicator(
        color: black,
        onRefresh: (){
          return Future.delayed(const Duration(seconds: 1),()async{// Get Athlete Details Data
            getData();
            userCon.getUserData(true);
          });
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:  Column(
            children: [
              SizedBox(height: 10.h),
              userInfo(),
              // SizedBox(height: 20),
              topBanner(),
              SizedBox(height: 10.h),
              rewardsSection(),
              SizedBox(height: 20.h),
              topFivePerformersSection(),
              SizedBox(height: 30.h),
              partnerLogo(),
              SizedBox(height: 120.h)
            ],
          ),
        ),
      ),
    );
  }

  topBanner() {
    return Obx((){
      if (userCon.isProfileLoading.value) {
        return const SizedBox();
      }

      if (userCon.user.value.data.user.role.toLowerCase() == "customer" && userCon.user.value.data.user.status == 0) {
        return verificationWarningContainer(
          onRefresh: (){
            userCon.getUserData(true);
          }
        );
      }

    if(userCon.user.value.data.user.role.toLowerCase() == "technician" && userCon.user.value.data.user.status == 0){
        return verificationWarningContainer(
          onRefresh: (){
            userCon.getUserData(true);
          }
        );
      }

      if(homeCon.isAdBannerLoading.isTrue){
        return Container(
          height: 175.h,
          margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 236, 236, 236),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      } 

      if(homeCon.adSliderData == null ||homeCon.adSliderData.data.length == 0){
        return SizedBox();
      }

      return SizedBox(
        height: 220.h,
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 188.h,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: List.generate(homeCon.adSliderData.data.length, (index) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 236, 236, 236),
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(homeCon.adSliderData.data[index].image.toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              })
            ),
            SizedBox(height: 10.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(homeCon.adSliderData.data.length, (index) {
                return Container(
                  width: 12.w,
                  height: 2.5.h,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _currentIndex == index ? black.withValues(alpha:0.8) : black.withValues(alpha:0.1),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  Widget rewardsSection() {
  return Obx(() {
    final user = userCon.user.value.data.user;
    final bool isNepali = userCon.isNepaliUser.value;

    if (userCon.isProfileLoading.value) {
      return const SizedBox();
    }

    /// role checks (keep your logic, but cleaner)
    final role = user.role.toLowerCase();

    if (role == "customer") {
      return const SizedBox();
    }

    if (role == "technician" && user.status == 0) {
      return const SizedBox();
    }

    /// -----------------------------
    /// COUNTRY FILTERED LIST
    /// -----------------------------
    final filteredList = homeCon.redeemInfoData.where((item) {
      final country = (item.country ?? '').toString().toLowerCase().trim();
      return isNepali ? country == "nepal" : country == "india";
    }).toList();

    if (homeCon.isRedeemInfoLoading.value) {
      return Container(
        height: 300.h,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20.sp),
        decoration: BoxDecoration(
          color: yellowL,
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    if (filteredList.isEmpty) {
      return const SizedBox();
    }

    final bool isMoreThanThreeItems = filteredList.length > 3;
    final lastItem = filteredList.isNotEmpty ? filteredList.last : null;

    final mainItems = isMoreThanThreeItems
        ? filteredList.sublist(0, filteredList.length - 1)
        : filteredList;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: yellowL,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 20.sp),
      margin: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        children: [
          /// HEADER IMAGE
          CustomNetworkImage(
            imageUrl: homeCon.headerImage.toString(),
            height: 120.h,
            width: 300.w,
            borderRadius: 8.r,
          ),

          SizedBox(height: 26.h),

          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 16) / 3;

              return Column(
                children: [
                  /// -------------------------
                  /// GRID ITEMS
                  /// -------------------------
                  Wrap(
                    spacing: 8,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: List.generate(mainItems.length, (index) {
                      final item = mainItems[index];

                      final bool canRedeem =
                          user.redeemed >= item.points;

                      return SizedBox(
                        width: itemWidth,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (!canRedeem) {
                                  showToast(
                                    isSuccess: false,
                                    message:
                                        "Your Points are insufficient to redeem this Prize.",
                                  );
                                  return;
                                }
                                redeemPrzeDialogue(item.id);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 36.sp),
                                padding: EdgeInsets.all(10.sp),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: yellow,
                                    width: 0.8,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 25.h),
                                    Text(
                                      item.title,
                                      textAlign: TextAlign.center,
                                      style: poppinsBold(
                                        size: 10.sp,
                                        color: black,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),

                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.sp,
                                        vertical: 4.sp,
                                      ),
                                      decoration: BoxDecoration(
                                        color: canRedeem
                                            ? maroon.withOpacity(0.9)
                                            : gray.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            "assets/images/golden_star.png",
                                            height: 14.sp,
                                            width: 14.sp,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            formatter.format(item.points),
                                            style: poppinsSemiBold(
                                              size: 10.sp,
                                              color: white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            /// IMAGE
                            Align(
                              alignment: Alignment.topCenter,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CustomNetworkImage(
                                  imageUrl: item.image,
                                  height: 70.sp,
                                  width: 70.sp,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),

                  /// -------------------------
                  /// LAST BIG ITEM
                  /// -------------------------
                  if (isMoreThanThreeItems && lastItem != null)
                    Column(
                      children: [
                        SizedBox(height: 12.h),

                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (user.redeemed < lastItem.points) {
                                  showToast(
                                    isSuccess: false,
                                    message:
                                        "Your Points are insufficient to redeem this Prize.",
                                  );
                                  return;
                                }
                                redeemPrzeDialogue(lastItem.id);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 20.sp),
                                child: Container(
                                  width: 180.w,
                                  padding: EdgeInsets.all(10.sp),
                                  margin: EdgeInsets.only(top: 36.sp),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: yellow,
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 25.h),

                                      Text(
                                        lastItem.title,
                                        textAlign: TextAlign.center,
                                        style: poppinsBold(
                                          size: 14.sp,
                                          color: black,
                                        ),
                                      ),

                                      SizedBox(height: 8.h),

                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.sp,
                                          vertical: 4.sp,
                                        ),
                                        decoration: BoxDecoration(
                                          color: user.redeemed <
                                                  lastItem.points
                                              ? gray.withOpacity(0.5)
                                              : maroon.withOpacity(0.95),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              "assets/images/golden_star.png",
                                              height: 16.sp,
                                              width: 16.sp,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              formatter.format(
                                                  lastItem.points),
                                              style: poppinsSemiBold(
                                                size: 12.sp,
                                                color: white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            /// IMAGE
                            Align(
                              alignment: Alignment.topCenter,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CustomNetworkImage(
                                  imageUrl: lastItem.image,
                                  height: 90.sp,
                                  width: 90.sp,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  });
}

  userInfo() {
    return Obx(()=>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFE5D9), Color(0xFFFCEED5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: userCon.isProfileLoading.isTrue
            ? SizedBox(
              height: 50.h,
            )
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          // Profile Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CustomNetworkImage(
                              imageUrl: userCon.user.value.data.user.profileUrl.toString(),
                              width: 40.sp,
                              height: 40.sp,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          // Name and Membership ID
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userCon.user.value.data.user.name.toString(), style: poppinsBold(size: 14.sp, color: black),overflow: TextOverflow.ellipsis, maxLines: 2,),
                              SizedBox(height: 2.h),
                              Text("Membership ID: ${userCon.user.value.data.user.id}", style: poppinsSemiBold(size: 9.sp, color: black.withValues(alpha:0.7)), maxLines: 2,),
                              Text(
                                userCon.user.value.data.user.number.toString(),
                                style: poppinsMedium(size: 11.sp, color: black.withValues(alpha:0.6))
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Total Gained Points
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Total Gain Points", style: poppinsSemiBold(size: 9.sp, color: black.withValues(alpha:0.5)),),
                                  SizedBox(height: 4.h),
                                  Container(
                                    constraints: BoxConstraints(
                                      minWidth: 70.w
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                                    decoration: BoxDecoration(
                                      color: green,
                                      borderRadius: BorderRadius.circular(6.sp),
                                    ),
                                    alignment: Alignment.center,
                                    child: RichText(
                                      text: TextSpan(
                                        style: poppinsSemiBold(size: 11.sp, color: white),
                                        children: [
                                          WidgetSpan(
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 4.sp),
                                              child: Image.asset("assets/images/golden_star.png", height: 14.sp, width: 14.sp)
                                            ),
                                          ),
                                          TextSpan(
                                            text: formatter.format(int.parse("${userCon.user.value.data.user.redeemed}")),
                                            style: poppinsSemiBold(color: white, size: 10.sp ),
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
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

  topFivePerformersSection() {
    // Sort performers by highest totalRedeem

    return Obx(() {
      if (homeCon.isTop5PerformerLoading.value) {
        return const SizedBox();
      }

      if (homeCon.topPerformer.isEmpty) {
        return const SizedBox(); // Hide the entire section
      }

      if (userCon.isProfileLoading.value) {
        return const SizedBox();
      }

      if (userCon.user.value.data.user.role.toLowerCase() == "customer" && userCon.user.value.data.user.status == 0) {
        return const SizedBox();
      }

      if(userCon.user.value.data.user.role.toLowerCase() == "technician" && userCon.user.value.data.user.status == 0){
        return const SizedBox();
      }

      final sortedPerformers = List.of(homeCon.topPerformer)..sort((a, b) => b.totalRedeem.compareTo(a.totalRedeem));

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 260.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: gray.withValues(alpha:0.1),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 15.w),
                      const Icon(Icons.star, color: primary, size: 24),
                      SizedBox(width: 5.w),
                      Text(
                        "Top Five Performers",
                        style: poppinsSemiBold(size: 14.sp, color: black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(width: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: homeCon.topPerformer.length,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemBuilder: (context, index) {
                        final performer =sortedPerformers[index];

                        return Stack(
                          children: [
                            Container(
                              width: 130.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  ClipOval(
                                    child: CustomNetworkImage(
                                      imageUrl: performer.profilePicture ?? "",
                                      width: 60.sp,
                                      height: 60.sp,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    performer.user ?? "Unknown",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: poppinsRegular(size: 14.sp, color: black),
                                  ),
                                  SizedBox(height: 10.h),
                                  Container(
                                    constraints: BoxConstraints(minWidth: 80.w),
                                    padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                                    decoration: BoxDecoration(
                                      color: black.withValues(alpha:0.95),
                                      borderRadius: BorderRadius.circular(6.sp),
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        style: poppinsSemiBold(size: 11.sp, color: black.withValues(alpha:0.5)),
                                        children: [
                                          WidgetSpan(
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 4.sp),
                                              child: Image.asset(
                                                "assets/images/golden_star.png",
                                                height: 14.sp,
                                                width: 14.sp,
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                            text: "${performer.totalRedeem ?? 0} Points",
                                            style: poppinsMedium(color: white, size: 12.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Ribbon for 1st, 2nd, and 3rd place
                            Positioned(
                              top: 0,
                              left: 0,
                              child: buildRibbon(index + 1),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });

  }
  
  // Function to build ribbons
  buildRibbon( rank) {
    Color ribbonColor;
    String ribbonText;

    switch (rank) {
      case 1:
        ribbonColor = Colors.amber; // Gold for 1st
        ribbonText = "🥇 1st";
        break;
      case 2:
        ribbonColor = Colors.grey; // Silver for 2nd
        ribbonText = "🥈 2nd";
        break;
      case 3:
        ribbonColor = Colors.brown; // Bronze for 3rd
        ribbonText = "🥉 3rd";
        break;
      default:
        return const SizedBox(); // No ribbon for other ranks
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ribbonColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Text(
        ribbonText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // customAppbar(){
  //   return PreferredSize(
  //     preferredSize: Size(double.infinity, 70.0.h),
  //     child: Container(
  //       color: white,
  //       child: SafeArea(
  //         bottom: false,
  //         child: Column(
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.fromLTRB(20.sp, 10.0.sp, 20.sp, 0),
  //               child: Row(
  //                 children: [
  //                   Image.asset("assets/images/logo.png", height: 50.h),
  //                   const Spacer(),
  //                   Icon(Icons.headphones, color: black.withValues(alpha:0.7), size: 20.sp),
  //                 ],
  //               ),
  //             ),
  //             const Spacer(),
  //             Divider(
  //               color: gray.withValues(alpha:0.25),
  //               thickness: 0.8.sp,
  //               height: 0,
  //             ),
  //           ],
  //         ),
  //       ),
  //     )
  //   );
  // }

  // Redeem Prize Dialogue
  redeemPrzeDialogue(redeemId){
    List<Map<String, String>> redeemeList;

    if(userCon.user.value.data.user.role.toLowerCase() == "shopkeeper"){
      redeemeList = [
        {
          "name" : "Cash"
        },
      ];
    } else {
      redeemeList = [
        {
          "name" : "Product"
        },
        {
          "name" : "Cash"
        },
      ];
    }

    var selectedItem = "";

    return Get.defaultDialog(
      backgroundColor: boxCol,
      title: '',
      titlePadding: EdgeInsets.symmetric(horizontal: 20.0.w),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0.w),
      content: StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    "Redeem Prize",
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: black,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Select Reward Type",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: black,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() {
                        selectedItem = value;
                      });
                    },
                    itemBuilder: (context) => redeemeList
                        .map((item) => PopupMenuItem<String>(
                              value: item["name"] ?? "",
                              child: SizedBox(
                                width: 200.w,
                                child: Text(item["name"] ?? "")
                              ),
                            ))
                        .toList(),
                    offset: Offset(4.w,0),
                    position: PopupMenuPosition.under, // Ensures the menu appears below
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha:0.9),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.transparent, width: 0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selectedItem),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Submit Button
                  Obx(()=>
                    CustomButton(
                      isLoading: userCon.isChecoutLoading.isTrue,
                      onPressed: () async{
                        if(selectedItem == ""){
                          showToast(
                            isSuccess: false,
                            message: "Please select a type first."
                          );
                          return;
                        }
                        await userCon.checkOutPrize(redeemId, selectedItem);
                      },
                      text: "Redeem",
                      bgColor: black,
                      fontColor: white,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Cancel Button
                  CustomButton(
                    onPressed: () {
                      // Handle manual code submission
                      Get.back();
                    },
                    text: "Cancel",
                    bgColor: Colors.transparent,
                    fontColor: black,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
