abstract class ItineraryItem { }

class Accommodation implements ItineraryItem {
  static const type = 'accommodation';

  String title, address;
  String? paymentStatus, notes;
  DateTime checkIn, checkOut; 

  Accommodation({required this.title, required this.address, required this.checkIn, required this.checkOut});

  Accommodation.fromJson(Map<String, dynamic> json): 
    title = json['Title'],
    address = json['Address'],
    paymentStatus = json['PaymentStatus'],
    notes = json['Notes'],
    checkIn = DateTime.parse(json['CheckIn']),
    checkOut = DateTime.parse(json['CheckOut']);

  Map<String, dynamic> toJson() {
    return {
      'Type': type,
      'Title': title,
      'Address': address,
      'PaymentStatus': paymentStatus,
      'Notes': notes,
      'CheckIn': checkIn.toString(),
      'CheckOut': checkOut.toString()
    };
  }
}

class TransportationFlight implements ItineraryItem {
  static const type = 'transportation-flight';

  String from, to, address;
  String? flightStatus, flightGate, seat, notes;
  DateTime departure, arrival;

  TransportationFlight({
    required this.from, 
    required this.to, 
    required this.address, 
    required this.departure, 
    required this.arrival
  });

  TransportationFlight.fromJson(Map<String, dynamic> json): 
    from = json['From'],
    to = json['To'],
    address = json['Address'],
    flightStatus = json['FlightStatus'],
    flightGate = json['FlightGate'],
    seat = json['Seat'],
    notes = json['Notes'],
    departure = DateTime.parse(json['Departure']),
    arrival = DateTime.parse(json['Arrival']);

  Map<String, dynamic> toJson() {
    return {
      'Type': type,
      'From': from,
      'To': to,
      'Address': address,
      'FlightStatus': flightStatus,
      'FlightGate': flightGate,
      'Seat': seat,
      'Notes': notes,
      'Departure': departure.toString(),
      'Arrival': arrival.toString()
    };
  }
}

class Event implements ItineraryItem {
  static const type = 'event';
  String title, address;
  String? notes;
  DateTime dateTime;

  Event.fromJson(Map<String, dynamic> json): 
    title = json['Title'],
    address = json['Address'],
    notes = json['Notes'],
    dateTime = DateTime.parse(json['EventDatetime']);

  Event({required this.title, required this.address, required this.dateTime, this.notes});

  Map<String, dynamic> toJson() {
    return {
      'Type': type,
      'Title': title,
      'Address': address,
      'Notes': notes,
      'EventDatetime': dateTime.toString()
    };
  }
}

class TransportationTrain implements ItineraryItem {
  static const type = 'transportation-train';

  String? from, to, address, platform, seat, notes;
  DateTime? departure, arrival;
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
      if (!item.containsKey('Type')) continue;

      switch (item['Type'] as String) {
        case Accommodation.type: itinerary.add(Accommodation.fromJson(item));
        case TransportationFlight.type: itinerary.add(TransportationFlight.fromJson(item));
        //case TransportationTrain.type: itinerary.add(TransportationTrain.fromJson(item));
        case Event.type: itinerary.add(Event.fromJson(item));
          break;
        default:
      }
    }
  }

   Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> jsonItinerary = [];
    for(var item in itinerary) {
      if (item is Accommodation){
        jsonItinerary.add(item.toJson());
      }
      else if (item is TransportationFlight) {
        jsonItinerary.add(item.toJson());
      }
      else if (item is Event) {
        jsonItinerary.add(item.toJson());
      }
    }

    return {
      'Name': name,
      'Owner': ownerId,
      'Start': startDate.toString(),
      'End': endDate?.toString() ?? 'TBD',
      'Description': description ?? '',
      'SharedWith': [],
      'Itinerary': jsonItinerary,
    };
  }
}