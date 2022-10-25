import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fatwa/Dimensions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fatwa/services/http.dart' as hp;
import 'package:provider/provider.dart';

import '../../../../../Views/imam_screen.dart';
import '../../../../../models/user.dart';
import '../../../../../services/auth.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _switchValue = true;
  List<User>? follows;
  var isLoaded = false;
  final storage = new FlutterSecureStorage();

  Future<List<User>?> getFollows() async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.get(
      hp.ApiUrl('/follows'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var json = response.body;
      follows = userFromJson(json);
      // print(follows!.length);
      if (follows != null) {
        setState(() {
          isLoaded = true;
        });
      }
    }
    print(follows![0]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFollows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top:35,left:10,right:10,bottom:20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFfcf4e4),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: Color(0xFF756d54),
                  ),
                ),
              ),
              title: Text(
                'Abonnements',
                style: TextStyle(),
              ),
            ),
            Consumer<Auth>(builder: (context, auth, child) {
              if (auth.authenticated && auth.user.usertype == 0) {
                return Column(children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: isLoaded,
                              child: SizedBox(
                                height: 200,
                                width: 250,
                                child: ListView.builder(
                                  itemCount: follows?.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImamScreen(
                                                        id: follows![index].id,
                                                      )));
                                        },
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  follows![index].avatar),
                                              radius: 30,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(follows![index]
                                                    .name
                                                    .toString() +
                                                ' ' +
                                                follows![index]
                                                    .lastname
                                                    .toString()),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          ])),
                ]);
              } else {
                return Container();
              }
            })
            //     : SizedBox(
            //         height: 0,
            //       ),
            // auth.user.usertype == 0
            //     ? Visibility(
            //         visible: isLoaded,
            //         child: SizedBox(
            //           height: 200,
            //           child: ListView.builder(
            //             itemCount: follows?.length,
            //             itemBuilder: (context, index) {
            //               return Container(
            //                 child: GestureDetector(
            //                   onTap: () {
            //                     Navigator.of(context).push(
            //                         MaterialPageRoute(
            //                             builder: (context) =>
            //                                 ImamScreen(id: follows![index].id,)));
            //                   },
            //                   child: Row(
            //                     children: [
            //                       CircleAvatar(
            //                         backgroundImage: NetworkImage(
            //                             follows![index].avatar),
            //                         radius: 30,
            //                       ),
            //                       SizedBox(
            //                         width: 10,
            //                       ),
            //                       Text(follows![index]
            //                               .name
            //                               .toString() +
            //                           ' ' +
            //                           follows![index]
            //                               .lastname
            //                               .toString()),
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             },
            //           ),
            //         ),
            //         replacement: const Center(
            //           child: CircularProgressIndicator(),
            //         ),
            //       )
            //     : SizedBox(
            //         height: 0,
            //       )
          ],
        ),
      ),
    );
  }
}
