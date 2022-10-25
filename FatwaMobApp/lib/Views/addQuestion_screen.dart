import 'dart:convert';

import 'package:fatwa/Views/fatwas_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:fatwa/services/dio.dart';

import '../Dimensions.dart';
import '../Screens/HomePage/Home_Fatwa/Home_Fatwa.dart';
import '../services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:fatwa/services/http.dart' as hp;
import 'package:dio/dio.dart' as Dio;

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key}) : super(key: key);

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final storage = new FlutterSecureStorage();

  final _formquestionKey = GlobalKey<FormState>();
  TextEditingController _titreController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  TextEditingController _categorieController = TextEditingController();
  TextEditingController _questionController = TextEditingController();

  String selecteddropdownvalue = '3';
  String dropdownvalue = 'Religion';
  var items = [
    'Religion',
    'Social',
    'Education',
    'Langage',
  ];

  String? selectedName;
  List data = [];

  Future getCategoriesNames() async {
    var client = http.Client();

    final response = await client.get(
      hp.ApiUrl('/showCategoriesAPI'),
    );
    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody);
    setState(() {
      data = jsonData;
    });
    return 'success';
  }

  void createQuestion({Map? infos}) async {
    String? token = await storage.read(key: 'token');

    final response = await http.post(
      hp.ApiUrl('/post_questionAPI'),
      body: infos,
    );
  }

  @override
  void initState() {
    super.initState();

    _typeController.text = "";
    _categorieController.text = "";
    _titreController.text = "";
    _questionController.text = "";
    getCategoriesNames();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
        // appBar: AppBar(
        //     backgroundColor: Colors.green[700],
        //     title: Text('Poser une question')),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Consumer<Auth>(builder: (context, auth, child) {
              if (auth.authenticated) {
          if (auth.user.usertype == 0) {
            return Form(
              key: _formquestionKey,
              child: Column(
                children: [
                  Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child:  Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(255, 96, 192, 99),
                              Color.fromARGB(255, 1, 162, 184)
                            ]),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Expanded(
                                child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(left:20.0),
                                child: Text('Poser une question',style: TextStyle(color: Colors.white,fontSize: 26,fontWeight:FontWeight.bold)),
                              ),
                              leading: IconButton(
                                icon: Icon(Icons.arrow_back_ios,
                                    color: Colors.white, size: 35),
                                onPressed: () => Navigator.pop(context),
                              ),
                            )),
                          ),
                        ),
                      ),
              ),
                  const ListTile(
                    leading: Text(
                      "Posez votre question!",
                      style: TextStyle(fontSize: 18, color: Colors.cyan),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                        controller: _titreController,
                        decoration: InputDecoration(
                          labelText: 'titre',
                          hintText: 'Titre de votre question ..',
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator:(value){
                              if (value == null || value.isEmpty) {
                                return 'Entrer le sujet de votre question !';
                              } 
                              return null;
                            }
                        ),
                  ),
                  const ListTile(
                    leading: Text(
                      "Type de votre question",
                      style: TextStyle(fontSize: 18, color: Colors.cyan),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: ButtonTheme(
                      textTheme: ButtonTextTheme.primary,
                      alignedDropdown: true,
                      child: DropdownButtonFormField(
                        hint: Text('Type'),
                        isExpanded: true,
                        value: dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                            switch (dropdownvalue) {
                              case 'Social':
                                {
                                  selecteddropdownvalue = '1';
                                }
                                break;
        
                              case 'Education':
                                {
                                  selecteddropdownvalue = '2';
                                }
                                break;
        
                              case 'Religion':
                                {
                                  selecteddropdownvalue = '3';
                                }
                                break;
        
                              case 'Langage':
                                {
                                  selecteddropdownvalue = '4';
                                }
                                break;
        
                              default:
                                {
                                  selecteddropdownvalue = '3';
                                }
                                break;
                            }
                          });
                        },
                        validator:(value){
                        if (value == null ) {
                          return 'Choisissez le type de question !';
                        } 
                        return null;
                      }
                      ),
                    ),
                  ),
                  const ListTile(
                    leading: Text(
                      "Question categorie",
                      style: TextStyle(fontSize: 18, color: Colors.cyan),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: ButtonTheme(
                      textTheme: ButtonTextTheme.primary,
                      alignedDropdown: true,
                      child: DropdownButtonFormField(
                          isExpanded: true,
                          value: selectedName,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          hint: Text('Catégorie'),
                          items: data.map(
                            (list) {
                              return DropdownMenuItem(
                                child: Text(list['name']),
                                value: list['id'].toString(),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedName = value as String?;
                            });
                          },
                          validator:(value){
                        if (value == null ) {
                          return 'Choisissez une catégorie !';
                        } 
                        return null;
        }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Question",
                          style: TextStyle(color: Colors.cyan, fontSize: 18),
                        ),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        TextFormField(
                            controller: _questionController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintText: 'Votre question ..',
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            validator:(value){
                                if (value == null || value.isEmpty) {
                                  return 'Entrer votre Question !';
                                } 
                                return null;
                              }
                            ),
                        SizedBox(height: Dimensions.height25),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.orange[300],
                              borderRadius: BorderRadius.circular(25)),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: () {
                                Map infos = {
                                  "title": _titreController.text,
                                  "typeqst": selecteddropdownvalue,
                                  "category_id": selectedName,
                                  "contenu": _questionController.text,
                                  "user_id": auth.user.id.toString(),
                                };
                                if (_formquestionKey.currentState!.validate()) {
                                  createQuestion(infos: infos);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) => FatwasScreen()));
                                }
                              },
                              child: Text(
                                "Publier",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 20),
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
              } else {
          return Container();
              }
            }),
        )
        // body: Column(children: [
        //   Consumer<Auth>(builder: (context, auth, child) {
        //     if (auth.authenticated) {
        //       if (auth.user.usertype == 0) {
        //         return Column(children: [
        //           Padding(
        //             padding: const EdgeInsets.all(12.0),
        //             child: Form(
        //                 key: _formquestionKey,
        //                 child: Column(
        //                   children: [
        //                     TextFormField(
        //                       controller: _titreController,
        //                       decoration: InputDecoration(
        //                         labelText: "Le titre de votre question",
        //                       ),
        //                     ),
        //                     DropdownButton(
        //                       value: dropdownvalue,
        //                       icon: const Icon(Icons.keyboard_arrow_down),
        //                       items: items.map((String items) {
        //                         return DropdownMenuItem(
        //                           value: items,
        //                           child: Text(items),
        //                         );
        //                       }).toList(),
        //                       onChanged: (String? newValue) {
        //                         setState(() {
        //                           dropdownvalue = newValue!;
        //                           switch (dropdownvalue) {
        //                             case 'Social':
        //                               {
        //                                 selecteddropdownvalue = '1';
        //                               }
        //                               break;

        //                             case 'Education':
        //                               {
        //                                 selecteddropdownvalue = '2';
        //                               }
        //                               break;

        //                             case 'Religion':
        //                               {
        //                                 selecteddropdownvalue = '3';
        //                               }
        //                               break;

        //                             case 'Langage':
        //                               {
        //                                 selecteddropdownvalue = '4';
        //                               }
        //                               break;

        //                             default:
        //                               {
        //                                 selecteddropdownvalue = '3';
        //                               }
        //                               break;
        //                           }
        //                         });
        //                       },
        //                     ),
        //                     DropdownButton(
        //                         value: selectedName,
        //                         icon: const Icon(Icons.keyboard_arrow_down),
        //                         hint: Text('select'),
        //                         items: data.map(
        //                           (list) {
        //                             return DropdownMenuItem(
        //                               child: Text(list['name']),
        //                               value: list['id'].toString(),
        //                             );
        //                           },
        //                         ).toList(),
        //                         onChanged: (value) {
        //                           setState(() {
        //                             selectedName = value as String?;
        //                           });
        //                         }),
        //                     TextFormField(
        //                       controller: _questionController,
        //                       decoration: InputDecoration(
        //                         labelText: "Entrez votre question",
        //                       ),
        //                     ),
        //                     TextButton(
        //                       style: TextButton.styleFrom(
        //                         primary: Colors.blue,
        //                       ),
        //                       child: Text('Envoyer'),
        //                       onPressed: () {
        //                         Map infos = {
        //                           "title": _titreController.text,
        //                           "typeqst": selecteddropdownvalue,
        //                           "category_id": selectedName,
        //                           "contenu": _questionController.text,
        //                           "user_id": auth.user.id.toString(),
        //                         };
        //                         if (_formquestionKey.currentState!.validate()) {
        //                           createQuestion(infos: infos);
        //                           Navigator.pushReplacement(
        //                               context,
        //                               MaterialPageRoute(
        //                                   builder: (BuildContext context) =>
        //                                       super.widget));
        //                         }
        //                       },
        //                     )
        //                   ],
        //                 )),
        //           ),
        //         ]);
        //       } else {
        //         return Container();
        //       }
        //     } else {
        //       return Container();
        //     }
        //   }),
        // ]),
        );
  }
}
