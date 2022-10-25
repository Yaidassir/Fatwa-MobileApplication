import 'dart:io';

import 'package:fatwa/Views/article_screen.dart';
import 'package:fatwa/models/Imam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:fatwa/services/http.dart' as hp;
import '../models/Post.dart';
import '../services/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../services/dio.dart';
import 'package:dio/dio.dart' as Dio;

import 'messagerie_screen.dart';

class ImamScreen extends StatefulWidget {
  const ImamScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<ImamScreen> createState() => _ImamScreenState();
}

class _ImamScreenState extends State<ImamScreen> {
  Imam? imam;
  var isLoaded = false;
  bool showRapportForm = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _rapportController = TextEditingController();

  void getImam() async {
    var client = http.Client();

    final response = await client
        .post(hp.ApiUrl('/showImamAPI'), body: {'query': widget.id.toString()});
    if (response.statusCode == 200) {
      var json = response.body;
      imam = imamFromJson(json);
      if (imam != null) {
        setState(() {
          isLoaded = true;
        });
      }
    }
  }

  List<Post>? posts;
  var isLoadedPost = false;

  Future<List<Post>?> getPosts() async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.get(hp.ApiUrl('/articlesAPI')
        // Send authorization headers to the backend.
        );
    if (response.statusCode == 200) {
      var json = response.body;
      posts = postFromJson(json);
      // print(posts.toString());
      if (posts != null) {
        setState(() {
          isLoadedPost = true;
        });
      }
    }
  }

  final storage = new FlutterSecureStorage();

  void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token);
  }

  Future<void> sendRapport({Map? infos}) async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/create_userRapportAPI'),
      body: infos,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
  }

  Future<void> FollowImam({Map? infos}) async {
    String? token = await storage.read(key: 'token');

    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/post_followAPI'),
      body: infos,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
  }

  bool isFollowed = false;

  void checkFollow(Map map, {Map? infos}) async {
    String? token = await storage.read(key: 'token');

    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/checkFollowAPI'),
      body: infos,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.body == '1') {
      if (this.mounted) {
        setState(() {
          isFollowed = true;
        });
      }
    }
    print(response.body);
  }


  @override
  void initState() {
    super.initState();
    _rapportController.text = "";
    readToken();
    getPosts();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var auth = context.read<Auth>();
      if (auth.authenticated) {
        checkFollow({
          // 'user_id': auth.user.id.toString,
          // 'imam_id': widget.id.toString()
          'user_id': '1',
          'imam_id': '6'
        });
      }
    });

    getImam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Profil imam'),
        //   backgroundColor: Colors.green[700],
        // ),
        body: SingleChildScrollView(
      child: Column(
        children: [
          isLoaded == true
              ? Column(
                  children: [
                    Container(
                      height: 270,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 96, 192, 99),
                            Color.fromARGB(255, 1, 162, 184)
                          ]),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 40.0, left: 25, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(imam!.avatar),
                                    radius: 65,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  imam!.name + ' ' + imam!.lastname,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            Consumer<Auth>(builder: (context, auth, child) {
                              if (auth.authenticated &&
                                  auth.user.usertype == 0 && auth.user.etatcompte == 0) {
                                Map infos = {
                                  'user_id': auth.user.id.toString(),
                                  'imam_id': widget.id.toString()
                                };

                                return Column(
                                  children: [
                                    isFollowed
                                        ? IconButton(
                                            onPressed: () {
                                              FollowImam(infos: infos);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          super.widget));
                                            },
                                            icon: Icon(
                                              Icons.person_add_disabled,
                                              color: Colors.white,
                                            ))
                                        : IconButton(
                                            onPressed: () {
                                              FollowImam(infos: infos);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          super.widget));
                                            },
                                            icon: Icon(Icons.person_add,
                                                color: Colors.white)),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showRapportForm = !showRapportForm;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.library_books,
                                          color: Colors.white,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                            Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return Messagerie(
                                                id: widget.id.toString(),
                                              );
                                            },
                                          ));
                                        },
                                        icon: Icon(
                                          Icons.messenger,
                                          color: Colors.white,
                                        ))
                                  ],
                                );
                              } else {
                                return Container(width: 50,);
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Consumer<Auth>(builder: (context, auth, child) {
                          //   if (auth.authenticated) {
                          //     Map infos = {
                          //       'user_id': auth.user.id.toString(),
                          //       'imam_id': widget.id.toString()
                          //     };
                          //     checkFollow(infos: infos);

                          //     return Column(
                          //       children: [
                          //        isFollowed == false
                          //            ? ElevatedButton(
                          //                onPressed: () {
                          //                  FollowImam(infos: infos);
                          //                  Navigator.pushReplacement(
                          //                      context,
                          //                      MaterialPageRoute(
                          //                          builder: (BuildContext
                          //                                  context) =>
                          //                              super.widget));
                          //                },
                          //                child: Text('follow'))
                          //            : ElevatedButton(
                          //                style: ElevatedButton.styleFrom(
                          //                    primary: Colors.red),
                          //                onPressed: () {
                          //                  FollowImam(infos: infos);
                          //                  Navigator.pushReplacement(
                          //                      context,
                          //                      MaterialPageRoute(
                          //                         builder: (BuildContext
                          //                                  context) =>
                          //                              super.widget));
                          //                },
                          //                child: Text('unFollow')),
                          //         ElevatedButton(
                          //             onPressed: () {
                          //               setState(() {
                          //                 showRapportForm =
                          //                     !showRapportForm;
                          //               });
                          //             },
                          //             child: Text('Signaler l\'imam')),
                          //       ],
                          //     );
                          //   } else {
                          //     return Container();
                          //   }
                          // })
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Consumer<Auth>(builder: (context, auth, child) {
                          if (auth.authenticated) {
                            return Visibility(
                                visible: showRapportForm,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 30,
                                  child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: TextFormField(
                                              controller: _rapportController,
                                              decoration: InputDecoration(
                                                labelText: "Motif du rapport",
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              primary: Colors.blue,
                                            ),
                                            child: Text(
                                              'Envoyer',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                            onPressed: () {
                                              Map infos = {
                                                'sender_id':
                                                    auth.user.id.toString(),
                                                'motif':
                                                    _rapportController.text,
                                                'user_id': imam!.id.toString()
                                              };
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                sendRapport(infos: infos);
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            super.widget));
                                              }
                                            },
                                          )
                                        ],
                                      )),
                                ));
                          } else {
                            return Container();
                          }
                        }),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Nom:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(imam!.name)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Divider(
                        height: 10,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Prénom:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(imam!.lastname)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Divider(
                        height: 10,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Date de naissance:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(imam!.dateofbirth.toString().substring(0, 10))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Divider(
                        height: 10,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Adresse email:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(imam!.email)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Divider(
                        height: 10,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Description:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Flexible(child: Text(imam!.description))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Divider(
                        height: 10,
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Les articles publiés',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Visibility(
            visible: isLoadedPost,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: posts?.length,
              itemBuilder: (context, index) {
                return posts![index].imam_name.toString() ==
                        (imam!.name + ' ' + imam!.lastname)
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ArticleScreen(post: posts![index])));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 4,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  )
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 22.0, horizontal: 12.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 49,
                                            backgroundColor: Color.fromARGB(
                                                255, 96, 192, 99),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  posts![index].avatar),
                                              radius: 45,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  posts![index].imam_name,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                posts![index].title.length >20 ?
                                                Text(
                                                  posts![index].title.substring(0,20)+'...',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ): Text(
                                                  posts![index].title,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                if (posts![index].typepost == 1)
                                                  Text('hadith'),
                                                if (posts![index].typepost == 2)
                                                  Text('dars'),
                                                if (posts![index].typepost == 3)
                                                  Text('khoutba'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                posts![index].note.toString() ==
                                                        'null'
                                                    ? RatingBarIndicator(
                                                        rating: 0,
                                                        itemBuilder:
                                                            (context, index) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        itemCount: 5,
                                                        itemSize: 25.0,
                                                        direction:
                                                            Axis.horizontal,
                                                      )
                                                    : RatingBarIndicator(
                                                        rating: posts![index]
                                                            .note!
                                                            .toDouble(),
                                                        itemBuilder:
                                                            (context, index) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        itemCount: 5,
                                                        itemSize: 25.0,
                                                        direction:
                                                            Axis.horizontal,
                                                      ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container();
                // return Card(
                //   child: GestureDetector(
                //     onTap: () {
                //       Navigator.of(context).push(MaterialPageRoute(
                //           builder: (context) =>
                //               ArticleScreen(post: posts![index])));
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.all(15),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         children: [
                //           CircleAvatar(
                //             backgroundImage:
                //                 NetworkImage(posts![index].avatar),
                //             radius: 25,
                //           ),
                //           SizedBox(
                //             width: 10,
                //           ),
                //           Column(
                //             crossAxisAlignment:
                //                 CrossAxisAlignment.start,
                //             children: [
                //               Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   Text(
                //                     posts![index]
                //                         .imam_name
                //                         .toString(),
                //                     style: TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         color: Colors.green[700]),
                //                   ),
                //                   SizedBox(
                //                     width: 20,
                //                   ),
                //                   posts![index].note.toString() ==
                //                           'null'
                //                       ? Text('.../5')
                //                       : Text(posts![index]
                //                               .note
                //                               .toString()
                //                               .substring(0, 1) +
                //                           '/5'),
                //                 ],
                //               ),
                //               Text(
                //                 posts![index].title.toString(),
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.w600),
                //               ),
                //               if (posts![index].typepost == 1)
                //                 Text('hadith'),
                //               if (posts![index].typepost == 2)
                //                 Text('dars'),
                //               if (posts![index].typepost == 3)
                //                 Text('khoutba'),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // );
              },
            ),
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    ));
  }
}
