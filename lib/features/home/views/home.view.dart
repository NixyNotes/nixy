import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nextcloudnotes/core/di/di.dart';
import 'package:nextcloudnotes/core/models/user.model.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/core/storage/auth.storage.dart';

@RoutePage()
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authStorage = getIt<AuthStorage>();

    return AppScaffold(
        body: Column(
      children: [
        ElevatedButton(
            onPressed: () => authStorage.deleteAll(),
            child: const Text("delete all")),
        FutureBuilder<List<User>>(
          future: authStorage.getUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              case ConnectionState.active:
                return const CircularProgressIndicator();

              case ConnectionState.done:
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final User item = snapshot.data![index];

                      return ListTile(
                        title: Text(item.username ?? ""),
                      );
                    },
                    itemCount: snapshot.data?.length,
                  );
                }

                return const Placeholder();

              case ConnectionState.none:
                return const SizedBox.shrink();
            }
          },
        ),
      ],
    ));
  }
}
