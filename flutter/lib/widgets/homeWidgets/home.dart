import 'package:challange_kide/services/api_service.dart';
import 'package:flutter/material.dart';
import 'challenge.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Category>> categoriesFuture;
  late Future<List<Challenge>> challengesFuture;
  late Future<List<Post>> postFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = apiService.fetchCategories();
    challengesFuture = apiService.fetchKidChallenges();
    postFuture = apiService.fetchKidPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          // Handle scroll notifications if needed
          return true;
        },
        child: CustomScrollView(
          slivers: [
            // Fixed header section
            SliverAppBar(
              pinned: true,
              expandedHeight: 120.0, // Adjust height as needed
              backgroundColor: Colors.white, // Set background color to white
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: 60.0, left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo image
                          Image.asset(
                            'image/kids.png', // Path to your logo image
                            width: 50.0, // Adjust size as needed
                            height: 50.0,
                          ),
                          // Search bar
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  hintStyle:
                                      const TextStyle(color: Colors.black54),
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
                          ),
                          // Notification icon
                          IconButton(
                            icon: const Icon(
                              Icons.notifications,
                              size: 30,
                              color: Color.fromARGB(255, 70, 98, 255),
                            ),
                            onPressed: () {
                              // Handle notification icon tap
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Scrollable content
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Event announcement
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: SizedBox(
                  //     height: 180,
                  //     width: 380, // Adjust the height as needed
                  //     child: Container(
                  //       padding: const EdgeInsets.all(16.0),
                  //       decoration: BoxDecoration(
                  //         color: const Color.fromRGBO(172, 215, 255, 1),
                  //         borderRadius:
                  //             BorderRadius.circular(12), // Rounded border
                  //         boxShadow: const [
                  //           BoxShadow(
                  //             color: Colors.black26,
                  //             blurRadius: 4,
                  //             offset: Offset(0, 2),
                  //           ),
                  //         ],
                  //         image: const DecorationImage(
                  //           image:
                  //               AssetImage('image/BG.png'), // Background image
                  //           fit: BoxFit.cover, // Adjust the fit as needed
                  //         ),
                  //       ),
                  //       child: const Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           SizedBox(
                  //               height: 16), // Add space between image and text
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // Category title
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    /*child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Category',
                        style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                      ),
                    ),*/
                  ),
                  // Horizontal list view for categories
                  FutureBuilder<List<Category>>(
                    future: categoriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No categories found'));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            height: 50, // Adjust height as needed
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final category = snapshot.data![index];
                                return Card(
                                  color: const Color.fromRGBO(61, 143, 239,
                                      1), // Background color of the Card
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        category.title,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                15), // Text color for better visibility on the background color
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
                  // Tab controller section
                  DefaultTabController(
                    length: 2, // Number of tabs
                    child: Column(
                      children: [
                        // Tab bar with two tabs
                        const TabBar(
                          tabs: [
                            SizedBox(
                              width: 100,
                              child: Tab(
                                child: Text(
                                  'Challenges',
                                  style: TextStyle(
                                      fontSize: 16), // Change text size here
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Tab(
                                child: Text(
                                  'Posts',
                                  style: TextStyle(
                                      fontSize: 16), // Change text size here
                                ),
                              ),
                            ),
                          ],
                          indicatorColor: const Color.fromRGBO(61, 143, 239,
                              1), // Change the indicator color to blue
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 5.0,
                              color: Colors
                                  .blue, // Change the indicator color to blue
                            ),
                          ),
                        ),

                        // Tab bar view with two lists of challenges
                        SizedBox(
                          height: 570, // Adjust height as needed
                          child: TabBarView(
                            children: [
                              // First tab - List of challenges
                              FutureBuilder<List<Challenge>>(
                                future: challengesFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text('No challenges found'));
                                  } else {
                                    return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final challenge = snapshot.data![index];
                                        return Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  bottom: 8),
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
                                                    color: const Color(
                                                        0xFFE0E0E0)),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
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
                                                          const BorderRadius
                                                              .vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      8.0)),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            'http://192.168.1.12:8000/uploads/images/${challenge.imageFileName}'),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          challenge.title,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(challenge
                                                            .description),
                                                        const SizedBox(
                                                            height: 8),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Icons
                                                                    .favorite_border,
                                                                Icons.share,
                                                                Icons.more_vert
                                                              ].map((icon) {
                                                                return InkWell(
                                                                  onTap: () {},
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            8.0),
                                                                    child: Icon(
                                                                      icon,
                                                                      size: 30,
                                                                      color: const Color
                                                                          .fromRGBO(
                                                                          61,
                                                                          143,
                                                                          239,
                                                                          1),
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  40, // Adjust height as needed
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ChallengeScreen(
                                                                              challenge: challenge),
                                                                    ),
                                                                  );
                                                                },
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      const Color
                                                                          .fromRGBO(
                                                                          61,
                                                                          143,
                                                                          239,
                                                                          1),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8), // Rounded corners
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    SizedBox(
                                                                        width:
                                                                            8), // Space between icon and text
                                                                    Text(
                                                                      'Learn More ',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.white), // Adjust text size if needed
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .arrow_forward, // Replace with your desired icon
                                                                      color: Colors
                                                                          .white,
                                                                      size:
                                                                          20, // Adjust icon size as needed
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                              // Second tab - Same list of challenges
                              FutureBuilder<List<Post>>(
                                future: postFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text('No challenges found'));
                                  } else {
                                    return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final challenge = snapshot.data![index];
                                        return Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  bottom: 8),
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
                                                    color: const Color(
                                                        0xFFE0E0E0)),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
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
                                                          const BorderRadius
                                                              .vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      8.0)),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            'http://192.168.1.12:8000/uploads/images/${challenge.mediaFileName}'),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          challenge.title,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(challenge.content),
                                                        const SizedBox(
                                                            height: 8),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Icons
                                                                    .favorite_border,
                                                                Icons.share,
                                                                Icons.more_vert
                                                              ].map((icon) {
                                                                return InkWell(
                                                                  onTap: () {},
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            8.0),
                                                                    child: Icon(
                                                                      icon,
                                                                      size: 30,
                                                                      color: const Color
                                                                          .fromRGBO(
                                                                          61,
                                                                          143,
                                                                          239,
                                                                          1),
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
