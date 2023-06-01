// ignore_for_file: public_member_api_docs, constant_identifier_names

import 'package:auto_route/auto_route.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';

/// The `enum RouterMeta` is defining a set of named constants, each of which has a `page` and a `title`
/// property. These constants represent different pages in the app and are used to generate routes using
/// the `auto_route` package. The `titleToWidget()` method returns a function that takes a `context` and
/// `data` parameter and returns the `title` property of the corresponding `RouterMeta` constant. This
/// is used to dynamically set the title of the app bar for each page.
enum RouterMeta {
  Home(page: HomeRoute.page, title: 'Notes'),
  Login(page: LoginRoute.page, title: 'Login to a instance'),
  ConnectToServer(page: ConnectToServerRoute.page, title: 'Nextcloud'),
  NewNote(page: NewNoteRoute.page, title: 'New Note'),
  Settings(page: SettingsRoute.page, title: 'Settings'),
  Categories(page: CategoriesRoute.page, title: 'Categories');

  const RouterMeta({required this.page, required this.title});

  /// `final PageInfo<dynamic> page;` is declaring a final variable `page` of type `PageInfo<dynamic>`.
  /// `PageInfo` is a class provided by the `auto_route` package that represents a page in the app and
  /// contains information such as the path, name, and widget associated with the page. The `<dynamic>`
  /// type parameter indicates that the `PageInfo` can be associated with any type of widget. In the
  /// `RouterMeta` enum, each constant is associated with a specific `PageInfo` object that represents a
  /// page in the app.
  final PageInfo<dynamic> page;

  /// The `final String title;` is declaring a final variable `title` of type `String` in the `RouterMeta`
  /// enum. It represents the title of a specific page in the app. Each constant in the `RouterMeta` enum
  /// is associated with a specific `title` that is used to dynamically set the title of the app bar for
  /// that page.
  final String title;

  /// This function returns a string function that takes in context and data parameters and returns the
  /// title as a widget.
  ///
  /// Returns:
  ///   A function that takes in a context and data parameter and returns the value of the "title"
  /// variable.
  String Function(dynamic context, dynamic data) titleToWidget() {
    return (context, data) => title;
  }
}
