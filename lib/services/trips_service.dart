import 'dart:convert';

import 'package:voyagr_mobile/services/base_api_service.dart';
import 'package:voyagr_mobile/models/trip_model.dart';

class TripsService extends BaseApiService {

  Future<Trip> getTrip(int tripId) async {
    final response = await client.get(
      Uri.parse('$endpoint/getTrip/$tripId'), 
      headers: defaultHeaders
    );

    if(response.statusCode != 200)
      throw Exception('Error retrieving Trip.');

    return Trip.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Trip>> getAllTrips() async {
    final response = await client.get(
      Uri.parse('$endpoint/getTrips'), 
      headers: defaultHeaders
    );

    if(response.statusCode != 200)
      throw Exception('Error retrieving Trip List.');

    return [];//Trip.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}