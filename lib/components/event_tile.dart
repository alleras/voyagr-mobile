import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:voyagr_mobile/models/trip_model.dart';

import 'package:voyagr_mobile/components/event_card.dart';
import 'package:voyagr_mobile/components/event_accomodation_card.dart';
import 'package:voyagr_mobile/components/event_transportation_card.dart';

class EventTile extends StatelessWidget {
  final bool isFirst, isLast, isPast;
  final ItineraryItem item;

  const EventTile({
    super.key, 
    required this.item,
    this.isFirst = false, 
    this.isLast = false, 
    this.isPast = false
  });

  Widget? getInformationCard() {
    if (item is Accommodation) return EventAccomodationCard(data: item as Accommodation);
    if (item is Event) return EventCard(data: item as Event);
    if (item is TransportationFlight || item is TransportationTrain) return EventTransportationCard(data: item);

    return null;
  }

  IconData getEventIcon() {
    if (item is Accommodation) return Icons.hotel;
    if (item is Event) return Icons.meeting_room;
    if (item is TransportationFlight) return Icons.flight;
    if (item is TransportationTrain) return Icons.train;

    return Icons.info;
  }
  
  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst, 
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 35,
        height: 35,
        drawGap: true,
        indicatorXY: 0.1,
        indicator: Icon(getEventIcon())
      ),
      alignment: TimelineAlign.manual,
      lineXY: 0.17,
      startChild: Container(
          alignment: const Alignment(0.0, -.9),
          child: const Text(
            '07/25',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)
          ),
        ),
      endChild: Column(
        children: [
          Card(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: getInformationCard()
            ),
          ),
          if (!isLast) ...[const SizedBox(height: 5,)]
        ],
      ),
    );
  }
}