import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



bool _isRegistering = false;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  Future<void> registerUser() async {
  if (_isRegistering) return;
  _isRegistering = true;

  String email = usernameController.text.trim();
  String password = passwordController.text.trim();
  String confirmPassword = rePasswordController.text.trim();

  if (password != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar  (content: Text("Passwords do not match")),
    );
    return;
  }

  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Αποθήκευση στο Firestore
    User? user = userCredential.user;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': email,
        'uid': user.uid,
        'created_at': FieldValue.serverTimestamp(),
      });
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  } on FirebaseAuthException catch (e) {
    String message = "Registration failed";
    if (e.code == 'email-already-in-use') {
      message = 'Email already in use';
    } else if (e.code == 'weak-password') {
      message = 'Password is too weak';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  _isRegistering = false;
}



  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Center(
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
                left: 20,
                top: 336,
                child: Container(
                  width: 176,
                  height: 74,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      Positioned(
                        left: -6,
                        top: 2,
                          child: Text(
                            'Register',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.w400,
                              shadows: [Shadow(offset: Offset(0, 4), blurRadius: 4, color: Color(0xFF000000).withOpacity(0.25))],
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
              ),
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
                  left: 46,
                  top: 485,
                  child: Container(
                    width: 311,
                    height: 52,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Image.asset(
                            "assets/images/locked-computer.png",
                            width: 36,
                            height: 36,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: passwordController,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type Password',
                              hintStyle: TextStyle(
                                color: const Color(0xFF9E9A9A),
                                fontSize: 24,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                left: 46,
                top: 420,
                child: Container(
                  width: 311,
                  height: 52,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/user.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: usernameController,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type mail',
                              hintStyle: TextStyle(
                                color: const Color(0xFF9E9A9A),
                                fontSize: 24,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
                Positioned(
                  left: 46,
                  top: 551,
                  child: Container(
                    width: 311,
                    height: 52,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Image.asset(
                            "assets/images/locked-computer.png",
                            width: 36,
                            height: 36,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: rePasswordController,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Re-enter Password',
                              hintStyle: TextStyle(
                                color: const Color(0xFF9E9A9A),
                                fontSize: 24,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                left: -8,
                top: 740,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Container(
                    width: 154,
                    height: 49,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 47,
                          top: -8,
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 37,
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 230,
                top: 733,
                child: GestureDetector(
                  onTap: registerUser,
                            child: Text(
                              'Hop on!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 37,
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
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
    );
  }
}