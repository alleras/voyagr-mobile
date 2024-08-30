import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voyagr_mobile/components/event_card_information.dart';
import 'package:voyagr_mobile/components/event_card_title.dart';

import 'package:voyagr_mobile/models/trip_model.dart';
import 'package:voyagr_mobile/components/icon_label.dart';

class EventTransportationCard extends StatelessWidget {
  final TransportationFlight data;
  const EventTransportationCard({super.key, required this.data});

  final String text = '';
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventCardTitle(
          title: '${data.from!} -> ${data.to}' ,
          subtitle: 'Flight - Departs at ${DateFormat('jm').format(data.departure!)}',
        ),
        const SizedBox(height: 10,),

        EventCardInformationSection(children: [
          IconLabel(
            icon: Icons.maps_home_work_outlined, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Address', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(data.address!)
              ]
            ),
          ),
          IconLabel(icon: Icons.airplane_ticket_outlined, child: Text('Gate ${data.flightGate!}')),
          if (data.seat != null && data.seat!.isNotEmpty) ... [
            IconLabel(icon: Icons.chair_outlined, child: Text('Seat ${data.seat!}'))
          ],
          IconLabel(
            icon: Icons.access_alarm_outlined, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Arrives', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(DateFormat('MMM dd, yyyy').add_jm().format(data.arrival!)),
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
              child: const Text('View Ticket'),
              onPressed: () {},
            )
          ],
        ),
      ],
    );
  } 
}