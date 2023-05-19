// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;
import 'package:nextcloudnotes/features/app/app.view.dart' as _i2;
import 'package:nextcloudnotes/features/connect-to-server/connect-to-server.view.dart'
    as _i3;
import 'package:nextcloudnotes/features/home/views/home.view.dart' as _i1;
import 'package:nextcloudnotes/features/login/views/login.view.dart' as _i4;
import 'package:nextcloudnotes/features/note/note.view.dart' as _i5;

abstract class $AppRouter extends _i6.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeView(),
      );
    },
    AppRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AppView(),
      );
    },
    ConnectToServerRoute.name: (routeData) {
      final args = routeData.argsAs<ConnectToServerRouteArgs>();
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.ConnectToServerView(
          key: args.key,
          url: args.url,
          onResult: args.onResult,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>(
          orElse: () => const LoginRouteArgs());
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.LoginView(
          key: args.key,
          onResult: args.onResult,
        ),
      );
    },
    NoteRoute.name: (routeData) {
      final args = routeData.argsAs<NoteRouteArgs>();
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.NoteView(
          key: args.key,
          noteId: args.noteId,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.HomeView]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute({List<_i6.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AppView]
class AppRoute extends _i6.PageRouteInfo<void> {
  const AppRoute({List<_i6.PageRouteInfo>? children})
      : super(
          AppRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ConnectToServerView]
class ConnectToServerRoute extends _i6.PageRouteInfo<ConnectToServerRouteArgs> {
  ConnectToServerRoute({
    _i7.Key? key,
    required String url,
    dynamic Function(bool)? onResult,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          ConnectToServerRoute.name,
          args: ConnectToServerRouteArgs(
            key: key,
            url: url,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'ConnectToServerRoute';

  static const _i6.PageInfo<ConnectToServerRouteArgs> page =
      _i6.PageInfo<ConnectToServerRouteArgs>(name);
}

class ConnectToServerRouteArgs {
  const ConnectToServerRouteArgs({
    this.key,
    required this.url,
    this.onResult,
  });

  final _i7.Key? key;

  final String url;

  final dynamic Function(bool)? onResult;

  @override
  String toString() {
    return 'ConnectToServerRouteArgs{key: $key, url: $url, onResult: $onResult}';
  }
}

/// generated route for
/// [_i4.LoginView]
class LoginRoute extends _i6.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i7.Key? key,
    dynamic Function(bool)? onResult,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i6.PageInfo<LoginRouteArgs> page =
      _i6.PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    this.onResult,
  });

  final _i7.Key? key;

  final dynamic Function(bool)? onResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i5.NoteView]
class NoteRoute extends _i6.PageRouteInfo<NoteRouteArgs> {
  NoteRoute({
    _i7.Key? key,
    required int noteId,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          NoteRoute.name,
          args: NoteRouteArgs(
            key: key,
            noteId: noteId,
          ),
          initialChildren: children,
        );

  static const String name = 'NoteRoute';

  static const _i6.PageInfo<NoteRouteArgs> page =
      _i6.PageInfo<NoteRouteArgs>(name);
}

class NoteRouteArgs {
  const NoteRouteArgs({
    this.key,
    required this.noteId,
  });

  final _i7.Key? key;

  final int noteId;

  @override
  String toString() {
    return 'NoteRouteArgs{key: $key, noteId: $noteId}';
  }
}
