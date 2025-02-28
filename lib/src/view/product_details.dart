import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/product_controller.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:pecon/src/widgets/custom_markdown.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';
import 'package:pecon/src/widgets/view_full_screen_image.dart';

class ProductDetailsPage extends StatefulWidget {
  final int index;
  const ProductDetailsPage({super.key, required this.index});


  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  // Get Controller
  final ProductsController productCon = Get.put(ProductsController());

  final NumberFormat formatter = NumberFormat("#,##0", "en_US");
  
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Product Image Slider
            productImageSlider(),
            SizedBox(height: 4.h),
            // Product Details
            productDetails(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  // About Product
  productDetails() {
    String title = productCon.productList[widget.index].title;
    List<String> words = title.split(" ");  
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category
          Text(
            productCon.productList[widget.index].category.name.toString(),
            style: TextStyle(fontSize: 13.sp, color: black, letterSpacing: -0.5.sp, fontWeight: FontWeight.w900, height: 1.5),
          ),
          SizedBox(height: 2.0.h,),
          // Product Name
          Text(
            words.isNotEmpty ? words[0].toUpperCase() : "",
            style: TextStyle(fontSize: 24.sp, color: const Color.fromARGB(255, 207, 47, 36), letterSpacing: -1.sp, fontWeight: FontWeight.w900,height: 0),
          ),
          SizedBox(height: 2.0.h,),
          Text(
            words.length > 1 ? words.sublist(1).join(" ") : "", // Joins all words after index 0
            style: TextStyle(fontSize: 17.sp, color: black, letterSpacing: -0.5.sp, fontWeight: FontWeight.w600, height: 0),
          ),
          SizedBox(height: 12.h),
          // CCT / Watt
          Text("CCT : ${productCon.productList[widget.index].color ?? "0"}   /   WATTS : ${productCon.productList[widget.index].watt ?? "0"}", 
            style: TextStyle(fontSize: 24.sp, color: black, letterSpacing: -1.sp, fontWeight: FontWeight.w900, height: 0),
          ),
          SizedBox(height: 14.h),
          // Price and Redeem
          Row(
            children: [
              Visibility(
                visible: productCon.productList[widget.index].price != "0",
                child: Column(
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
                              text: formatter.format(double.parse(productCon.productList[widget.index].price ?? "0")),
                              style: poppinsSemiBold(color: green, size: 13.sp ),
                            ),
                          ],
                        ),
                      )
                    )
                  ],
                ),
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
                            text: formatter.format(double.parse(productCon.productList[widget.index].redeem ?? "0")),
                            style: poppinsSemiBold(color: white, size: 12.sp ),
                          ),
                        ],
                      ),
                    )
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 14.h,),
          Divider(
            color: gray.withOpacity(0.25),
            thickness: 0.8.sp,
            height: 0,
          ),
          SizedBox(height: 10.h,),
          Text(
            "Technical Specification",
            style: poppinsSemiBold(size: 18.sp, color: black)
          ),
          SizedBox(height: 6.h),
          CustomMarkdownWidget(
            data: productCon.productList[widget.index].specification  ?? "", 
            imageBuilder: (uri, title, alt) {
              var imageList = [];
              imageList.add(uri.toString());
              return InkWell(
                onTap: () {
                  Get.to(() => FullScreenImagePage(imageUrl: imageList[imageList.indexOf(uri.toString())]),
                    transition: Transition.downToUp
                  );
                },
                child: CustomNetworkImage(
                  imageUrl: uri.toString(),
                  height: 442.0.h,
                  width: double.infinity,
                ),
              );
            },
          )
        ],
      ),
    );
  }


  // Product Image slider
  productImageSlider() {
    return productCon.productList[widget.index].images == []
      ? const SizedBox()
      : Column(
        children: [
          CarouselSlider(
            items: (productCon.productList[widget.index].images as List<dynamic>?)
                ?.cast<String>() // Ensure it's List<String>
                .map<Widget>((url) => GestureDetector(
                      onTap: () {
                        Get.to(() => FullScreenImagePage(imageUrl: url));
                      },
                      child: Container(
                        color: const Color.fromARGB(255, 236, 236, 236),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        ),
                      ),
                    ))
                .toList() ?? [const SizedBox()], // Fallback widget
            options: CarouselOptions(
              height: 300.h,
              viewportFraction: 1.0,
              scrollPhysics: productCon.productList[widget.index].images.length <= 1 ? const NeverScrollableScrollPhysics() : null,
              autoPlay: productCon.productList[widget.index].images.length <= 1 ? false : true,
              onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
              },
            ),
          ),

          SizedBox(height: 8.h),
          // Custom Page Indicator
          Visibility(
            visible: productCon.productList[widget.index].images.length > 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                productCon.productList[widget.index].images.length, // Ensure it matches image count
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: activeIndex == index ? 16.w : 12.w, // Active indicator slightly wider
                  height: 3.h, // Keep a uniform height
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: activeIndex == index ? black.withOpacity(0.8) : black.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
      
        ],
      );
  }
}
