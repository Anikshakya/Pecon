import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/auth_controller.dart';
import 'package:pecon/src/controllers/user_controller.dart';
import 'package:pecon/src/view/privacy_policy.dart';
import 'package:pecon/src/view/profile_form_page.dart';
import 'package:pecon/src/view/terms_condition.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppbar(),
      body: SingleChildScrollView(
        child: SafeArea(
          bottom: false,
          child: Obx(()=>
            Column(
              children: [
                // Profile Header
                Container(
                  padding: EdgeInsets.all(20.sp),
                  decoration: const BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: userCon.isProfileLoading.isTrue 
                    ? const SizedBox()
                    : Row(
                      children: [
                        CustomNetworkImage(
                          imageUrl: userCon.user.value.data.profileUrl, 
                          height: 60.sp, 
                          width: 60.sp,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userCon.user.value.data.name.toString(),
                              style: poppinsMedium(size: 18.sp, color: black)
                            ),
                            SizedBox(height: 4.h,),
                            Text(
                              'Member ID: ${userCon.user.value.data.id}',
                              style: poppinsMedium(size: 11.sp, color: black.withOpacity(0.6))
                            ),
                            Text(
                              userCon.user.value.data.number.toString(),
                              style: poppinsMedium(size: 11.sp, color: black.withOpacity(0.6))
                            ),
                          ],
                        ),
                      ],
                    ),
                ),
                SizedBox(height: 18.h),
                
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
                
                SizedBox(height: 16.h),
                
                // Account Options List
                Padding(
                  padding: EdgeInsets.all(16.0.sp),
                  child: Column(
                    children: [
                      _buildListTile('My Earnings', Icons.account_balance_wallet),
                      _buildListTile('Warranty Replacement', Icons.swap_horiz),
                      _buildListTile('Withdrawal Requests', Icons.request_page),
                      _buildListTile('Offers And Promotions', Icons.local_offer),
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
                          await authCon.logout();
                        },
                        'Log Out', Icons.exit_to_app, 
                        isDestructive: true
                      ),
                      _buildListTile('Delete Account', Icons.delete, isDestructive: true),
                    ],
                  ),
                ),
            
                SizedBox(height: 60.h),
              ],
            ),
          ),
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
