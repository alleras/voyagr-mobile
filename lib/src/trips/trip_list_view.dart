import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings/settings_view.dart';
import '../../components/trip_card.dart';
import '../trips/trip_setup_view.dart';
import 'package:voyagr_mobile/providers/trips_provider.dart';

class TripListView extends StatefulWidget {
  const TripListView({super.key});

  static const routeName = '/triplist';

  @override
  State<TripListView> createState() => _TripListViewState();
}

class _TripListViewState extends State<TripListView> {
  int currentPageIndex = 0;
  @override
  void initState() {
    super.initState();
    Provider.of<TripsProvider>(context, listen: false).loadAllTrips("28");
  }

  Widget buildTripPage(TripsProvider tripProvider) {
    return Consumer<TripsProvider>(
      builder: (context, tripProvider, child){
        var tripList = tripProvider.trips;

        if (tripList.isEmpty) return const Text('No data');

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
          restorationId: 'tripListView',
          itemCount: tripList.length,
          itemBuilder: (BuildContext context, int i) {
            return TripCard(tripData: tripList[i],);
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    var tripsProvider = context.watch<TripsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voyagr'),
        actions: [
          if (currentPageIndex == 0) ...[
          TextButton(
            child: const Text('Refresh'),
            onPressed: () {
              tripsProvider.loadAllTrips("28");
            },
          )],
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
        buildTripPage(tripsProvider),
        const Center(child: Text('Work in Progress: Profile page', textAlign: TextAlign.center,)),
      ][currentPageIndex],

      floatingActionButton: Visibility(
        visible: currentPageIndex == 0,
        child: FloatingActionButton.extended(
          heroTag: 'tripListView',
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const TripSetupView()
              )
            );
          },
          label: const Text('Add Trip'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
