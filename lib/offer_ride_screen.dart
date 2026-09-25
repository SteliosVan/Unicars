import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audioplayers/audioplayers.dart';



class OfferRideScreen extends StatefulWidget {
    @override
  _OfferRideScreenState createState() => _OfferRideScreenState();
}

class _OfferRideScreenState extends State<OfferRideScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final TextEditingController departureController = TextEditingController();
  final TextEditingController seatsController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

void dispose() {
    departureController.dispose();
    seatsController.dispose();
    destinationController.dispose();
    super.dispose();
  }

    String? selectedUniversity;
Future<void> handleRideMatch({
  required String rideType, 
  required String destination,
  required String currentUserId,
}) async {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Decide which collection to search (the opposite of the current ride type)
  final String oppositeCollection = 'rides_requested';

  // Find rides with the same destination in the opposite collection
  final QuerySnapshot matchingSnapshot = await db
      .collection(oppositeCollection)
      .where('destination', isEqualTo: destination)
      .get();

  for (final doc in matchingSnapshot.docs) {
    final String matchedUserId = doc['userId'];

    if (matchedUserId == currentUserId) continue; // Skip self-matching


      // Add current user (the offerer) to the matched requester's request_matches list
      await db.collection('users').doc(matchedUserId).set({
        'request_matches': FieldValue.arrayUnion([currentUserId]),
      }, SetOptions(merge: true));
    

  }
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
      child: Column(
        children: [
          Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: const Color(0xFF082C58)),
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
                        ),
                      ),
                      Positioned(
                        left: 2,
                        top: 0,
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
                      Positioned(
                        left: 140,
                        top: 12,
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
                    ],
                  ),
                ),
              ),
              ),
              Positioned(
                left: 99,
                top: 182,
                child: SizedBox(
                  width: 214,
                  height: 40,
                  child: Text(
                    'Give your ride info',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 241,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 95,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: const Color(0xFF082C58)),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 15,
                        top: 14,
                          child: Text(
                            'Departure Location / Address',
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
                        top: 42,
                        child: Container(
                          width: 311,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all( color: Colors.black,),
                            borderRadius: BorderRadius.circular(30)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            controller: departureController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Neighborhood (small letters)',
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
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
                top: 450,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 95,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: const Color(0xFF082C58)),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 15,
                        top: 14,
                          child: Text(
                            'Seats Available',
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
                        top: 42,
                        child: Container(
                          width: 311,
                          height: 52,
                          
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all( color: Colors.black,),
                                    borderRadius: BorderRadius.circular(30)
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: TextField(
                                    controller: seatsController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '4',
                                    ),
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
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
  top: 336,
  child: Container(
    width: MediaQuery.of(context).size.width,
    height: 95, // ✅ SAME as others
    decoration: BoxDecoration(color: const Color(0xFF082C58)),
    child: Stack(
      children: [
        Positioned(
          left: 15,
          top: 14,
          child: Text(
            'Destination University',
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
          top: 42,
          child: Container(
            width: 311, // ✅ SAME WIDTH
            height: 52,  // ✅ SAME HEIGHT
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              onChanged: (value) {
                selectedUniversity = value.trim();
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'University (small letters)',
              ),
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20, // ✅ MATCH others
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),

              Positioned(
                left: 210,
                top: 714,
                child: ElevatedButton(
                  onPressed: () async {
                    final String departure = departureController.text.trim();
                    final String? destination = selectedUniversity;
                    final int? seats = int.tryParse(seatsController.text.trim());

                    if (departure.isEmpty || destination == null || seats == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all the fields correctly')),
                      );
                      return;
                    }


                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser == null) return;

                    final rideData = {
                      'userId': currentUser.uid,
                      'departure': departure,
                      'destination': destination,
                      'seats': seats,
                      'timestamp': FieldValue.serverTimestamp(),
                    };

                    // Save ride
                    await FirebaseFirestore.instance.collection('rides_offered').add(rideData);
                    await _audioPlayer.play(AssetSource('sounds/ride_offer.mp3')); 

                    // Attempt to find matching requests
                    await handleRideMatch(
                      rideType: 'offeredRides',
                      destination: destination,
                      currentUserId: currentUser.uid,
                    );

                    // Navigate back or show confirmation
                    showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Ride Offered Sucessfully!"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );

                    Navigator.push(
                      context,  
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    'Offer Ride',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 32,
                top: 720,
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
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
            ],
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