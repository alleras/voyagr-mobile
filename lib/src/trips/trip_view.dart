import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:voyagr_mobile/components/event_tile.dart';
import 'package:voyagr_mobile/providers/trips_provider.dart';
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

  late Future<Trip?> tripData;

  @override
  void initState() {
    super.initState();
    reloadTrip();
  }

  reloadTrip() {
    tripData = TripsProvider(context: context).loadTrip(widget.tripId);
  }

  ExpandableFab buildExpandableFab() {
    return const ExpandableFab(
      distance: 70,
      icon: Icon(Icons.add),
      children: [
        FloatingActionButton.extended(
          heroTag: "fab_transportation",
          onPressed: null,
          label: Text('Add Transportation'),
          icon: Icon(Icons.airplane_ticket),
        ),
        FloatingActionButton.extended(
          heroTag: "fab_accommodation",
          onPressed: null,
          label: Text('Add Accommodation'),
          icon: Icon(Icons.hotel),
        ),
        FloatingActionButton.extended(
          heroTag: "fab_event",
          onPressed: null,
          label: Text('Add Event'),
          icon: Icon(Icons.event),
        ),
      ],
    );
  }

  ListView buildEventList(Trip tripData) {
    List<Widget> itemList = [const SizedBox(height: 20)];

    for (final (index, item) in tripData.itinerary.indexed){
      itemList.add(
        EventTile(
          item: item, 
          isFirst: index == 0, 
          isLast: index == tripData.itinerary.length - 1)
        );
    }

    itemList.add(const SizedBox(height: 100));

    return ListView(children: itemList);
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder<Trip?>(
      future: tripData,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: snapshot.data != null ? ListTile(
              title: Text(snapshot.data!.name),
              subtitle: Text(
                'Planned for: ${DateFormat('E, MMM dd, yyyy').format(snapshot.data!.startDate!)}', 
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
                      builder: (context) => TripSetupView(trip: snapshot.data)
                    )
                  ).then((onValue){
                    setState(() => reloadTrip());
                  });
                },
              ),
            ],
          ),
          
          floatingActionButton: Visibility(
            visible: snapshot.hasData,
            child: buildExpandableFab()
          ),
          
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: !snapshot.hasData ? const Center(child: CircularProgressIndicator()) : buildEventList(snapshot.data!),
          )
        );
      },
    );
  }
}
