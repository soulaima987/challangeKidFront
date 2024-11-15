import 'package:flutter/material.dart';
import 'package:challange_kide/services/api_service.dart';
import 'home.dart';

class favoriteScreen extends StatefulWidget {
  @override
  _favoriteScreenState createState() => _favoriteScreenState();
}

class _favoriteScreenState extends State<favoriteScreen> {
  late Future<List<String>> _topicsFuture;
  final Set<String> _selectedTopics = {};
  final ApiService apiService = ApiService();

@override
  void initState() {
    super.initState();
    _topicsFuture = apiService.fetchCategoriesRegister(); // Fetch categories on initialization
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white, // Set the background color to white
    body: Stack(
      children: [
        // Main content area
        FutureBuilder<List<String>>(
          future: _topicsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No topics available'));
            }

            final topics = snapshot.data!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top text
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Text(
                    'Select Your Topics',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                // Grid view
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of items per row
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 50 / 20,
                      ),
                      itemCount: topics.length,
                      itemBuilder: (context, index) {
                        final topic = topics[index];
                        final isSelected = _selectedTopics.contains(topic);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedTopics.remove(topic);
                              } else {
                                _selectedTopics.add(topic);
                              }
                            });
                          },
                          child: Container(
                            width: 50, // Fixed width
                            height: 20, // Fixed height
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue : Colors.grey[300],
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.grey[400]!,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12), // Optional: rounded corners
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              topic,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis, // Ensure text does not overflow
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        // Next button
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: () async {
                    bool test = await apiService.saveSelectedTopics(_selectedTopics);
                    if (test){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Your category is successfully taken')),
                      );
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomeScreen()),
                                              );
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Your category not taken')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}
