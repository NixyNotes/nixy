import 'package:auto_route/auto_route.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/home/controllers/home.controller.dart';
import 'package:nextcloudnotes/models/category.model.dart';

@RoutePage()
class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key, required this.categories});

  final List<CategoryModel> categories;

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  navigateToPosts(String label) {
    isViewingCategoryPosts.value = true;
    context.router.push(HomeRoute(byCategoryName: label));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          return ListTile(
              title: Text(category.label),
              leading: const Icon(EvaIcons.folderOutline),
              onTap: () => navigateToPosts(category.label));
        },
        itemCount: widget.categories.length,
      ),
    );
  }
}
