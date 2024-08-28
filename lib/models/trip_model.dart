abstract class ItineraryItem { }

class Accommodation implements ItineraryItem {
  static const type = 'accomodation';

  String? title, address, paymentStatus, notes;
  DateTime? checkIn, checkOut; 
}

class TransportationFlight implements ItineraryItem {
  static const type = 'transportation-flight';

  String? from, to, address, flightStatus, flightGate, seat, notes;
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
  String name;
  String? description;
  DateTime? startDate, endDate;
  String? ownerId;

  List<ItineraryItem> itinerary = [];

  Trip.fromJson(Map<String, dynamic> json):
    id = json['ID'] as String,
    name = json['Name'] as String,
    description = json['Description'] as String,
    startDate = DateTime.parse(json['Start']),
    ownerId = json['Owner'] as String
  { 
    List<dynamic> jsonItinerary = json['Itinerary'];

    for (Map<String, dynamic> item in jsonItinerary) 
    {      
      if (!item.containsKey('type')) continue;

      switch (item['type'] as String) {
        case Accommodation.type: itinerary.add(Accommodation());
        case TransportationFlight.type: itinerary.add(TransportationFlight());
        case TransportationTrain.type: itinerary.add(TransportationTrain());
        case Event.type: itinerary.add(Event());
          break;
        default:
      }
    }
  }

   Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> jsonItinerary = [];
    for(var item in itinerary) {
      if (item is Accommodation){
        jsonItinerary.add({
          'Title': item.title,
          'Address': item.address,
          'PaymentStatus': item.paymentStatus,
          'Notes': item.notes,
          'CheckIn': item.checkIn,
          'CheckOut': item.checkOut
        });
      }
      else if (item is TransportationFlight) {
        jsonItinerary.add({
          'From': item.from,
          'To': item.to,
          'Address': item.address,
          'FlightStatus': item.flightStatus,
          'FlightGate': item.flightGate,
          'Seat': item.seat,
          'Notes': item.notes,
          'Departure': item.departure,
          'Arrival': item.arrival
        });
      }
      else if (item is Event) {
        jsonItinerary.add({
          'Address': item.address,
          'Notes': item.notes
        });
      }
    }

    return {
      'Name': name,
      'Owner': ownerId,
      'Start': startDate.toString(),
      'End': endDate?.toString(),
      'Description': description ?? '',
      'SharedWith': [],
      'Itinerary': jsonItinerary,
    };
  }
}