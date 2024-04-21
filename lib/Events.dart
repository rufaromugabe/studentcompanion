import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flip_card/flip_card.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  Future<List> _fetchEventsFromApi() async {
    final response = await http.get(
      Uri.parse('https://x8ki-letl-twmt.n7.xano.io/api:XOmrzuME/events'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 1, 21, 52),
      ),
      body: FutureBuilder<List>(
        future: _fetchEventsFromApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var event = snapshot.data?[index];
                return FlipCard(
                  direction: FlipDirection.HORIZONTAL, // default
                  front: Card(
                    color: Color.fromARGB(255, 1, 21, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    borderOnForeground: true,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 200, // specify the height of the image
                          width: double
                              .infinity, // it will take the full width of the card
                          child:
                              Image.network(event['Link'], fit: BoxFit.cover),
                        ),
                        ListTile(
                          title: Text(event['Name']),
                          subtitle: Text(
                            'Date: ${event['Date']}}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  back: Card(
                    color: Color.fromARGB(255, 1, 21, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    borderOnForeground: true,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text('${event['Name']} Details'),
                          subtitle: Text(event['Details']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
