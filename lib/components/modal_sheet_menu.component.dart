import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

class ModalSheetMenu extends StatelessWidget {
  const ModalSheetMenu({super.key, required this.items});

  final List<PullDownMenuItem> items;

  List<ListTile> get itemsToListTile => items
      .map((e) => ListTile(
            leading: e.icon != null ? Icon(e.icon) : null,
            title: Text(e.title),
            onTap: e.onTap,
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: itemsToListTile,
      ),
    );
  }
}
