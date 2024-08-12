import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'event_card.dart';

class EventTile extends StatelessWidget {
  final bool isFirst, isLast, isPast;

  const EventTile({
    super.key, 
    this.isFirst = false, 
    this.isLast = false, 
    this.isPast = false
  });
  
  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst, 
      isLast: isLast,
      indicatorStyle: const IndicatorStyle(
        width: 35,
        height: 35,
        drawGap: true,
        indicatorXY: 0,
        indicator: Icon(Icons.hotel)
      ),
      alignment: TimelineAlign.manual,
      lineXY: 0.17,
      startChild: Container(
          alignment: const Alignment(0.0, -.9),
          child: Text(
            '07/25',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300)
          ),
        ),
      endChild: EventCard(),  
    );
  }
}