import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Exit App'),
      content: const Text('Are you sure you want to exit?'),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop(); 
            SystemNavigator.pop(); 
          },
        ),
      ],
    );
  }
}
