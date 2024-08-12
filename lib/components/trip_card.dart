import 'package:flutter/material.dart';

import '../src/trips/trip_view.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Card(  
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, TripView.routeName);
        },
        child: Row(children: [
          Image(
            height: 100,
            image: AssetImage('assets/images/flutter_logo.png')
          ),
          Expanded(
            child: ListTile(
              title: Text('This is a Trip'),
              subtitle: Text('A sufficiently long subtitle warrants three lines.'),
              isThreeLine: true,
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (String value) {
                  // Handle the menu selection
                  print('Selected: $value');
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
