import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyagr_mobile/models/trip_model.dart';
import 'package:voyagr_mobile/providers/trips_provider.dart';

class EventAccommodationSetupView extends StatefulWidget {
  final Accommodation? event;
  final int? eventIndex;
  bool get isEdit => (event != null) && (eventIndex != null);

  const EventAccommodationSetupView({super.key, required this.event, required this.eventIndex});

  static const newTripRoute = '/tripEventSetup';
  static const editTripRoute = '/editTripEvent';
  
  @override
  EventAccommodationSetupViewState createState() {
    return EventAccommodationSetupViewState();
  }
}

class EventAccommodationSetupViewState extends State<EventAccommodationSetupView> {
  final _formKey = GlobalKey<FormState>();
  
  DateTime? checkIn;
  DateTime? checkOut;
  final TextEditingController titleController = TextEditingController(text: '');
  final TextEditingController addressController = TextEditingController(text: '');
  final TextEditingController notesController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();

    if (!widget.isEdit) return;

    checkIn = widget.event!.checkIn;
    checkOut = widget.event!.checkOut;
    titleController.text = widget.event!.title;
    addressController.text = widget.event!.address;
    notesController.text = widget.event!.notes ?? '';
  }

  void persistChanges(TripsProvider tripsProvider) {
    var event = Accommodation(
      title: titleController.text,
      address: addressController.text,
      checkIn: checkIn!,
      checkOut: checkOut!
    );

    event.notes = notesController.text;

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
          const Text('Title and Address'),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
            controller: titleController,
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Address',
            ),
            controller: addressController,
          ),

          const SizedBox(height: 65,),
          const Text('Stay Information'),
          DateTimeField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Check-in Date',
            ),       
            mode: DateTimeFieldPickerMode.dateAndTime,
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            initialPickerDateTime: DateTime.now(),
            value: checkIn,
            onChanged: (DateTime? value) { 
              setState(() => checkIn = value);
            },
          ),
          DateTimeField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Check-out Date',
            ),       
            mode: DateTimeFieldPickerMode.dateAndTime,
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            initialPickerDateTime: DateTime.now(),
            value: checkOut,
            onChanged: (DateTime? value) { 
              setState(() => checkOut = value);
            },
          ),

          const SizedBox(height: 65,),
          const Text('Extra Information'),
          TextField(
            controller: notesController,
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
        title:  const Text('Accommodation'),
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