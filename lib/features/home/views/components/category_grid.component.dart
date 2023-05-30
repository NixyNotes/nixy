import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid(
      {super.key, required this.categoryName, required this.onTap});

  final String categoryName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [const Icon(EvaIcons.folderOutline), Text(categoryName)],
        ),
      ),
    );
  }
}
