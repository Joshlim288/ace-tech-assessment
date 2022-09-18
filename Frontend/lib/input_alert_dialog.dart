import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Contains logic for both checking and updating password, since they are very similar
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
  bool isLoading = false;
  String? response;

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
            const SizedBox(height: 5),
            isLoading
                ? const CircularProgressIndicator()
                : response != null
                    ? Text(response!, style: const TextStyle(color: Colors.black))
                    : Column(
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
                      )
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
        // only show when not loading, and when no response received
        if (!isLoading && response == null)
          TextButton(
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
          ),
      ],
    );
  }
}
