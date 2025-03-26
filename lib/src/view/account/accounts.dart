import 'package:intl/intl.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/auth_controller.dart';
import 'package:pecon/src/controllers/user_controller.dart';
import 'package:pecon/src/view/account/change_password.dart';
import 'package:pecon/src/view/account/download_catalogue.dart';
import 'package:pecon/src/view/account/earning_history_page.dart';
import 'package:pecon/src/view/account/offer_promotion.dart';
import 'package:pecon/src/view/account/privacy_policy.dart';
import 'package:pecon/src/view/account/profile_form_page.dart';
import 'package:pecon/src/view/account/replace_product/replace_product.dart';
import 'package:pecon/src/view/account/return_product/return_qr_scanner.dart';
import 'package:pecon/src/view/account/terms_condition.dart';
import 'package:pecon/src/view/account/withdrawal_request.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // Get Controllers
  final UserController userCon = Get.put(UserController());
  final AuthController authCon = Get.put(AuthController());
  // Formate Number to US standard
  final NumberFormat formatter = NumberFormat("#,##0", "en_US");
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          bottom: false,
          child: Obx(()=>
            Column(
              children: [
                // Profile Header
                SizedBox(height: 10.0.h,),
                userInfo(),
                SizedBox(height: 20.h),
                
                // Action Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(Icons.favorite, 'My Benefits', maroon, (){}),
                      _buildActionButton(Icons.notifications, 'Notifications', Colors.orange, (){}),
                      _buildActionButton(Icons.arrow_forward, 'Profile', green, (){Get.to(() => const ProfileFormPage());}),
                    ],
                  ),
                ),
                
                
                // Account Options List
                Padding(
                  padding: EdgeInsets.all(16.0.sp),
                  child: Column(
                    children: [
                      _buildListTile('My Earnings', Icons.account_balance_wallet,
                        onTap: (){
                          Get.to(()=> const EarningHistoryPage());
                        }
                      ),
                      Visibility(
                        visible :  userCon.user.value.data.role.toLowerCase() == "shopkeeper",
                        child: Column(
                          children: [
                            _buildListTile('Product Return', Icons.arrow_back,
                              onTap: (){
                                Get.to(()=> const ReturnQRScannerPage());
                              }
                            ),
                            _buildListTile('Warranty Replacement', Icons.swap_horiz,
                              onTap: (){
                                Get.to(()=> const ReplaceProductPage());
                              }
                            ),
                          ],
                        ),
                      ),
                      _buildListTile(
                        'Withdrawal Requests',
                        Icons.request_page,
                        onTap: (){
                          Get.to(()=> const WithdrawalRequestPage());
                        }
                      ),
                      _buildListTile('Download Catalog', Icons.download,
                        onTap: (){
                          Get.to(()=> const CataloguePage());
                        }
                      ),
                      _buildListTile('Change Password', Icons.visibility_off,
                        onTap: (){
                          Get.to(()=> const ChangePasswordPage());
                        }
                      ),
                      _buildListTile('Offers And Promotions', Icons.local_offer,
                        onTap: (){
                          Get.to(()=> const OfferPage());
                        }
                      ),
                      _buildListTile('Privacy Policy', Icons.lock,
                        onTap: (){
                          Get.to(()=> PrivacyPolicy());
                        }
                      ),
                      _buildListTile('Terms And Conditions', Icons.description,
                        onTap: (){
                          Get.to(()=> TermsAndConditions());
                        }
                      ),
                      _buildListTile(
                        onTap: () async{
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
                                          "Do you want To Logout?",
                                          style: poppinsSemiBold(size: 16.sp, color: black)
                                        ),
                                        
                                        SizedBox(height: 24.h),
                                        // Submit Button
                                        Obx(()=>
                                          CustomButton(
                                            isLoading: authCon.isLogOutLoading.isTrue,
                                            onPressed: () async{
                                              await authCon.logout();
                                            },
                                            text: "Logout",
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
                        },
                        'Log Out', Icons.exit_to_app, 
                        isDestructive: true
                      ),
                      _buildListTile('Delete Account', Icons.delete, isDestructive: true),
                    ],
                  ),
                ),
            
                SizedBox(height: 30.h),
              ],
            ),
          ),
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
                            imageUrl: userCon.user.value.data.profileUrl.toString(),
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
                            Text(userCon.user.value.data.name.toString(), style: poppinsBold(size: 14.sp, color: black),overflow: TextOverflow.ellipsis, maxLines: 2,),
                            SizedBox(height: 2.h),
                            Text("Membership ID: ${userCon.user.value.data.id}", style: poppinsSemiBold(size: 9.sp, color: black.withOpacity(0.7)), maxLines: 2,),
                            Text(
                              userCon.user.value.data.number.toString(),
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
                                          text: formatter.format(int.parse("${userCon.user.value.data.redeemed}")),
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

  Widget _buildActionButton(IconData icon, String label, Color color, onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            radius: 24,
            child: Icon(icon, color: color, size: 24),
          ),
        ),
        SizedBox(height: 8.h),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildListTile(String title, IconData icon, {bool isDestructive = false, onTap}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black,
          fontWeight: isDestructive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
      onTap: onTap,
    );
  }
}
