import 'package:get/get.dart';
import 'package:pecon/src/view/product_details.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';
import 'package:intl/intl.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final NumberFormat formatter = NumberFormat("#,##0", "en_US");
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: productAppbar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(bottom: 60.0.sp),
          //products list
          child: Column(
            children: [
              ListView.separated(
                separatorBuilder: (context, index) => 
                  Divider(
                    color: gray.withOpacity(0.25),
                    thickness: 0.8.sp,
                    height: 0,
                  ),
                itemCount: productsList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      Get.to(()=> const ProductDetailsPage());
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
                                imageUrl: productsList[index]["productUrl"], 
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
                                Text(productsList[index]["productName"], style: poppinsSemiBold(size: 14.sp, color: black),overflow: TextOverflow.ellipsis, maxLines: 2,),
                                SizedBox(height: 2.h),
                                Text("Product Code: ${productsList[index]["productCode"]}", style: poppinsSemiBold(size: 12.sp, color: black.withOpacity(0.7))),
                                SizedBox(height: 10.h),
                                //products price and rewar points
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("MRP", style: poppinsSemiBold(size: 10.sp, color: black.withOpacity(0.5)),),
                                        SizedBox(height: 4.h),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                                          decoration: BoxDecoration(
                                            color: gray.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(6.sp),
                                          ),
                                          child: RichText(
                                            text: TextSpan(
                                              style: poppinsSemiBold(size: 11.sp, color: black.withOpacity(0.5)),
                                              children: [
                                                const TextSpan(text: "₹  "),
                                                TextSpan(
                                                  text: formatter.format(int.parse(productsList[index]["productMrp"])),
                                                  style: poppinsSemiBold(color: green, size: 13.sp ),
                                                ),
                                              ],
                                            ),
                                          )
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("Points", style: poppinsSemiBold(size: 11.sp, color: black.withOpacity(0.5)),),
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
                                                  text: formatter.format(int.parse(productsList[index]["cashReward"])),
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
    );
  }

  List<Map<String, dynamic>> productsList = [
    {
      "productUrl": "https://m.media-amazon.com/images/I/61hf2tu4IvL.jpg",
      "productName": "Wireless Earbuds",
      "productCode": "EB1001",
      "productMrp": "2500",
      "cashReward": "150",
    },
    {
      "productUrl": "https://m.media-amazon.com/images/I/7161CULzh+L._AC_SL1500_.jpg",
      "productName": "Smartwatch",
      "productCode": "SW2001",
      "productMrp": "4500",
      "cashReward": "250",
    },
    {
      "productUrl": "https://app.infotechsnepal.com.np/wp-content/uploads/2024/12/JBL-GO-4-Speaker.jpg",
      "productName": "Bluetooth Speaker",
      "productCode": "BS3001",
      "productMrp": "3200",
      "cashReward": "200",
    },
    {
      "productUrl": "https://static-01.daraz.com.np/p/e3e4c976b3758b2cfd2ec77e3b7b524a.jpg",
      "productName": "Gaming Mouse",
      "productCode": "GM4001",
      "productMrp": "1800",
      "cashReward": "120",
    },
    {
      "productUrl": "https://m.media-amazon.com/images/I/71fRP7KY9hL._AC_SL1500_.jpg",
      "productName": "Mechanical Keyboard",
      "productCode": "MK5001",
      "productMrp": "5500",
      "cashReward": "300",
    },
    {
      "productUrl": "https://static-01.daraz.com.np/p/b3082c8b3e176a2153814506d5052486.jpg",
      "productName": "Laptop Stand",
      "productCode": "LS6001",
      "productMrp": "1300",
      "cashReward": "80",
    },
    {
      "productUrl": "https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6556/6556967_sd.jpg",
      "productName": "Portable Charger",
      "productCode": "PC7001",
      "productMrp": "2800",
      "cashReward": "170",
    },
    {
      "productUrl": "https://static-01.daraz.com.np/p/9142ccf4acd35f0de87ca8991f5f6d11.jpg",
      "productName": "Wireless Headphones",
      "productCode": "WH8001",
      "productMrp": "6200",
      "cashReward": "350",
    },
    {
      "productUrl": "https://m.media-amazon.com/images/I/71rZLuhfn8L.jpg",
      "productName": "Tablet Stand",
      "productCode": "TS9001",
      "productMrp": "1600",
      "cashReward": "90",
    },
    {
      "productUrl": "https://uk.zhiyun-tech.com/cdn/shop/files/SM51_f614743f-d324-4b5b-b6a0-04012190fee4.jpg?v",
      "productName": "Smartphone Gimbal",
      "productCode": "SG1001",
      "productMrp": "7000",
      "cashReward": "400",
    },
    {
      "productUrl": "https://ottlite.com/cdn/shop/files/CSN30G5W_1.jpg?v",
      "productName": "LED Desk Lamp",
      "productCode": "DL1101",
      "productMrp": "2400",
      "cashReward": "130",
    },
    {
      "productUrl": "https://images.zapnito.com/users/483790/posters/02d95439-4b68-4f81-b7ca-a549d7712f79_large.jpeg",
      "productName": "VR Headset",
      "productCode": "VR1201",
      "productMrp": "8500",
      "cashReward": "500",
    },
  ];
}