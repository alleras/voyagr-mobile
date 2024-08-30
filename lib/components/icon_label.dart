import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {
  final IconData icon;
  final Widget child;

  IconLabel({super.key, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10,),
        Flexible(child: child),
      ],
    );
  }
}