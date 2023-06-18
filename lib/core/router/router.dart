import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/router/router_meta.dart';
import 'package:nextcloudnotes/features/categories/views/categories.view.dart';
import 'package:nextcloudnotes/features/connect-to-server/connect-to-server.view.dart';
import 'package:nextcloudnotes/features/home/views/home.view.dart';
import 'package:nextcloudnotes/features/login/views/login.view.dart';
import 'package:nextcloudnotes/features/new_note/views/new_note.view.dart';
import 'package:nextcloudnotes/features/note/note.view.dart';
import 'package:nextcloudnotes/features/settings/views/settings.view.dart';
import 'package:nextcloudnotes/models/category.model.dart';

/// Navigator key
final navigatorKey = GlobalKey<NavigatorState>();

@injectable

/// Router for application
class AppRouter {
  /// Router for application
  AppRouter(this._authController);

  final AuthController _authController;

  /// Router
  GoRouter get router => GoRouter(
        navigatorKey: navigatorKey,
        initialLocation: RouterMeta.Login.path,
        refreshListenable: _authController,
        debugLogDiagnostics: true,
        errorPageBuilder: (context, state) =>
            MaterialPage(child: Text(state.error.toString())),
        routes: [
          GoRoute(
            name: RouterMeta.Home.name,
            path: RouterMeta.Home.path,
            pageBuilder: (context, state) {
              final categoryName = state.queryParameters['categoryName'];

              return MaterialPage<HomeView>(
                child: HomeView(
                  byCategoryName: categoryName,
                ),
                key: state.pageKey,
              );
            },
          ),
          GoRoute(
            name: RouterMeta.Login.name,
            path: RouterMeta.Login.path,
            pageBuilder: (context, state) => MaterialPage<LoginView>(
              child: const LoginView(),
              key: state.pageKey,
            ),
          ),
          GoRoute(
            name: RouterMeta.AddNewAccount.name,
            path: RouterMeta.AddNewAccount.path,
            pageBuilder: (context, state) => MaterialPage<LoginView>(
              child: const LoginView(),
              key: state.pageKey,
            ),
          ),
          GoRoute(
            name: RouterMeta.ConnectToServer.name,
            path: RouterMeta.ConnectToServer.path,
            pageBuilder: (context, state) => MaterialPage<ConnectToServerView>(
              child: ConnectToServerView(
                url: state.pathParameters['url']!,
              ),
              key: state.pageKey,
              fullscreenDialog: true,
            ),
          ),
          GoRoute(
            name: RouterMeta.Settings.name,
            path: RouterMeta.Settings.path,
            pageBuilder: (context, state) => MaterialPage<SettingsView>(
              child: const SettingsView(),
              key: state.pageKey,
              fullscreenDialog: true,
            ),
          ),
          GoRoute(
            name: RouterMeta.SingleNote.name,
            path: RouterMeta.SingleNote.path,
            pageBuilder: (context, state) => MaterialPage<NoteView>(
              child: NoteView(noteId: int.parse(state.pathParameters['id']!)),
              key: state.pageKey,
              fullscreenDialog: true,
            ),
          ),
          GoRoute(
            name: RouterMeta.Categories.name,
            path: RouterMeta.Categories.path,
            pageBuilder: (context, state) {
              final categories = state.extra as List<CategoryModel>;

              return MaterialPage<CategoriesView>(
                child: CategoriesView(
                  categories: categories,
                ),
                key: state.pageKey,
                fullscreenDialog: true,
              );
            },
          ),
          GoRoute(
            name: RouterMeta.NewNote.name,
            path: RouterMeta.NewNote.path,
            pageBuilder: (context, state) => MaterialPage<NewNoteView>(
              child: const NewNoteView(),
              key: state.pageKey,
              fullscreenDialog: true,
            ),
          ),
        ],
        redirect: (context, state) {
          final isLoggedIn = _authController.isLoggedIn;
          final loginLocation = state.namedLocation(RouterMeta.Login.name);

          final homeLocation = state.namedLocation(RouterMeta.Home.name);

          final isInLoginPage = state.location == loginLocation;

          if (!isLoggedIn) {
            if (isInLoginPage) {
              return null;
            }

            if (state.location.startsWith('/connect')) {
              return null;
            }

            return loginLocation;
          }

          if (isLoggedIn && isInLoginPage) {
            return homeLocation;
          }

          return null;
        },
      );
}
