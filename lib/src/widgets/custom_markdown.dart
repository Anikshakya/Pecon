import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomMarkdownWidget extends StatelessWidget {
  final String data;
  final Widget Function(Uri uri, String? title, String? alt) imageBuilder;

  const CustomMarkdownWidget({super.key, 
    required this.data,
    required this.imageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Markdown(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      selectable: true,
      softLineBreak: true, //Line break
      onTapLink: (text, href, title) => href != null ? launchUrlString(href,mode: LaunchMode.externalApplication) : null,
      physics: const NeverScrollableScrollPhysics(),
      styleSheet: MarkdownStyleSheet(
        horizontalRuleDecoration: const BoxDecoration(
          border: Border(
            top: BorderSide(// Set the color of the horizontal rule
              color: gray,
              width: 1.3, // Set the desired thickness of the horizontal rule
            ),
          ),
        ),
        blockSpacing: 14,
        // em: const TextStyle(
        //   fontStyle: FontStyle.italic,
        //   color: Colors.transparent, // em use here
        // ),
        // Define different styles for each heading level
        // h1: h1(black),
        // h2: h2(black),
        // h3: h3(black),
        // h4: h4(black),
        // h5: h5(black),
        h6: null,
        p: poppinsMedium(size: 12.sp, color: gray),
        listBullet: null, //Bullet Color
        listIndent: null, //Bullet Spacing
        strong: poppinsBold(size: 12.sp, color: black), //Bullet Heading
        blockquote:poppinsBold(size: 14.sp, color: black),
        blockquoteDecoration: const BoxDecoration(color: grey3),
      ),
      data: data.toString().replaceAll('<br>', '\u2028').replaceAll('![image](![file]', ''),
      imageBuilder: imageBuilder,
    );
  }
}
