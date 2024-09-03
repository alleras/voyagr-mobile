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
  
  DateTime? checkIn = DateTime.now();
  DateTime? checkOut = DateTime.now();
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
    if (!_formKey.currentState!.validate()) return;

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

    Navigator.pop(context);
  }
  
  Widget buildSetupEventForm(){
    return Form(
      key: _formKey,
      child: Wrap(
        runSpacing: 12.0, // gap between lines
        children: [
          const Text('Title and Address'),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
            controller: titleController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter a Title';
              return null;
            }
          ),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Address',
            ),
            controller: addressController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter an Address';
              return null;
            }
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
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
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
              onPressed: () => showDialog<String>(
                context: context, 
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Delete'),
                  content: const Text('Are you sure you want to delete this item?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        var provider = Provider.of<TripsProvider>(context, listen: false);
                        provider.removeItineraryItem(widget.eventIndex!);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                )
              ),
            )
          ]
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(padding: const EdgeInsets.only(top: 20), child: buildSetupEventForm()),
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 20),
        curve: Curves.decelerate,
        padding: MediaQuery.of(context).viewInsets,
        child: BottomAppBar(
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
                },
                child: widget.isEdit ? const Text('Update') : const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}