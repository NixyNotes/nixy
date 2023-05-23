// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../../features/app/controllers/app.controller.dart' as _i12;
import '../../../features/connect-to-server/controllers/connect-to-server.controller.dart'
    as _i4;
import '../../../features/home/controllers/home.controller.dart' as _i13;
import '../../../features/login/controllers/login_view.controller.dart' as _i5;
import '../../../features/note/controllers/note-view.controller.dart' as _i14;
import '../../../repositories/notes.repositories.dart' as _i10;
import '../../controllers/auth.controller.dart' as _i6;
import '../../controllers/queue.controller.dart' as _i11;
import '../../storage/auth.storage.dart' as _i3;
import '../dio/init_dio.dart' as _i9;
import '../dio/interceptors/auth.interceptor.dart' as _i7;
import '../dio/interceptors/base_url.interceptor.dart' as _i8;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.AuthStorage>(() => _i3.AuthStorage());
    gh.factory<_i4.ConnectToServerController>(
        () => _i4.ConnectToServerController());
    gh.factory<_i5.LoginViewController>(() => _i5.LoginViewController());
    gh.lazySingleton<_i6.AuthController>(
        () => _i6.AuthController(gh<_i3.AuthStorage>()));
    gh.lazySingleton<_i7.AuthInterceptor>(
        () => _i7.AuthInterceptor(gh<_i6.AuthController>()));
    gh.lazySingleton<_i8.BaseUrlInterceptor>(
        () => _i8.BaseUrlInterceptor(gh<_i6.AuthController>()));
    gh.lazySingleton<_i9.DioService>(() => _i9.DioService(
          gh<_i7.AuthInterceptor>(),
          gh<_i8.BaseUrlInterceptor>(),
        ));
    gh.lazySingleton<_i10.NoteRepositories>(
        () => _i10.NoteRepositories(gh<_i9.DioService>()));
    gh.lazySingleton<_i11.QueueController>(
        () => _i11.QueueController(gh<_i10.NoteRepositories>()));
    gh.lazySingleton<_i12.AppViewController>(() => _i12.AppViewController(
          gh<_i6.AuthController>(),
          gh<_i11.QueueController>(),
        ));
    gh.lazySingleton<_i13.HomeViewController>(
        () => _i13.HomeViewController(gh<_i10.NoteRepositories>()));
    gh.lazySingleton<_i14.NoteViewController>(() => _i14.NoteViewController(
          gh<_i10.NoteRepositories>(),
          gh<_i11.QueueController>(),
        ));
    return this;
  }
}
