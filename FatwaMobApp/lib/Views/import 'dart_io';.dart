import 'dart:io';

import 'package:fatwa/Views/messagerie_screen.dart';
import 'package:fatwa/models/Message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fatwa/services/http.dart' as hp;
import 'package:provider/provider.dart';

import '../services/auth.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final storage = new FlutterSecureStorage();

  List<Message>? messages;
  var isLoaded = false;

  late List data1 = [];
  late List data2 = [];

  Future<List<Message>?> contacts() async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();
    final response = await client.get(
      hp.ApiUrl('/contacts'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var json = response.body;
      messages = messageFromJson(json);
      if (messages != null) {
        setState(() {
          var messages2 = messages!.toSet().toList();
          isLoaded = true;
        });
      }
    }
    print(messages);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    contacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussions'),
      ),
      body: Column(
        children: [
          Consumer<Auth>(builder: (context, auth, child) {
            if (auth.authenticated) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 120,
                  width: MediaQuery.of(context).size.width - 30,
                  child: Visibility(
                    visible: isLoaded,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: messages?.length,
                        itemBuilder: (context, index) {
                          index == 0 ?
                          data1.add(''):data1.add(messages![index].sender_id);
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: 
                            data1.contains(auth.user.id) == false ? 
                                  Container(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return Messagerie(
                                                id: messages![index]
                                                    .receiver_id,
                                              );
                                            },
                                          ));
                                        },
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  messages![index]
                                                      .receiveravatar
                                                      .toString()),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(messages![index]
                                                .receiverusername
                                                .toString(),style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                      ),
                                    ):Container(),
                                    );
                                  // : auth.user.id == messages![index].receiver_id && data2.contains(auth.user.id) == false
                                  //     ? Container(
                                  //         child: GestureDetector(
                                  //           onTap: () {
                                  //             Navigator.push(context,
                                  //                 MaterialPageRoute(
                                  //               builder: (context) {
                                  //                 return Messagerie(
                                  //                   id: messages![index]
                                  //                       .sender_id,
                                  //                 );
                                  //               },
                                  //             ));
                                  //           },
                                  //           child: Row(
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment.start,
                                  //             children: [
                                  //               CircleAvatar(
                                  //                 backgroundImage: NetworkImage(
                                  //                     messages![index]
                                  //                         .senderavatar
                                  //                         .toString()),
                                  //               ),
                                  //               SizedBox(
                                  //                 width: 20,
                                  //               ),
                                  //               Text(messages![index]
                                  //                   .senderusername
                                  //                   .toString()),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : Container());
                        }),
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }
}
