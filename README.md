# Changelog Widgets for Fluent UI

by [Damian Aldair](https://damianaldair.github.io).

---

Inspired by Flutter's **AboutDialog** and [Changelog Widgets](https://pub.dev/packages/changelog_widgets).

The easiest way to display your Fluent UI app's changelog.


## Getting Started

Add following dependency to your `pubspec.yaml`.

```yaml
dependencies:
  changelog_widgets_fluent_ui: <latest_version>
```


## Initialization

Add the markdown file to your `pubspec.yaml`, in the **flutter** section, for example:

```dart
flutter:
  assets:
    - CHANGELOG.md
```

Import the package.
```dart
import 'package:changelog_widgets/changelog_widgets_fluent_ui.dart';
```

Now, you can use the view and dialogs.

## Available widgets

- Content for be used by other widgets: `ChangelogContent`.
- Built-in Fluent UI dialog: `ChangelogDialog`.
- Built-in Fluent UI view: `ChangelogView`.