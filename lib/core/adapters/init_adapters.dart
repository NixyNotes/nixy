import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/adapters/auth.adapter.dart';
import 'package:nextcloudnotes/core/adapters/base.adapter.dart';
import 'package:nextcloudnotes/core/adapters/mote/auth.adapter.dart';
import 'package:nextcloudnotes/core/adapters/mote/mote.adapter.dart';
import 'package:nextcloudnotes/core/adapters/nextcloud/auth.adapter.dart';
import 'package:nextcloudnotes/core/adapters/nextcloud/nextcloud.adapter.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';

enum AdapterType { Mote, Nextcloud }

final authAdapters = [getIt<MoteAuthAdapter>()];

@lazySingleton
class Adapter {
  /// Adapter bindings
  Adapter(this._authController);
  final AuthController _authController;

  final List<AuthAdapter> authAdapters = [];

  /// Active adapter
  BaseAdapter? currentAdapter;

  late String currentServerUri;

  /// init
  void init() {
    authAdapters
      ..add(getIt<MoteAuthAdapter>())
      ..add(getIt<NextcloudAuthAdapter>());

    _authController.currentAccount.observe((account) {
      if (account.newValue != null) {
        currentServerUri = account.newValue!.server;
        final adapter = account.newValue!.adapter;
        currentAdapter = _getAdapterByType(adapter);
      }
    });
  }

  BaseAdapter _getAdapterByType(AdapterType type) {
    switch (type) {
      case AdapterType.Mote:
        return getIt<MoteAdapter>();

      case AdapterType.Nextcloud:
        return NextcloudAdapter();
    }
  }
}