// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeViewController on _HomeViewControllerBase, Store {
  late final _$notesAtom =
      Atom(name: '_HomeViewControllerBase.notes', context: context);

  @override
  List<Note> get notes {
    _$notesAtom.reportRead();
    return super.notes;
  }

  @override
  set notes(List<Note> value) {
    _$notesAtom.reportWrite(value, super.notes, () {
      super.notes = value;
    });
  }

  @override
  String toString() {
    return '''
notes: ${notes}
    ''';
  }
}
