import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyagr_mobile/providers/trips_provider.dart';

import '../src/trips/trip_view.dart';
import 'package:voyagr_mobile/models/trip_model.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.tripData});

  final Trip tripData;

  @override
  Widget build(BuildContext context) {
    var tripsProvider = context.watch<TripsProvider>();

    return Card(  
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripView(tripId: tripData.id),
            ),
          );        
        },
        child: Row(children: [
          const Image(
            height: 100,
            image: AssetImage('assets/images/flutter_logo.png')
          ),
          Expanded(
            child: ListTile(
              title: Text(tripData.name),
              subtitle: Text(tripData.description ?? ''),
              isThreeLine: true,
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (String value) {
                  // Handle the menu selection
                  print('Selected: $value');
                  switch (value){
                    case 'Delete': {
                      tripsProvider.deleteTrip(tripData.id);
                    }
                    default: 
                      return;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'Share',
                      child: Row(children: [Icon(Icons.share, size: 15), SizedBox(width: 8), Text('Share')]),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Delete',
                      child: Row(children: [Icon(Icons.delete, size: 15), SizedBox(width: 8), Text('Delete')]),
                    ),
                  ];
                },
              ),
            ),
          )
        ],)
      )
    );
  }
}
