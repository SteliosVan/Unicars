import 'package:flutter/material.dart';
import 'package:unicars/choose_driver_screen.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';


class RequestRideScreen extends StatefulWidget {
    @override
  _RequestRideScreenState createState() => _RequestRideScreenState();
}

class _RequestRideScreenState extends State<RequestRideScreen> {
  String? selectedUniversity;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();


void dispose() {
    departureController.dispose();
    destinationController.dispose();
    super.dispose();
  }

Future<bool> handleRideMatch({
  required String destination,
  required String departure,
  required String currentUserId,
}) async {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  final QuerySnapshot matchingSnapshot = await db
      .collection('rides_offered')
      .where('destination', isEqualTo: destination)
      .where('departure', isEqualTo: departure)
      .get();

  bool hasMatch = false;

  for (final doc in matchingSnapshot.docs) {
    final String matchedUserId = doc['userId'];

    if (matchedUserId == currentUserId) continue;

    hasMatch = true;

    await db.collection('users').doc(currentUserId).set({
      'request_matches': FieldValue.arrayUnion([matchedUserId]),
    }, SetOptions(merge: true));
  }

  return hasMatch;
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
                              hintText: ' Your address',
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
  top: 336,
  child: Container(
    width: MediaQuery.of(context).size.width,
    height: 95, // ✅ same as Departure parent
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
                hintText: ' Enter university',
              ),
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20, // ✅ MATCH departure
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
                left: 245,
                top: 720,
                child: GestureDetector(
                    onTap: () async {
                      final user = FirebaseAuth.instance.currentUser;
  
                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No user is signed in')),
                        );
                        return;
                      }

                      final rideRequest = {
                        'userId': user.uid,
                        'departure': departureController.text.trim(),
                        'destination': selectedUniversity ?? '',
                        'timestamp': Timestamp.now()
                      };

                      try {
                        await FirebaseFirestore.instance.collection('rides_requested').add(rideRequest);
                        await _audioPlayer.play(AssetSource('sounds/ride_request.mp3')); 

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ride request submitted')),
                        );
                        final hasMatch = await handleRideMatch(
  destination: selectedUniversity?.trim() ?? '',
  departure: departureController.text.trim(),
  currentUserId: user.uid,
);

if (!hasMatch) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('No drivers available right now')),
  );

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => HomeScreen()),
    (route) => false,
  );
  return;
}

Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const ChooseDriverScreen()),
);

                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to submit request: $e')),
                        );
                      }
                    },

                child: Container(
                  width: 118,
                  height: 47,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: const Color(0xFF082C58)),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 5,
                        child: Container(
                          width: 118,
                          height: 39,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF82F47E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 5,
                        child: Container(
                          width: 118,
                          height: 39,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF82F47E),
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
                            'Confirm\n',
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