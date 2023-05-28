// To parse this JSON data, do
//
//     final capabilities = capabilitiesFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';

part 'capabilities.model.freezed.dart';
part 'capabilities.model.g.dart';

@freezed
class Capabilities with _$Capabilities {
  const factory Capabilities({
    required Ocs ocs,
  }) = _Capabilities;

  factory Capabilities.fromJson(Map<String, dynamic> json) =>
      _$CapabilitiesFromJson(json);
}

@freezed
class Ocs with _$Ocs {
  const factory Ocs({
    required Data data,
  }) = _Ocs;

  factory Ocs.fromJson(Map<String, dynamic> json) => _$OcsFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    required Map<String, Map> capabilities,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
