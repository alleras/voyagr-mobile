import 'dart:convert';

import 'package:voyagr_mobile/services/base_api_service.dart';
import 'package:voyagr_mobile/models/trip_model.dart';

class TripsService extends BaseApiService {

  Future<Trip> getTrip(String tripId) async {
    final response = await client.get(
      Uri.parse('$endpoint/trips/$tripId'), 
      headers: defaultHeaders
    );

    if (response.statusCode == 404){
      throw Exception('Trip not found.');
    }
    else if(response.statusCode != 200) {
      throw Exception('Error retrieving Trip.');
    }
    
    return Trip.fromJson((jsonDecode(response.body) as Map<String, dynamic>)['data']);
  }

  Future<List<Trip>> getAllTrips(String userId) async {
    final response = await client.get(
      Uri.parse('$endpoint/trips?user_id=$userId'), 
      headers: defaultHeaders
    );

    if(response.statusCode != 200) {
      throw Exception('Error retrieving Trip List.');
    }

    var jsonTrips = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
    List<Trip> result = [];

    for (Map<String, dynamic> trip in jsonTrips){
      result.add(Trip.fromJson(trip));
    }

    return result;//Trip.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Trip> addTrip(String owner, tripName, DateTime startDate, [String? description]) async {
    final response = await client.post(
      Uri.parse('$endpoint/trips/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic> {
        'Name': tripName,
        'Owner': owner,
        'Start': startDate.toString(),
        'End': startDate.toString(),
        'Description': description ?? '',
        'SharedWith': [],
        'Itinerary': [],
      })
    );

    if (response.statusCode == 201) {
      return Trip.fromJson((jsonDecode(response.body) as Map<String, dynamic>)['data']);
    } else {
      throw Exception("Error creating trip: ${response.body}");
    }
  }

  Future<void> updateTrip(Trip tripData) async {
    var json = tripData.toJson();

    final response = await client.patch(
      Uri.parse('$endpoint/trips/${tripData.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(json)
    );

    if (response.statusCode != 200) throw Exception("Error updating Trip: ${response.body}");
  }

  Future<void> deleteTrip(String tripId) async {
    final response = await client.delete(
      Uri.parse('$endpoint/trips/$tripId')
    );

    if (response.statusCode != 204) {
      throw Exception("Failed to delete Trip with ID: $tripId");
    }
  }
}