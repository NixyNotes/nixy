import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/features/home/controllers/home.controller.dart';

class NixiSearchDelegate extends SearchDelegate<String> {
  NixiSearchDelegate()
      : super(
          searchFieldLabel: "Search for notes",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      onPressed: () => Navigator.of(context).pop(), icon: Icon(EvaIcons.close));

  @override
  Widget buildSuggestions(BuildContext context) {
    final controller = getIt<HomeViewController>();
    controller.search(query);

    return ListView(
      children: controller.searchNotes,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final controller = getIt<HomeViewController>();
    controller.search(query);

    return ListView(
      children: controller.searchNotes,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => <Widget>[
        IconButton(
          onPressed: () => null,
          icon: Icon(EvaIcons.search),
        ),
      ];
}
