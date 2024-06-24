import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_elastic_list_view/flutter_elastic_list_view.dart';
import 'package:http/http.dart' as http;
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:student_companion/Events.dart';
import 'package:student_companion/main.dart';
import 'package:student_companion/screens/schedule_screen.dart';
import 'package:student_companion/timetable.dart';

class DepartmentList extends StatefulWidget {
  const DepartmentList({super.key});

  @override
  _DepartmentListState createState() => _DepartmentListState();
}

class _DepartmentListState extends State<DepartmentList> {
  Future<List<dynamic>> _fetchDepartmentsFromApi() async {
    const cacheKey = 'departments_cache';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(cacheKey) != null) {
      return json.decode(prefs.getString(cacheKey)!);
    } else {
      final response = await http.get(Uri.parse(
          'https://script.googleusercontent.com/macros/echo?user_content_key=2y_4S9PzfXC6MyRRZFtRJr8QOlkWLCL5RZ_RYQGEhVPqUh1W-nsNF15gfC_WB80Ashe545s2yk0EGFuFvjb5cs_45q4Qugc4m5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnMwsCG3c3bDiFCkSmwiX76Qh40QndxLXRyGMlJWbMHwdWPLwC7ch20rrR9UJYVyx7oBX4sJHdEJ_zSgxZLd3nxkZYVCAAs03Ktz9Jw9Md8uu&lib=M6NEMZODtH7M_wApyPI_9z0WkH33IFIqp'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        await prefs.setString(cacheKey, json.encode(responseData));

        return responseData;
      } else {
        throw Exception(
            'Failed to load departments. Status Code: ${response.statusCode}, Details: ${response.body}');
      }
    }
  }

  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Text(
              'No Internet !',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        content: const Text(
          'You are currently offline. This feature requires an internet connection to function properly.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshAllCache() async {
    try {
      final response = await http
          .get(Uri.parse(
              'https://script.googleusercontent.com/macros/echo?user_content_key=2y_4S9PzfXC6MyRRZFtRJr8QOlkWLCL5RZ_RYQGEhVPqUh1W-nsNF15gfC_WB80Ashe545s2yk0EGFuFvjb5cs_45q4Qugc4m5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnMwsCG3c3bDiFCkSmwiX76Qh40QndxLXRyGMlJWbMHwdWPLwC7ch20rrR9UJYVyx7oBX4sJHdEJ_zSgxZLd3nxkZYVCAAs03Ktz9Jw9Md8uu&lib=M6NEMZODtH7M_wApyPI_9z0WkH33IFIqp'))
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear(); // This will clear all data in SharedPreferences
        setState(() {});
      } else {
        showNoInternetDialog(context);
        setState(() {});
      }
    } on TimeoutException catch (_) {
      // Handle timeout exception
      showNoInternetDialog(context);
      setState(() {});
    } catch (e) {
      // Handle other exceptions
      showNoInternetDialog(context);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              const Text('Departments', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 1, 21, 52),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LiteRollingSwitch(
                value: Theme.of(context).brightness == Brightness.light,
                width: 100,
                textOn: 'Light',
                textOff: 'Dark',
                colorOn: Colors.amber,
                colorOff: const Color.fromARGB(255, 31, 28, 28),
                iconOn: Icons.wb_sunny,
                iconOff: Icons.nights_stay,
                onTap: () {},
                onChanged: (bool isOn) {
                  Provider.of<ThemeNotifier>(context, listen: false)
                      .toggleTheme();
                },
                onDoubleTap: () {},
                onSwipe: () {},
              ),
            ),
            IconButton(
              iconSize: 40,
              icon: const Icon(
                Icons.refresh,
              ),
              tooltip: ('Refresh'),
              onPressed: _refreshAllCache,
            ),
          ]),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 1, 5, 35).withOpacity(0.8),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 1, 21, 52),
                  ),
                  child: Text('Menu', style: TextStyle(color: Colors.white))),
            ),

            ListTile(
              title: const Text('Reload Data'),
              leading: const Icon(Icons.refresh, size: 40),
              onTap: () async {
                Navigator.pop(context);
                await _refreshAllCache();
              },
            ),
            ListTile(
              title: const Text('University Schedule'),
              leading: const Icon(Icons.home, size: 40),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScheduleScreen()));
              },
            ),
            ListTile(
              title: const Text('Events'),
              leading: const Icon(Icons.home, size: 40),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EventsPage()));
              },
            ),
            // Add more ListTiles for more departments
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAllCache,
        child: FutureBuilder<List<dynamic>>(
          future: _fetchDepartmentsFromApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                  itemCount: 20, // number of shimmer items you want to show
                  itemBuilder: (_, __) => Shimmer.fromColors(
                        baseColor: Colors.grey[600]!,
                        highlightColor: Colors.grey,
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16)),
                          child: const ListTile(),
                        ),
                      ));
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Failed to load departments${snapshot.error}'));
            } else {
              return ElasticListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var department = snapshot.data?[index];
                  return Container(
                    height: 50,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber[(index % 9 + 3) * 100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: Text(
                        department['Dname'],
                        style: const TextStyle(color: Colors.black),
                      ),
                      leading: const Icon(Icons.collections_bookmark),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => timetable(
                              departmentCode: department['code'],
                              departmentName: department['Dname'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
