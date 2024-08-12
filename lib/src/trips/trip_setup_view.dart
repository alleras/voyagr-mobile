import 'package:flutter/material.dart';

class TripSetupView extends StatelessWidget {
  final bool isEdit;

  const TripSetupView({super.key, this.isEdit = false});
  static const newTripRoute = '/tripSetup';
  static const editTripRoute = '/editTrip';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: 
        isEdit ? const Text('Trip Title') : const Text('Add Trip')),
    );
  }
}