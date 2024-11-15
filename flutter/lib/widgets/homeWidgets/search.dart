import 'package:challange_kide/services/api_service.dart';
import 'package:challange_kide/widgets/home.dart';
import 'package:flutter/material.dart';
import 'challenge.dart'; // Import your HomeScreen class

class searcheScreen extends StatefulWidget {
  const searcheScreen({super.key});

  @override
  _searcheScreenState createState() => _searcheScreenState();
}

class _searcheScreenState extends State<searcheScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Challenge>> challengesFuture;

  @override
  void initState() {
    super.initState();
    challengesFuture = apiService.fetchChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(100.0), // Set the desired height here
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            width: double.infinity, // Make the container span the full width
            child: AppBar(
              backgroundColor:
                  const Color.fromARGB(255, 255, 255, 255), // Remove shadow
              title: const Align(
                alignment: Alignment.center,
                child: Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(255, 70, 98, 255)),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<Challenge>>(
              future: challengesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No challenges found'));
                } else {
                  return Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final challenge = snapshot.data![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChallengeScreen(challenge: challenge),
                                ),
                              );
                            },
                            child: Container(
                              height: 160,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(234, 244, 255, 1),
                                border:
                                    Border.all(color: const Color(0xFFE0E0E0)),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 130,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            'http://192.168.1.12:8000/uploads/images/${challenge.imageFileName}',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              challenge.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              challenge.description,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            // Remove redundant Row or use for additional data
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
