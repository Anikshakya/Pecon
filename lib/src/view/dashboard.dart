import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon_app/src/app_config/styles.dart';
import 'package:pecon_app/src/controllers/app_controller.dart';
import 'package:pecon_app/src/controllers/user_controller.dart';
import 'package:pecon_app/src/view/account/accounts.dart';
import 'package:pecon_app/src/view/home_page.dart';
import 'package:pecon_app/src/view/notification_page.dart';
import 'package:pecon_app/src/view/products_page.dart';
import 'package:pecon_app/src/view/qr_scanner.dart';

class Dashboard extends StatefulWidget {
  final int? initialIndex;
  const Dashboard({super.key, this.initialIndex});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Get Controller
  final UserController userCon = Get.put(UserController());
  final AppController  appCon  = Get.put(AppController());
  
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ProductsPage(),
    const NotificationPage(),
    const AccountPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if(mounted){
      WidgetsBinding.instance.addPostFrameCallback((_) async{
        await getData();
        setState(() {
         _selectedIndex = widget.initialIndex ?? 0;
        });
        appCon.sendAppUpdate();
      });
    }
  }

  @override
  dispose() {
    super.dispose();
    // Optional offline status
    appCon.onlineApi(0);
  }

  // Get Initial Data
  getData() async{
    appCon.showAdDialog();
    // Get Logged In User data
    await userCon.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomSheet: Obx(() =>userCon.isProfileLoading.isTrue 
        ? BottomAppBar(
          color: primary,
          shadowColor: black,
          elevation: 90,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Column(
                      children: [
                        Icon(Icons.home, color: Colors.transparent),
                        SizedBox(height: 2.0.h),
                        Text("HOME", style: poppinsSemiBold(size: 9, color: Colors.transparent,))
                      ],
                    ),
                    onPressed: null,
                  ),
                ],
              ),
              IconButton(
                icon: Column(
                  children: [
                    Icon(Icons.shopping_cart_outlined, color: Colors.transparent),
                    SizedBox(height: 2.0.h),
                    Text("PRODUCT", style: poppinsSemiBold(size: 9, color: Colors.transparent,))
                  ],
                ),
                onPressed: null,
              ),
              const SizedBox(width: 40), // Space for FAB
              IconButton(
                icon: Column(
                  children: [
                    Icon(Icons.notifications, color: Colors.transparent),
                    SizedBox(height: 2.0.h),
                    Text("NOTIFY", style: poppinsSemiBold(size: 9, color: Colors.transparent,))
                  ],
                ),
                onPressed: null,
              ),
              IconButton(
                icon: Column(
                  children: [
                    Icon(Icons.person, color: Colors.transparent),
                    SizedBox(height: 2.0.h),
                    Text("ACCOUNT", style: poppinsSemiBold(size: 9, color: Colors.transparent,))
                  ],
                ),
                onPressed: null,
              ),
            ],
          ),
        )
        : (userCon.user.value.data.user.role.toLowerCase() == "customer" && userCon.user.value.data.user.status == 0)
          ? const SizedBox()
          : (userCon.user.value.data.user.role.toLowerCase() == "technician" && userCon.user.value.data.user.status == 0)
            ? const SizedBox()
            : BottomAppBar(
              color: primary,
              shadowColor: black,
              elevation: 90,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Column(
                          children: [
                            Icon(Icons.home, color: _selectedIndex == 0 ? black : black.withValues(alpha:0.5)),
                            SizedBox(height: 2.0.h),
                            Text("HOME", style: poppinsSemiBold(size: 9, color: _selectedIndex == 0 ? black : black.withValues(alpha:0.5)),)
                          ],
                        ),
                        onPressed: () => _onItemTapped(0),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Column(
                      children: [
                        Icon(Icons.shopping_cart_outlined, color: _selectedIndex == 1 ? black : black.withValues(alpha:0.5)),
                        SizedBox(height: 2.0.h),
                        Text("PRODUCT", style: poppinsSemiBold(size: 9, color: _selectedIndex == 1 ? black : black.withValues(alpha:0.5)),)
                      ],
                    ),
                    onPressed: () => _onItemTapped(1),
                  ),
                  const SizedBox(width: 40), // Space for FAB
                  IconButton(
                    icon: Column(
                      children: [
                        Icon(Icons.notifications, color: _selectedIndex == 2 ? black : black.withValues(alpha:0.5)),
                        SizedBox(height: 2.0.h),
                        Text("NOTIFY", style: poppinsSemiBold(size: 9, color: _selectedIndex == 2 ? black : black.withValues(alpha:0.5)),)
                      ],
                    ),
                    onPressed: () => _onItemTapped(2),
                  ),
                  IconButton(
                    icon: Column(
                      children: [
                        Icon(Icons.person, color: _selectedIndex == 3 ? black : black.withValues(alpha:0.5)),
                        SizedBox(height: 2.0.h),
                        Text("ACCOUNT", style: poppinsSemiBold(size: 9, color: _selectedIndex == 3 ? black : black.withValues(alpha:0.5)),)
                      ],
                    ),
                    onPressed: () => _onItemTapped(3),
                  ),
                ],
              ),
            ),
      ),
      floatingActionButton: Obx(() => userCon.isProfileLoading.isTrue
        ? FloatingActionButton(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            onPressed: null,
            child: const Icon(Icons.qr_code_scanner, color: Colors.transparent,),
          )
        : Padding(
          padding: EdgeInsets.only(
            bottom: (userCon.user.value.data.user.role.toLowerCase() == "customer" && userCon.user.value.data.user.status == 0)
            ? 50.0.sp
            : (userCon.user.value.data.user.role.toLowerCase() == "technician" && userCon.user.value.data.user.status == 0)
              ? 50.0.sp
              : 0.0,
          ),
          child: FloatingActionButton(
            backgroundColor: (userCon.user.value.data.user.role.toLowerCase() == "customer" && userCon.user.value.data.user.status == 0) 
            ? maroon
            : (userCon.user.value.data.user.role.toLowerCase() == "technician" && userCon.user.value.data.user.status == 0) 
            ? maroon : black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            onPressed: () {
              Get.to(() => const QRScannerPage(), transition: Transition.cupertinoDialog);
            },
            child: const Icon(Icons.qr_code_scanner, color: white,),
          ),
        ),
      ),
      floatingActionButtonLocation: (userCon.user.value.data.user.role.toLowerCase() == "customer" && userCon.user.value.data.user.status == 0) 
        ? FloatingActionButtonLocation.endDocked
          : (userCon.user.value.data.user.role.toLowerCase() == "technician" && userCon.user.value.data.user.status == 0)
          ? FloatingActionButtonLocation.endDocked
          : FloatingActionButtonLocation.centerDocked,
    );
  }
}
