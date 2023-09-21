import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcloudnotes/core/adapters/mote/auth.adapter.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/services/toast.service.dart';

class MoteAuthView extends StatefulWidget {
  const MoteAuthView({super.key});

  @override
  State<MoteAuthView> createState() => _MoteAuthViewState();
}

class _MoteAuthViewState extends State<MoteAuthView> {
  final controller = getIt<MoteAuthAdapter>();
  final toastService = getIt<ToastService>();

  @override
  void dispose() {
    getIt.resetLazySingleton<MoteAuthAdapter>();
    super.dispose();
  }

  onLoginWrapper() async {
    final response = await controller.onLogin();

    if (response) {
      GoRouter.of(context).pop();
    } else {
      toastService.showTextToast('Could not login!', type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                controller: controller.usernameController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  label: Text('Username'),
                ),
              ),
              TextFormField(
                autocorrect: false,
                controller: controller.passwordController,
                obscureText: true,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  label: Text('Password'),
                ),
                onFieldSubmitted: (value) => controller.onLogin(),
              ),
              ElevatedButton(
                onPressed: onLoginWrapper,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
