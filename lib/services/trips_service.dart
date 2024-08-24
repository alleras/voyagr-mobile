import 'dart:convert';

import 'package:voyagr_mobile/services/base_api_service.dart';
import 'package:voyagr_mobile/models/trip_model.dart';

class TripsService extends BaseApiService {

  Future<Trip> getTrip(int tripId) async {
    final response = await client.get(
      Uri.parse('$endpoint/trips/$tripId'), 
      headers: defaultHeaders
    );

    if(response.statusCode != 200) {
      throw Exception('Error retrieving Trip.');
    }
    else if (response.statusCode == 404){
      throw Exception('Trip not found.');
    }

    return Trip.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Trip>> getAllTrips(int userId) async {
    final response = await client.get(
      Uri.parse('$endpoint/trips?user_id=$userId'), 
      headers: defaultHeaders
    );

    if(response.statusCode != 200) {
      throw Exception('Error retrieving Trip List.');
    }

    return [];//Trip.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  void addTrip(Trip trip) async {
  }
}