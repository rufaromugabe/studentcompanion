import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';
import 'package:student_companion/Departments.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/time.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 150,
              ),
              const Text(
                'NB. This App is Still in Demo !\n   Timetable App By Spyware',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 70,
              ),
              SliderButton(
                action: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DepartmentList()),
                  );
                  return false;
                },
                label: const Text(
                  "Slide to Proceed",
                  style: TextStyle(
                      color: Color(0xff4a4a4a),
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
                icon: const Center(
                    child: Icon(
                  CupertinoIcons.time,
                  color: Colors.deepPurpleAccent,
                  size: 30.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                )),
                boxShadow: BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
