import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
                  left: 46,
                  top: 490,
                  child: Container(
                    width: 311,
                    height: 53,
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
            image: AssetImage('assets/images/locked-computer.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Expanded(
        child: TextField(
          controller: _passwordController,
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Password',
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
                  top: 420,
                  child: Container(
                    width: 311,
                    height: 52,
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
                              controller: _usernameController,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Username',
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
                          left: 2,
                          top: 0,
                          child: Container(
                            width: 146,
                            height: 146,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/topcar.png'),
                                fit: BoxFit.cover,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 142,
                          top: 12,
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
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 13,
                  top: 341,
                  child: Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontFamily: 'League Spartan',
                      fontWeight: FontWeight.w400,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          color: Color(0xFF000000).withOpacity(0.25),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 258,
                  top: 582,
                  child: GestureDetector(
                    onTap: () async {
                      String username = _usernameController.text.trim();
                      String password = _passwordController.text.trim();

                      try {
                        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: username,
                          password: password,
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Login Failed"),
                            content: Text("Invalid credentials or user not found."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Enter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            color: Color(0xFF000000).withOpacity(0.25),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 214,
                  top: 730,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
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
    ),
  );
  }
}
