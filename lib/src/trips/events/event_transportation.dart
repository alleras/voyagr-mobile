import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyagr_mobile/models/trip_model.dart';
import 'package:voyagr_mobile/providers/trips_provider.dart';

class EventTransportationSetupView extends StatefulWidget {
  final TransportationFlight? event;
  final int? eventIndex;
  bool get isEdit => (event != null) && (eventIndex != null);

  const EventTransportationSetupView({super.key, required this.event, required this.eventIndex});

  static const newTripRoute = '/tripEventSetup';
  static const editTripRoute = '/editTripEvent';
  
  @override
  EventTransportationSetupViewState createState() {
    return EventTransportationSetupViewState();
  }
}

class EventTransportationSetupViewState extends State<EventTransportationSetupView> {
  final _formKey = GlobalKey<FormState>();
  
  DateTime? departureDate = DateTime.now();
  DateTime? arrivalDate = DateTime.now();

  final TextEditingController fromController = TextEditingController(text: '');
  final TextEditingController toController = TextEditingController(text: '');
  final TextEditingController addressController = TextEditingController(text: '');

  final TextEditingController gateController = TextEditingController(text: '');
  final TextEditingController seatController = TextEditingController(text: '');

  final TextEditingController notesController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();

    if (!widget.isEdit) return;

    departureDate = widget.event!.departure;
    arrivalDate = widget.event!.arrival;

    fromController.text = widget.event!.from;
    toController.text = widget.event!.to;
    addressController.text = widget.event!.address;

    gateController.text = widget.event!.flightGate ?? '';
    seatController.text = widget.event!.seat ?? '';
    
    notesController.text = widget.event!.notes ?? '';
  }

  void persistChanges(TripsProvider tripsProvider) {
    if (!_formKey.currentState!.validate()) return;

    var event = TransportationFlight(
      from: fromController.text,
      to: toController.text,
      address: addressController.text,
      departure: departureDate!,
      arrival: arrivalDate!
    );

    event.notes = notesController.text;
    event.flightGate = gateController.text;
    event.seat = seatController.text;

    if(!widget.isEdit){
      tripsProvider.addItineraryItem(event);
    }
    else  {
      tripsProvider.updateItineraryItem(event, widget.eventIndex!);
    }

    Navigator.pop(context);
  }
  
  Widget buildSetupEventForm(){
    return Consumer<TripsProvider>(
      builder: (context, tripsProvider, child) {
        return Form(
          key: _formKey,
          child: Wrap(
            runSpacing: 12.0, // gap between lines
            children: [
              const Text('Travel Information'),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'From',
                      ),
                      controller: fromController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please fill out this field';
                        return null;
                      }
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'To',
                      ),
                      controller: toController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please fill out this field';
                        return null;
                      }
                    ),
                  ),
                ],
              ),
              DateTimeField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Departs',
                ),       
                mode: DateTimeFieldPickerMode.dateAndTime,
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                initialPickerDateTime: null,
                value: departureDate,
                onChanged: (DateTime? value) { 
                  setState(() => departureDate = value);
                },
              ),
              DateTimeField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Arrives',
                ),       
                mode: DateTimeFieldPickerMode.dateAndTime,
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                initialPickerDateTime: null,
                value: arrivalDate,
                onChanged: (DateTime? value) { 
                  setState(() => arrivalDate = value);
                },
              ),
              TextFormField(
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
              const Text('Boarding and seating'),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Gate',
                ),
                controller: gateController,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Seat',
                ),
                controller: seatController,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Transportation'),
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