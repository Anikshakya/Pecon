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