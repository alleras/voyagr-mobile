import 'package:flutter/material.dart';

import 'package:voyagr_mobile/models/trip_model.dart';

import '../settings/settings_view.dart';
import '../../components/trip_card.dart';
import '../trips/trip_setup_view.dart';

class TripListView extends StatefulWidget {
  const TripListView({super.key});

  static const routeName = '/triplist';

  @override
  _TripListViewState createState() => _TripListViewState();
}

class _TripListViewState extends State<TripListView> {
  int currentPageIndex = 0;

  late Future<List<Trip>> tripList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voyagr'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.flight),
            label: 'Trips',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),

      body: <Widget>[

        ListView.builder(
          padding: const EdgeInsets.all(20),
          restorationId: 'tripListView',
          itemCount: 3,
          itemBuilder: (BuildContext context, int i) {
            return const TripCard();
          },
        ),

        const Text('Hello World'),
      ][currentPageIndex],

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => TripSetupView()
            )
          );
        },
        label: const Text('Add Trip'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
