# Examples

## Material example

```dart

import 'package:changelog_widgets_fluent_ui/changelog_widgets_fluent_ui.dart';
import 'package:fluent_ui/fluent_ui.dart';

void main() {
  runApp(const MyFluentApp());
}


class MyFluentApp extends StatelessWidget {

  const MyFluentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluent UI App',
      home: const FluentView(),
    );
  }
}

class FluentView extends StatelessWidget {
  const FluentView({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: ScaffoldPage(
        header: scaffoldHeader ??
            PageHeader(
              leading: const _BackButton(),
              title: title ?? const Text(widgetTitle),
            ),
        content: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Button(
                child: const Text(goToTheScreen),
                onPressed: () {
                  Navigator.push(
                    context,
                    FluentPageRoute(builder: (_) => const ChangelogView()),
                  );
                },
              ),
              const SizedBox.square(dimension: gap),
              Button(
                child: const Text(showTheDialog),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const ChangelogDialog(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```