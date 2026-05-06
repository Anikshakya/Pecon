import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pecon_app/src/app_config/styles.dart';
import 'package:pecon_app/src/utils/app_utils.dart';
import 'package:pecon_app/src/widgets/custom_button.dart';
import 'package:pecon_app/src/widgets/custom_text_field.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

class ReplaceQRScannerPage extends StatefulWidget {
  const ReplaceQRScannerPage({super.key});

  @override
  State<ReplaceQRScannerPage> createState() => _ReplaceQRScannerPageState();
}

class _ReplaceQRScannerPageState extends State<ReplaceQRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool _isScanned = false; // 🔒 IMPORTANT LOCK

  @override
  void dispose() {
    // ignore: deprecated_member_use
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          qrView(),
          scannerText(),
          flash(),
          manualCodeButton(),
          backButton(),
        ],
      ),
    );
  }

  Widget manualCodeButton() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 120.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 140.w,
              height: 36.h,
              child: CustomButton(
                onPressed: () {
                  scannedCodeDialogue(
                    code: null,
                    isReadOnly: false,
                    headingText: "Manual Code Replace",
                    infoText: "Enter a code that points out to a QR.",
                  );
                },
                text: "Manual Code",
                bgColor: white,
                fontColor: black,
              ),
            ),
            SizedBox(
              width: 140.w,
              height: 36.h,
              child: CustomButton(
                onPressed: () async {
                  final scannedData = await scanFromGallery();

                  if (scannedData != null) {
                    await controller?.stopCamera();
                    Get.back(result: scannedData.toString());
                  } else {
                    await controller?.stopCamera();

                    if (!mounted) return;

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text("Cannot Scan QR Code"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ).then((_) async {
                      await Future.delayed(const Duration(milliseconds: 300));
                      await controller?.resumeCamera();
                    });
                  }
                },
                text: "Gallery",
                bgColor: white,
                fontColor: black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget qrView() {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).scaffoldBackgroundColor,
        borderWidth: 4,
        borderLength: 22,
        cutOutSize: MediaQuery.of(context).size.width * 0.7,
      ),
    );
  }

  Widget scannerText() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 160.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: 200,
          child: Text(
            'Place the QR code inside the above frame to scan.',
            style: TextStyle(fontSize: 13.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget flash() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: IconButton(
          icon: FutureBuilder(
            future: controller?.getFlashStatus(),
            builder: (context, snapshot) {
              final isOn = snapshot.data ?? false;

              return Icon(
                isOn
                    ? Icons.flashlight_on_rounded
                    : Icons.flashlight_off_rounded,
                color: Colors.white.withValues(alpha: 0.6),
                size: 30,
              );
            },
          ),
          onPressed: () async {
            await controller?.toggleFlash();
            setState(() {});
          },
        ),
      ),
    );
  }

  void onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;

    ctrl.scannedDataStream.listen((scanData) async {
      if (_isScanned) return; // 🔒 BLOCK DUPLICATES
      _isScanned = true;

      final scannedData = scanData.code?.toString() ?? "";

      log("Scanned Data: $scannedData");

      await controller?.stopCamera();

      await Future.delayed(const Duration(milliseconds: 200));

      if (Get.isOverlaysOpen) {
        Get.back(result: scannedData);
      } else {
        Get.back(result: scannedData);
      }
    });
  }

  Widget backButton() {
    return Positioned(
      top: 45,
      left: 10,
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () async {
          await controller?.stopCamera();
          Get.back();
        },
      ),
    );
  }

  Future<String?> scanFromGallery() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    final croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        IOSUiSettings(minimumAspectRatio: 1.0),
      ],
    );

    if (croppedImage == null) return null;

    try {
      return await QrCodeToolsPlugin.decodeFrom(croppedImage.path);
    } catch (_) {
      return null;
    }
  }

  void scannedCodeDialogue({
    code,
    isReadOnly,
    headingText,
    infoText,
  }) {
    final TextEditingController codeCon = TextEditingController();

    Get.defaultDialog(
      backgroundColor: boxCol,
      title: '',
      barrierDismissible: false,
      content: StatefulBuilder(
        builder: (context, setState) {
          if (isReadOnly == true) {
            codeCon.text = code.toString();
          }

          return SizedBox(
            height: 230.h,
            width: 342.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headingText ?? "",
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  infoText ?? "",
                  style: TextStyle(fontSize: 13.sp, color: black),
                ),
                SizedBox(height: 10.h),
                CustomTextFormField(
                  controller: codeCon,
                  readOnly: isReadOnly ?? false,
                  headingText: "Enter Code",
                  inputFormatters: [ToUpperCaseTextFormatter()],
                ),
                SizedBox(height: 10.h),
                CustomButton(
                  onPressed: () {
                    Get.back();
                    Get.back(result: codeCon.text);
                  },
                  text: "Replace",
                  bgColor: black,
                  fontColor: white,
                ),
                SizedBox(height: 10.h),
                CustomButton(
                  onPressed: () => Get.back(),
                  text: "Cancel",
                  bgColor: Colors.transparent,
                  fontColor: black,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}