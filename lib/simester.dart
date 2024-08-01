import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'services/simester_service.dart';

class SimesterScreen extends StatefulWidget {
  final String? departmentCode;
  final String? departmentName;
  const SimesterScreen({super.key, this.departmentCode, this.departmentName});

  @override
  _SimesterScreenState createState() => _SimesterScreenState();
}

class _SimesterScreenState extends State<SimesterScreen> {
  late Future<List<Appointment>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = AppointmentService.fetchAppointmentsOfflineOrOnline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 1, 21, 52),
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Simster Schedule',
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
              return const Text('Failed to Load Schedule');
            } else if (snapshot.hasData) {
              return SfCalendarTheme(
                data: const SfCalendarThemeData(
                    todayHighlightColor: Colors.red,
                    viewHeaderDateTextStyle: TextStyle(color: Colors.white),
                    viewHeaderDayTextStyle: TextStyle(color: Colors.white),
                    timeIndicatorTextStyle: TextStyle(color: Colors.red),
                    viewHeaderBackgroundColor: Colors.deepPurple),
                child: SfCalendar(
                  view: CalendarView.schedule,
                  showCurrentTimeIndicator: true,
                  allowedViews: const [
                    CalendarView.schedule,
                  ],
                  scheduleViewMonthHeaderBuilder: (context, details) {
                    String formattedMonth =
                        DateFormat.MMMM().format(details.date);
                    int month = details.date.month;

                    String getMonthImagePath(int month) {
                      switch (month) {
                        case 1:
                          return 'assets/january2.jpg';
                        case 2:
                          return 'assets/february.jpg';
                        case 3:
                          return 'assets/march.jpg';
                        case 4:
                          return 'assets/april.jpg';
                        case 5:
                          return 'assets/may.jpg';
                        case 6:
                          return 'assets/june.jpg';
                        case 7:
                          return 'assets/july.jpg';
                        case 8:
                          return 'assets/august.jpg';
                        case 9:
                          return 'assets/september.jpg';
                        case 10:
                          return 'assets/october.jpg';
                        case 11:
                          return 'assets/november.jpg';
                        case 12:
                          return 'assets/december.jpg';
                        default:
                          return 'assets/time.jpg';
                      }
                    }

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            child: Image.asset(
                              getMonthImagePath(month),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  timeSlotViewSettings: const TimeSlotViewSettings(
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
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
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
        textStyle: const TextStyle(
          color: Colors.black,
        )));
    regions.add(TimeRegion(
        startTime: DateTime(2024, 1, 01, 13, 0, 0),
        endTime: DateTime(2024, 1, 01, 14, 0, 0),
        recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MON,TUE,WED,THU,FRI',
        text: "Lunch",
        color: Colors.blue.withOpacity(0.5),
        enablePointerInteraction: true,
        textStyle: const TextStyle(
          color: Colors.black,
        )));

    return regions;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
