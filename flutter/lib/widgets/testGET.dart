import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

Future<List<dynamic>> fetchData() async {
  final client = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Bypass SSL verification
  
  final request = await client.getUrl(Uri.parse('https://10.0.2.2:8000/api/challenge')); // Use HTTPS
  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();

  if (response.statusCode == 200) {
    return json.decode(responseBody);
  } else {
    print('Failed to load data: ${response.statusCode} ${responseBody}'); // Debugging information
    throw Exception('Failed to load data');
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late Future<List<dynamic>> fetchDataFuture;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Widget'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                return Column(
                children: [
                  Text(item['title'] ?? 'No name available'),
                  Text(item['description'] ?? 'No description available'),
                ],

              );

              },
            );
          }
        },
      ),
    );
  }
}
