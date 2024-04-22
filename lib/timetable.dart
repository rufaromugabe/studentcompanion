import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class timetable extends StatefulWidget {
  final String? departmentCode;
  final String? departmentName;
  timetable({Key? key, this.departmentCode, this.departmentName})
      : super(key: key);

  @override
  _timetableState createState() => _timetableState();
}

class _timetableState extends State<timetable> {
  late Future<List<Appointment>> _appointmentsFuture;
  late String _cacheKey;

  @override
  void initState() {
    super.initState();
    _cacheKey = 'timetable_cache_' + widget.departmentCode!;
    _appointmentsFuture = _fetchAppointmentsOfflineOrOnline();
  }

  Future<List<Appointment>> _fetchAppointmentsOfflineOrOnline() async {
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
      return _fetchAppointmentsFromApi();
    }
  }

  List<TimeRegion> _getTimeRegions() {
    final List<TimeRegion> regions = <TimeRegion>[];
    regions.add(TimeRegion(
        startTime: DateTime(2024, 1, 01, 10, 0, 0),
        endTime: DateTime(2024, 1, 01, 10, 15, 0),
        recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MON,TUE,WED,THU,FRI',
        text: ".",
        color: Colors.blue.withOpacity(0.5),
        enablePointerInteraction: true,
        textStyle: TextStyle(
          color: Colors.black,
        )));
    regions.add(TimeRegion(
        startTime: DateTime(2024, 1, 01, 13, 0, 0),
        endTime: DateTime(2024, 1, 01, 14, 0, 0),
        recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MON,TUE,WED,THU,FRI',
        text: "Lunch",
        color: Colors.blue.withOpacity(0.5),
        enablePointerInteraction: true,
        textStyle: TextStyle(
          color: Colors.black,
        )));

    return regions;
  }

  Future<List<Appointment>> _fetchAppointmentsFromApi() async {
    final _cacheKey = 'timetable_cache_' + widget.departmentCode!;

    final response = await http.get(Uri.parse(
        'https://x8ki-letl-twmt.n7.xano.io/api:XOmrzuME/' +
            widget.departmentCode!));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 1, 21, 52),
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            widget.departmentName!,
            style: TextStyle(color: Colors.white),
          )),
      body: Center(
        child: FutureBuilder<List<Appointment>>(
          future: _appointmentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset(
                  'assets/loading.gif',
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Failed to Load Timetable');
            } else if (snapshot.hasData) {
              return SfCalendarTheme(
                data: SfCalendarThemeData(
                    todayHighlightColor: Colors.red,
                    viewHeaderDateTextStyle: TextStyle(color: Colors.white),
                    viewHeaderDayTextStyle: TextStyle(color: Colors.white),
                    timeIndicatorTextStyle: TextStyle(color: Colors.red),
                    viewHeaderBackgroundColor: Colors.deepPurple),
                child: SfCalendar(
                  view: CalendarView.workWeek,
                  showCurrentTimeIndicator: true,
                  allowedViews: [
                    CalendarView.day,
                    CalendarView.workWeek,
                    CalendarView.timelineDay,
                    CalendarView.timelineWeek,
                  ],
                  timeSlotViewSettings: TimeSlotViewSettings(
                      timeIntervalHeight: 60,
                      timeIntervalWidth: 50,
                      startHour: 8,
                      endHour: 16,
                      nonWorkingDays: <int>[
                        DateTime.saturday,
                        DateTime.sunday
                      ]),
                  firstDayOfWeek: 6,
                  specialRegions: _getTimeRegions(),
                  dataSource: MeetingDataSource(snapshot.data!),
                ),
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

Color generateDarkColor() {
  // Generate a random double between 0 (inclusive) and 0.5 (exclusive)
  final double randomDouble = Random().nextDouble() * 0.5;

  // Convert the double to an opacity value (0.0 to 1.0) suitable for dark colors
  final double opacity = randomDouble;

  // Set the red, green, and blue components to random values between 0 and 127 (inclusive)
  final int red = Random().nextInt(128);
  final int green = Random().nextInt(128);
  final int blue = Random().nextInt(128);

  // Combine the components and opacity into a single ARGB color value
  return Color.fromARGB((opacity * 255).toInt(), red, green, blue);
}
