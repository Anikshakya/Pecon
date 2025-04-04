import 'dart:developer';
import 'package:pecon/src/app_config/styles.dart';
import 'package:pecon/src/controllers/product_controller.dart';
import 'package:pecon/src/utils/app_utils.dart';
import 'package:pecon/src/widgets/custom_button.dart';
import 'package:pecon/src/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';

class ReturnQRScannerPage extends StatefulWidget {
  const ReturnQRScannerPage({super.key});

  @override
  State<ReturnQRScannerPage> createState() => _ReturnQRScannerPageState();
}

class _ReturnQRScannerPageState extends State<ReturnQRScannerPage> {
  // Get Controllers
   final ProductsController productCon = Get.put(ProductsController());
   
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    // Dispose of the QR controller when the widget is disposed
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // QR Code Scanner View
          qrView(),
          // Instructions for the user to place QR code in the frame
          scannerText(),
          // Flashlight toggle button
          flash(),
          // Manual code entry and gallery scan options
          manualCodeButton(),
          // Back button to navigate back to previous screen
          backButton(context),
        ],
      ),
    );
  }

  // Button for manual code entry and selecting QR code from gallery
  Widget manualCodeButton() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 120.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Manual Code Entry Button
            SizedBox(
              width: 140.w,
              height: 36.h,
              child: CustomButton(
                onPressed: () async{
                  Get.back();
                  // Open dialog to enter QR code manually
                  scannedCodeDialogue(
                    code: null, 
                    isReadOnly: false,
                    headingText: "Manual Code Return",
                    infoText: "Enter a code that points out to a QR.",
                  );
                },
                text: "Manual Code",
                bgColor: white,
                fontColor: black,
              ),
            ),
            // Select QR code from Gallery Button
            SizedBox(
              width: 140.w,
              height: 36.h,
              child: CustomButton(
                onPressed: () async {
                  // Scan QR code from selected image in gallery
                  var scannedData = await scanFromGallery();
                  if (scannedData != null) {
                    // Show scanned data in a popup
                    Get.back();
                    scannedCodeDialogue(
                      code: scannedData,
                      isReadOnly: true,
                      headingText: "Return Product",
                      infoText: "You can Return Product by submitting.",
                    );
                    Future.delayed(const Duration(milliseconds: 300), () {
                      controller!.resumeCamera();
                    });
                  } else {
                    // Show error message if no QR code is found
                    controller!.stopCamera();  // Stop the camera after scanning
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text("Cannot Scan QR Code"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ).then((_) {
                      // Resume camera after the dialog is dismissed
                      Future.delayed(const Duration(milliseconds: 300), () {
                        controller!.resumeCamera();
                      });
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
  // QR Code scanner view
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

  // Instructions for the user to scan the QR code inside the frame
  Widget scannerText() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 160.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: 200,
          child: Text(
            'Place the QR code inside the above frame to scan.',
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Flashlight toggle button
  Widget flash() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: IconButton(
          icon: FutureBuilder(
            future: controller?.getFlashStatus(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Icon(
                  snapshot.data!
                      ? Icons.flashlight_on_rounded
                      : Icons.flashlight_off_rounded,
                  color: Colors.white.withOpacity(0.6),
                  size: 30,
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          onPressed: () async {
            // Toggle the flashlight on or off
            await controller?.toggleFlash();
            setState(() {});
          },
        ),
      ),
    );
  }

  // QR Code scanned callback
  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    // Listen to scanned data and show it in a dialog
    controller.scannedDataStream.listen((scanData) {
      controller.stopCamera();  // Stop the camera after scanning
      String scannedData = scanData.code.toString();
      log('Scanned Data: $scannedData');
      // Show scanned data in a popup
      Get.back();
      scannedCodeDialogue(
        code: scannedData,
        isReadOnly: true,
        headingText: "Redeeme Points",
        infoText: "You can redeeme points by submitting."
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        controller.resumeCamera();
      });
    });
  }

  // Back button to navigate to the previous screen
  Widget backButton(BuildContext context) {
    return Positioned(
      top: 45,
      left: 10,
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  // Show manual code entry dialog
  void scannedCodeDialogue({code, isReadOnly, headingText, infoText}) {
    final TextEditingController codeCon = TextEditingController();
    final TextEditingController remarksCon= TextEditingController();

    Get.defaultDialog(
      backgroundColor: boxCol,
      title: '',
      barrierDismissible: false,
      titlePadding: EdgeInsets.symmetric(horizontal: 20.0.w),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0.w),
      content: StatefulBuilder(
        builder: (context, setState) {
          if(isReadOnly == true){
            codeCon.text = code.toString();
          }
          return SizedBox(
            height: 280.h,
            width: 342.w,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    headingText ?? "",
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Instruction Text
                  Text(
                    infoText ?? "",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Manual Code Input Field
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CustomTextFormField(
                      controller: codeCon,
                      readOnly: isReadOnly ?? false,
                      headingText: "Ënter Code",
                      inputFormatters: [
                        ToUpperCaseTextFormatter(),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Remarks
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CustomTextFormField(
                      controller: remarksCon,
                      readOnly: false,
                      headingText: "Ënter Your Remarks",
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Submit Button
                  Obx(()=>
                    CustomButton(
                      isLoading: productCon.isProductReturnLoading.isTrue,
                      onPressed: () async{
                        await productCon.returnProduct(
                          previousCode: codeCon.text.trim(),
                          remarks: remarksCon.text.trim(),
                        );
                      },
                      text: "Return",
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
  }

  // Scan image from gallery and crop it
  Future<String?> scanFromGallery() async {
    // Pick an image from the gallery
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;

     // Crop the picked image
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
      // aspectRatioPresets: [
      //   CropAspectRatioPreset.square,
      //   CropAspectRatioPreset.ratio3x2,
      //   CropAspectRatioPreset.ratio4x3,
      //   CropAspectRatioPreset.ratio16x9,
      // ],
    );

    // Check if the image was cropped successfully
    if (croppedImage == null) return null;

    // Convert the CroppedFile to XFile
    XFile croppedXFile = XFile(croppedImage.path);

    // Decode the QR code from the cropped image
    try {
      var qrCodeData = await Scan.parse(croppedXFile.path);
      return qrCodeData;
    } catch (e) {
      return null;  // Return null if no QR code is detected
    }
  }
}