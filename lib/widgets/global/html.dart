import 'dart:io';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart' as htmlparser;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HTMLDisplay extends StatelessWidget {
  const HTMLDisplay({
    super.key,
    required this.html,
    this.margin = 0,
    this.marginOnParagraphTag = false,
    this.align = TextAlign.start,
  });

  final String html;
  final double margin;
  final bool marginOnParagraphTag;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    Document doc = htmlparser.parse(
      (marginOnParagraphTag ? html.replaceAll("<p></p>", "<br/><br/>") : html)
          .replaceAll(RegExp(r'\s*style=([\"])(.*?)\1'), "")
          .replaceAll(
              RegExp(
                r"<(\w+)(?:\s+[^>]*?)?>(?:\s*|<[^>]*>)<\/\1>",
                caseSensitive: false,
                multiLine: true,
              ),
              "")
          .replaceAll("<p><br></p>", ""),
    );

    return SelectionArea(
      child: Html.fromDom(
        document: doc,
        onLinkTap: (url, attributes, element) =>
            launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication),
        style: {
          "*": Style(margin: Margins.zero, textAlign: align),
          "body": Style(margin: Margins.all(margin)),
          "p": Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
            lineHeight: LineHeight.em(1.27),
            whiteSpace: WhiteSpace.pre,
            before: "",
          ),
          "font[size='1']": Style(fontSize: FontSize.small),
          "font[size='2']": Style(fontSize: FontSize.medium),
          "font[size='3']":
              Style(fontSize: FontSize.medium), // This is done on purpuse
          "font[size='4']": Style(fontSize: FontSize.large),
          "font[size='5']": Style(fontSize: FontSize.xLarge),
          "font[size='6']": Style(fontSize: FontSize.xxLarge),
          "font[size='7']": Style(fontSize: FontSize.xxLarge),
          "h1 h2 h3 h4 h5": Style(
            margin: Margins.only(bottom: 0.5, unit: Unit.rem),
          ),
          "blockquote": Style(
            fontStyle: FontStyle.italic,
            border: Border(
              left: BorderSide(
                width: 3,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            margin: Margins.only(
              top: 1,
              left: 2,
              bottom: 1,
              unit: Unit.rem,
            ),
            padding: HtmlPaddings.only(left: 0.6875, unit: Unit.rem),
          ),
          "h1": Style(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w400,
            fontSize: FontSize(1.3125, Unit.rem),
          ),
          "h2": Style(
            fontWeight: FontWeight.w400,
            fontSize: FontSize(1, Unit.rem),
          ),
          "h3": Style(
            fontWeight: FontWeight.w700,
            fontSize: FontSize(0.875, Unit.rem),
          ),
          "h4": Style(
            fontWeight: FontWeight.w700,
            fontSize: FontSize(0.75, Unit.rem),
          ),
          "h5": Style(
            fontWeight: FontWeight.w700,
            fontSize: FontSize(0.625, Unit.rem),
          ),
          "hr": Style(color: Theme.of(context).colorScheme.outline)
        },
        extensions: [
          ImageExtension(
            builder: (extContext) {
              // final element = extContext.styledElement as ImageElement;
              return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    gaplessPlayback: true,
                    extContext.element!.attributes["src"]!,
                    // width: element.width?.toDouble(),
                    // height: element.height?.toDouble(),
                  ));
            },
          ),
          if (Platform.isAndroid || Platform.isIOS)
            IframeHtmlExtension(
              navigationDelegate: NavigationDelegate(
                onNavigationRequest: (request) => NavigationDecision.navigate,
              ),
            ),
          if (!(Platform.isAndroid || Platform.isIOS))
            TagExtension(
              tagsToExtend: {"iframe"},
              builder: (ext) => FilledButton.icon(
                onPressed: () => ext.attributes["src"] != null
                    ? launchUrl(Uri.parse(ext.attributes["src"]!),
                        mode: LaunchMode.externalApplication)
                    : null,
                icon: const Icon(Icons.open_in_browser),
                label: const Text("Open website"),
              ),
            )
        ],
      ),
    );
  }
}

/// The custom theme that tries to mimic Magisters weird design choices whilst keeping close to Material 3
FleatherThemeData customFleatherTheme(BuildContext context) {
  final TextStyle defaultStyle = Theme.of(context).textTheme.bodyMedium!;
  return FleatherThemeData(
    bold: const TextStyle(fontWeight: FontWeight.bold),
    italic: const TextStyle(fontStyle: FontStyle.italic),
    underline: const TextStyle(decoration: TextDecoration.underline),
    strikethrough: const TextStyle(decoration: TextDecoration.lineThrough),
    inlineCode: InlineCodeThemeData(
      backgroundColor: Theme.of(context).colorScheme.outline,
      radius: const Radius.circular(3),
      style: defaultStyle,
      heading1: defaultStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w300,
      ),
      heading2: defaultStyle.copyWith(fontSize: 22),
      heading3: defaultStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
    link: TextStyle(
      color: Theme.of(context).colorScheme.primaryContainer,
      decoration: TextDecoration.underline,
    ),
    paragraph: TextBlockTheme(
      style: defaultStyle,
      spacing: const VerticalSpacing.zero(),
      // lineSpacing is not relevant for paragraphs since they consist of one line
    ),
    heading1: TextBlockTheme(
      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
      spacing: const VerticalSpacing(top: 16.0, bottom: 0.0),
    ),
    heading2: TextBlockTheme(
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)),
      spacing: const VerticalSpacing(bottom: 0.0, top: 8.0),
    ),
    heading3: TextBlockTheme(
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: defaultStyle.color?.withValues(alpha: 0.70),
          ),
      spacing: const VerticalSpacing(bottom: 0.0, top: 8.0),
    ),
    heading4: TextBlockTheme(
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: defaultStyle.color?.withValues(alpha: 0.50),
          ),
      spacing: const VerticalSpacing(bottom: 0.0, top: 8.0),
    ),
    heading5: TextBlockTheme(
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: defaultStyle.color?.withValues(alpha: 0.70),
            decoration: TextDecoration.underline,
          ),
      spacing: const VerticalSpacing(bottom: 0.0, top: 8.0),
    ),
    heading6: TextBlockTheme(
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: defaultStyle.color?.withValues(alpha: 0.50),
          fontWeight: FontWeight.w500),
      spacing: const VerticalSpacing(bottom: 0.0, top: 8.0),
    ),
    lists: TextBlockTheme(
      style: defaultStyle,
      spacing: const VerticalSpacing.zero(),
      lineSpacing: const VerticalSpacing(bottom: 0),
    ),
    quote: TextBlockTheme(
      style: TextStyle(color: defaultStyle.color?.withValues(alpha: 0.6)),
      spacing: const VerticalSpacing.zero(),
      lineSpacing: const VerticalSpacing(top: 6, bottom: 2),
      decoration: BoxDecoration(
        border: BorderDirectional(
          start: BorderSide(width: 4, color: Colors.grey.shade300),
        ),
      ),
    ),
    code: TextBlockTheme(
      style: TextStyle(
        color: Colors.blue.shade900.withValues(alpha: 0.9),
        fontSize: 13.0,
        height: 1.4,
      ),
      spacing: const VerticalSpacing.zero(),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
    horizontalRule:
        HorizontalRuleThemeData(height: 10, thickness: 1, color: Colors.black),
  );
}
