import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String API_BASE_URI  = dotenv.env['API_BASE_URI']!;
  static String API_KEY = dotenv.env['API_KEY']!;
}
