import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon/src/app_config/styles.dart';
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
      body: Column(
        children: [
          // Image Slider
          CarouselSlider(
            items: imageUrls.map((url) {
              return GestureDetector(
                onTap: (){
                  Get.to(()=> FullScreenImagePage(imageUrl: url));
                },
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 300,
              viewportFraction: 1.0,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
              },
            ),
          ),

          SizedBox(height: 10.h),

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

          SizedBox(height: 20.h),

          // Product Details
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Category 2",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "Hooded Sweatshirt",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "by Jarvis Pepperspray",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "\$125.00",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "\$200.00",
                      style: TextStyle(fontSize: 16, color: Colors.grey, decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  "Description",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Mauris neque tellus, placerat sit amet quam et, facilisis suscipit dui. "
                  "Cras a pretium ena mauris. Mauris eget sapien ut nisi posuere.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          Spacer(),

          // Add to Cart Button
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {},
              child: Text(
                "Add To Cart",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
