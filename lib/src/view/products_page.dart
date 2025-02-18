import 'package:get/get.dart';
import 'package:pecon/src/controllers/product_controller.dart';
import 'package:pecon/src/view/product_details.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';
import 'package:intl/intl.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pecon/src/widgets/custom_text_field.dart';
import 'package:pecon/src/widgets/customer_service_dialog.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductsController productCon = Get.put(ProductsController());
  final NumberFormat formatter = NumberFormat("#,##0", "en_US");

  @override
  void initState() {
    initialise();
    super.initState();
  }

  initialise() async{
    await productCon.getSearchCategory();
  }
  
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

  //appbar with search
  productAppbar(context){
    return PreferredSize(
      preferredSize: Size(double.infinity, 124.0.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 12.0.sp),
        decoration: const BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 34.h,
                    child: Image.asset("assets/images/peacon_logo.png"),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: (){
                      customerServiceDialog();
                    },
                    child: Image.asset("assets/images/customer_service.png", width:22.w, height:26.w, fit: BoxFit.cover,),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 280.w,
                    height: 48.h,
                    child:  CustomTextFormField(
                      headingText: "Search", 
                      prefixIcon: Icon(Icons.search, color: grey10.withOpacity(0.8),),
                      filledColor: white,
                    )
                  ),
                  const Spacer(),
                  Obx(() => productCon.isLoading.isTrue 
                    ? SizedBox(
                      height: 16.sp,
                      width: 16.sp,
                      child: CircularProgressIndicator(
                        color: black,
                        strokeWidth: 1.5.sp,
                      ),
                    )
                    : GestureDetector(
                      onTap: (){
                          filterDialog();
                        },
                      child: const Icon(Icons.filter_alt_outlined, color: black)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }

  // Show manual code entry dialog
  filterDialog() {
    Get.defaultDialog(
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
                    "Filter Search Results",
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: black,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Filter Category",
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
                        productCon.selectedCategory = value;

                        // Find selected category and get its subcategories
                        var selectedCategoryData = productCon.categoryList.firstWhere(
                          (item) => item["name"] == value,
                          orElse: () => {},
                        );

                        // Extract subcategories list or set it to empty if not found
                        productCon.filteredSubcategories = selectedCategoryData["subcategories"] ?? [];
                      });
                    },
                    itemBuilder: (context) => productCon.categoryList
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
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.transparent, width: 0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(productCon.selectedCategory),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  if (productCon.filteredSubcategories.isNotEmpty) 
                  ...[
                    SizedBox(height: 16.h),
                    Text(
                      "Filter Sub-Category",
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
                          productCon.selectedSubCategory = value;
                        });
                      },
                      itemBuilder: (context) => productCon.filteredSubcategories
                          .map((sub) => PopupMenuItem<String>(
                                value: sub["name"] ?? "",
                                child: SizedBox(
                                  width: 200.w,
                                  child: Text(sub["name"] ?? ""),
                                ),
                              ))
                          .toList(),
                      offset: Offset(4.w, 0),
                      position: PopupMenuPosition.under,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.transparent, width: 0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(productCon.selectedSubCategory),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 24.h),
                  // Submit Button
                  CustomButton(
                    onPressed: () {
                      // Handle manual code submission
                      Get.back();
                    },
                    text: "Apply",
                    bgColor: black,
                    fontColor: white,
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