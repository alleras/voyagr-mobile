import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voyagr_mobile/components/event_card_information.dart';
import 'package:voyagr_mobile/components/event_card_title.dart';
import 'package:voyagr_mobile/components/icon_label.dart';

import 'package:voyagr_mobile/models/trip_model.dart';
import 'package:voyagr_mobile/src/trips/events/event.dart';

class EventCard extends StatelessWidget {
  final Event data;
  final int itemIndex;

  const EventCard({super.key, required this.data, required this.itemIndex});

  final String text = '';
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventCardTitle(
          title: data.title,
          subtitle: 'Event - ${DateFormat('jm').format(data.dateTime)}',
        ),
        const SizedBox(height: 10,),

        EventCardInformationSection(children: [
          IconLabel(
            icon: Icons.maps_home_work_outlined, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(data.address)
              ]
            ),
          ),
          if (data.notes != null && data.notes!.isNotEmpty) ...[
            IconLabel(
            icon: Icons.info_outline,
            child: Text(data.notes!),
          )]
        ]),
        
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => EventSetupView(event: data, eventIndex: itemIndex,)
                  )
                );
              },
            ),
          ],
        ),
      ],
    );
  } 
}