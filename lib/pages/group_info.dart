import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/database_services.dart';
import 'package:chatapp_firebase/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo(
      {super.key,
      required this.adminName,
      required this.groupId,
      required this.groupName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xffee7b64),
        title: Text("Group Info"),
        actions: [
          IconButton(
              onPressed: (() {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Exit"),
                        content: const Text(
                            "Are you sure you want to exit the group?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              DatabaseService(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .toggleGroupJoin(widget.groupId,
                                      getName(widget.adminName), widget.groupName).whenComplete((){
                                        nextScreen(context, const HomePge());
                                      });
                            },
                                   
                            
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              }),
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xffee7b64).withOpacity(0.2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xffee7b64),
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Group : ${widget.groupName}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text("Admin : ${getName(widget.adminName)}"),
                    ],
                  )
                ],
              ),
            ),
            memberList()
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null) {
              if (snapshot.data['members'].length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data['members'].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xffee7b64),
                              child: Text(
                                widget.groupName.substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              )),
                          title: Text(getName(snapshot.data['members'][index])),
                          subtitle:
                              Text(getId(snapshot.data['members'][index])),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffee7b64),
                  ),
                );
              }
            } else {
              return Text('NO MEMBERS');
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xffee7b64),
              ),
            );
          }
        });
  }
}
