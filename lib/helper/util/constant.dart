import 'package:shared_preferences/shared_preferences.dart';

class Constant {
  static String baseUrl =
      'https://apigenerator.dronahq.com/api/g7s7P925/TestAlan/';
  static String addUrl =
      'https://apigenerator.dronahq.com/api/g7s7P925/TestAlan';
  static String token =
      '\$2a\$16\$TlB6hYDRMSF5HBgxImeaU.itfBOu881/lI4mSPMR0jYRnMXklQKp6';

  static Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, value);
  }

  static Future<List<String>> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getStringList(key);
    return res ?? [];
  }
}
