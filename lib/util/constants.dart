import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String API_BASE_URI  = dotenv.env['API_BASE_URI']!;
  static String API_KEY = dotenv.env['API_KEY']!;
  static String PROFILE_PLACEHOLDER_URL = 'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=';
}
