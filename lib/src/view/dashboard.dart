import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/app_controller.dart';
import 'package:pecon/src/controllers/user_controller.dart';
import 'package:pecon/src/view/account/accounts.dart';
import 'package:pecon/src/view/home_page.dart';
import 'package:pecon/src/view/products_page.dart';
import 'package:pecon/src/view/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

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
    const NotificationsPage(),
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
      });
    }
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
      bottomNavigationBar: BottomAppBar(
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
                      Icon(Icons.home, color: _selectedIndex == 0 ? black : black.withOpacity(0.5)),
                      SizedBox(height: 2.0.h),
                      Text("HOME", style: poppinsSemiBold(size: 9, color: _selectedIndex == 0 ? black : black.withOpacity(0.5)),)
                    ],
                  ),
                  onPressed: () => _onItemTapped(0),
                ),
              ],
            ),
            IconButton(
              icon: Column(
                children: [
                  Icon(Icons.shopping_cart_outlined, color: _selectedIndex == 1 ? black : black.withOpacity(0.5)),
                  SizedBox(height: 2.0.h),
                  Text("PRODUCT", style: poppinsSemiBold(size: 9, color: _selectedIndex == 1 ? black : black.withOpacity(0.5)),)
                ],
              ),
              onPressed: () => _onItemTapped(1),
            ),
            const SizedBox(width: 40), // Space for FAB
            IconButton(
              icon: Column(
                children: [
                  Icon(Icons.notifications, color: _selectedIndex == 2 ? black : black.withOpacity(0.5)),
                  SizedBox(height: 2.0.h),
                  Text("NOTIFY", style: poppinsSemiBold(size: 9, color: _selectedIndex == 2 ? black : black.withOpacity(0.5)),)
                ],
              ),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Column(
                children: [
                  Icon(Icons.person, color: _selectedIndex == 3 ? black : black.withOpacity(0.5)),
                  SizedBox(height: 2.0.h),
                  Text("ACCOUNT", style: poppinsSemiBold(size: 9, color: _selectedIndex == 3 ? black : black.withOpacity(0.5)),)
                ],
              ),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        onPressed: () {
          Get.to(() => const QRScannerPage(), transition: Transition.cupertinoDialog);
        },
        child: const Icon(Icons.qr_code_scanner, color: white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Search Page'));
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Notifications Page'));
  }
}