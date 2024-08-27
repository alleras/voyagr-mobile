import 'package:flutter/material.dart';

class EventCardTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  EventCardTitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        ),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12)
        ),
        const Divider(thickness: .5),
      ]),
    );
  }
}