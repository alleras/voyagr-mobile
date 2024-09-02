import 'dart:collection';

import 'package:voyagr_mobile/models/trip_model.dart';
import 'package:voyagr_mobile/providers/base_provider.dart';
import 'package:voyagr_mobile/services/trips_service.dart';

class TripsProvider extends BaseProvider {
  TripsProvider({required super.context});

  final List<Trip> _trips = [];
  Trip? _currentTrip;

  UnmodifiableListView<Trip> get trips => UnmodifiableListView(_trips);
  Trip? get currentTrip => _currentTrip;

  void invalidateCurrentTrip() {
    _currentTrip = null;
  }

  void invalidateSession() {
    _currentTrip = null;
    _trips.clear();
  }

  Future<void> addItineraryItem(ItineraryItem item) async {
    if (_currentTrip == null) throw Exception('Cannot add itinerary item to inexistent trip');

    try{
      _currentTrip!.itinerary.add(item);
      await TripsService().updateTrip(_currentTrip!);
      _currentTrip = await TripsService().getTrip(_currentTrip!.id);
      notifyListeners();
    }
    catch(e) {
      showError(e.toString());
    }
  }

  Future<void> updateItineraryItem(ItineraryItem item, int itemIndex) async {
    if (_currentTrip == null) throw Exception('Cannot update itinerary item on inexistent trip');

    try{
      _currentTrip!.itinerary[itemIndex] = item;
      await TripsService().updateTrip(_currentTrip!);
      _currentTrip = await TripsService().getTrip(_currentTrip!.id);
      notifyListeners();
    }
    catch(e) {
      showError(e.toString());
    }
  }

  Future<void> removeItineraryItem(int itemIndex) async {
    if (_currentTrip == null) throw Exception('Cannot remove itinerary item on inexistent trip');

    try {
      _currentTrip!.itinerary.removeAt(itemIndex);
      await TripsService().updateTrip(_currentTrip!);
      _currentTrip = await TripsService().getTrip(_currentTrip!.id);
      notifyListeners();
    }
    catch(e) {
      showError(e.toString());
    }
  }

  Future<Trip?> loadTrip(String id) async {
    try{
      final Trip trip = await TripsService().getTrip(id);

      _currentTrip = trip;
      notifyListeners();
      return trip;
    } 
    catch(e) {
      showError(e.toString());
      return null;
    }
  }

  Future<List<Trip>> loadAllTrips(String owner) async {
    try{
      var service = TripsService();
      final List<Trip> tripList = await service.getAllTrips(owner);

      _trips.clear();
      _trips.addAll(tripList);

      notifyListeners();

      return tripList;
    } 
    catch(e) {
      showError(e.toString());
      return [];
    }
  }

  Future<Trip?> addTrip(String owner, tripName, DateTime startDate, [String? description]) async{
    try{
      var trip = await TripsService().addTrip(owner, tripName, startDate, description);
      _trips.add(trip);

      notifyListeners();

      return trip;
    }
    catch(e){
      showError(e.toString());
      return null;
    }
  }

  Future<void> updateTrip(Trip tripData) async {
    try{
      await TripsService().updateTrip(tripData);
      _trips[_trips.indexOf(_trips.where((trip) => trip.id == tripData.id).first)] = tripData;

      notifyListeners();
    }
    catch(e){
      showError(e.toString());
    }
  }

  Future<void> deleteTrip(String id) async {
    try{
      await TripsService().deleteTrip(id);
      _trips.remove(_trips.where((trip) => trip.id == id).first);

      showInformation("Trip removed");

      notifyListeners();
    }
    catch(e) {
      showError(e.toString());
    }
  }
}