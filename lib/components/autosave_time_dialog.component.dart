import 'package:flutter/material.dart';

/// The AutoSaveTimePickerDialog class is a dialog box that allows the user to select a time interval
/// for auto-saving, with options for minutes and seconds.
class AutoSaveTimePickerDialog extends StatelessWidget {
  /// The AutoSaveTimePickerDialog class is a dialog box that allows the user to select a time interval
  /// for auto-saving, with options for minutes and seconds.
  const AutoSaveTimePickerDialog({
    required this.onTapDone,
    required this.minutesTextController,
    required this.secondsTextController,
    super.key,
  });

  /// `final VoidCallback onTapDone;` is declaring a final variable `onTapDone` of type `VoidCallback`.
  /// This variable is used to store a function that will be called when the user taps the "Ok" button in
  /// the dialog box. The `VoidCallback` type is a function type that takes no arguments and returns no
  /// value.
  final VoidCallback onTapDone;

  /// `final TextEditingController minutesTextController;` is declaring a final variable
  /// `minutesTextController` of type `TextEditingController`. This variable is used to store a controller
  /// for the text field that allows the user to input the number of minutes for the auto-save time
  /// interval. The `TextEditingController` class is used to control the text being entered into a text
  /// field and to retrieve the current value of the text field.
  final TextEditingController minutesTextController;

  /// `final TextEditingController secondsTextController;` is declaring a final variable
  /// `secondsTextController` of type `TextEditingController`. This variable is used to store a controller
  /// for the text field that allows the user to input the number of seconds for the auto-save time
  /// interval. The `TextEditingController` class is used to control the text being entered into a text
  /// field and to retrieve the current value of the text field.
  final TextEditingController secondsTextController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select time interval'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onTapDone();
            Navigator.pop(context);
          },
          child: const Text('Ok'),
        ),
      ],
      content: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AutoSaveFormField(
              isMinutes: true,
              controller: minutesTextController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                textAlign: TextAlign.center,
                ':',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            _AutoSaveFormField(
              isMinutes: false,
              controller: secondsTextController,
            ),
          ],
        ),
      ),
    );
  }
}

class _AutoSaveFormField extends StatelessWidget {
  const _AutoSaveFormField({
    required this.controller,
    required this.isMinutes,
  });

  final TextEditingController controller;
  final bool isMinutes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineLarge,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          labelText: isMinutes ? 'Minutes' : 'Seconds',
          filled: true,
          fillColor: Theme.of(context).colorScheme.primaryContainer,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
