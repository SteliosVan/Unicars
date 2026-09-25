import 'package:flutter/material.dart';
import 'package:unicars/chat_screen.dart';
import 'package:unicars/give_review_screen.dart';
import 'package:unicars/map_screen.dart';
import 'home_screen.dart';
import 'see_reviews_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowProfile1 extends StatefulWidget {
  final Map<String, dynamic> user;

  const ShowProfile1({Key? key, required this.user}) : super(key: key);

  @override
  State<ShowProfile1> createState() => _ShowProfile1State();
}

class _ShowProfile1State extends State<ShowProfile1> {
  bool _showPanel = false;
  double? averageRating;

  @override
  void initState() {
    super.initState();
    fetchAverageRating();
  }

Future<void> fetchAverageRating() async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('ratings')
      .where('uid_of_rated', isEqualTo: widget.user['uid'])
      .get();

  double total = 0;
  int count = 0;

  for (var doc in querySnapshot.docs) {
    final data = doc.data();
    if (data.containsKey('rating') && data['rating'] is num) {
      total += data['rating'];
      count++;
    }
  }

  setState(() {
    averageRating = count > 0 ? total / count : 0.0;
  });
}


  @override
  Widget build(BuildContext context) {
     final user = widget.user;
     return Scaffold(
      body: SingleChildScrollView(
        child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 917,
          decoration: BoxDecoration(color: const Color(0xFF082C58)),
        child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 146,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF002346),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                            );
                          },
                        child: Container(
                          width: 412,
                          height: 146,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF002346),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        ),
                      ),
                      Positioned(
                        left: 2,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                            );
                          },
                        child: Container(
                          width: 146,
                          height: 146,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/topcar.png"),
                              fit: BoxFit.cover,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
                            ),
                          ),
                        ),
                        ),
                      ),
                      Positioned(
                        left: 140,
                        top: 12,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                            );
                          },
                        child: SizedBox(
                          width: 262,
                          height: 126,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '\n',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'UniCars\n',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontFamily: 'Kiwi Maru',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: '                             ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'Kiwi Maru',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Hop on',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Kiwi Maru',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 186,
                child: Container(
                  width: 412,
                  height: 731,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(55),
                        topRight: Radius.circular(55),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width-52,
                top: 260,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPanel = !_showPanel;
                    });
                  },
                child: Container(
                  width: 52,
                  height: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xD3D3D3D3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(55),
                      bottomLeft: Radius.circular(55),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight, // move image to the right
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2), // optional padding from right edge
                      child: Image.asset(
                        "assets/images/review.png",
                        width: 40,
                        height: 35,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                ),
              ),
              ),
              Positioned(
                left: 135,  // adjust this value to align with your profile image
                top: 270,   // adjust this to appear below profile image
                child: averageRating == null
                ? SizedBox.shrink() // or show placeholder like: Text('No rating yet')
                : Row(
                    children: List.generate(5, (index) {
                      if (averageRating! >= index + 1) {
                        return Icon(Icons.star, color: Colors.amber);
                      } else if (averageRating! > index && averageRating! < index + 1) {
                        return Icon(Icons.star_half, color: Colors.amber);
                      } else {
                        return Icon(Icons.star_border, color: Colors.amber);
                      }
                    }),
                  ),

              ),
              Positioned(
                left: 25,
                top: 320,
                child: Container(
                  width: 414,
                  height: 95,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 30,
                        top: 14,
                        child: Text(
                          'First Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF978C8C),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 15,
                        top: 38,
                        child: Container(
                          width: 311,
                          height: 52,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 20,  // padding inside the container
                                top: 10,   // make this value larger to move text lower
                                child: Text(
                                  user['firstName'] ?? 'Unknown',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 25,
                top: 410,
                child: Container(
                  width: 424,
                  height: 98,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 30,
                        top: 14,
                        child: Text(
                          'Last Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF978C8C),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 15,
                        top: 38,
                        child: Container(
                          width: 311,
                          height: 52,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children:  [
                              Positioned(
                                left: 20,  // padding inside the container
                                top: 10,   // make this value larger to move text lower
                                child: Text(
                                  user['lastName'] ?? 'Unknown',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 25,
                top: 500,
                child: Container(
                  width: 414,
                  height: 96,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 30,
                        top: 14,
                        child: Text(
                          'Phone Number',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF978C8C),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 15,
                        top: 38,
                        child: Container(
                          width: 311,
                          height: 52,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children:  [
                              Positioned(
                                left: 20,  // padding inside the container
                                top: 10,   // make this value larger to move text lower
                                child: Text(
                                  user['contactNumber'] ?? 'Unknown',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 25,
                top: 590,
                child: Container(
                  width: 429,
                  height: 108,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 30,
                        top: 14,
                        child: Text(
                          'Year of Birth',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF978C8C),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 15,
                        top: 38,
                        child: Container(
                          width: 311,
                          height: 52,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children:  [
                              Positioned(
                                left: 20,  // padding inside the container
                                top: 10,   // make this value larger to move text lower
                                child: Text(
                                  user['yearOfBirth'] ?? 'Unknown',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 25,
                top: 680,
                child: Container(
                  width: 429,
                  height: 119,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 30,
                        top: 14,
                        child: Text(
                          'University',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF978C8C),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 15,
                        top: 38,
                        child: Container(
                          width: 311,
                          height: 52,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children:  [
                              Positioned(
                                left: 20,  // padding inside the container
                                top: 10,   // make this value larger to move text lower
                                child: Text(
                                  user['university'] ?? 'Unknown',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 119,
                top: 105,
                child: Container(
                  width: 180,
                  height: 168,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 152,
                          height: 152,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/user1.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 32,
                top: 830,
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen(user: widget.user)),
                      );
                    },
                child: Container(
                  width: 34,
                  height: 45,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/arrowback.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ),
              Positioned(
                left: 235,
                top: 830,
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen(user: widget.user)),
                      );
                    },
                      child: Text(
                            'See Location',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                ),
              ),
               if (_showPanel)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPanel = false; // Close the panel
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.3), // Semi-transparent overlay
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                right: _showPanel ? 0 : -375, // Slide in from right
                top: 260,
                child: Container(
                  width: 375,
                  height: 657,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 153, 188, 225),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Centered Title
                        Center(
                          child: Text(
                            "Reviews",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        // Black Line
                        Container(
                          height: 2,
                          width: double.infinity,
                          color: Colors.black,
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SeeReview(user:widget.user))),
                            // Handle see reviews tap
                          
                          child: Text(
                            "See Reviews",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GiveReview(user:widget.user))),                         
                          child: Text(
                            "Add Review",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        ),
      ),
    );
  }
}