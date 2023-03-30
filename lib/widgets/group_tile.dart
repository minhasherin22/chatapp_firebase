import 'package:chatapp_firebase/pages/chat_page.dart';
import 'package:chatapp_firebase/widgets/widget.dart';
import 'package:flutter/material.dart';


class GroupTile extends StatefulWidget {
  String userName;
  String groupId;
  String groupName;
   GroupTile({super.key,required this.groupId,required this.groupName,required this.userName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(context,  ChatPage(
          groupId: widget.groupId,
          groupName: widget.groupName,
          userName: widget.userName,
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xffee7b64),
            child: Text(
              widget.groupName.substring(0,1).toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white,fontSize: 22),
            ),
            
          ),
          title: Text(
            widget.groupName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              
            ),
          ),
          subtitle: Text('Join the conversation as ${widget.userName}',style: TextStyle(fontSize: 13 ),),
        ),
      ),
    );
  }
}