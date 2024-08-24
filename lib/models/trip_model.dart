class Trip {
  int id;
  String? name;
  DateTime? startDate, endDate;
  int? ownerId;

  Trip.fromJson(Map<String, dynamic> json):
    id = json['data']['id'] as int,
    name = json['data']['name'] as String,
    startDate = DateTime.parse(json['data']['start']),
    ownerId = json['data']['owner'] as int;
}