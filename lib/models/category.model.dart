// ignore_for_file: public_member_api_docs

import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.model.freezed.dart';

@freezed
class CategoryModel with _$CategoryModel {
  factory CategoryModel({required String label}) = _CategoryModel;
}
