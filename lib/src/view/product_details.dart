import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
            productCon.productList[widget.index].categoryId.toString(),
            style: poppinsMedium(size: 13.sp, color: gray)
          ),
          SizedBox(height: 6.h),
          Text(
            productCon.productList[widget.index].title ?? "",
            style: poppinsBold(size: 21.sp, color: black)
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Flexible(
                child: RichText(
                  text: TextSpan(
                    style: poppinsSemiBold(size: 10.sp, color: black),
                    children: [
                      TextSpan(
                        text: productCon.productList[widget.index].watt ?? "0",
                        style: poppinsSemiBold(color: primary, size: 20.sp),
                      ),
                      WidgetSpan(
                        child: Text(
                          " CCT",
                          style: poppinsMedium(color: black, size: 18.sp),
                          maxLines: 2, // Allow up to 2 lines
                          overflow: TextOverflow.ellipsis, // Truncate after 2 lines
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              Text(
                "/",
                style: poppinsSemiBold(size: 18.sp, color: black),
              ),

              SizedBox(width: 8.w),

              Flexible(
                child: RichText(
                  text: TextSpan(
                    style: poppinsSemiBold(size: 10.sp, color: black),
                    children: [
                      TextSpan(
                        text: productCon.productList[widget.index].watt ?? "0",
                        style: poppinsSemiBold(color: primary, size: 20.sp),
                      ),
                      WidgetSpan(
                        child: Text(
                          " Watt",
                          style: poppinsMedium(color: black, size: 18.sp),
                          maxLines: 2, // Allow up to 2 lines
                          overflow: TextOverflow.ellipsis, // Truncate after 2 lines
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Text(
            "Technical Specification",
            style: poppinsBold(size: 18.sp, color: black)
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
    return Column(
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
    
      ],
    );
  }
}
