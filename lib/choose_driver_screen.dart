import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'request_ride_screen.dart';
import 'show_prof3_screen.dart';

class ChooseDriverScreen extends StatefulWidget {
  const ChooseDriverScreen({super.key});

  @override
  State<ChooseDriverScreen> createState() => _ChooseDriverScreenState();
}

class _ChooseDriverScreenState extends State<ChooseDriverScreen> {
  late Future<List<Map<String, dynamic>>> _matchedDrivers;

  @override
  void initState() {
    super.initState();
    _matchedDrivers = fetchMatchedDrivers();
  }

  Future<List<Map<String, dynamic>>> fetchMatchedDrivers() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
    final requestMatches = List<String>.from(userDoc.data()?['request_matches'] ?? []);

    if (requestMatches.isEmpty) return [];

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', whereIn: requestMatches)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  void _refreshMatches() {
    setState(() {
      _matchedDrivers = fetchMatchedDrivers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _matchedDrivers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No matched drivers found.', style: TextStyle(color: Colors.white)));
          }

          final matchedDrivers = snapshot.data!;

          return SingleChildScrollView(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: const Color(0xFF082C58),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen())),
                        child: const HeaderWidget(),
                      ),
                    ),
                    const Positioned(
                      left: 65,
                      top: 182,
                      child: SizedBox(
                        width: 341,
                        height: 52,
                        child: Text(
                          'Choose preferred driver ',
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
                      left: 0,
                      top: 260,
                      right: 0,
                      bottom: 110,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: matchedDrivers.length,
                        itemBuilder: (context, index) {
                          final driver = matchedDrivers[index];
                          return DriverCard(
                            userData: driver,
                            onRequestComplete: _refreshMatches,
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                      ),
                    ),
                    const Positioned(
                      left: 1,
                      top: 720,
                      child: SizedBox(
                        width: 412,
                        height: 111,
                        child: BackArrowWidget(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class BackArrowWidget extends StatelessWidget {
  const BackArrowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 32,
          top: 24,
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  RequestRideScreen())),
            child: Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/arrowback.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DriverCard extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onRequestComplete;

  const DriverCard({super.key, required this.userData, required this.onRequestComplete});

  Future<void> _handleRequest() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    final driverRef = FirebaseFirestore.instance.collection('users').doc(userData['uid']);

    final userDoc = await userRef.get();
    final matches = List<String>.from(userDoc.data()?['request_matches'] ?? []);

    matches.remove(userData['uid']);
    await userRef.update({'request_matches': matches});

    final driverDoc = await driverRef.get();
    final pendingList = List<String>.from(driverDoc.data()?['pending_list'] ?? []);
    if (!pendingList.contains(currentUser.uid)) {
      pendingList.add(currentUser.uid);
      await driverRef.update({'pending_list': pendingList});
    }

    onRequestComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 410,
      height: 140,
      color: const Color(0xFF082C58),
      child: Stack(
        children: [
          Positioned(
            left: 146,
            top: 81,
            child: GestureDetector(
              onTap: _handleRequest,
              child: Container(
                width: 118,
                height: 47,
                decoration: BoxDecoration(
                  color: const Color(0xFF82F47E),
                  borderRadius: BorderRadius.circular(90),
                ),
                child: const Center(
                  child: Text(
                    'Request',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Kiwi Maru',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 0,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ShowProfile3(user: userData)),
              ),
              child: SizedBox(
                width: 211,
                height: 64,
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(userData['imagePath'] ?? 'assets/images/user1.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      userData['firstName'] ?? '',
                      style: const TextStyle(
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
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 146,
      decoration: const BoxDecoration(
        color: Color(0xFF002346),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
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
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
                image: DecorationImage(
                  image: AssetImage('assets/images/topcar.png'),
                  fit: BoxFit.cover,
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
                    TextSpan(text: '\n', style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'Inter')),
                    TextSpan(text: 'UniCars\n', style: TextStyle(fontSize: 32, color: Colors.white, fontFamily: 'Kiwi Maru')),
                    TextSpan(text: '                             ', style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'Kiwi Maru')),
                    TextSpan(text: 'Hop on', style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Kiwi Maru')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}