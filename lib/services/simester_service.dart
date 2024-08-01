import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../utils/color_utils.dart';

class AppointmentService {
  static const _cacheKey = 'simester_cache';

  static Future<List<Appointment>> fetchAppointmentsOfflineOrOnline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      final List<dynamic> responseData = json.decode(cachedData);
      return responseData
          .map((data) => Appointment(
                startTime:
                    DateTime.fromMillisecondsSinceEpoch(data['startTime']),
                endTime: DateTime.fromMillisecondsSinceEpoch(data['endTime']),
                subject: data['subject'],
                recurrenceRule: data['reccurenceRule'],
                color: generateDarkColor().withOpacity(1.0),
                isAllDay: false,
              ))
          .toList();
    } else {
      return fetchAppointmentsFromApi();
    }
  }

  static Future<List<Appointment>> fetchAppointmentsFromApi() async {
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbxJ15Jw0E0BRsQNuybvMf2vL24CqrYTt8ScxOKrpsacumyqViPlMV3F4XgTrZGh_Zd6wQ/exec'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, response.body);
      return responseData
          .map((data) => Appointment(
                startTime:
                    DateTime.fromMillisecondsSinceEpoch(data['startTime']),
                endTime: DateTime.fromMillisecondsSinceEpoch(data['endTime']),
                subject: data['subject'],
                recurrenceRule: data['reccurenceRule'],
                color: generateDarkColor().withOpacity(1.0),
                isAllDay: false,
              ))
          .toList();
    } else {
      throw Exception('Network error occurred!');
    }
  }
}
