import 'package:get/get.dart';
import 'package:pecon/src/controllers/product_controller.dart';
import 'package:pecon/src/controllers/user_controller.dart';
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
  //get controller
  final ProductsController productCon = Get.put(ProductsController());
  final UserController userCon = Get.put(UserController());
  //textcontroller
  final TextEditingController searchController = TextEditingController();
  //number format
  final NumberFormat formatter = NumberFormat("#,##0", "en_US");
  //store filter search id
  int? categoryId;
  int? subCategoryId;

  @override
  void initState() {
    initialise();
    super.initState();
  }

  initialise() async{
    productCon.selectedCategory = "";
    productCon.getProductList();
    productCon.getSearchCategory();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: productAppbar(context),
      body: RefreshIndicator(
        color: black,
        onRefresh: (){
          return Future.delayed(const Duration(seconds: 1),()async{// Get Athlete Details Data
            initialise();
          });
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(bottom: 60.0.sp),
            //products list
            child: Obx(() => productCon.isProductListLoading.isTrue
              ? SizedBox(
                height: 570.0.h,
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
              : productCon.productList.isEmpty
              ? SizedBox(
                height: 570.0.h,
                child: const Center(
                  child: Text("No Products List")
                ),
              )
              : 
              Column(
                children: [
                  ListView.separated(
                    separatorBuilder: (context, index) => 
                      Divider(
                        color: gray.withOpacity(0.25),
                        thickness: 0.8.sp,
                        height: 0,
                      ),
                    itemCount: productCon.productList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          Get.to(()=> ProductDetailsPage(
                            index: index,
                          ));
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
                                    imageUrl: productCon.productList[index].coverPhoto.toString(), 
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
                                    SizedBox(height: 3.h),
                                    Text(productCon.productList[index].title.toString(), style: poppinsSemiBold(size: 14.sp, color: black),overflow: TextOverflow.ellipsis, maxLines: 2,),
                                    SizedBox(height: 12.h),
                                    //products price and rewar points
                                    Row(
                                      children: [
                                        userCon.userRole == "Customer"
                                          ? Visibility(
                                            visible: productCon.productList[index].price != "0",
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
                                                          text: formatter.format(double.parse(productCon.productList[index].price ?? "0")),
                                                          style: poppinsSemiBold(color: green, size: 13.sp ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                )
                                              ],
                                            ),
                                          )
                                          : Visibility(
                                            visible: productCon.productList[index].category.name != "",
                                            child: Column(
                                              children: [
                                                SizedBox(height: 18.h),
                                                Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: 190.w,
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                                                  decoration: BoxDecoration(
                                                    color: gray.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(6.sp),
                                                  ),
                                                  child: Text(
                                                    productCon.productList[index].category.name,
                                                    style: poppinsSemiBold(color: black.withOpacity(.5), size: 11.sp ),
                                                  )
                                                ),
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
                                                      text: formatter.format(double.parse(productCon.productList[index].redeem ?? "0")),
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
                      controller: searchController,
                      headingText: "Search", 
                      prefixIcon: Icon(Icons.search, color: grey10.withOpacity(0.8),),
                      filledColor: white,
                      onFieldSubmitted: (value) {
                        productCon.getProductList(searchController.text,categoryId,subCategoryId);
                      },
                    )
                  ),
                  const Spacer(),
                  Obx(() => GestureDetector(
                      onTap: productCon.isLoading.isTrue 
                        ? (){}
                        :(){
                          filterDialog();
                        },
                      child: Icon(Icons.filter_alt_outlined, color: productCon.isLoading.isTrue ? black.withOpacity(0.2) : black)
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
                        productCon.selectedSubCategory = "";

                        productCon.selectedCategory = value;

                        // Find selected category and get its subcategories
                        var selectedCategoryData = productCon.categoryList.firstWhere(
                          (item) => item["name"] == value,
                          orElse: () => {},
                        );

                        // Extract subcategories list or set it to empty if not found
                        productCon.filteredSubcategories = selectedCategoryData["subcategories"] ?? [];

                        //store category id to search
                        categoryId = selectedCategoryData["id"];

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

                          // Find selected subcategory and get its subcategories
                          var selectedSubCategoryData = productCon.filteredSubcategories.firstWhere(
                            (item) => item["name"] == value,
                            orElse: () => {},
                          );

                          //store subcategory id to search
                          subCategoryId = selectedSubCategoryData["id"];
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
                      Get.back();
                      productCon.getProductList(searchController.text,categoryId,subCategoryId);
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
}