abstract class ItineraryItem { }

class Accommodation implements ItineraryItem {
  static const type = 'accomodation';

  String? title, address, paymentStatus, notes;
  DateTime? checkIn, checkOut; 
}

class TransportationFlight implements ItineraryItem {
  static const type = 'transportation-flight';

  String? from, to, address, status, gate, seat, notes;
  DateTime? departure, arrival;
}

class TransportationTrain implements ItineraryItem {
  static const type = 'transportation-train';

  String? from, to, address, platform, seat, notes;
  DateTime? departure, arrival;
}

class Event implements ItineraryItem {
  static const type = 'event';
  String? address, notes;
}

class Trip {
  String id;
  String? name;
  DateTime? startDate, endDate;
  String? ownerId;

  List<ItineraryItem>? itinerary;

  Trip.fromJson(Map<String, dynamic> json):
    id = json['data']['ID'] as String,
    name = json['data']['Name'] as String,
    startDate = DateTime.parse(json['data']['Start']),
    ownerId = json['data']['Owner'] as String
  {
    itinerary = [];
    
    List<dynamic> jsonItinerary = json['data']['Itinerary'];

    for (Map<String, dynamic> item in jsonItinerary) 
    {      
      if (!item.containsKey('type')) continue;

      switch (item['type'] as String) {
        case Accommodation.type: itinerary!.add(Accommodation());
        case TransportationFlight.type: itinerary!.add(TransportationFlight());
        case TransportationTrain.type: itinerary!.add(TransportationTrain());
        case Event.type: itinerary!.add(Event());
          break;
        default:
      }
    }
  }
}