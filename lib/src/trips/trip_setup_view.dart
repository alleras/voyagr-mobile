import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:voyagr_mobile/models/trip_model.dart';

class TripSetupView extends StatefulWidget {
  final Trip? trip;

  bool get isEdit => trip != null;

  const TripSetupView({super.key, this.trip});
  static const newTripRoute = '/tripSetup';
  static const editTripRoute = '/editTrip';
  
  @override
  TripSetupViewState createState() {
    return TripSetupViewState();
  }
}

class TripSetupViewState extends State<TripSetupView> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startDate = widget.trip?.startDate;
  }

  Widget buildSetupTripForm(){
    TextEditingController tripNameController = TextEditingController(text: widget.trip?.name);
    TextEditingController tripDescriptionController = TextEditingController(text: ''/*widget.trip?.description*/);

    return Form(
      key: _formKey,
      child: Wrap(
        runSpacing: 12.0, // gap between lines
        children: [
          if (!widget.isEdit) ...[
            const Text("Let's add some basic information:", style: TextStyle(fontSize: 17)), 
            const SizedBox(height: 30)
          ],
           TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Trip Name',
            ),
            controller: tripNameController,
          ),
          DateTimeField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Start Date',
            ),       
            mode: DateTimeFieldPickerMode.date,
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            lastDate: DateTime.now().add(const Duration(days: 40)),
            initialPickerDateTime: DateTime.now(),
            value: _startDate,
            onChanged: (DateTime? value) { 
              setState(() => _startDate = value);
            },
          ),
          TextField(
            controller: tripDescriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Trip Description',
              hintText: 'Type a short description for your trip'
            ),
          ),
      
          const SizedBox(height: 150),
          Center(child: 
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(170, 50)),
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
              },
              child: widget.isEdit ? const Text('Update') : const Text('Add Trip'),
            )
          ,),
      
          Center(child: 
            TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(170, 50)),
              onPressed: () { Navigator.pop(context); },
              child: const Text('Cancel'),
            )
          ,)
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: 
        widget.isEdit ? Text('Edit trip - ${widget.trip!.name}') : const Text('Add new trip')
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: buildSetupTripForm(),
      ),
    );
  }
}