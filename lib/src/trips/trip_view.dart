import 'package:flutter/material.dart';
import '../../components/event_tile.dart';
import 'trip_setup_view.dart';

class TripView extends StatelessWidget {
  const TripView({super.key,});

  static const routeName = '/tripview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip - Trip Name Here'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () { 
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => TripSetupView(isEdit: true,)
                )
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 20,),
            EventTile(isFirst: true, isPast: true,),
            EventTile(),
            EventTile(),
            EventTile(),
            EventTile(isLast: true),
          ],
        ),
      )
    );
  }
}
