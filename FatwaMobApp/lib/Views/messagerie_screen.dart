import 'dart:io';

import 'package:fatwa/models/Message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fatwa/services/http.dart' as hp;
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../services/dio.dart';
import 'package:dio/dio.dart' as Dio;

class Messagerie extends StatefulWidget {
  final id;
  const Messagerie({Key? key, this.id}) : super(key: key);

  @override
  State<Messagerie> createState() => _MessagerieState();
}

class _MessagerieState extends State<Messagerie> {
  final storage = new FlutterSecureStorage();

  final TextEditingController _msgController = TextEditingController();

  void send(String $message) async {
    String? token = await storage.read(key: 'token');
    Dio.Response response =
        await dio().post('/messages/' + widget.id.toString(),
            data: {'message': $message},
            options: Dio.Options(
              headers: {'Authorization': 'Bearer $token'},
              followRedirects: false,
              validateStatus: (status) => true,
            ));

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => Messagerie(id: widget.id.toString())),
    );
  }

  List<Message>? messages;
  var isLoaded = false;

  Future<List<Message>?> receivedmsg() async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();
    final response = await client.get(
      hp.ApiUrl('/messages/' + widget.id.toString()),
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _msgController.text = "";
    receivedmsg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 96, 192, 99),
        title: Text('Messagerie'),
      ),
      body: GestureDetector(
         onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [        
              Consumer<Auth>(builder: (context, auth, child) {
                if (auth.authenticated) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height-140,
                          width: MediaQuery.of(context).size.width - 30,
                          child: Visibility(
                            visible: isLoaded,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: messages?.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: auth.user.id == messages![index].sender_id
                                          ? Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(messages![index].contenu),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        messages![index]
                                                            .senderavatar
                                                            .toString()),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        messages![index]
                                                            .senderavatar
                                                            .toString()),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(messages![index].contenu),
                                                ],
                                              ),
                                            ));
                                }),
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                           Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.grey[100],
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width-80,
                        height: 50,
                        child: TextFormField(
                          controller: _msgController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Message',
                          ),
                        ),
                      ),
                      IconButton(onPressed: (){
                        send(_msgController.text);
                      }, icon: Icon(Icons.send,color: Colors.blue[400],))
                    ],
                  ),
                ),
              ),
              // Center(
              //     child: ElevatedButton(
              //   onPressed: () {
              //     send(_msgController.text);
              //   },
              //   child: Text('Send'),
              // )),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        
              
            ],
          ),
        ),
      ),
    );
  }
}
