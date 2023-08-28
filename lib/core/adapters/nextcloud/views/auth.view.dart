import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcloudnotes/core/adapters/nextcloud/auth.adapter.dart';
import 'package:nextcloudnotes/core/router/router_meta.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';

class NextcloudAuthView extends StatefulWidget {
  const NextcloudAuthView({super.key});

  @override
  State<NextcloudAuthView> createState() => _NextcloudAuthViewState();
}

class _NextcloudAuthViewState extends State<NextcloudAuthView> {
  final controller = getIt<NextcloudAuthAdapter>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController serverFormController = TextEditingController();

  @override
  void dispose() {
    serverFormController.dispose();
    super.dispose();
  }

  String? urlFormValidator(String? value) {
    if (value != null) {
      if (!value.startsWith('http')) {
        return 'Url please';
      }

      return null;
    }
    return null;
  }

  void onPressLogin() {
    if (formKey.currentState!.validate()) {
      context.pushNamed(
        RouterMeta.ConnectToServer.name,
        pathParameters: {'url': serverFormController.text},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Login to your Nextcloud',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          'Make sure Nextcloud Notes is installed before you contiune.',
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: formKey,
            child: TextFormField(
              autocorrect: false,
              controller: serverFormController,
              validator: urlFormValidator,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                label: Text('https://yournextcloud.server'),
              ),
              onFieldSubmitted: (value) => onPressLogin(),
            ),
          ),
        ),
        OutlinedButton(
          onPressed: onPressLogin,
          child: const Text('Login'),
        ),
      ],
    );
  }
}
