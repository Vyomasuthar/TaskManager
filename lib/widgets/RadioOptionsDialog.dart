import 'package:flutter/material.dart';

class RadioOptionsDialog extends StatefulWidget {
  final TextEditingController textEditingController;

  const RadioOptionsDialog({required this.textEditingController});

  @override
  _RadioOptionsDialogState createState() => _RadioOptionsDialogState();
}

class _RadioOptionsDialogState extends State<RadioOptionsDialog> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select an Option'),
      children: [
        RadioListTile(
          title: const Text('Never'),
          value: 'Never',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value as String?;
            });
          },
        ),
        RadioListTile(
          title: const Text('Every Day'),
          value: 'Every Day',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value as String?;
            });
          },
        ),
         RadioListTile(
          title: const Text('Every Week'),
          value: 'Every Week',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value as String?;
            });
          },
        ),
        RadioListTile(
          title: const Text('Every Month'),
          value: 'Every Month',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value as String?;
            });
          },
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            widget.textEditingController.text = selectedOption ?? '';
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
