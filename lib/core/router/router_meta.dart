import 'package:auto_route/auto_route.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';

enum RouterMeta {
  Home(page: HomeRoute.page, title: "Notes"),
  Login(page: LoginRoute.page, title: "Login to a instance"),
  ConnectToServer(page: ConnectToServerRoute.page, title: "Nextcloud"),
  NewNote(page: NewNoteRoute.page, title: "New Note"),
  Settings(page: SettingsRoute.page, title: "Settings"),
  Categories(page: CategoriesRoute.page, title: "Categories");

  final PageInfo<dynamic> page;
  final String title;

  titleToWidget() {
    return (context, data) => title;
  }

  const RouterMeta({required this.page, required this.title});
}
