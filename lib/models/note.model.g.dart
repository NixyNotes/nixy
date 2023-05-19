// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Note _$$_NoteFromJson(Map<String, dynamic> json) => _$_Note(
      id: json['id'] as int,
      etag: json['etag'] as String,
      readonly: json['readonly'] as bool,
      modified: json['modified'] as int,
      title: json['title'] as String,
      category: json['category'] as String?,
      content: json['content'] as String,
      favorite: json['favorite'] as bool,
    );

Map<String, dynamic> _$$_NoteToJson(_$_Note instance) => <String, dynamic>{
      'id': instance.id,
      'etag': instance.etag,
      'readonly': instance.readonly,
      'modified': instance.modified,
      'title': instance.title,
      'category': instance.category,
      'content': instance.content,
      'favorite': instance.favorite,
    };
