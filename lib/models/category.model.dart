import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.model.freezed.dart';

@freezed
class CategoryModel with _$CategoryModel {
  factory CategoryModel({required String label, required VoidCallback onTap}) =
      _CategoryModel;
}
