import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:pecon/src/widgets/view_full_screen_image.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int activeIndex = 0;

  final List<String> imageUrls = [
    'https://graphicsfamily.com/wp-content/uploads/edd/2021/06/Gadget-Banner-Design-Template-scaled.jpg',
    'https://img.freepik.com/free-psd/black-friday-super-sale-facebook-cover-banner-template_120329-5177.jpg',
    'https://graphicsfamily.com/wp-content/uploads/edd/2021/06/Gadget-Banner-Design-Template-scaled.jpg',
    'https://img.freepik.com/premium-psd/black-friday-sale-laptops-gadgets-banner-template-3d-render_444361-44.jpg',
    'https://graphicsfamily.com/wp-content/uploads/edd/2021/06/Gadget-Banner-Design-Template-scaled.jpg'
  ];

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
            SizedBox(height: 20.h),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Category 2",
            style: poppinsMedium(size: 13.sp, color: gray)
          ),
          SizedBox(height: 6.h),
          Text(
            "Electric Bike",
            style: poppinsSemiBold(size: 21.sp, color: black)
          ),
          SizedBox(height: 6.h),
          Text(
            "by Bhrati Electra",
            style: poppinsMedium(size: 13.sp, color: gray)
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  style: poppinsSemiBold(size: 10.sp, color: black),
                  children: [
                    TextSpan(
                      text: "2000 ",
                      style: poppinsSemiBold(color: primary, size: 20.sp ),
                    ),
                    TextSpan(
                      text: "CCT",
                      style: poppinsSemiBold(color: black, size: 20.sp ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "/",
                style: poppinsSemiBold(size: 18.sp, color: black)
              ),
              SizedBox(width: 12.w),
              RichText(
                text: TextSpan(
                  style: poppinsSemiBold(size: 10.sp, color: black),
                  children: [
                    TextSpan(
                      text: "120 ",
                      style: poppinsSemiBold(color: primary, size: 20.sp ),
                    ),
                    TextSpan(
                      text: "Watt",
                      style: poppinsSemiBold(color: black, size: 20.sp ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            "Technical Specification",
            style: poppinsSemiBold(size: 18.sp, color: black)
          ),
          SizedBox(height: 6.h),
          Text(
            "Mauris neque tellus, placerat sit amet quam et, facilisis suscipit dui. "
            "Mauris neque tellus, placerat sit amet quam et, facilisis suscipit dui. "
            "Mauris neque tellus, placerat sit amet quam et, facilisis suscipit dui. "
            "Mauris neque tellus, placerat sit amet quam et, facilisis suscipit dui. "
            "Mauris neque tellus, placerat sit amet quam et, facilisis suscipit dui. "
            "Mauris neque tellus, placerat sit amet quam et, facilisis suscipit dui. "
            "Mauris neque tellus, placerat sit amet quam et, facilisis suscipit dui. "
            "Mauris neque tellus, placerat sit amet quam et, facilisis suscipit dui. "
            "Mauris neque tellus, placerat sit amet quam et, facilisis suscipit dui. "
            "Cras a pretium ena mauris. Mauris eget sapien ut nisi posuere.",
            style: poppinsMedium(size: 13.sp, color: gray)
          ),
        ],
      ),
    );
  }


  // Product Image slider
  productImageSlider() {
    return Column(
      children: [
        CarouselSlider(
          items: imageUrls.map((url) {
            return GestureDetector(
              onTap: (){
                Get.to(()=> FullScreenImagePage(imageUrl: url));
              },
              child: Container(
                color: const Color.fromARGB(255, 236, 236, 236),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 300.h,
            viewportFraction: 1.0,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: 8.h),
        // Custom Page Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(imageUrls.length, (index) {
            return Container(
              width: 12.w,
              height: 2.5.h,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: activeIndex == index ? black.withOpacity(0.8) : black.withOpacity(0.1),
              ),
            );
          }),
        ),
    
      ],
    );
  }
}
