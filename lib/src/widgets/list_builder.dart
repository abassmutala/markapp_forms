import 'package:flutter/material.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListBuilder<T> extends StatelessWidget {
  const ListBuilder({
    super.key,
    required this.snapshot,
    required this.itemBuilder,
    required this.separatorWidget,
    this.restorationId,
  });

  final AsyncSnapshot<List<T>?> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final Widget separatorWidget;
  final String? restorationId;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T>? items = snapshot.data;
      if (items!.isNotEmpty) {
        return buildList(items);
      } else {
        return const Center(
          child: Text("No registered users"),
        );
      }
    } else if (snapshot.hasError) {
      debugPrint(snapshot.error.toString());
      return const Center(
        child: Text(
          "An error occured. Please contact the operators",
        ),
      );
    } else if (!snapshot.hasData) {
      return const Center(
        child: Text("No registered users"),
      );
    }
    return const CircularProgressIndicator.adaptive();
  }

  ListView buildList(List<dynamic> items) {
    return ListView.separated(
      // Providing a restorationId allows the ListView to restore the
      // scroll position when a user leaves and returns to the app after it
      // has been killed while running in the background.
      restorationId: restorationId,
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) => separatorWidget,
      itemBuilder: (BuildContext context, int index) {
        return itemBuilder(context, items[index]);
      },
    );
  }
}
