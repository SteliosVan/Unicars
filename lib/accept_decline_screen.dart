    import 'package:flutter/material.dart';
    import 'home_screen.dart';
    import 'show_prof2_screen.dart';
    import 'package:firebase_auth/firebase_auth.dart';
    import 'package:cloud_firestore/cloud_firestore.dart';

    class AcceptDecline extends StatefulWidget {
      const AcceptDecline({super.key});

      @override
      State<AcceptDecline> createState() => _AcceptDeclineState();
    }

    class _AcceptDeclineState extends State<AcceptDecline> {
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
        final requestMatches = List<String>.from(userDoc.data()?['pending_list'] ?? []);

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

    final matchedDrivers = snapshot.data ?? [];

    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color(0xFF082C58),
          child: Stack(
            children: [
              // Header
              Positioned(
                left: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen())),
                  child: const HeaderWidget(),
                ),
              ),

              // Αν υπάρχουν matched drivers
              if (matchedDrivers.isNotEmpty) ...[
                const Positioned(
                  left: 84,
                  top: 182,
                  child: SizedBox(
                    width: 243,
                    height: 34,
                    child: Text(
                      'Want to join your ride! ',
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
              ] else ...[
                const Positioned(
                  top: 260,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'No matched drivers found.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Kiwi Maru',
                      ),
                    ),
                  ),
                ),
              ],

              // Footer
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



    // Header widget
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

    class BackArrowWidget extends StatelessWidget {
      const BackArrowWidget({super.key});

      @override
      Widget build(BuildContext context) {
        return Stack(
          children: [
            Positioned(
              left: 32,
              top: 0,
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen())),
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

    Future<void> _acceptRequest() async {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
      final targetUserRef = FirebaseFirestore.instance.collection('users').doc(userData['uid']);

      final userDoc = await userRef.get();
      final targetUserDoc = await targetUserRef.get();

      final currentUserData = userDoc.data() ?? {};
      final targetUserData = targetUserDoc.data() ?? {};

      // --- 1. Update current user's accept_list and pending_list ---
      final currentAcceptList = List<String>.from(currentUserData['accept_list'] ?? []);
      if (!currentAcceptList.contains(userData['uid'])) {
        currentAcceptList.add(userData['uid']);
      }

      final currentPendingList = List<String>.from(currentUserData['pending_list'] ?? []);
      currentPendingList.remove(userData['uid']); // ✅ Remove the target user from my pending list

      await userRef.update({
        'accept_list': currentAcceptList,
        'pending_list': currentPendingList,
      });

      // --- 2. Update target user's accept_list ---
      final targetAcceptList = List<String>.from(targetUserData['accept_list'] ?? []);
      if (!targetAcceptList.contains(currentUser.uid)) {
        targetAcceptList.add(currentUser.uid);
      }

      await targetUserRef.update({
        'accept_list': targetAcceptList,
      });

      // --- 3. Reload the screen ---
      onRequestComplete();
    }



      Future<void> _declineRequest() async {
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
        pendingList.remove(currentUser.uid);
        await driverRef.update({'pending_list': pendingList});

        onRequestComplete();
      }

      @override
      Widget build(BuildContext context) {
        return Container(
          width: 410,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 13, 53, 103),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ShowProfile2(user: userData)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        image: DecorationImage(
                          image: userData['imageUrl'] != null && userData['imageUrl'].toString().isNotEmpty
                              ? NetworkImage(userData['imageUrl']) as ImageProvider
                              : const AssetImage('assets/images/user1.png'),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _acceptRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF82F47E),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      minimumSize: const Size(118, 47),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(
                        fontFamily: 'Kiwi Maru',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _declineRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[300],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      minimumSize: const Size(118, 47),
                    ),
                    child: const Text(
                      'Decline',
                      style: TextStyle(
                        fontFamily: 'Kiwi Maru',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    }




