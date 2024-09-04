import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import '../../../common/color_extension.dart';
import 'package:http/http.dart' as http;
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final ChatUser _currentUser =
  ChatUser(id: '1', firstName: 'Swapnil', lastName: 'Kolte');

  final ChatUser _gptChatUser =
  ChatUser(id: '2', firstName: 'Chat', lastName: 'Bot');

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];


  final oururl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAnfDbFF5yAZd-GHLs_Hcnop5Dxz9KaNkA';

  final header = {
      'Content-Type': 'application/json'
  };

  getData(ChatMessage m) async {
    _typingUsers.add(_gptChatUser);
    _messages.insert(0, m);
    setState(() {
    });

    var data = {"contents":[{"parts":[{"text":m.text}]}]};

    await http.post(Uri.parse(oururl),headers: header,body: jsonEncode(data))
        .then((value){
          if(value.statusCode==200){
            var result = jsonDecode(value.body);
            print(result['candidates'][0]['content']['parts'][0]['text']);

            ChatMessage msg = ChatMessage(
              text: result['candidates'][0]['content']['parts'][0]['text'],
                user: _gptChatUser,
                createdAt: DateTime.now());
            
            _messages.insert(0, msg);

          }else{
            print("error occured");
          }
    })
        .catchError((e){});
    _typingUsers.remove(_gptChatUser);
    setState(() {

    });
  }
  
  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Tcolor.white,
      appBar: AppBar(
        backgroundColor: Tcolor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: mediaWidth * 0.1, // Adjusted height
            width: mediaWidth * 0.1, // Adjusted width
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Tcolor.lightgray,
              borderRadius: BorderRadius.circular(mediaWidth * 0.025), // Adjusted borderRadius
            ),
            child: Image.asset(
              "assets/images/black_btn.png",
              width: mediaWidth * 0.038, // Adjusted width
              height: mediaWidth * 0.038, // Adjusted height
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Chat Bot",
          style: TextStyle(
            color: Tcolor.black,
            fontSize: mediaWidth * 0.046, // Adjusted font size
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: DashChat(
        typingUsers: _typingUsers,
          currentUser: _currentUser,
          messageOptions: const MessageOptions(
            currentUserContainerColor: Color(0xff92A3FD),
            containerColor: Color(0xff9DCEFF),
            textColor: Colors.white,
          ),
          onSend: (ChatMessage m){
        getData(m);
      }, messages: _messages),
    );
  }
}
