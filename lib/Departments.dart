import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_elastic_list_view/flutter_elastic_list_view.dart';
import 'package:student_companion/main.dart';
import 'package:student_companion/timetable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DepartmentList extends StatefulWidget {
  @override
  _DepartmentListState createState() => _DepartmentListState();
}

class _DepartmentListState extends State<DepartmentList> {
  bool _isDarkTheme = false;
  Future<List<dynamic>> _fetchDepartmentsFromApi() async {
    final _cacheKey = 'departments_cache';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_cacheKey) != null) {
      return json.decode(prefs.getString(_cacheKey)!);
    } else {
      final response = await http.get(
          Uri.parse('https://x8ki-letl-twmt.n7.xano.io/api:XOmrzuME/ict_dep'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        await prefs.setString(_cacheKey, json.encode(responseData));

        return responseData;
      } else {
        throw Exception('Failed to load departments');
      }
    }
  }

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
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
        content: Text(
          'You are currently offline. This feature requires an internet connection to function properly.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshAllCache() async {
    try {
      final response = await http
          .get(Uri.parse(
              'https://x8ki-letl-twmt.n7.xano.io/api:XOmrzuME/ict_dep'))
          .timeout(Duration(seconds: 10));

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
          title: Text('Departments', style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 1, 21, 52),
          actions: <Widget>[
            Switch(
              value: Provider.of<ThemeNotifier>(context).darkTheme,
              onChanged: (value) {
                Provider.of<ThemeNotifier>(context, listen: false)
                    .toggleTheme();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: _refreshAllCache,
            ),
          ]),
      body: RefreshIndicator(
        onRefresh: _refreshAllCache,
        child: FutureBuilder<List<dynamic>>(
          future: _fetchDepartmentsFromApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load departments'));
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
                        style: TextStyle(color: Colors.black),
                      ),
                      leading: Icon(Icons.collections_bookmark),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => timetable(
                              departmentCode: department['Code'],
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
