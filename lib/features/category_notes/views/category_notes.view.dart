import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CategoryNotesView extends StatefulWidget {
  const CategoryNotesView({super.key, required this.categoryName});

  final String categoryName;

  @override
  State<CategoryNotesView> createState() => _CategoryNotesViewState();
}

class _CategoryNotesViewState extends State<CategoryNotesView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
