import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

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

      body: TripSetupForm(),
    );
  }
}

class TripSetupForm extends StatefulWidget {
  const TripSetupForm({super.key});

  @override
  TripSetupFormState createState() {
    return TripSetupFormState();
  }
}

class TripSetupFormState extends State<TripSetupForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: 'Trip Name'),
            ),
            DateTimeField(
              decoration: const InputDecoration(
                labelText: 'Start Date',
              ),
              mode: DateTimeFieldPickerMode.date,
              firstDate: DateTime.now().add(const Duration(days: 10)),
              lastDate: DateTime.now().add(const Duration(days: 40)),
              initialPickerDateTime: DateTime.now().add(const Duration(days: 20)),
              onChanged: (DateTime? value) {
                print(value);
              },
            ),
            DateTimeField(
              decoration: const InputDecoration(
                labelText: 'End Date',
              ),
              mode: DateTimeFieldPickerMode.date,
              firstDate: DateTime.now().add(const Duration(days: 10)),
              lastDate: DateTime.now().add(const Duration(days: 40)),
              initialPickerDateTime: DateTime.now().add(const Duration(days: 20)),
              onChanged: (DateTime? value) {
                print(value);
              },
            ),
          ],
        ),
      )
    );
  }
}