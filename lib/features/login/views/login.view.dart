import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcloudnotes/core/router/router_meta.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/login/controllers/login_view.controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final controller = getIt<LoginViewController>();

  @override
  void initState() {
    super.initState();

    controller.init();
    controller.selectedAuthAdapter.observe((_) {
      if (_.newValue == '') {
        return;
      }

      final adapter = controller.authProviders[_.newValue];

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return AppScaffold(body: adapter!.view());
          },
        ),
      );
    });
  }

  void navigateHome() {
    context.goNamed(RouterMeta.Home.name);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Nixy',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            'Please select a provider',
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
          Observer(
            builder: (context) {
              final widgets = <Widget>[];
              for (final e in controller.authProviders.keys) {
                widgets.add(
                  RadioListTile<String>.adaptive(
                    title: Text(
                      e,
                    ),
                    value: e,
                    groupValue: controller.selectedAuthAdapter.value,
                    onChanged: (value) => controller.onSelectAuthAdapter(e),
                  ),
                );
              }

              return Column(
                children: widgets,
              );
            },
          )
        ],
      ),
    );
  }
}
