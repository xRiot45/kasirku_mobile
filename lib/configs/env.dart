import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config{
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  static String get apiUrl{
    return dotenv.env['API_URL'] ?? 'No API URL Found';
  }
}