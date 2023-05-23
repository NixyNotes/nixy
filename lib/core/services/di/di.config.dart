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

import '../../../features/app/controllers/app.controller.dart' as _i14;
import '../../../features/connect-to-server/controllers/connect-to-server.controller.dart'
    as _i15;
import '../../../features/home/controllers/home.controller.dart' as _i16;
import '../../../features/login/controllers/login_view.controller.dart' as _i5;
import '../../../features/new_note/controllers/new_note.controller.dart'
    as _i17;
import '../../../features/note/controllers/note_view.controller.dart' as _i18;
import '../../../repositories/login.repository.dart' as _i11;
import '../../../repositories/notes.repositories.dart' as _i12;
import '../../controllers/auth.controller.dart' as _i7;
import '../../controllers/queue.controller.dart' as _i13;
import '../../storage/auth.storage.dart' as _i3;
import '../dio/init_dio.dart' as _i10;
import '../dio/interceptors/auth.interceptor.dart' as _i8;
import '../dio/interceptors/base_url.interceptor.dart' as _i9;
import '../log.service.dart' as _i4;
import '../toast.service.dart' as _i6;

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
    gh.lazySingleton<_i4.LogService>(() => _i4.LogService());
    gh.factory<_i5.LoginViewController>(() => _i5.LoginViewController());
    gh.lazySingleton<_i6.ToastService>(() => _i6.ToastService());
    gh.lazySingleton<_i7.AuthController>(
        () => _i7.AuthController(gh<_i3.AuthStorage>()));
    gh.lazySingleton<_i8.AuthInterceptor>(
        () => _i8.AuthInterceptor(gh<_i7.AuthController>()));
    gh.lazySingleton<_i9.BaseUrlInterceptor>(
        () => _i9.BaseUrlInterceptor(gh<_i7.AuthController>()));
    gh.lazySingleton<_i10.DioService>(() => _i10.DioService(
          gh<_i8.AuthInterceptor>(),
          gh<_i9.BaseUrlInterceptor>(),
        ));
    gh.lazySingleton<_i11.LoginRepository>(
        () => _i11.LoginRepository(gh<_i10.DioService>()));
    gh.lazySingleton<_i12.NoteRepositories>(
        () => _i12.NoteRepositories(gh<_i10.DioService>()));
    gh.lazySingleton<_i13.QueueController>(
        () => _i13.QueueController(gh<_i12.NoteRepositories>()));
    gh.lazySingleton<_i14.AppViewController>(() => _i14.AppViewController(
          gh<_i7.AuthController>(),
          gh<_i13.QueueController>(),
        ));
    gh.factory<_i15.ConnectToServerController>(
        () => _i15.ConnectToServerController(
              gh<_i7.AuthController>(),
              gh<_i11.LoginRepository>(),
              gh<_i6.ToastService>(),
              gh<_i4.LogService>(),
            ));
    gh.lazySingleton<_i16.HomeViewController>(
        () => _i16.HomeViewController(gh<_i12.NoteRepositories>()));
    gh.lazySingleton<_i17.NewNoteController>(
      () => _i17.NewNoteController(gh<_i12.NoteRepositories>()),
      dispose: _i17.disposeNewNoteController,
    );
    gh.lazySingleton<_i18.NoteViewController>(
      () => _i18.NoteViewController(
        gh<_i12.NoteRepositories>(),
        gh<_i13.QueueController>(),
      ),
      dispose: _i18.disposeNoteViewController,
    );
    return this;
  }
}
