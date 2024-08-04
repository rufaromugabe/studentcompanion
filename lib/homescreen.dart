import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_companion/Departments.dart';
import 'package:student_companion/Events.dart';
import 'package:student_companion/about.dart';
import 'package:student_companion/main.dart';
import 'package:student_companion/screens/schedule_screen.dart';

class Feature {
  final String name;
  final IconData icon;
  final Widget screen;

  Feature({required this.name, required this.icon, required this.screen});
}

final List<Feature> features = [
  Feature(
      name: 'Timetable', icon: Icons.timelapse, screen: const DepartmentList()),
  Feature(
      name: 'Events Diary', icon: Icons.event, screen: const ScheduleScreen()),
  Feature(
      name: 'Noticeboard',
      icon: Icons.notification_important,
      screen: EventsPage()),
  Feature(name: 'About Us', icon: Icons.info, screen: const AboutPage()),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;

  final List<String> imgList = [
    'assets/time2.jpg',
    'assets/time3.jpg',
    'assets/time5.jpg'
  ];

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
          'You are currently offline. Get connected to the internet to refresh the app data.',
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
        prefs.clear();
        setState(() {
          loading = false;
        });
        print('Cache cleared');
      } else {}
    } catch (e) {
      setState(() {
        loading = false;
      });
      showNoInternetDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 1, 21, 52),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
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
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: imgList
                .map((item) => Container(
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset(
                            item,
                            fit: BoxFit.cover,
                            width: 300,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10.0),
          Center(
              child: SizedBox(
            height: 50.0,
            width: 200.0,
            child: ElevatedButton(
              onPressed: () {
                _refreshAllCache();
                setState(() {
                  loading = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeData().splashColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Refresh App Data'),
            ),
          )),
          const SizedBox(height: 10.0),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 10.0,
                  mainAxisExtent: 150.0,

                  mainAxisSpacing: 10.0,
                ),
                itemCount: features.length,
                itemBuilder: (context, index) {
                  final feature = features[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => feature.screen),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 236, 174, 3),
                            Color.fromARGB(255, 198, 179, 7)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 173, 143, 196)
                                .withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(feature.icon, size: 50.0),
                          const SizedBox(height: 10.0),
                          Text(feature.name,
                              style: const TextStyle(fontSize: 16.0)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
