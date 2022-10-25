// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:fatwa/Screens/HomePage/FatwaContentPage/CommentBox.dart';
import 'package:fatwa/Screens/HomePage/FatwaContentPage/Comments.dart';
import 'package:fatwa/models/Question.dart';
import 'package:fatwa/models/Reply.dart';
import 'package:fatwa/Views/imam_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fatwa/services/http.dart' as hp;
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Dimensions.dart';
import '../Screens/Profile/Componenets/Profile_pages/MyAccount/mybutton_widget.dart';
import '../services/auth.dart';

class FatwaScreen extends StatefulWidget {
  const FatwaScreen({Key? key, required this.question}) : super(key: key);
  final Question question;

  @override
  State<FatwaScreen> createState() => _FatwaScreenState();
}

class _FatwaScreenState extends State<FatwaScreen> {
  List<Reply>? replies;
  var isLoaded = false;
  TextEditingController _reponseController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  Future<List<Reply>?> getReplies({Map? infos}) async {
    var client = http.Client();

    final response = await client.post(hp.ApiUrl('/getReplies'), body: {
      'query': widget.question.id.toString(),
    });
    if (response.statusCode == 200) {
      var json = response.body;
      replies = replyFromJson(json);
      if (replies != null) {
        print(replies);
        setState(() {
          isLoaded = true;
        });
      }
    }

    print(response.body.toString());
  }

  final storage = new FlutterSecureStorage();

  void deleteQuestion() async {
    // final response = await client.post(hp.ApiUrl('/delete_questionAPI'), body: {
    //   'query': widget.question.id.toString(),
    // });

    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/delete_questionAPI'),
      body: {
        'query': widget.question.id.toString(),
      },
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    print(response.body);
  }

  Future<void> postResponse({Map? infos}) async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/post_reponseAPI'),
      body: infos,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
  }

  Future<void> deleteResponse({Map? infos}) async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/delete_replyAPI'),
      body: infos,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
  }

  @override
  void initState() {
    print(widget.question.id);
    getReplies();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.green[700],
        //   title: Text('Fatwa'),
        // ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                         Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 227, 248, 255),
                        ),
                        child: IconButton(
                          icon:Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: Color(0xFF756d54),),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width/1.4,
                        child: Text(
                          widget.question.title,
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                        ),
                      ),
                      ],),

                      Consumer<Auth>(builder: (context, auth, child) {
                        if (auth.authenticated) {
                          if (auth.user.id == widget.question.userId) {
                            return Container(
                              decoration: BoxDecoration(
                        color: Color.fromARGB(255, 218, 218, 218).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20)
                      ),
                              child: IconButton(
                                onPressed: () {
                                  deleteQuestion();
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sujet',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: Dimensions.height10,
                          ),
                          if (widget.question.typeqst == 1)
                            Text(
                              'Social',
                            ),
                          if (widget.question.typeqst == 2)
                            Text(
                              'Education',
                            ),
                          if (widget.question.typeqst == 3)
                            Text(
                              'Religion',
                            ),
                          if (widget.question.typeqst == 4)
                            Text(
                              'Langue',
                            ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                        color: Color.fromARGB(255, 218, 218, 218).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Nombre de vus : " +
                              widget.question.nbVus.toString()),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.orange[300],
                  ),
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Question',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white)),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        Text(
                          widget.question.contenu,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Réponses",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Consumer<Auth>(builder: (context, auth, child) {
                        if (auth.authenticated &&
                            auth.user.usertype == 1 &&
                            auth.user.etatcompte == 0) {
                          return ButtonWidget(
                            text: 'Répondre',
                            onClicked: () async {
                              showDialog<String>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Entrez votre réponse"),
                                        content: TextField(
                                          controller: _reponseController,
                                          autofocus: true,
                                          maxLines: 4,
                                          decoration: InputDecoration(
                                            fillColor: Colors.grey[300],
                                            hintText: 'Votre réponse',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Map infos = {
                                                  'user_id':
                                                      auth.user.id.toString(),
                                                  'question_id': widget
                                                      .question.id
                                                      .toString(),
                                                  'reponse':
                                                      _reponseController.text
                                                };
                                                postResponse(infos: infos);
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            super.widget));
                                              },
                                              child: Text(
                                                'Envoyer',
                                                style: TextStyle(fontSize: 16),
                                              ))
                                        ],
                                      ));
                            },
                          );
                        } else {
                          return Container();
                        }
                      }),
                    ],
                  ),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                Visibility(
                  visible: isLoaded,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: replies?.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ImamScreen(
                                                  id: replies![index]
                                                      .userId!
                                                      .toInt())));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                              replies![index].imamAvatar),
                                        ),
                                        SizedBox(
                                          width: Dimensions.width10,
                                        ),
                                        Text(replies![index].imamName),
                                           Consumer<Auth>(
                                            builder: (context, auth, child) {
                                          if (auth.authenticated) {
                                            if (auth.user.id ==
                                                replies![index].userId) {
                                              return IconButton(
                                                  onPressed: () {
                                                    Map infos = {
                                                      'id': replies![index]
                                                          .id
                                                          .toString()
                                                    };

                                                    deleteResponse(
                                                        infos: infos);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                super.widget));
                                                  },
                                                  color: Colors.red,
                                                  icon: Icon(
                                                    Icons.delete,
                                                  ));
                                            } else {
                                              return Container();
                                            }
                                          } else {
                                            return Container();
                                          }
                                        }),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimensions.height20,
                                  ),
                                  Text(replies![index].contenu),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                          replies![index].createdAt.toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // child: Card(
                          //   child: Column(
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: GestureDetector(
                          //           onTap: () {
                          //             Navigator.of(context).push(
                          //                 MaterialPageRoute(
                          //                     builder: (context) => ImamScreen(
                          //                         id: replies![index]
                          //                             .userId!
                          //                             .toInt())));
                          //           },
                          //           child: Row(
                          //             children: [
                          //               CircleAvatar(
                          //                 backgroundImage: NetworkImage(
                          //                     replies![index].imamAvatar),
                          //                 radius: 25,
                          //               ),
                          //               SizedBox(
                          //                 width: 10,
                          //               ),
                          //               Text(replies![index].imamName),
                          //               Consumer<Auth>(
                          //                   builder: (context, auth, child) {
                          //                 if (auth.authenticated) {
                          //                   if (auth.user.id ==
                          //                       replies![index].userId) {
                          //                     return IconButton(
                          //                         onPressed: () {
                          //                           Map infos = {
                          //                             'id': replies![index]
                          //                                 .id
                          //                                 .toString()
                          //                           };

                          //                           deleteResponse(
                          //                               infos: infos);
                          //                           Navigator.pushReplacement(
                          //                               context,
                          //                               MaterialPageRoute(
                          //                                   builder: (BuildContext
                          //                                           context) =>
                          //                                       super.widget));
                          //                         },
                          //                         color: Colors.red,
                          //                         icon: Icon(
                          //                           Icons.delete,
                          //                         ));
                          //                   } else {
                          //                     return Container();
                          //                   }
                          //                 } else {
                          //                   return Container();
                          //                 }
                          //               })
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.start,
                          //           children: [
                          //             Text(replies![index].contenu),
                          //           ],
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.end,
                          //           children: [
                          //             Text(
                          //                 replies![index].createdAt.toString()),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        );
                      }),
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
              ],
            ),
          ),

          // child: Column(
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           if (widget.question.typeqst == 1)
          //             Text(
          //               'Social',
          //               style: TextStyle(
          //                   fontSize: 18, fontWeight: FontWeight.bold),
          //             ),
          //           if (widget.question.typeqst == 2)
          //             Text(
          //               'Education',
          //               style: TextStyle(
          //                   fontSize: 18, fontWeight: FontWeight.bold),
          //             ),
          //           if (widget.question.typeqst == 3)
          //             Text(
          //               'Religion',
          //               style: TextStyle(
          //                   fontSize: 18, fontWeight: FontWeight.bold),
          //             ),
          //           if (widget.question.typeqst == 4)
          //             Text(
          //               'Langue',
          //               style: TextStyle(
          //                   fontSize: 18, fontWeight: FontWeight.bold),
          //             ),
          //           Column(
          //             crossAxisAlignment: CrossAxisAlignment.end,
          //             children: [
          //               Text(widget.question.createdAt.toString()),
          //               Text("Nombre de vus : " +
          //                   widget.question.nbVus.toString()),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             widget.question.title.toString(),
          //             style:
          //                 TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          //           ),
          //           Consumer<Auth>(builder: (context, auth, child) {
          //             if (auth.authenticated) {
          //               if (auth.user.id == widget.question.userId) {
          //                 return IconButton(
          //                   onPressed: () {
          //                     deleteQuestion();
          //                     Navigator.of(context).pop();
          //                   },
          //                   icon: Icon(Icons.delete),
          //                   color: Colors.red,
          //                 );
          //               } else {
          //                 return Container();
          //               }
          //             } else {
          //               return Container();
          //             }
          //           }),
          //         ],
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         children: [
          //           Expanded(
          //             child: Text(
          //               widget.question.contenu.toString(),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     const Center(
          //                       child: Text(
          //                     'Réponses',
          //                     style: TextStyle(
          //                         fontSize: 20, fontWeight: FontWeight.bold),
          //                   )),
          //     Consumer<Auth>(builder: (context, auth, child) {
          //       if (auth.authenticated && auth.user.usertype == 1 && auth.user.etatcompte == 0) {
          //         return SizedBox(
          //           height: 150,
          //           width: MediaQuery.of(context).size.width - 40,
          //           child: Form(
          //               key: _formKey,
          //               child: Column(
          //                 children: [
          //                   TextFormField(
          //                     controller: _reponseController,
          //                     decoration: const InputDecoration(
          //                       labelText: "Entrez votre réponse!",
          //                     ),
          //                   ),
          //                   TextButton(
          //                     style: TextButton.styleFrom(
          //                       primary: Colors.blue,
          //                     ),
          //                     child: Text('Envoyer'),
          //                     onPressed: () {
          //                       Map infos = {
          //                         'user_id': auth.user.id.toString(),
          //                         'question_id':
          //                             widget.question.id.toString(),
          //                         'reponse': _reponseController.text
          //                       };
          //                       if (_formKey.currentState!
          //                           .validate()) {
          //                         postResponse(infos: infos);
          //                         Navigator.pushReplacement(
          //                             context,
          //                             MaterialPageRoute(
          //                                 builder: (BuildContext
          //                                         context) =>
          //                                     super.widget));
          //                       }
          //                     },
          //                   ),
          //                 ],
          //               )),
          //         );
          //       } else {
          //         return Container();
          //       }
          //     }),

          //     Visibility(
          //       visible: isLoaded,
          //       child: ListView.builder(
          //           scrollDirection: Axis.vertical,
          //           shrinkWrap: true,
          //           itemCount: replies?.length,
          //           itemBuilder: (context, index) {
          //             return Padding(
          //               padding: const EdgeInsets.symmetric(vertical: 5),
          //               child: Card(
          //                 child: Column(
          //                   children: [
          //                     Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: GestureDetector(
          //                         onTap: () {
          //                           Navigator.of(context).push(
          //                               MaterialPageRoute(
          //                                   builder: (context) => ImamScreen(
          //                                       id: replies![index]
          //                                           .userId!
          //                                           .toInt())));
          //                         },
          //                         child: Row(
          //                           children: [
          //                             CircleAvatar(
          //                               backgroundImage: NetworkImage(
          //                                   replies![index].imamAvatar),
          //                               radius: 25,
          //                             ),
          //                             SizedBox(
          //                               width: 10,
          //                             ),
          //                             Text(replies![index].imamName),
          //                              Consumer<Auth>(builder:
          //                                           (context, auth, child) {
          //                                         if (auth.authenticated) {
          //                                           if (auth.user.id ==
          //                                               replies![index]
          //                                                   .userId) {
          //                                             return IconButton(
          //                                                 onPressed: () {
          //                                                   Map infos = {
          //                                                     'id': replies![
          //                                                             index]
          //                                                         .id
          //                                                         .toString()
          //                                                   };

          //                                                   deleteResponse(
          //                                                       infos: infos);
          //                                                   Navigator.pushReplacement(
          //                                                       context,
          //                                                       MaterialPageRoute(
          //                                                           builder: (BuildContext
          //                                                                   context) =>
          //                                                               super
          //                                                                   .widget));
          //                                                 },
          //                                                 color: Colors.red,
          //                                                 icon: Icon(
          //                                                   Icons.delete,
          //                                                 ));
          //                                           } else {
          //                                             return Container();
          //                                           }
          //                                         } else {
          //                                           return Container();
          //                                         }
          //                                       })
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //                     Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Row(
          //                         mainAxisAlignment: MainAxisAlignment.start,
          //                         children: [
          //                           Text(replies![index].contenu),
          //                         ],
          //                       ),
          //                     ),
          //                     Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Row(
          //                         mainAxisAlignment: MainAxisAlignment.end,
          //                         children: [
          //                           Text(replies![index].createdAt.toString()),
          //                         ],
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             );
          //           }),
          //       replacement: const Center(
          //         child: CircularProgressIndicator(),
          //       ),
          //     )
          //   ],
          // ),
        ));
  }
}

// class ContentHeader extends StatefulWidget {
//   const ContentHeader({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<ContentHeader> createState() => _ContentHeaderState();
// }

// class _ContentHeaderState extends State<ContentHeader> {
//   late TextEditingController controller;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     controller = TextEditingController();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     void submit() {
//       Navigator.of(context).pop(controller.text);
//     }

//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 height: 50.0,
//                 width: 50.0,
//                 decoration: new BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: new BorderRadius.all(Radius.circular(50))),
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: NetworkImage(
//                       'https://www.japanfm.fr/wp-content/uploads/2022/01/Jujutsu.jpg'),
//                 ),
//               ),
//               SizedBox(
//                 width: Dimensions.width10,
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Nagato - Pain",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "19:22",
//                     style: TextStyle(color: Colors.grey, fontSize: 14),
//                   ),
//                 ],
//               )
//             ],
//           ),
//           PopupMenuButton(
//             itemBuilder: (context) => [
//               // popupmenu item 1
//               PopupMenuItem(
//                 onTap: () {
//                   Future.delayed(
//                       Duration(seconds: 0),
//                       () => showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: Text('Votre rapport'),
//                               content: TextField(
//                                 controller: controller,
//                                 autofocus: true,
//                                 maxLines: 4,
//                                 decoration: InputDecoration(
//                                   fillColor: Colors.grey[300],
//                                   hintText: 'Entez votre rapport',
//                                 ),
//                               ),
//                               actions: [
//                                 TextButton(
//                                     onPressed: () {
//                                       submit();
//                                     },
//                                     child: Text(
//                                       'Submit',
//                                       style: TextStyle(fontSize: 16),
//                                     ))
//                               ],
//                             ),
//                           ));
//                 },
//                 child: Row(
//                   children: [
//                     Icon(Icons.report),
//                     SizedBox(
//                       // sized box with width 10
//                       width: 10,
//                     ),
//                     Text("Signaler")
//                   ],
//                 ),
//               ),
//             ],
//             offset: Offset(-10, 45),
//             color: Colors.white,
//             elevation: 2,
//           ),
//         ],
//       ),
//     );
//   }
// }
