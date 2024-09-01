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
  
  DateTime? departureDate;
  DateTime? arrivalDate;

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
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'From',
                      ),
                      controller: fromController,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'To',
                      ),
                      controller: toController,
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
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
                controller: addressController,
              ),
        
              const SizedBox(height: 65,),
              const Text('Boarding and seating'),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Gate',
                ),
                controller: gateController,
              ),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Seat',
                ),
                controller: seatController,
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