import 'package:flutter/material.dart';

class EventCardInformationSection extends StatelessWidget{
  final List<Widget> children;

  const EventCardInformationSection({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 10,
      children: children,
    );
  }
}