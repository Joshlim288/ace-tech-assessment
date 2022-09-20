import 'package:flutter/material.dart';

/// Contains logic for the dialogs shown in the application
/// Supports dialogs with and without input
/// Allows provision of the text to be displayed, and what API to call
class InputDialog extends StatefulWidget {
  const InputDialog({Key? key, required this.icon, required this.title, required this.prompt, required this.submitFunction, required this.isInput}) : super(key: key);
  final IconData icon;
  final String title;
  final String prompt;
  final Function submitFunction;
  final bool isInput;

  @override
  InputDialogState createState() => InputDialogState();
}

class InputDialogState extends State<InputDialog> {
  final TextEditingController dialogController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? response;

  /// only show when not loading, and when no response received
  Widget confirmButton() {
    return TextButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });
          if (widget.isInput) {
            widget.submitFunction(dialogController.text, (returnStr) {
              setState(() {
                isLoading = false;
                response = returnStr;
              });
            });
          } else {
            widget.submitFunction((returnStr) {
              setState(() {
                isLoading = false;
                response = returnStr;
              });
            });
          }
        }
      },
      child: const Text('Confirm', style: TextStyle(color: Colors.blue)),
    );
  }

  /// Defines the text field shown when input data is needed
  Widget inputField() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.prompt,
          ),
        ),
        if (widget.isInput)
          SizedBox(
            width: 400,
            child: TextFormField(
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 15),
            isLoading
                ? const CircularProgressIndicator()
                : response != null
                    ? Text(response!, style: const TextStyle(color: Colors.black))
                    : inputField(),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        if (!isLoading && response == null) confirmButton()
      ],
    );
  }
}
