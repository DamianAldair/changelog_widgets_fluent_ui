import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'shared.dart';

/// Customizable content for changelog.
class ChangelogContent extends StatelessWidget {
  /// Markdown file path.
  ///
  /// Default: "CHANGELOG.md".
  final String? changelogPath;

  /// Widget to be built when the file is loading.
  final Widget Function(BuildContext context) onLoading;

  /// Widget to be built when the file load fails.
  final Widget Function(BuildContext context) onError;

  /// Builder that exposes the [Markdown] to be renderer.
  ///
  /// Note: [Markdown] inherits from [Markdown].
  final Widget Function(BuildContext context, Widget markdown) bodyBuilder;

  /// Content constructor.
  const ChangelogContent({
    super.key,
    this.changelogPath,
    required this.onLoading,
    required this.onError,
    required this.bodyBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final path = changelogPath ?? defaultChangelogPath;

    return FutureBuilder(
      future: rootBundle.loadString(path),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return onLoading.call(context);
        }

        if (snapshot.hasError) {
          return onError.call(context);
        }

        final scrollController = ScrollController();
        final markdown = Markdown(
          controller: scrollController,
          data: snapshot.data!,
        );
        return Scrollbar(
          controller: scrollController,
          child: bodyBuilder.call(context, markdown),
        );
      },
    );
  }
}
