class Trip {
  String tripId;

  Trip.fromJson(Map<String, dynamic> json):
    tripId = json['id'] as String;
}