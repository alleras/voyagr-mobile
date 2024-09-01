import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyagr_mobile/models/trip_model.dart';
import 'package:voyagr_mobile/providers/trips_provider.dart';

class EventSetupView extends StatefulWidget {
  final Event? event;
  final int? eventIndex;
  bool get isEdit => (event != null) && (eventIndex != null);

  const EventSetupView({super.key, required this.event, required this.eventIndex});

  static const newTripRoute = '/tripEventSetup';
  static const editTripRoute = '/editTripEvent';
  
  @override
  EventSetupViewState createState() {
    return EventSetupViewState();
  }
}

class EventSetupViewState extends State<EventSetupView> {
  final _formKey = GlobalKey<FormState>();
  
  DateTime? startDate = DateTime.now();
  final TextEditingController eventTitleController = TextEditingController(text: '');
  final TextEditingController eventNotesController = TextEditingController(text: '');
  final TextEditingController addressController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();

    if (!widget.isEdit) return;

    eventTitleController.text = widget.event!.title;
    eventNotesController.text = widget.event!.notes ?? "";
    addressController.text = widget.event!.address;
    startDate = widget.event!.dateTime;
  }

  void persistChanges(TripsProvider tripsProvider) {
    var event = Event(
      title: eventTitleController.text,
      address: addressController.text,
      notes: eventNotesController.text,
      dateTime: startDate!
    );

    if(!widget.isEdit){
      tripsProvider.addItineraryItem(event);
    }
    else  {
      tripsProvider.updateItineraryItem(event, widget.eventIndex!);
    }
  }
  
  Widget buildSetupEventForm(){
    return Form(
      key: _formKey,
      child: Wrap(
        runSpacing: 12.0, // gap between lines
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Event Title',
            ),
            controller: eventTitleController,
          ),
          DateTimeField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Date',
            ),       
            mode: DateTimeFieldPickerMode.dateAndTime,
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            initialPickerDateTime: DateTime.now(),
            value: startDate,
            onChanged: (DateTime? value) { 
              setState(() => startDate = value);
            },
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Address',
            ),
            controller: addressController,
          ),
          TextField(
            controller: eventNotesController,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Notes',
              hintText: 'Add any extra information about this event.'
            ),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Event'),
        actions: [
          if (widget.isEdit) ...[
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: (){ 
                var provider = Provider.of<TripsProvider>(context, listen: false);
                provider.removeItineraryItem(widget.eventIndex!);
                Navigator.pop(context);
              },
            )
          ]
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(padding: const EdgeInsets.only(top: 20), child: buildSetupEventForm()),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () { Navigator.pop(context); },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))), 
                minimumSize: const Size(50, 50)
              ),
              onPressed: () async {
                persistChanges(Provider.of<TripsProvider>(context, listen: false));
                if(mounted) Navigator.pop(context);
              },
              child: widget.isEdit ? const Text('Update') : const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}