import 'dart:convert';
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
  List<Message>? dummy;
  List<Message>? distinct;


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
          isLoaded = true;
        });
      }
    }

    var seen = Set<Message>();
    List<Message> uniquelist = messages!.where((e) => seen.add(e)).toList();


    dummy = [];
  int i=0,k=0;

  while (i >messages!.length){

    for (int j = 0; j > messages!.length; j++) {
      if (messages![i].receiver_id!=messages![j].receiver_id){

      }
    }
  }

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
        backgroundColor: Color.fromARGB(255, 96, 192, 99),
        title: Text('Discussions'),
      ),
      body: Column(
        children: [
          // Visibility(
          //   visible: false,
          //   child: ListView.builder(
          //       scrollDirection: Axis.vertical,
          //       itemCount: messages?.length,
          //       itemBuilder: (context, index) {
          //         data1.add(messages![index].receiver_id);
          //         data1 = data1.toSet().toList();
          //         print(data1);
          //         return Container();
          //       }),
          // ),
          Consumer<Auth>(builder: (context, auth, child) {
            if (auth.authenticated) {
              if (auth.user.usertype == 0) {
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
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: data1.contains(
                                            messages![index].receiver_id) ==
                                        false
                                    ? Container(
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
                                                radius: 30,
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
                                                  .toString().toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container());
                          }),
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                );
              } else {
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
                            // Future.delayed(const Duration(milliseconds: 100 ),(){
                            //   data1.add(messages![index].receiver_id);
                            // });
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return Messagerie(
                                                  id: messages![index]
                                                      .sender_id,
                                                );
                                              },
                                            ));
                                          },
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundImage: NetworkImage(
                                                    messages![index]
                                                        .senderavatar
                                                        .toString()),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(messages![index]
                                                  .senderusername
                                                  .toString().toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ),
                                      )
                                    );
                          }),
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }
}
