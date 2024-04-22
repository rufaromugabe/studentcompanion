import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_companion/Departments.dart';
import 'package:slider_button/slider_button.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/time.jpg'), // Replace this URL with your image URL
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
              ),
              Text(
                'NB. This App is Still in Demo !\n   Timetable App By Spyware',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 70,
              ),
              SliderButton(
                action: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DepartmentList()),
                  );
                  return false;
                },
                label: Text(
                  "Slide to Proceed",
                  style: TextStyle(
                      color: Color(0xff4a4a4a),
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
                icon: Center(
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
