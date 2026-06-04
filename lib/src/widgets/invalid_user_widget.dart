import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pecon_app/src/controllers/app_controller.dart';

Widget verificationWarningContainer({
  required VoidCallback onRefresh,
  BuildContext? context,
}) {
  AppController appCon = Get.find<AppController>();
  return Container(
    padding: const EdgeInsets.all(20.0),
    margin: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.0),
      border: Border.all(color: Colors.red.shade100),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Warning Shield Icon
        Icon(
          Icons.shield_outlined, 
          color: Colors.red.shade500, 
          size: 48
        ),
        const SizedBox(height: 16),
        
        // English Text
        Text(
          "QR scan only. Your account is not verified yet. After verification, you can access all app features.\nContact this number for account verification: ${appCon.phoneLink}",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black87, 
            fontSize: 14, 
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        // Subtle Divider
        Padding(
          padding: EdgeInsets.symmetric(vertical: 14.0),
          child: Divider(color: Colors.black12, height: 1),
        ),
        
        // Nepali Text
        Text(
          "QR स्क्यान मात्र अनुमति छ। तपाईंको खाता अझै प्रमाणित भएको छैन। प्रमाणित भएपछि एपका सबै सुविधा प्रयोग गर्न सक्नुहुन्छ।\nप्रमाणिकरणका लागि यस नम्बरमा सम्पर्क गर्नुहोस्: ${appCon.phoneLink}",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black87, 
            fontSize: 14, 
            height: 1.4,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Dynamic Refresh Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onRefresh, // Dynamic action happens here
            icon: const Icon(Icons.refresh),
            label: const Text(
              "Check Status / रिफ्रेस गर्नुहोस्",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A1A), // Sleek off-black
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    ),
  );
}