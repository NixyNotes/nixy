import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

/// The `CustomLoadingToast` class is a widget that displays a circular progress indicator and an
/// optional text content in a material container with a customizable flash controller.
class CustomLoadingToast extends StatelessWidget {
  /// The `CustomLoadingToast` class is a widget that displays a circular progress indicator and an
  /// optional text content in a material container with a customizable flash controller.
  const CustomLoadingToast({
    required this.flashController,
    required this.content,
    super.key,
  });

  /// `final FlashController flashController;` is declaring a final variable `flashController` of type
  /// `FlashController`. This variable is required as an input parameter for the `CustomLoadingToast`
  /// widget and is used as the controller for the `Flash` widget that wraps the content of the toast. The
  /// `FlashController` is responsible for controlling the visibility and animation of the `Flash` widget.
  final FlashController<void> flashController;

  /// `final String? content;` is declaring a final nullable variable `content` of type `String`. This
  /// variable is an optional input parameter for the `CustomLoadingToast` widget and is used to display
  /// an optional text content in the toast.
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Flash<void>(
        controller: flashController,
        position: FlashPosition.bottom,
        dismissDirections: const [FlashDismissDirection.startToEnd],
        child: SafeArea(
          minimum: EdgeInsets.all(
            MediaQuery.of(context).size.height / 10,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            elevation: 24,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  if (content != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(content!),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
