import 'package:flutter/material.dart';

class HomeDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        textTheme:const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            decoration:const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 1, 0, 19), // #4F4D98
                  Color.fromARGB(255, 11, 0, 40), // #6B4487
                  Color.fromARGB(255, 3, 0, 49), // #5E3B76
                  Color.fromARGB(255, 5, 0, 74), // #503365
                  Color.fromARGB(255, 0, 1, 79), // #432655
                ],
              ),
            ),
            child:const Column(
              children: [
                Padding(
                  padding:EdgeInsets.only(left: 20.0, top: 32.0, right: 20.0),
                  child: Text(
                    'Catalyzing Change',
                    style: TextStyle(
                      fontSize: 45,
                      fontFamily: 'ProtestStrike',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Digital Solutions for waste Management',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding:EdgeInsets.only(left: 20.0, top: 32.0, right: 20.0),
                  child: Text(
                    'Welcome to Catalyzing Change, our innovative waste management program designed to transform communities and protect the environment. We are thrilled to have your organization join us on this journey towards a cleaner, greener future.',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Textual data section
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to left
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Text('Catalyzing Change in Action',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Our organization module within the Catalyzing Change app empowers organizations like yours to play a vital role in waste collection and management.',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Here, you can schedule pickups, manage waste categories, and collaborate with other stakeholders to drive positive change in your community.',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Join us in catalyzing change! Explore success stories from organizations like yours who have made a significant impact on waste management practices and contributed to building sustainable communities.',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, top: 20.0, bottom: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your feedback matters! Share your thoughts, suggestions, and ideas for improving our waste management program and app experience.s',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Horizontal image gallery
                    // SizedBox(
                    //   height: 150,
                    //   child: ListView(
                    //     scrollDirection: Axis.horizontal,
                    //     children: [
                    //       SizedBox(width: 20), // Add initial padding

                    //       // First image
                    //       Container(
                    //         margin: EdgeInsets.only(right: 10),
                    //         child: ClipRRect(
                    //           borderRadius: BorderRadius.circular(
                    //               10), // Adjust the radius as needed
                    //           child: Image.asset(
                    //             'assets/home.png',
                    //             width: 150,
                    //             height: 150,
                    //             fit: BoxFit.cover,
                    //           ),
                    //         ),
                    //       ),

                    //       // Second image
                    //       Container(
                    //         margin: EdgeInsets.only(right: 10),
                    //         child: ClipRRect(
                    //           borderRadius: BorderRadius.circular(
                    //               10), // Adjust the radius as needed
                    //           child: Image.asset(
                    //             'assets/home1.png',
                    //             width: 150,
                    //             height: 150,
                    //             fit: BoxFit.cover,
                    //           ),
                    //         ),
                    //       ),

                    //       // Third image
                    //       Container(
                    //         margin: EdgeInsets.only(right: 20),
                    //         child: ClipRRect(
                    //           borderRadius: BorderRadius.circular(
                    //               10), // Adjust the radius as needed
                    //           child: Image.asset(
                    //             'assets/home2.png',
                    //             width: 150,
                    //             height: 150,
                    //             fit: BoxFit.cover,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Text('Credit System',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Users earn credits for recycling or participating in sustainable initiatives.',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Organizations provide credits for waste collection and recycling services.',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Users spend credits for disposal of non-recyclable or hazardous waste.',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Organizations charge credits for handling and disposing of specialized waste items.',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, top: 20.0, bottom: 30.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Credits can be transferred between users and organizations.',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Add more sections as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}