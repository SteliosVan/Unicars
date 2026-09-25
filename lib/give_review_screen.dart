  import 'package:flutter/material.dart';
  import 'package:unicars/show_prof1_screen.dart';  
  import 'home_screen.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter_rating_bar/flutter_rating_bar.dart';
  import 'package:audioplayers/audioplayers.dart';



  class GiveReview extends StatefulWidget {
    final Map<String, dynamic> user;

    const GiveReview({Key? key, required this.user}) : super(key: key);
      @override
    _GiveReviewState createState() => _GiveReviewState();
  }

  class _GiveReviewState extends State<GiveReview> {
    final AudioPlayer _audioPlayer = AudioPlayer();
    final TextEditingController reviewcontroller = TextEditingController();
    double _currentRating = 0;

  void dispose() {
      reviewcontroller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
                    width: MediaQuery.of(context).size.width,
                    height: 771,
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
                  left: 85,
                  top: 260,
                  child: SizedBox(
                    width: 250,
                    height: 40,
                    child: Text(
                      'Tell us what you think',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 90,
                  top: 320,  // shifted a bit up so text fits above
                  child: Column(
                    children: [
                      Text(
                        "How was your experience ??",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5),
                      RatingBar.builder(
                        initialRating: _currentRating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 30,
                        unratedColor: Colors.grey,   // color for unselected stars
                        itemBuilder: (context, index) {
                          return Icon(
                            _currentRating > index ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          );
                        },
                        onRatingUpdate: (rating) {
                          setState(() {
                            _currentRating = rating;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 25,
                  top: 390,
                  child: Container(
                    width: 429,
                    height: 419,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 10,
                          top: 14,
                            child: Text(
                              'Your Review',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF978C8C),
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
                            height: 300,
                            decoration: BoxDecoration(
                              border: Border.all( color: Colors.black,),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: reviewcontroller,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Write your review',
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              keyboardType:TextInputType.multiline,
                              maxLines: null,
                            ),
                          ),
                        ),
                    
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 32,
                  top: 750,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShowProfile1(user: widget.user)),
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
                  left: 245,
                  top: 750,
                  child: GestureDetector(
                    onTap: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      

                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No user is signed in')),
                        );
                        return;
                      }

                      final ratingEntry = {
                        'uid_of_rated': widget.user['uid'],
                        'userId': user.uid,
                        'review': reviewcontroller.text.trim(),
                        'rating': _currentRating,
                        'timestamp': Timestamp.now()
                      };

                      try {
                        await FirebaseFirestore.instance.collection('ratings').add(ratingEntry);
                        await _audioPlayer.play(AssetSource('sounds/confirm.mp3')); 

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Thank you for your review!')),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShowProfile1(user: widget.user)),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to submit review: $e')),
                        );
                      }
                    },
                    child: Container(
                      width: 118,
                      height: 47,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(color: const Color(0xFFFFFFFF)),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 5,
                            child: Container(
                              width: 118,
                              height: 39,
                              decoration: ShapeDecoration(
                                color: Colors.lightBlue[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(90),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 24,
                            top: 12,
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Kiwi Maru',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 120,
                  top: 116,
                  child: Container(
                    width: 180,
                    height: 168,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 21,
                          top: 0,
                          child: Container(
                            width: 138,
                            height: 138,
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
          
              ],
          ),
          ),
          ),
            ),
          );

    }
  }