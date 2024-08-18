import 'package:http/http.dart' as http;
import 'package:voyagr_mobile/util/constants.dart';

class BaseApiService {
  var client = http.Client();

  String endpoint = Constants.API_BASE_URI;
  String apiKey = Constants.API_KEY;

  Map<String, String> defaultHeaders = 
    {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
}