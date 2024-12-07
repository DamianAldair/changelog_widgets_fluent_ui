import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'shared.dart';

/// Changelog view FluentUI-based.
class ChangelogView extends StatelessWidget {
  /// Markdown file path.
  ///
  /// Default: "CHANGELOG.md".
  final String? changelogPath;

  /// The title of the dialog is displayed in a large font.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// The app bar of the page.
  final NavigationAppBar? appBar;

  /// The header of this page. Usually a [PageHeader] is used.
  final Widget? scaffoldHeader;

  /// Builder that exposes the [Markdown] to be renderer.
  ///
  /// If the builder is `null`, the [Markdown] will be built directly.
  ///
  /// Note: [Markdown] inherits from [Markdown].
  final Widget Function(BuildContext context, Widget markdown)? bodyBuilder;

  /// ChangelogView constructor
  const ChangelogView({
    super.key,
    this.changelogPath,
    this.bodyBuilder,
    this.title,
    this.appBar,
    this.scaffoldHeader,
  });

  @override
  Widget build(BuildContext context) {
    final path = changelogPath ?? defaultChangelogPath;

    return NavigationView(
      appBar: appBar,
      content: ScaffoldPage(
        header: scaffoldHeader ??
            PageHeader(
              leading: const _BackButton(),
              title: title ?? const Text(widgetTitle),
            ),
        content: FutureBuilder(
          future: rootBundle.loadString(path),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: ProgressRing());
            }

            if (snapshot.hasError) {
              return Center(child: Text(getDefaultErrorMessage(path)));
            }

            final scrollController = ScrollController();
            final markdown = Markdown(
              controller: scrollController,
              data: snapshot.data!,
            );
            return Scrollbar(
              controller: scrollController,
              child: bodyBuilder?.call(context, markdown) ?? markdown,
            );
          },
        ),
      ),
    );
  }
}

/// Back button for Scaffold Page Header.
class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Tooltip(
        message: FluentLocalizations.of(context).backButtonTooltip,
        child: IconButton(
          icon: const Icon(FluentIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
