import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/settings/controllers/settings_view.controller.dart';
import 'package:nextcloudnotes/features/settings/views/components/settings_icon.component.dart';

@RoutePage()
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final controller = getIt<SettingsViewController>();

  @override
  void initState() {
    super.initState();

    controller.init(context);
  }

  @override
  void dispose() {
    getIt.resetLazySingleton<SettingsViewController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Observer(builder: (_) {
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final item = controller.settings[index];

            return ListTile(
              leading: SettingsIcon(
                icon: item.icon,
                bgColor: item.iconBgColor,
              ),
              title: Text(
                item.label,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              trailing: item.trailing,
              onTap: item.onTap,
            );
          },
          itemCount: controller.settings.length,
        );
      }),
    );
  }
}
