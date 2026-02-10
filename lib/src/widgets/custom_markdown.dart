import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:pecon_app/src/app_config/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomMarkdownWidget extends StatelessWidget {
  final String data;
  final Widget Function(Uri uri, String? title, String? alt) imageBuilder;

  const CustomMarkdownWidget({
    super.key,
    required this.data,
    required this.imageBuilder,
  });

  /// Pre-process HTML to remove empty tags that crash flutter_markdown
  String _sanitizeHtml(String html) {
    var sanitized = html;

    // Remove empty paragraph tags or paragraphs with only &nbsp;
    sanitized = sanitized.replaceAll(
      RegExp(r'<p>(&nbsp;|\s)*</p>', multiLine: true),
      '',
    );

    // Remove empty <em> or <strong>
    sanitized = sanitized.replaceAll(
      RegExp(r'<(em|strong)>\s*</\1>', multiLine: true),
      '',
    );

    // Remove empty <div> or <span>
    sanitized = sanitized.replaceAll(
      RegExp(r'<(div|span)>\s*</\1>', multiLine: true),
      '',
    );

    // Remove empty tables or table cells with only &nbsp;
    sanitized = sanitized.replaceAll(
      RegExp(r'<table>[\s\S]*?<td>(&nbsp;|\s)*</td>[\s\S]*?</table>', multiLine: true),
      '',
    );

    // Remove empty <figure> tags
    sanitized = sanitized.replaceAll(
      RegExp(r'<figure[^>]*>\s*</figure>', multiLine: true),
      '',
    );

    // Normalize <br> tags
    sanitized = sanitized.replaceAll('<br>', '\n');

    return sanitized.trim();
  }

  /// Pre-process Markdown to prevent empty inline nodes
  String _sanitizeMarkdown(String markdown) {
    var sanitized = markdown;

    // Remove lines with only spaces or blank
    sanitized = sanitized.replaceAll(RegExp(r'^\s+$', multiLine: true), '');

    // Collapse multiple blank lines
    sanitized = sanitized.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    // If everything is empty, insert a space to avoid flutter_markdown crash
    if (sanitized.isEmpty) sanitized = ' ';

    return sanitized;
  }

  @override
  Widget build(BuildContext context) {
    // Safety guard
    if (data.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final sanitizedHtml = _sanitizeHtml(data);
    final markdownData = _sanitizeMarkdown(html2md.convert(sanitizedHtml));

    return Markdown(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      selectable: true,
      softLineBreak: false, // prevents inline crashes
      physics: const NeverScrollableScrollPhysics(),
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrlString(href, mode: LaunchMode.externalApplication);
        }
      },
      styleSheet: MarkdownStyleSheet(
        blockSpacing: 14,
        horizontalRuleDecoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: gray, width: 1.3),
          ),
        ),
        h1: poppinsMedium(size: 22.sp, color: black),
        h2: poppinsMedium(size: 20.sp, color: black),
        h3: poppinsMedium(size: 18.sp, color: black),
        h4: poppinsMedium(size: 16.sp, color: black),
        h5: poppinsMedium(size: 14.sp, color: black),
        h6: poppinsMedium(size: 12.sp, color: black),
        p: poppinsMedium(size: 14.sp, color: black.withValues(alpha: 0.6)),
        strong: poppinsBold(size: 14.sp, color: black),
        blockquote: poppinsBold(size: 16.sp, color: black),
        blockquoteDecoration: const BoxDecoration(color: grey3),
      ),
      data: markdownData,
      // ignore: deprecated_member_use
      imageBuilder: imageBuilder,
    );
  }
}
