import 'package:flutter/material.dart';

/// Contains logic for both checking and updating password, since they are very similar
class InputDialog extends StatefulWidget {
  const InputDialog({
    Key? key,
    required this.icon,
    required this.title,
    required this.prompt,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final String prompt;

  @override
  InputDialogState createState() => InputDialogState();
}

class InputDialogState extends State<InputDialog> {
  final TextEditingController dialogController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      title: Column(
        children: <Widget>[
          Icon(widget.icon),
          Text(widget.title),
        ],
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // password
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.prompt,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 400,
              child: TextFormField(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: OutlineInputBorder(),
                ),
                controller: dialogController,
                minLines: 5,
                maxLines: 5,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
            ),
            // Widgets relating to 2nd field for confirming password will not be created if not in update mode
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.pop(context, dialogController.text);
            }
          },
          child: const Text('Confirm', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
