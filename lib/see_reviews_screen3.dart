import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'show_prof3_screen.dart';
class SeeReview3 extends StatefulWidget {
  final Map<String, dynamic> user;
  
  const SeeReview3({Key? key, required this.user}) : super(key: key);

  @override
  State<SeeReview3> createState() => _SeeReviewState3();
}

class _SeeReviewState3 extends State<SeeReview3> {
  late Future<List<Map<String, dynamic>>> _reviews;

  @override
  void initState() {
    super.initState();
    _reviews = fetchReviews();
  }

  Future<List<Map<String, dynamic>>> fetchReviews() async {
    final ratedUid = widget.user['uid'];

    // Step 1: Get all ratings where this user was rated
    final ratingsSnapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .where('uid_of_rated', isEqualTo: ratedUid)
        .get();

    if (ratingsSnapshot.docs.isEmpty) return [];

    // Step 2: For each rating, get the review and reviewer UID
    List<Map<String, dynamic>> reviews = [];

    for (var doc in ratingsSnapshot.docs) {
      final data = doc.data();
      final reviewerUid = data['userId'];

      // Get reviewer info
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: reviewerUid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final reviewerData = userSnapshot.docs.first.data();
        reviews.add({
          'reviewerName': reviewerData['firstName'] ?? 'Unknown',
          'review': data['review'] ?? '',
          'rating': data['rating'] ?? 0,
        });
      }
    }

    return reviews;
  }


  void _refreshMatches() {
    setState(() {
      _reviews = fetchReviews();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _reviews,
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
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen())),
                        child: const HeaderWidget(),
                      ),
                    ),
                    const Positioned(
                      left: 150,
                      top: 185,
                      child: SizedBox(
                        width: 243,
                        height: 34,
                        child: Text(
                          ' Reviews ',
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
                    Positioned(
                      left: 1,
                      top: 807,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 111,
                        child: BackArrowWidget(user: widget.user),
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


class DriverCard extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onRequestComplete;

  const DriverCard({
    super.key,
    required this.userData,
    required this.onRequestComplete,
  });

  Widget buildStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rating = userData['rating'] ?? 0;
    final review = userData['review'] ?? '';
    final reviewerName = userData['reviewerName'] ?? 'Unknown';

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  image: DecorationImage(
                    image: AssetImage(userData['imagePath'] ?? 'assets/images/user1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),

              // Reviewer Name and Stars
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewerName ?? 'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Kiwi Maru',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    buildStars(rating),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Review (starts from left edge)
          Text(
            review,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),

    );
  }
}

class BackArrowWidget extends StatelessWidget {
  final Map<String, dynamic> user;
  const BackArrowWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 32,
          top: 24,
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShowProfile3(user: user))),
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
