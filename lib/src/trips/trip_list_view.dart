import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyagr_mobile/providers/users_provider.dart';
import 'package:voyagr_mobile/src/account/account_view.dart';

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
    var email = Provider.of<UsersProvider>(context, listen: false).currentUser!.email;
    Provider.of<TripsProvider>(context, listen: false).loadAllTrips(email);
  }

  Widget buildTripPage(TripsProvider tripProvider) {
    return Consumer<TripsProvider>(
      builder: (context, tripProvider, child){
        var tripList = tripProvider.trips;

        if (tripList.isEmpty) return const Center(child: Text('There are no trips yet. Use the "Add Trip" button to start.'));

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
          restorationId: 'tripListView',
          itemCount: tripList.length,
          itemBuilder: (BuildContext context, int i) {
            return TripCard(tripData: tripList[i], index: i);
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    var tripsProvider = context.watch<TripsProvider>();
    var usersProvider = context.watch<UsersProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voyagr'),
        actions: [
          if (currentPageIndex == 0) ...[
          TextButton(
            child: const Text('Refresh'),
            onPressed: () {
              tripsProvider.loadAllTrips(usersProvider.currentUser!.email);
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
        AccountView(user: usersProvider.currentUser!),
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
