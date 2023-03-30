

import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/profile_page.dart';
import 'package:chatapp_firebase/pages/search_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_services.dart';
import 'package:chatapp_firebase/widgets/group_tile.dart';
import 'package:chatapp_firebase/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class HomePge extends StatefulWidget {
  const HomePge({super.key});

  @override
  State<HomePge> createState() => _HomePgeState();
}

class _HomePgeState extends State<HomePge> {
  String userName = '';
  String email = '';
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  String getId(String res){
    return res.substring(0,res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (() {
                nextScreenReplace(context, const SearchPage());
              }),
              icon: const Icon(Icons.search))
        ],
        backgroundColor: const Color(0xffee7b64),
        centerTitle: true,
        title: const Text(
          'Groups',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle, size: 100, color: Colors.grey[400]),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: (() {}),
              selectedColor: const Color(0xffee7b64),
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(
                Icons.group,
              ),
              title: const Text(
                'Groups',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: (() {
                nextScreenReplace(
                    context,
                    ProfilePage(
                      userName: userName,
                      email: email,
                    ));
              }),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(
                Icons.person,
              ),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: ((context,setState){
                        return AlertDialog(
                          title: const Text('Logout'),
                          content:
                              const Text('Are you sure you want to logout? '),
                          actions: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                )),
                            IconButton(
                                onPressed: () async {
                                  await authService.signOut();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ))
                          ],
                        );
                        })
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(
                Icons.exit_to_app,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: const Color(0xffee7b64),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Create a group',
              textAlign: TextAlign.left,
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              _isLoading == true
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xffee7b64)),
                    )
                  : TextField(
                      onChanged: (value) {
                        setState(() {
                          groupName = value;
                        });
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffee7b64),
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffee7b64),
                              ),
                              borderRadius: BorderRadius.circular(20))),
                    )
            ]),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xffee7b64)),
                onPressed: (() {
                  Navigator.of(context).pop();
                }),
               child: Text('Cancel')
               ),
               ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xffee7b64)),
                onPressed: () async {
                  if(groupName != ""){
                    setState(() {
                      _isLoading = true;
                    });
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(userName, FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete((){
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                    showSnackbar(context, Colors.green, "group created successfully");
                  }
                },
               child: Text('Create')
               )
               ],
          );
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != null) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context,index){
                  int reversIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                    groupId: getId(snapshot.data['groups'][reversIndex]),
                    groupName: getName(snapshot.data['groups'][reversIndex]),
                    userName:snapshot.data['fullName']
                    );
                }
                );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xffee7b64)),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: const Icon(
              Icons.add_circle,
              size: 75,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'You have not joined any groups,tap on the add icon to create a group or also search from top search',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
