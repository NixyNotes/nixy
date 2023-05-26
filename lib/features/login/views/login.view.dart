import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/login/controllers/login_view.controller.dart';

@RoutePage()
class LoginView extends StatelessWidget {
  const LoginView({super.key, this.onResult});

  final Function(bool success)? onResult;

  @override
  Widget build(BuildContext context) {
    final controller = getIt<LoginViewController>();

    return AppScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Login to your Nextcloud",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            "Make sure Nextcloud Notes is installed before you contiune.",
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: controller.formKey,
              child: TextFormField(
                autocorrect: false,
                initialValue: null,
                controller: controller.serverFormController,
                validator: controller.urlFormValidator,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                    label: Text("https://yournextcloud.server")),
                onFieldSubmitted: (value) => controller.onPressLogin(context),
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () => controller.onPressLogin(context),
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}
