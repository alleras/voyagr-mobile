import 'package:flutter/material.dart';
import 'package:voyagr_mobile/components/event_card_information.dart';
import 'package:voyagr_mobile/components/event_card_title.dart';
import 'package:voyagr_mobile/components/icon_label.dart';

import 'package:voyagr_mobile/models/trip_model.dart';

class EventCard extends StatelessWidget {
  final Event data;
  const EventCard({super.key, required this.data});

  final String text = '';
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventCardTitle(
          title: 'Leadership Meeting',
          subtitle: 'Event - 10:25 PM',
        ),
        const SizedBox(height: 10,),

        EventCardInformationSection(children: [
          IconLabel(
            icon: Icons.maps_home_work_outlined, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text('1 Saarinen Cir, '),
                Text('Dulles, VA 20166'),
              ]
            ),
          ),
        ]),
        
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: const Text('Edit'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  } 
}