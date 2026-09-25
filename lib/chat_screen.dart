import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'show_prof1_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'video_call_page.dart';

class ChatScreen extends StatefulWidget {
    final dynamic user; // or use the correct type like `final User user;`
    const ChatScreen({Key? key, required this.user}) : super(key: key);
    @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final String chatId;
  final TextEditingController messageController = TextEditingController();
@override
void dispose() {
    messageController.dispose();
    super.dispose();
  }

@override
void initState() {
  super.initState();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final recipientId = widget.user['uid'];
  chatId = currentUserId.compareTo(recipientId) < 0
      ? '${currentUserId}_$recipientId'
      : '${recipientId}_$currentUserId';
}

Future<void> sendMessage() async {
  final String text = messageController.text.trim();
  if (text.isEmpty) return;

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final String recipientId = widget.user['uid'];

  // Generate chatId (e.g., lexicographically sorted to avoid duplicates)
  final chatId = currentUserId.compareTo(recipientId) < 0
      ? '${currentUserId}_$recipientId'
      : '${recipientId}_$currentUserId';

  final messageData = {
    'senderId': currentUserId,
    'text': text,
    'timestamp': FieldValue.serverTimestamp(),
  };

  await FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .add(messageData);

  messageController.clear();
}

    Widget build(BuildContext context) {
     return Scaffold(
      body: SingleChildScrollView(
        child: Center(
        child: Container(
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
                left: 0,
                top: 142,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 9,
                        top: 26,
                        child: GestureDetector(  // Added GestureDetector
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                            );
                          },
                        child: Container(
                          width: 34,
                          height: 34,
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
                      Positioned(
                        left: 51,
                        top: 11,
                        child: GestureDetector(  // Added GestureDetector
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ShowProfile1(user:widget.user)),
                            );
                          },
                        child: Container(
                          width: 64,
                          height: 64,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/user1.png"),
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
                      Positioned(
                        left: 131,
                        top: 26,
                        child: Container(
                          width: 129,
                          height: 29,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: SizedBox(
                                  width: 129,
                                  height: 29,
                                  child: Text(
                                    widget.user['firstName'] ?? 'Unknown',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
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
                        left: 300,
                        top: 26,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoCallPage(channelName: 'test'), // βάλε το σωστό όνομα σελίδας
                              ),
                            );
                          },
                          child: Container(
                            width: 34,
                            height: 34,
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
                                        image: AssetImage("assets/images/video-camera.png"),
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

                      Positioned(
                        left: 345,
                        top: 24,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ShowProfile1(user: widget.user),
                              ),
                            );
                          },
                        child: Container(
                          width: 34,
                          height: 34,
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
                                      image: AssetImage("assets/images/info.png"),
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
              ),
              
              Positioned(
                left: -4,
                top: 230,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 580, // Ύψος για τα μηνύματα
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatId)
                        .collection('messages')
                        .orderBy('timestamp')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final messages = snapshot.data!.docs;

                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: 80),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message['senderId'] == FirebaseAuth.instance.currentUser!.uid;
                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: isMe
                                  ? EdgeInsets.fromLTRB(50, 4, 12, 4)  // shift right message leftward
                                  : EdgeInsets.fromLTRB(12, 4, 50, 4),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.blue[200] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                message['text'],
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),
                          );

                        },
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: MediaQuery.of(context).viewInsets.bottom,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 96,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 20,
                        top: 5,
                        child: Container(
                          width: 287,
                          height: 36,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: -5,
                                top: 0,
                                child: Container(
                                  width: 292,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    border: Border.all( color: Colors.black,),
                                    borderRadius: BorderRadius.circular(30)
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: TextField(
                                    controller: messageController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Type Message',
                                    ),
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
                        left: 330,
                        top: 5,
                        child: GestureDetector(
                          onTap: () => sendMessage(),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/send.png"),
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