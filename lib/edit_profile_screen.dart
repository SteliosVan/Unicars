import 'package:flutter/material.dart';
import 'camera.dart';
import 'home_screen.dart';
//import 'screens/camera_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EditProfile extends StatefulWidget {
    @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController yearOfBirthController = TextEditingController();
  final TextEditingController universityController = TextEditingController();

void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    yearOfBirthController.dispose();
    universityController.dispose();
    super.dispose();
  }

  void initState() {
  super.initState();
  loadUserData();
}


void loadUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      final data = userDoc.data();
      setState(() {
        firstNameController.text = data?['firstName'] ?? '';
        lastNameController.text = data?['lastName'] ?? '';
        phoneController.text = data?['contactNumber'] ?? '';
        yearOfBirthController.text = data?['yearOfBirth'] ?? '';
        universityController.text = data?['university'] ?? '';
      });
    }
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
                  height: 618,
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
                left: 25,
                top: 280,
                child: Container(
                  width: 414,
                  height: 425, // you can tweak this depending on space
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // First Name
                        Container(
                          height: 95,
                          clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(color: Colors.white),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 10,
                                      top: 14,
                                      child: Text(
                                        'First Name',
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
                                        height: 52,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: TextField(
                                          controller: firstNameController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Stelios',
                                          ),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        // Last Name
                        Container(
                          height: 95,
                          clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(color: Colors.white),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 10,
                                      top: 14,
                                        child: Text(
                                          'Last Name',
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
                                        height: 52,
                                        decoration: BoxDecoration(
                                          border: Border.all( color: Colors.black,),
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: TextField(
                                          controller: lastNameController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Vantarakis',
                                          ),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                    ),
                                    ),
                                  ],
                                ),
                        ),
                        // Contact Number
                        Container(
                          height: 95,
                          clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(color: Colors.white),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 10,
                                      top: 14,
                                        child: Text(
                                          'Contact Number',
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
                                        height: 52,
                                        decoration: BoxDecoration(
                                          border: Border.all( color: Colors.black,),
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: TextField(
                                          controller: phoneController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '69xxxxxxxx',
                                          ),
                                          keyboardType: TextInputType.phone,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                    ),
                                    ),
                                  ],
                                ),
                        ),
                        // Year of Birth
                        Container(
                          height: 95,
                          clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(color: Colors.white),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 10,
                                      top: 14,
                                        child: Text(
                                          'Year of Birth',
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
                                        height: 52,
                                        decoration: BoxDecoration(
                                          border: Border.all( color: Colors.black,),
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: TextField(
                                          controller: yearOfBirthController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '2005',
                                          ),
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                    ),
                                    ),
                                  ],
                                ),
                        ),
                        // University
                        Container(
                          height: 95,
                          clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(color: Colors.white),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 10,
                                      top: 14,
                                        child: Text(
                                          'University',
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
                                        height: 52,
                                        decoration: BoxDecoration(
                                          border: Border.all( color: Colors.black,),
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: TextField(
                                          controller: universityController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'NTUA',
                                          ),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        // Cancel and Confirm buttons
                        // Cancel and Confirm buttons in one row
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start, // ή .end / .center ανάλογα με το design σου
                            children: [
                              // Cancel Button
                              Container(
                                width: 120,
                                height: 30,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(color: Colors.white),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomeScreen()),
                                    );
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFF082C58)),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: const Color(0xFF082C58),
                                        fontSize: 15,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 100),
                              // Confirm Button
                              Container(
                                width: 120,
                                height: 30,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(color: Colors.white),
                                child: GestureDetector(
                                  onTap: () async {
                                    final user = FirebaseAuth.instance.currentUser;
                                    final contactNumber = phoneController.text.trim();
                                    final yearOfBirthText = yearOfBirthController.text.trim();

                                    final isPhoneValid = contactNumber.startsWith('69');
                                    final year = int.tryParse(yearOfBirthText);
                                    final isYearValid = year != null && year >= 1990 && year <= 2100;

                                    if (!isPhoneValid || !isYearValid) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Invalid Information')),
                                      );
                                      return;
                                    }

                                    if (user != null) {
                                      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                                        'firstName': firstNameController.text.trim(),
                                        'lastName': lastNameController.text.trim(),
                                        'contactNumber': contactNumber,
                                        'yearOfBirth': yearOfBirthText,
                                        'university': universityController.text.trim(),
                                      }, SetOptions(merge: true));

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomeScreen()),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('User not signed in')),
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFF082C58)),
                                      borderRadius: BorderRadius.circular(30),
                                      color: const Color(0xFF082C58),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
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
              Positioned(
                left: 0,
                top: 720,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 119,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 68,
                        top: 0,
                        child: Container(
                          width: 75,
                          height: 102,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 8,
                                top: 17,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomeScreen()),
                                    );
                                  },
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
                              ),
                              Positioned(
                                left: 0,
                                top: 67,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomeScreen()),
                                    );
                                  },
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
                        child: Container(
                          width: 87,
                          height: 95,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(color: Colors.white),
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 171,
                top: 116,
                child: Container(
                  width: 180,
                  height: 168,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      ProfileImage(),
                      Positioned(
                        left: 128,
                        top: 101,
                        child: GestureDetector(
                           onTap: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CameraScreen()),
                          );
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/cameraprof.png"),
                              fit: BoxFit.cover,
                            ),
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
              width: 138,
              height: 138,
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