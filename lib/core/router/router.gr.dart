// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:nextcloudnotes/features/connect-to-server/connect-to-server.view.dart'
    as _i3;
import 'package:nextcloudnotes/features/home/views/home.view.dart' as _i1;
import 'package:nextcloudnotes/features/login/views/login.view.dart' as _i2;

abstract class $AppRouter extends _i4.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeView(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.LoginView(),
      );
    },
    ConnectToServerRoute.name: (routeData) {
      final args = routeData.argsAs<ConnectToServerRouteArgs>();
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.ConnectToServerView(
          key: args.key,
          url: args.url,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.HomeView]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute({List<_i4.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i2.LoginView]
class LoginRoute extends _i4.PageRouteInfo<void> {
  const LoginRoute({List<_i4.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ConnectToServerView]
class ConnectToServerRoute extends _i4.PageRouteInfo<ConnectToServerRouteArgs> {
  ConnectToServerRoute({
    _i5.Key? key,
    required String url,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          ConnectToServerRoute.name,
          args: ConnectToServerRouteArgs(
            key: key,
            url: url,
          ),
          initialChildren: children,
        );

  static const String name = 'ConnectToServerRoute';

  static const _i4.PageInfo<ConnectToServerRouteArgs> page =
      _i4.PageInfo<ConnectToServerRouteArgs>(name);
}

class ConnectToServerRouteArgs {
  const ConnectToServerRouteArgs({
    this.key,
    required this.url,
  });

  final _i5.Key? key;

  final String url;

  @override
  String toString() {
    return 'ConnectToServerRouteArgs{key: $key, url: $url}';
  }
}
