import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voyagr_mobile/components/event_card_information.dart';
import 'package:voyagr_mobile/components/event_card_title.dart';
import 'package:voyagr_mobile/components/icon_label.dart';

import 'package:voyagr_mobile/models/trip_model.dart';

class EventAccomodationCard extends StatelessWidget {
  final Accommodation data;
  const EventAccomodationCard({super.key, required this.data});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventCardTitle(
          title: data.title!,
          subtitle: 'Stay - Check in at ${DateFormat('jm').format(data.checkIn!)}',
        ),
        const SizedBox(height: 10,),
        
        EventCardInformationSection(children: [
          IconLabel(
            icon: Icons.maps_home_work_outlined, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(data.address ?? ''),  
            ]),
          ),
          IconLabel(
            icon: Icons.access_alarm_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Check Out', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(DateFormat('MMM dd, yyyy').add_jm().format(data.checkOut!)),
            ]),
          ),
          if (data.notes != null && data.notes!.isNotEmpty) ...[
            IconLabel(
            icon: Icons.info_outline,
            child: Text(data.notes!),
          )]
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
              child: const Text('View Reservation'),
              onPressed: () {},
            )
          ],
        ),
      ],
    );
  } 
}