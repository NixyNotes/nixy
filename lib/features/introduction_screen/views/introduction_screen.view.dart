import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:nextcloudnotes/core/assets.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/features/introduction_screen/controllers/introduction_screen.controller.dart';

/// The IntroductionScreenView class is a StatefulWidget that displays an introduction screen with a
/// single page containing information about the Nixy app.
class IntroductionScreenView extends StatefulWidget {
  /// The IntroductionScreenView class is a StatefulWidget that displays an introduction screen with a
  /// single page containing information about the Nixy app.
  const IntroductionScreenView({super.key});

  @override
  State<IntroductionScreenView> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreenView> {
  List<PageViewModel> get pages => [
        PageViewModel(
          title: 'Nixy',
          bodyWidget: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.labelLarge,
              children: const [
                TextSpan(
                  text: 'Markdown notes, ',
                ),
                TextSpan(
                  text: 'multi account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ', offline mode. Fast, elegant, secure.')
              ],
            ),
          ),
          image: Center(
            child: SizedBox(
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(Assets.NixyLogo),
              ),
            ),
          ),
        )
      ];

  @override
  Widget build(BuildContext context) {
    final controller = getIt<IntroductionScreenViewController>();
    return IntroductionScreen(
      pages: pages,
      showSkipButton: true,
      skip: const Text('Skip'),
      done: const Text('Done'),
      next: const Text('Next'),
      onDone: controller.onDone,
    );
  }
}
