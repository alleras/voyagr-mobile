import 'package:flutter/material.dart';
import 'package:voyagr_mobile/components/event_card_information.dart';
import 'package:voyagr_mobile/components/event_card_title.dart';

import 'package:voyagr_mobile/models/trip_model.dart';
import 'package:voyagr_mobile/components/icon_label.dart';

class EventTransportationCard extends StatelessWidget {
  final ItineraryItem data;
  const EventTransportationCard({super.key, required this.data});

  final String text = '';
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventCardTitle(
          title: 'Washington - Dallas',
          subtitle: 'Flight - Departs at 10:25 PM',
        ),
        const SizedBox(height: 10,),

        EventCardInformationSection(children: [
          IconLabel(icon: Icons.info_outline, child: Text('Gate A15')),
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


        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: const Text('Edit'),
              onPressed: () {},
            ),
            FilledButton(
              child: Text('View Ticket'),
              onPressed: () {},
            )
          ],
        ),
      ],
    );
  } 
}