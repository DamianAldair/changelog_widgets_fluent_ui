import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'shared.dart';

/// Where and how the pop button should be placed.
enum ChangelogDialogPopButtonType {
  /// As a Close Button at the right top corner of dialog.
  closeButton,

  /// As an action at the bottom of dialog.
  okButton,

  /// Custom.
  custom,
}

/// Changelog dialog FluentUI-based.
class ChangelogDialog extends StatelessWidget {
  /// Markdown file path.
  ///
  /// Default: "CHANGELOG.md".
  final String? changelogPath;

  /// Where and how the pop button should be placed.
  final ChangelogDialogPopButtonType popButtonType;

  /// The title of the dialog is displayed in a large font.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// Custom close button.
  final Widget? closeButton;

  /// Builder that exposes the [Markdown] to be renderer.
  ///
  /// If the builder is `null`, the [Markdown] will be built directly.
  ///
  /// Note: [Markdown] inherits from [Markdown].
  final Widget Function(BuildContext context, Widget markdown)? bodyBuilder;

  /// Custom ok button.
  final Widget? okButton;

  /// The actions of the dialog. Usually, a List of [Button]s.
  final List<Widget>? actions;

  /// ChangelogDialog constructor.
  const ChangelogDialog({
    super.key,
    this.changelogPath,
    this.popButtonType = ChangelogDialogPopButtonType.closeButton,
    this.title,
    this.closeButton,
    this.bodyBuilder,
    this.okButton,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final path = changelogPath ?? defaultChangelogPath;
    final loc = FluentLocalizations.of(context);

    Widget? closeWidget;
    List<Widget>? actionWidgets;

    if (popButtonType == ChangelogDialogPopButtonType.custom) {
      closeWidget = closeButton;
      if (actions != null && actions!.isNotEmpty) {
        actionWidgets = actions;
      }
    }

    if (popButtonType == ChangelogDialogPopButtonType.okButton) {
      actionWidgets = [];
      actionWidgets.add(
        FilledButton(
          child: Text(loc.closeButtonLabel),
          onPressed: () => Navigator.pop(context),
        ),
      );
    }

    if (popButtonType == ChangelogDialogPopButtonType.closeButton) {
      closeWidget = Tooltip(
        message: loc.closeWindowTooltip,
        child: IconButton(
          icon: const Icon(FluentIcons.chrome_close),
          onPressed: () => Navigator.pop(context),
        ),
      );
    }

    return ContentDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          title ?? const Text(widgetTitle),
          if (closeWidget != null) closeWidget,
        ],
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
      actions: actionWidgets,
    );
  }
}
