import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget child; 

  const CustomBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.indigo[700]!, Colors.purple[700]!],
        ),
      ),
      child: child,
    );
  }
}
