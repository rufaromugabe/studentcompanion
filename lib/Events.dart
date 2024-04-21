import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flip_card/flip_card.dart';
import 'package:shimmer/shimmer.dart';

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
            return ListView.builder(
              itemCount: 5, // number of shimmer items you want to show
              itemBuilder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.grey[600]!,
                highlightColor: Colors.grey!,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  borderOnForeground: true,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
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
                    color: Color.fromARGB(255, 25, 1, 66),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                          color: Color.fromARGB(255, 30, 1, 81), width: 5.0),
                    ),
                    borderOnForeground: true,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 200,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child:
                                Image.network(event['Link'], fit: BoxFit.cover),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            event['Name'],
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                          subtitle: Text(
                            'Date: ${event['Date']}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  back: Card(
                    color: Color.fromARGB(255, 1, 21, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.amber, width: 5.0),
                    ),
                    borderOnForeground: true,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 265,
                          width: double.infinity,
                          child: ListTile(
                            title: Text(
                              '${event['Name']} Details',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                            subtitle: Text(event['Details']),
                          ),
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
