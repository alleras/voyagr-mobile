import 'package:voyagr_mobile/models/trip_model.dart';
import 'package:voyagr_mobile/providers/base_provider.dart';
import 'package:voyagr_mobile/services/trips_service.dart';

class TripsProvider extends BaseProvider {
  TripsProvider({required super.context});

  Future<Trip?> loadTrip(String id) async {
    try{
      var service = TripsService();
      final Trip trip = await service.getTrip(id);
      notifyListeners();
      return trip;
    } 
    catch(e) {
      showError(e.toString());
      return null;
    }
  }
}