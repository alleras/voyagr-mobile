import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:voyagr_mobile/components/event_tile.dart';
import 'package:voyagr_mobile/providers/trips_provider.dart';
import 'package:voyagr_mobile/src/trips/events/event.dart';
import 'package:voyagr_mobile/src/trips/events/event_accommodation.dart';
import 'package:voyagr_mobile/src/trips/events/event_transportation.dart';
import 'package:voyagr_mobile/src/trips/trip_setup_view.dart';
import 'package:voyagr_mobile/components/expandable_fab.dart';
import 'package:voyagr_mobile/models/trip_model.dart';

class TripView extends StatefulWidget {
  const TripView({super.key, required this.tripId});

  final String tripId;

  static const routeName = '/tripview';

  @override
  State<TripView> createState() => _TripViewState();
}

class _TripViewState extends State<TripView> {

  @override
  void initState() {
    super.initState();
    reloadTrip();
  }

  reloadTrip() {
    Provider.of<TripsProvider>(context, listen: false).invalidateCurrentTrip();
    Provider.of<TripsProvider>(context, listen: false).loadTrip(widget.tripId);
  }

  ExpandableFab buildExpandableFab() {
    return ExpandableFab(
      distance: 70,
      icon: const Icon(Icons.add),
      children: [
        FloatingActionButton.extended(
          heroTag: "fab_transportation",
          label: const Text('Add Transportation'),
          icon: const Icon(Icons.airplane_ticket),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const EventTransportationSetupView(event: null, eventIndex: null)
              )
            );
          }
        ),
        FloatingActionButton.extended(
          heroTag: "fab_accommodation",
          label: const Text('Add Accommodation'),
          icon: const Icon(Icons.hotel),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const EventAccommodationSetupView(event: null, eventIndex: null)
              )
            );
          }
        ),
        FloatingActionButton.extended(
          heroTag: "fab_event",
          label: const Text('Add Event'),
          icon: const Icon(Icons.event),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const EventSetupView(event: null, eventIndex: null,)
              )
            );
          }
        ),
      ],
    );
  }

  Widget buildEventList(Trip tripData) {
    List<Widget> itemList = [];

    for (final (index, item) in tripData.itinerary.indexed){
      itemList.add(
        EventTile(
          item: item, 
          itemIndex: index,
          isFirst: index == 0, 
          isLast: index == tripData.itinerary.length - 1)
        );
    }

    return itemList.isNotEmpty ? 
      ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: itemList
      )
      :
      const Center(child: Text('This trip is empty. Add events with the + icon.', textAlign: TextAlign.center,));
  }

  @override
  Widget build(BuildContext context){
    return Consumer<TripsProvider>(
      builder: (context, tripsProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: tripsProvider.currentTrip != null ? ListTile(
              title: Text(tripsProvider.currentTrip!.name),
              subtitle: Text(
                'Planned for: ${DateFormat('E, MMM dd, yyyy').format(tripsProvider.currentTrip!.startDate!)}', 
                style: const TextStyle(fontSize: 12),
              ),
            ) : null,
            actions: [
              IconButton(
                icon: const Icon(Icons.info),
                onPressed: () { 
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => TripSetupView(trip: tripsProvider.currentTrip)
                    )
                  ).then((onValue){
                    setState(() => reloadTrip());
                  });
                },
              ),
            ],
          ),
          
          floatingActionButton: Visibility(
            visible: tripsProvider.currentTrip != null,
            child: buildExpandableFab()
          ),
          
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: tripsProvider.currentTrip == null ? 
              const Center(child: CircularProgressIndicator()) : buildEventList(tripsProvider.currentTrip!),
          )
        );
      },
    );
  }
}
