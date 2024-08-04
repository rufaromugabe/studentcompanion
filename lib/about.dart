import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 1, 21, 52),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'About This App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'This app is designed to provide students with an amazing experience. '
                'It is a time management app that helps users to manage their time effectively.'
                'It is still a demo app and more features will be added in the future.'
                'If you find any bugs or have any suggestions, please feel free to contact us.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text('h230275r@hit.ac.zw'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
