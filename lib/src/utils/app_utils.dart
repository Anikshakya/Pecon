import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  Future openLinkWithUrl(link) async {
    if (!await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $link');
    } else {
      return true;
    }
  }
}

class ToUpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String upperText = newValue.text.toUpperCase();
    return newValue.copyWith(
      text: upperText,
      selection: newValue.selection,
    );
  }
}