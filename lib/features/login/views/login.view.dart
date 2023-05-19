import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nextcloudnotes/core/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/login/controllers/login_view.controller.dart';

@RoutePage()
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<LoginViewController>();

    return AppScaffold(
      body: Column(
        children: [
          TextFormField(
            controller: controller.serverFormController,
            decoration: const InputDecoration(label: Text("https://")),
            onFieldSubmitted: (value) => controller.onPressLogin(context),
          ),
          ElevatedButton(
              onPressed: () => controller.onPressLogin(context),
              child: const Text("Login")),
          ElevatedButton(
              onPressed: () => {
                    Dio()
                        .get(
                            "https://hasanisabbah.duckdns.org/ocs/v1.php/cloud/user",
                            options: Options(headers: {
                              "Accept": "application/json",
                              "OCS-APIRequest": "true",
                              "Authorization":
                                  >token
                            }))
                        .then((value) => print(value))
                        .catchError((err) => print(err))
                  },
              child: const Text("Logint"))
        ],
      ),
    );
  }
}
