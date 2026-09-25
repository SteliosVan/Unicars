import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'chat_screen.dart';
import 'offer_ride_screen.dart';
import 'accept_decline_screen.dart';
import 'request_ride_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _startUploadingLocation(currentUser.uid);
      saveTokenToFirestore();
    }
  }

Future<void> saveTokenToFirestore() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null && token != null) {
    await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
      'fcmToken': token,
    });
    print('FCM token saved to Firestore');
  }
}

  void _startUploadingLocation(String userId) {
    _locationTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      final hasPermission = await _requestLocationPermission();
      if (!hasPermission) return;

      final position = await Geolocator.getCurrentPosition( desiredAccuracy: LocationAccuracy.best,);
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }
  final currentUid = FirebaseAuth.instance.currentUser?.uid;


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
              Positioned(
                left: 35,
                top: 164,
                child: SizedBox(
                  width: 167,
                  height: 45,
                  child: Text(
                    'Hello, Stelios!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Kiwi Maru',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 325,
                top: 150,
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // loading placeholder
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Icon(Icons.error); // fallback if user doc doesn't exist
                    }

                    final profileUrl = snapshot.data!.get('profile_pic');

                    return Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(profileUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                left: 85,
                top: 222,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AcceptDecline()),
                    );
                  },
                  child: Container(
                    width: 233,
                    height: 36,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF87A9FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 4.0),
                      child: Text(
                        'See ride requests',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Kiwi Maru',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ChatCard(),
              Positioned(
                left: 0,
                top: 720,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 105,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: const Color(0xFF082C58)),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 68,
                        top: 0,
                        child: Container(
                          width: 75,
                          height: 102,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(color: const Color(0xFF082C58)),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 8,
                                top: 17,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/messenger.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 67,
                                child: SizedBox(
                                  width: 75,
                                  height: 35,
                                  child: Text(
                                    'Chat',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontFamily: 'Kiwi Maru',
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
                        left: 266,
                        top: 3,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfile()),
                            );
                          },
                          child: Container(
                            width: 87,
                            height: 95,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(color: const Color(0xFF082C58)),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 19,
                                  top: 11,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage("assets/images/profile-user.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 61,
                                  child: SizedBox(
                                    width: 87,
                                    height: 28,
                                    child: Text(
                                      'Profile',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontFamily: 'Kiwi Maru',
                                        fontWeight: FontWeight.w400,
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
              ),
              Positioned(
                left: 0,
                top: 630,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 93,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: const Color(0xFF082C58)),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 259,
                        top: 14,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RequestRideScreen()),
                            );
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
                                  left: 21,
                                  top: 10,
                                  child: SizedBox(
                                    width: 83,
                                    height: 24,
                                    child: Text(
                                      'Find Ride',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Kiwi Maru',
                                        fontWeight: FontWeight.w400,
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
                        left: 34,
                        top: 14,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OfferRideScreen()),
                            );
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
                                  left: 18,
                                  top: 10,
                                  child: SizedBox(
                                    width: 83,
                                    height: 24,
                                    child: Text(
                                      'Offer Ride',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Kiwi Maru',
                                        fontWeight: FontWeight.w400,
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

class ChatCard extends StatelessWidget {
  
Future<String> getLastMessage(String otherUid) async {
  final currentUid = FirebaseAuth.instance.currentUser?.uid;
  if (currentUid == null) return 'Not logged in';

  final chatId1 = '${currentUid}_$otherUid';
  final chatId2 = '${otherUid}_$currentUid';
  final firestore = FirebaseFirestore.instance;

  var doc = await firestore.collection('chats').doc(chatId1).get();
  String chatId = doc.exists ? chatId1 : chatId2;

  final messagesSnapshot = await firestore
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .limit(1)
      .get();

  if (messagesSnapshot.docs.isNotEmpty) {
    return messagesSnapshot.docs.first['text'] ?? '';
  }

  return 'No messages yet';
}

  Future<List<Map<String, dynamic>>> _fetchAcceptedUsers() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    final List<String> acceptList = List<String>.from(userDoc.data()?['accept_list'] ?? []);

    if (acceptList.isEmpty) return [];

    // Fetch data of accepted users
    final List<Map<String, dynamic>> acceptedUsers = [];

    for (String uid in acceptList) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        acceptedUsers.add({...doc.data()!, 'uid': uid});
      }
    }

    return acceptedUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 270,
      child: Container(
        width: 415,
        height: 449,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchAcceptedUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No accepted users"));
            }

            final users = snapshot.data!;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChatScreen(user: user)),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: const BoxDecoration(color: Color(0xFF082C58)),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 15,
                          top: 14,
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: user['photoUrl'] != null
                                    ? NetworkImage(user['photoUrl'])
                                    : const AssetImage("assets/images/user1.png") as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 93,
                          top: 14,
                          child: SizedBox(
                            width: 190,
                            height: 22,
                            child: Text(
                              user['firstName'] ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Kiwi Maru',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 93,
                          top: 41,
                          child: SizedBox(
                            width: 190,
                            height: 32,
                            child: FutureBuilder<String>(
                              future: getLastMessage(user['uid']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Text(
                                    'Loading...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Kiwi Maru',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  );
                                }

                                final lastMessage = snapshot.data ?? 'No messages yet';

                                return Text(
                                  lastMessage,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Kiwi Maru',
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  Future<String?> getProfilePicUrl() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data()?['profile_pic'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getProfilePicUrl(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(); // or placeholder image
        }

        final url = snapshot.data!;
        return Positioned(
          left: 21,
          top: 0,
          child: ClipOval(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}