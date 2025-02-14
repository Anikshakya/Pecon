
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/app_controller.dart';
import 'package:pecon/src/controllers/home_controller.dart';
import 'package:pecon/src/controllers/user_controller.dart';
import 'package:pecon/src/view/product_details.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pecon/src/widgets/partner_logo.dart';

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

  final List<String> adImages = [
    'https://auxbeam.in/cdn/shop/files/RA80_XL-Banner_--_1_6996a792-2824-4901-be7f-b6d76bb4b138.jpg?v',
    'https://www.shutterstock.com/image-vector/vector-illustration-realistic-silver-color-260nw-2202634611.jpg',
    'https://endel.io/pages/index/hero-top-banner/hero-top-banner-desktop.jpg',
    'https://img.freepik.com/free-psd/black-friday-super-sale-facebook-cover-banner-template_120329-5177.jpg',
    'https://graphicsfamily.com/wp-content/uploads/edd/2021/06/Gadget-Banner-Design-Template-scaled.jpg',
    'https://img.freepik.com/premium-psd/black-friday-sale-laptops-gadgets-banner-template-3d-render_444361-44.jpg'
  ];

  final List redeemItemData = List.generate(5, (index) =>
      {
        "imageUrl" : "https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/1015f/MainBefore.jpg",
        "redeemPoints" : index+99,
      });

  final List<Map<String, dynamic>> topPerformers = [
    {
      "name": "Anjan Kumar",
      "phone": "+91 6201277689",
      "rank": "First",
      "cash": 2935,
      "profileUrl": "https://t3.ftcdn.net/jpg/07/72/07/02/360_F_772070223_m2tqMfNW4DSpmTS0QorQvlta9Qeyc4As.jpg"
    },
    {
      "name": "Manisha Sharma",
      "phone": "+91 9142149403",
      "rank": "Second",
      "cash": 2400,
      "profileUrl": "https://img.freepik.com/free-photo/lifestyle-people-emotions-casual-concept-confident-nice-smiling-asian-woman-cross-arms-chest-confident-ready-help-listening-coworkers-taking-part-conversation_1258-59335.jpg"
    },
    {
      "name": "Ramesh Kumar",
      "phone": "+91 8051789652",
      "rank": "Third",
      "cash": 1395,
      "profileUrl": "https://t3.ftcdn.net/jpg/09/99/44/94/360_F_999449473_eq6Om1kdD5Y5yZ29fR1j9TsiwbY583nw.jpg"
    },
    {
      "name": "Sahina Joshi",
      "phone": "+91 8051789652",
      "rank": "Fourth",
      "cash": 1395,
      "profileUrl": "https://img.freepik.com/free-photo/lifestyle-people-emotions-casual-concept-confident-nice-smiling-asian-woman-cross-arms-chest-confident-ready-help-listening-coworkers-taking-part-conversation_1258-59335.jpg"
    },
    {
      "name": "Anjan Lal Mishra",
      "phone": "+91 8051789652",
      "rank": "Fifth",
      "cash": 1395,
      "profileUrl": "https://t3.ftcdn.net/jpg/07/72/07/02/360_F_772070223_m2tqMfNW4DSpmTS0QorQvlta9Qeyc4As.jpg"
    },
  ];


  // Redeeme Items
  List<Map<String, dynamic>> redeemItemsJson = [
    {"id": 1, "name": "NEON HELMET", "imageUrl": "https://wroom.co.in/wp-content/uploads/2022/11/Vega-Bolt-Bunny-Black-Neon-Blue-Helmet-Online-Buy-India.jpg", "points": 600},
    {"id": 2, "name": "POWER BANK", "imageUrl": "https://i0.wp.com/mypowernepal.com/wp-content/uploads/2021/12/e4eba131e18bc2c2b357987ce3522d1a.png?fit", "points": 1500},
    {"id": 3, "name": "HAND GRINDER", "imageUrl": "https://hardwarepasal.com/src/img/product/multipleimages/2022-05-18-16-45-37_STvz8Ae7IJ.png", "points": 2000},
    {"id": 4, "name": "DRILL MACHINE", "imageUrl": "https://m.media-amazon.com/images/I/51fSluIoV2L._SL1000_.jpg", "points": 4000},
    {"id": 5, "name": "BICYCLE", "imageUrl": "https://cdn.shopify.com/s/files/1/0834/5213/3657/files/2025_STRATTOS_S7D-844233.jpg?v=1717547195", "points": 5500},
    {"id": 6, "name": "SMART PHONE", "imageUrl": "https://image.made-in-china.com/318f0j00ktZYIbnKflce/MIC-mp4.webp", "points": 12500},
    {"id": 7, "name": "SMART WATCH", "imageUrl": "https://ecdn6.globalso.com/upload/p/1417/image_product/2024-03/660275293990e60627.jpg", "points": 8000},
  ];

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
    await homeCon.getRedeemInformation();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: customAppbar(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              userInfo(),
              // SizedBox(height: 20),
              topBanner(),
              // SizedBox(height: 10),
              rewardsSection(),
              SizedBox(height: 20.h),
              topFivePerformersSection(),
              SizedBox(height: 30.h),
              partnerLogo(),
              SizedBox(height: 50.h)
            ],
          ),
        ),
      ),
    );
  }

  topBanner() {
    return Obx(() => homeCon.isAdBannerLoading.isTrue
      ? Container(
          height: 175.h,
          margin: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 236, 236, 236),
            borderRadius: BorderRadius.circular(8),
          ),
        )
      : SizedBox(
        height: 220.h,
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 200.h,
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
                  margin: const EdgeInsets.fromLTRB(20, 14, 20, 10),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: adImages.asMap().entries.map((entry) {
                return Container(
                  width: 12.w,
                  height: 2.5.h,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _currentIndex == entry.key ? black.withOpacity(0.8) : black.withOpacity(0.1),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      )
    );
  }

  Widget rewardsSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: yellowL,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 20.sp),
      margin: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Obx(() => homeCon.isRedeemInfoLoading.isTrue
        ? SizedBox(height: 300.h,)
        : Column(
          children: [
            Text(
              "Points-Based \nRewards",
              textAlign: TextAlign.center,
              style: poppinsSemiBold(size: 20.sp, color: black),
            ),
            // Image.asset("assets/images/logo.png", height: 50.h),
            SizedBox(height: 16.h,),
            // Redeem Code Grid
            LayoutBuilder(
              builder: (context, constraints) {
                double itemWidth = (constraints.maxWidth - 8 * 2) / 3; // 3 items per row
            
                return Wrap(
                  spacing: 8,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: List.generate(homeCon.redeemInfoData.length, (index) {
                    final item = homeCon.redeemInfoData[index];
            
                    Widget itemWidget = Stack(
                      children: [
                        // Info
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: (){
                              Get.to(()=> const ProductDetailsPage());
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10.sp),
                                  margin: EdgeInsets.only(top: 36.sp),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.r),
                                      topRight: Radius.circular(20.r),
                                      bottomLeft: Radius.circular(8.r),
                                      bottomRight: Radius.circular(8.r),
                                    ),
                                    border: Border.all(
                                      width: 0.8,
                                      color: yellow
                                    ),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.grey.withOpacity(0.3),
                                    //     blurRadius: 4,
                                    //     spreadRadius: 2,
                                    //   ),
                                    // ],
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 25.h),
                                      Text(
                                        item.title,
                                        style: poppinsBold(size: 10.sp, color: black),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 5.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                                        decoration: BoxDecoration(
                                          color: userCon.userPoints < item.points ? gray.withOpacity(0.5) : maroon.withOpacity(.95),
                                          borderRadius: BorderRadius.circular(6.sp),
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            style: poppinsSemiBold(size: 10.sp, color: userCon.userPoints < item.points ? white : black),
                                            children: [
                                              WidgetSpan(
                                                child: Padding(
                                                  padding: EdgeInsets.only(right: 4.sp),
                                                  child: Image.asset("assets/images/golden_star.png", height: 14.sp, width: 14.sp,)
                                                ),
                                              ),
                                              TextSpan(
                                                text: formatter.format(int.parse("${item.points}")),
                                                style: poppinsSemiBold(color:  white, size: 10.sp ),
                                              ),
                                            ],
                                          ),
                                        )
                                      )
                                    ],
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                        // Image
                        Align(
                          alignment: Alignment.topCenter,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CustomNetworkImage(
                              imageUrl: item.image,
                              height: 65.sp,
                              width: 65.sp,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    );
            
                    return Container(
                      width: itemWidth,
                      alignment: Alignment.center,
                      child: itemWidget,
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  
  userInfo() {
    return Padding(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'Welcome',
            //   style: poppinsSemiBold(size: 20.sp, color: black),
            //   overflow: TextOverflow.ellipsis, 
            //   maxLines: 2,
            // ),
            // SizedBox(height: 5.h),
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
                          imageUrl: userCon.userImage,
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
                          Text(userCon.userName.toString(), style: poppinsBold(size: 14.sp, color: black),overflow: TextOverflow.ellipsis, maxLines: 2,),
                          SizedBox(height: 2.h),
                          Text("Membership ID: ${userCon.userId}", style: poppinsSemiBold(size: 9.sp, color: black.withOpacity(0.7)), maxLines: 2,),
                          Text(
                            userCon.userNumber.toString(),
                            style: poppinsMedium(size: 11.sp, color: black.withOpacity(0.6))
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
                              Text("Total Gain Points", style: poppinsSemiBold(size: 9.sp, color: black.withOpacity(0.5)),),
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
                                        text: formatter.format(int.parse("${userCon.userPoints}")),
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
    );
  }


  topFivePerformersSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Replacing SingleChildScrollView with ListView.builder
          Container(
            height: 260.h, // Set a fixed height or adjust based on content
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: gray.withOpacity(0.1),
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
                      style: poppinsSemiBold(size: 14.sp, color : black)
                    ),
                  ],
                ),
                const SizedBox(height: 16,),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: topPerformers.length,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemBuilder: (context, index) {
                      final performer = topPerformers[index];
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
                                const SizedBox(height: 20,),
                                ClipOval(
                                  child: CustomNetworkImage(
                                    imageUrl: performer["profileUrl"] ?? "",
                                    width: 60.sp,
                                    height: 60.sp,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  performer["rank"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: poppinsBold(size: 14.sp, color: black)
                                ),
                                Text(
                                  performer["name"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: poppinsRegular(size: 14.sp, color: black)
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  constraints: BoxConstraints(
                                    minWidth: 80.w
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                                  decoration: BoxDecoration(
                                    color: maroon.withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(6.sp),
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      style: poppinsSemiBold(size: 11.sp, color: black.withOpacity(0.5)),
                                      children: [
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 4.sp),
                                            child: Image.asset("assets/images/golden_star.png", height: 14.sp, width: 14.sp)
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${performer["cash"]} Points",
                                          style: poppinsMedium(color: white, size: 12.sp ),
                                        ),
                                      ],
                                    ),
                                  )
                                )
                              ],
                            ),
                          ),
                          // Ribbon for 1st, 2nd, and 3rd place
                          Positioned(
                            top: 0,
                            left: 0,
                            child: buildRibbon(performer["rank"]),
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
  }
  
  // Function to build ribbons
  buildRibbon(String rank) {
    Color ribbonColor;
    String ribbonText;

    switch (rank) {
      case "First":
        ribbonColor = Colors.amber; // Gold for 1st
        ribbonText = "🥇 1st";
        break;
      case "Second":
        ribbonColor = Colors.grey; // Silver for 2nd
        ribbonText = "🥈 2nd";
        break;
      case "Third":
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
  //                   Icon(Icons.headphones, color: black.withOpacity(0.7), size: 20.sp),
  //                 ],
  //               ),
  //             ),
  //             const Spacer(),
  //             Divider(
  //               color: gray.withOpacity(0.25),
  //               thickness: 0.8.sp,
  //               height: 0,
  //             ),
  //           ],
  //         ),
  //       ),
  //     )
  //   );
  // }

}
