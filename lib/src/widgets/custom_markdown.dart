import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pecon/src/app_config/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:html2md/html2md.dart' as html2md;

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
        h1: poppinsMedium(size: 22.sp, color: black),
        h2: poppinsMedium(size: 20.sp, color: black),
        h3: poppinsMedium(size: 18.sp, color: black),
        h4: poppinsMedium(size: 16.sp, color: black),
        h5: poppinsMedium(size: 14.sp, color: black),
        h6: poppinsMedium(size: 12.sp, color: black),
        p: poppinsMedium(size: 14.sp, color: black),
        listBullet: null, //Bullet Color
        listIndent: null, //Bullet Spacing
        strong: poppinsBold(size: 14.sp, color: black), //Bullet Heading
        blockquote:poppinsBold(size: 16.sp, color: black),
        blockquoteDecoration: const BoxDecoration(color: grey3),
      ),
      data: html2md.convert(data),
      imageBuilder: imageBuilder,
    );
  }
}
