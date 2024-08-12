import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key});

  final String text = '';
  
  @override
  Widget build(BuildContext context) {
    return Flex(
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: Axis.vertical,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amazing Event',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
              Text(
                'Reservation - 10:25 PM',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w100)
              ),
              const SizedBox(height: 5,),
              Text('123 Amazing St'),
              Text('Charleston, SC 29406'),
              SizedBox(height: 8),
              ElevatedButton(onPressed: null, child: Text('View Ticket')),
            ],
          ),
        )
      ],);
  } 
}