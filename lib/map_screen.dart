import 'package:flutter/material.dart';
import 'package:unicars/show_prof1_screen.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';


class MapScreen extends StatefulWidget {
  final dynamic user;
  const MapScreen({Key? key, required this.user}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? userLocation;
  bool isLoading = true;
  final MapController _mapController = MapController();


Future<void> sendPushNotification({
  required String token,
  required String title,
  required String body,
}) async {
  const String serverKey = 'YOUR_FIREBASE_SERVER_KEY'; // 🔐 Αντικατάστησέ το

  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode({
        'to': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'sound': 'default',
        },
      }),
    );
  } catch (e) {
    print('Failed to send notification: $e');
  }
}

  Future<void> handleRideMatch({
    required String rideType,
    required String destination,
    required String currentUserId,
  }) async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection('rides_requested')
        .where('destination', isEqualTo: destination)
        .get();

    for (final doc in snapshot.docs) {
      final matchedUserId = doc['userId'];
      if (matchedUserId == currentUserId) continue;
      await db.collection('users').doc(matchedUserId).set({
        'request_matches': FieldValue.arrayUnion([currentUserId]),
      }, SetOptions(merge: true));
    }
  }

  @override
void initState() {
  super.initState();
  fetchUserLocation();
}

Future<void> fetchUserLocation() async {
  try {
    final userId = widget.user['uid'];
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null && data.containsKey('latitude') && data.containsKey('longitude')) {
        final double lat = (data['latitude'] as num).toDouble();
        final double lng = (data['longitude'] as num).toDouble();

        setState(() {
          userLocation = LatLng(lat, lng);
          isLoading = false;
        });

        // Εστίασε στον χάρτη μόλις φορτωθεί η τοποθεσία
        _mapController.move(userLocation!, 15.0); // zoom level 15
      }
    }
  } catch (e) {
    print('Error fetching user location: $e');
  }
}




  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Color(0xFF082C58)),
            child: Stack(
              children: [
                _buildHeader(context),
                const Positioned(
                  left: 99,
                  top: 182,
                  child: SizedBox(
                    width: 214,
                    height: 40,
                    child: Text(
                      'Friends Location',
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
                  left: -10,
                  top: 230,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 600,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 35,
                          top: 20,
                          child: SizedBox(
                            width: 350,
                            height: 350,
                            child: FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                center: userLocation ?? LatLng(37.9838, 23.7275),
                                zoom: 13.0,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  subdomains: const ['a', 'b', 'c'],
                                  userAgentPackageName: 'com.example.yourapp',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      width: 40,
                                      height: 40,
                                      point: userLocation ?? LatLng(37.9838, 23.7275),
                                      child: const Icon(Icons.location_pin,
                                          color: Colors.red, size: 20),
                                    ),
                                  ],
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
                  left: 90,
                  top: 650,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser == null) {
                          throw Exception("No logged in user");
                        }

                        final currentUserDoc = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser.uid)
                            .get();

                        final currentUsername = currentUserDoc.data()?['firstName'] ?? 'Someone';

                        final targetUserId = widget.user['uid'];
                        final targetUserDoc = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(targetUserId)
                            .get();

                        final targetToken = targetUserDoc.data()?['fcmToken'];
                        if (targetToken != null) {
                          await sendPushNotification(
                            token: targetToken,
                            title: 'Location Request',
                            body: '$currentUsername wants to know your location.',
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Notification sent to ${widget.user['username'] ?? 'user'}')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User does not have a registered FCM token.')),
                          );
                        }
                      } catch (e) {
                        print('Error sending notification: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to send notification')),
                        );
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 92, 184, 237),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(
                      'Request Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 32,
                  top: 760,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ShowProfile1(user: widget.user)),
                      );
                    },
                    child: SizedBox(
                      width: 34,
                      height: 45,
                      child: Image.asset("assets/images/arrowback.png"),
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

  Widget _buildHeader(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 146,
          decoration: ShapeDecoration(
            color: const Color(0xFF002346),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 2,
                top: 0,
                child: Container(
                  width: 146,
                  height: 146,
                  decoration: ShapeDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/images/topcar.png"),
                      fit: BoxFit.cover,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(30)),
                    ),
                  ),
                ),
              ),
              const Positioned(
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
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: 'UniCars\n',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontFamily: 'Kiwi Maru',
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: '                             ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Kiwi Maru',
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: 'Hop on',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Kiwi Maru',
                              fontWeight: FontWeight.w400),
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
    );
  }
}
