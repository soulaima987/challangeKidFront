import 'package:flutter/material.dart';
import 'package:challange_kide/widgets/signIn.dart';
import 'package:challange_kide/services/api_service.dart';
import 'challenge.dart'; // Make sure to import the Post model

class ProfilePage1 extends StatefulWidget {
  const ProfilePage1({Key? key}) : super(key: key);

  @override
  _ProfilePage1State createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  final ApiService apiService = ApiService();
  late Future<List<Post>> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = apiService.fetchUserPosts(); // Changed method call
  }

  Future<String> _getUserName() async {
    // Ensure this function is correctly implemented
    return await getUserName(); // Fetch the username from secure storage
  }

  void _showProfileModificationSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Modify Profile',
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle profile update logic here
                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  FutureBuilder<String>(
                    future: _getUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final username = snapshot.data ?? 'No username found';
                        return Text(
                          username,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          _showProfileModificationSheet();
                        },
                        heroTag: 'ModifyProfile',
                        elevation: 0,
                        backgroundColor: const Color.fromRGBO(61, 143, 239, 1),
                        label: const Text("Modify Profile",
                            style: TextStyle(color: Colors.white)),
                        icon: const Icon(Icons.edit, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      FloatingActionButton.extended(
                        onPressed: () {
                          logout(context);
                        },
                        heroTag: 'Logout',
                        elevation: 0,
                        backgroundColor: const Color.fromRGBO(61, 143, 239, 1),
                        label: const Text("Log out",
                            style: TextStyle(color: Colors.white)),
                        icon: const Icon(Icons.logout, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _ProfileInfoRow(),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<Post>>(
                      future: postsFuture, // Updated future
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text('No posts found'));
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              final post = snapshot.data![index];
                              return Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 8),
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color(0xFFE0E0E0)),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 225,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(8.0)),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  'http://192.168.1.12:8000/uploads/images/${post.mediaFileName}'),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post.title,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(post.content),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    color: post.approved == null
                                                        ? const Color.fromARGB(
                                                            255,
                                                            255,
                                                            193,
                                                            7) // Yellow for Pending
                                                        : post.approved == true
                                                            ? const Color
                                                                .fromARGB(
                                                                255,
                                                                54,
                                                                244,
                                                                63) // Green for Approved
                                                            : const Color
                                                                .fromARGB(
                                                                255,
                                                                244,
                                                                54,
                                                                54), // Red for Disapproved
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      post.approved == null
                                                          ? "Pending"
                                                          : post.approved ==
                                                                  true
                                                              ? "Approved"
                                                              : "Disapproved",
                                                      style: const TextStyle(
                                                        color: Colors
                                                            .white, // Text color
                                                        fontWeight: FontWeight
                                                            .bold, // Make the text bold
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);

  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("Posts", 900),
    ProfileInfoItem("Followers", 120),
    ProfileInfoItem("Following", 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items.map((item) {
          return Expanded(
            child: Row(
              children: [
                if (_items.indexOf(item) != 0) const VerticalDivider(),
                Expanded(child: _singleItem(context, item)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(item.title),
      ],
    );
  }
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromRGBO(61, 143, 239, 1),
                Color.fromRGBO(172, 215, 255, 1),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'image/user.png', // Path to your image asset
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
