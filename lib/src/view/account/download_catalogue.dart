import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/settings_controller.dart';
import 'package:pecon/src/widgets/custom_appbar.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pecon/src/widgets/custom_toast.dart';
import 'package:permission_handler/permission_handler.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({super.key});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  dynamic isDownload;
    //GetController
  final SettingsController settingCon = Get.put(SettingsController());
  
  @override
  void initState() {
    initialise();
    super.initState();
  }

  initialise()async{
    await settingCon.getCatalogue();
    isDownload = {
        "isDownloading" : List.generate(settingCon.catalogueList.length, (index) => false),
        "percentage" : List.generate(settingCon.catalogueList.length, (index) => 0.0),
      };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: appbar(title:'Download Catalogue'),
      body: Obx(() => settingCon.isCatalogLoading.value 
        ? SizedBox(
          height: 650.0.h,
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
        : ListView.builder(
          itemCount: settingCon.catalogueList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(settingCon.catalogueList[index]['name']), 
              subtitle: Text(settingCon.catalogueList[index]['url']),
              trailing:  ElevatedButton(
                onPressed: isDownload["isDownloading"][index] == true 
                  ? (){} 
                  : (){
                    downloadFile(
                      settingCon.catalogueList[index]['url'],  // Replace with actual file URL
                      settingCon.catalogueList[index]['name'],
                      context,
                      index
                    );
                  },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 15)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isDownload["isDownloading"][index]) // Show progress if downloading
                      Text(
                        "${(isDownload["percentage"][index] * 100).toStringAsFixed(0)}%", // Display percentage
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    if (isDownload["isDownloading"][index]) const SizedBox(width: 8), // Spacing between text & icon
                    Icon(isDownload["isDownloading"][index] ? Icons.downloading : Icons.download),
                  ],
                ),
              ),
            );
          },
        )
      ),
    );
  }

  Future<void> downloadFile(String url, String fileName, BuildContext context, int index) async {
    try {
      setState(() {
        isDownload["isDownloading"][index] = true;
        isDownload["percentage"][index] = 0.0;
      });

      // Request storage permission (only for Android)
      if (Platform.isAndroid) {
        PermissionStatus status = await Permission.storage.request();
        if (!status.isGranted) {
          showToast(message: "Storage permission denied");
          setState(() {
            isDownload["isDownloading"][index] = false;
          });
          return;
        }
      }

      // Get the appropriate directory for saving the file
      Directory directory = await _getSaveDirectory();

      // Ensure the directory exists
      if (!await directory.exists()) {
        await directory.create(recursive: true);
        debugPrint("Directory created: ${directory.path}");
      }

      String filePath = "${directory.path}/$fileName";

      // Download file with progress update
      await Dio().download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              isDownload["percentage"][index] = received / total;
            });
          }
        },
      );

      showToast(message: "Downloaded to $filePath");
    } catch (e) {
      showToast(message: "Download failed: $e");
    } finally {
      setState(() {
        isDownload["isDownloading"][index] = false;
      });
    }
  }

    /// Gets the appropriate directory for saving files based on the platform.
  Future<Directory> _getSaveDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      // For iOS, save to the application's documents directory
      return await getApplicationDocumentsDirectory();
    }
    // Throw an error for unsupported platforms
    throw UnsupportedError("Unsupported platform");
  }
}