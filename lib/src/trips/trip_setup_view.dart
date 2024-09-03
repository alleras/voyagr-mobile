import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:provider/provider.dart';
import 'package:voyagr_mobile/models/trip_model.dart';
import 'package:voyagr_mobile/providers/trips_provider.dart';
import 'package:voyagr_mobile/providers/users_provider.dart';

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
  
  DateTime? startDate = DateTime.now();
  final TextEditingController tripNameController = TextEditingController(text: '');
  final TextEditingController tripDescriptionController = TextEditingController(text: ''/*widget.trip?.description*/);

  @override
  void initState() {
    super.initState();

    if (!widget.isEdit) return;

    tripNameController.text = widget.trip!.name;
    tripDescriptionController.text = widget.trip!.description ?? '';
    startDate = widget.trip!.startDate ?? DateTime.now();
  }
  
  Widget buildSetupTripForm(TripsProvider tripsProvider){
    return Form(
      key: _formKey,
      child: Wrap(
        runSpacing: 12.0, // gap between lines
        children: [
          if (!widget.isEdit) ...[
            const Text("Let's add some basic information:", style: TextStyle(fontSize: 17)), 
            const SizedBox(height: 30)
          ],
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Trip Name',
            ),
            controller: tripNameController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter a name';
              return null;
            }
          ),
          DateTimeField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Date',
            ),       
            mode: DateTimeFieldPickerMode.date,
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            initialPickerDateTime: DateTime.now(),
            value: startDate,
            onChanged: (DateTime? value) { 
              setState(() => startDate = value);
            },
          ),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: tripDescriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Trip Description',
              hintText: 'Type a short description for your trip'
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter a description';
              return null;
            }
          ),
      
          const SizedBox(height: 150),
          Center(child: 
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(170, 50)),
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                if (!widget.isEdit){
                  tripsProvider.addTrip(Provider.of<UsersProvider>(context, listen: false).currentUser!.email, 
                    tripNameController.text, startDate!, tripDescriptionController.text);
                  Navigator.pop(context);
                } else {
                  widget.trip!.name = tripNameController.text;
                  widget.trip!.startDate = startDate!;
                  widget.trip!.description = tripDescriptionController.text;

                  await tripsProvider.updateTrip(widget.trip!);
                  if(mounted) Navigator.pop(context);
                }
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
    var tripsProvider = context.watch<TripsProvider>();

    return Scaffold(
      appBar: AppBar(title: 
        widget.isEdit ? Text('Edit trip - ${widget.trip!.name}') : const Text('Add new trip')
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: buildSetupTripForm(tripsProvider),
      ),
    );
  }
}