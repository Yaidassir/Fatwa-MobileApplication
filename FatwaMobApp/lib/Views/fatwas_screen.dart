// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'dart:convert';
import 'package:fatwa/models/Category.dart';
import 'package:fatwa/models/Question.dart';
import 'package:fatwa/Views/addQuestion_screen.dart';
import 'package:fatwa/Views/articles_screen.dart';
import 'package:fatwa/Views/fatwa_screen.dart';
import 'package:fatwa/Views/fatwas_categorie_screen.dart';
import 'package:fatwa/Views/home_screen.dart';
import 'package:fatwa/Views/login_screen.dart';
import 'package:fatwa/Views/profil_screen.dart';
import 'package:fatwa/Views/register_screen.dart';
import 'package:fatwa/Views/registerpro_screen.dart';
import 'package:fatwa/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:fatwa/services/http.dart' as hp;
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../Dimensions.dart';
import '../Screens/HomePage/Home_Fatwa/Home_Fatwa.dart';

class FatwasScreen extends StatefulWidget {
  const FatwasScreen({Key? key}) : super(key: key);
  @override
  State<FatwasScreen> createState() => _FatwasScreenState();
}

class _FatwasScreenState extends State<FatwasScreen> {
  final storage = new FlutterSecureStorage();
  int selectedIndex = 0;
  int buttoncolor = 0;

  PageController controller = PageController();
  List<Widget> _list = <Widget>[
    new Center(
        child: new Pages(
      text: "Page 1",
    )),
    new Center(
        child: new Pages(
      text: "Page 2",
    )),
    new Center(
        child: new Pages(
      text: "Page 3",
    )),
  ];
  int _curr = 0;
  var _currentIndex = 3;

  List<Question>? questions;
  var isLoaded = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _searchController = TextEditingController();

  Future<List<Question>?> getQuestions() async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.get(
      hp.ApiUrl('/showFatwasAPI'),
      // Send authorization headers to the backend.
    );
    if (response.statusCode == 200) {
      var json = response.body;
      questions = questionFromJson(json);
      if (questions != null) {
        setState(() {
          isLoaded = true;
        });
      }
    }
  }

  bool showQuestionForm = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<Question>? questions_vus;
  var isQuestionsVusLoaded = false;

  Future<List<Question>?> getQuestionsByVus() async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.get(
      hp.ApiUrl('/showFatwasByViewsAPI'),
      // Send authorization headers to the backend.
    );
    if (response.statusCode == 200) {
      var json = response.body;
      questions_vus = questionFromJson(json);
      if (questions_vus != null) {
        setState(() {
          isQuestionsVusLoaded = true;
        });
      }
    }
  }

  List<String> _kOptions = <String>[];
  List data = [];
  List data2 = [];

  Future<void> getPerfs(Map? infos) async {
    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/PrefAPI'),
      body: infos,
    );
    var jsonData = json.decode(response.body);

    setState(() {
      data = jsonData;
    });

    for (var item in data) {
      getSouscat({
        'query': item.toString(),
      });
    }
    // print(data);
  }

  Future<void> getSouscat(Map? infos) async {
    var client = http.Client();

    final response =
        await client.post(hp.ApiUrl('/showFatwasByCategorieAPI'), body: infos);

    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody);
    setState(() {
      data2 = data2..addAll(jsonData);
    });
    data2 = data + data2;
    print(data2);
  }

  List<Category> categories = [];
  var isCategoriesLoaded = false;

  Future<List<Category>?> getCategories() async {
    var client = http.Client();

    final response = await client.get(
      hp.ApiUrl('/showCategoriesAPI'),
    );
    if (response.statusCode == 200) {
      var json = response.body;
      categories = categoryFromJson(json);
      if (categories != null) {
        setState(() {
          isCategoriesLoaded = true;
        });
      }
    }
  }

  bool isSearching = false;
  List<Question>? searchFatwa;

  void search({Map? infos}) async {
    String? token = await storage.read(key: 'token');

    final response = await http.post(
      hp.ApiUrl('/searchquestionAPI'),
      body: infos,
    );
    if (response.statusCode == 200) {
      var json = response.body;
      searchFatwa = questionFromJson(json);
    }

    if (searchFatwa != null) {
      setState(() {
        isSearching = true;
      });
    }
  }

  @override
  void initState() {
    _searchController.text = "";

    super.initState();
    readToken();
    getCategories();
    getQuestions();
    getQuestionsByVus();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var auth = context.read<Auth>();
      if (auth.authenticated) {
        getPerfs({'id': auth.user.id.toString()});
      }
    });
  }

  void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset : false,

      // appBar: AppBar(
      //   backgroundColor: Colors.green[700],
      //   title: Text('Fatwas'),
      //   actions: [
      //     Consumer<Auth>(builder: (context, auth, child) {
      //       if (auth.authenticated && auth.user.usertype == 0) {
      //         return Row(
      //           children: [
      //             Text(
      //               'Poser une question',
      //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      //             ),
      //             IconButton(
      //                 onPressed: () {
      //                   Navigator.of(context).push(MaterialPageRoute(
      //                       builder: (context) => AddQuestion()));
      //                 },
      //                 icon: const Icon(Icons.add)),
      //           ],
      //         );
      //       } else {
      //         return Container();
      //       }
      //     })
      //   ],
      // ),
      body: GestureDetector(
        onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Padding(
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
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text('Fatwas',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                              ),
                              leading: IconButton(
                                icon: Icon(Icons.menu,
                                    color: Colors.white, size: 35),
                                onPressed: () =>
                                    scaffoldKey.currentState?.openDrawer(),
                              ),
                              trailing:
                                  Consumer<Auth>(builder: (context, auth, child) {
                                if (auth.authenticated &&
                                    auth.user.usertype == 0 && auth.user.etatcompte == 0) {
                                  return SizedBox(
                                    height: 100,
                                    width: 50,
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 140, 194, 152),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddQuestion()));
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                                size: 32,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                      height: 100, width: 50, child: Container());
                                }
                              }))),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
                child: Row(
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
                child: Visibility(
                  visible: isCategoriesLoaded,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FatwasCategoriesScreen(
                                    categorie: categories[index])));
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  categories[index].name.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: selectedIndex == index
                                        ? Colors.green[800]
                                        : Colors.grey[500],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  height: 2,
                                  width: 50,
                                  color: selectedIndex == index
                                      ? Colors.green
                                      : Colors.transparent,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff00000014).withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: Offset(6, 4),
                        )
                      ]),
                  child: Center(
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return _kOptions.where((String option) {
                          return option
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selection) {
                        setState(() {
                          _searchController.text = selection;
                        });
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController _searchController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted) {
                        return Form(
                          key: _formKey,
                          child: 
                            Consumer<Auth>(builder: (context, auth, child) {
                        if (auth.authenticated){
                          return TextField(
                            controller: _searchController,
                            focusNode: fieldFocusNode,
                            decoration: InputDecoration(
                                prefixIcon: IconButton(
                                    onPressed: () {
                                      Map infos = {
                                        'query': _searchController.text,
                                        'user_id': auth.user.id.toString()
                                      };
                                      if (_formKey.currentState!.validate()) {
                                        search(infos: infos);
                                      }
                                    },
                                    icon: Icon(Icons.search)),


                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      this.isSearching = false;
                                      this._searchController.text = '';
                                    });
                                  },
                                ),
                                hintText: 'Rechercher...',
                                border: InputBorder.none),
                          );
                        } else{
                          return TextField(
                            controller: _searchController,
                            focusNode: fieldFocusNode,
                            decoration: InputDecoration(
                                prefixIcon: IconButton(
                                    onPressed: () {
                                      Map infos = {
                                        'query': _searchController.text,
                                      };
      
                                      if (_formKey.currentState!.validate()) {
                                        search(infos: infos);
                                      }
                                    },
                                    icon: Icon(Icons.search)),


                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      this.isSearching = false;
                                      this._searchController.text = '';
                                    });
                                  },
                                ),
                                hintText: 'Rechercher...',
                                border: InputBorder.none),
                          );
                        }}),


                          
                        );
                      },
                    ),
                  ),
                ),
              ),
      
              // Padding(
              //   padding:
              //       const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
              //   child: Container(
              //     height: 54,
              //     decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(12),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Color(0xff00000014).withOpacity(0.1),
              //             spreadRadius: 1,
              //             blurRadius: 6,
              //             offset: Offset(6, 4),
              //           )
              //         ]),
              //     child: Center(
              //       child: Form(
              //         key: _formKey,
              //         child: TextField(
              //           controller: _searchController,
              //           decoration: InputDecoration(
              //               prefixIcon: IconButton(
              //                   onPressed: () {
              //                     print(_searchController.text);
              //                     Map infos = {
              //                       'query': _searchController.text,
              //                       'user_id': '1'
              //                     };
      
              //                     if (_formKey.currentState!.validate()) {
              //                       search(infos: infos);
              //                     }
              //                   },
              //                   icon: Icon(Icons.search)),
              //               suffixIcon: IconButton(
              //                 icon: const Icon(Icons.clear),
              //                 onPressed: () {
              //                   setState(() {
              //                     this.isSearching = false;
              //                     this._searchController.text = '';
              //                   });
              //                 },
              //               ),
              //               hintText: 'Rechercher...',
              //               border: InputBorder.none),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200]),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: buttoncolor == 0
                                  ? Color.fromARGB(61, 142, 202, 230)
                                  : Colors.transparent),
                          child: Center(
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      buttoncolor = 0;
                                    });
                                  },
                                  child: Text("Tous"))),
                        ),
                      ),
                      Consumer<Auth>(builder: (context, auth, child) {
                        if (auth.authenticated && auth.user.usertype == 0 && auth.user.etatcompte==0) {
                          return Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: buttoncolor == 1
                                      ? Color.fromARGB(61, 142, 202, 230)
                                      : Colors.transparent),
                              child: Center(
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          buttoncolor = 1;
                                        });
                                      },
                                      child: Text("Recommandés"))),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: buttoncolor == 2
                                  ? Color.fromARGB(61, 142, 202, 230)
                                  : Colors.transparent),
                          child: Center(
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      buttoncolor = 2;
                                    });
                                  },
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      "Les plus consultés"))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      
              // Form(
              //    // key: _formKey,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.symmetric(vertical: 10),
              //           child: Row(
              //             children: [
              //               SizedBox(
              //                 width: 270,
              //                 height: 50,
              //                 child: TextFormField(
              //                   controller: _searchController,
              //                   decoration: InputDecoration(
              //                     border: OutlineInputBorder(),
              //                     hintText: 'Rechercher dans les fatwas',
              //                   ),
              //                 ),
              //               ),
              //               IconButton(
              //                 icon: Icon(Icons.search),
              //                 onPressed: () {
              //                   print(_searchController.text);
              //                   Map infos = {
              //                     'query': _searchController.text,
              //                     'user_id': '1'
              //                   };
      
              //                   if (_formKey.currentState!.validate()) {
              //                     search(infos: infos);
              //                   }
              //                 },
              //               ),
              //               IconButton(
              //                 icon: Icon(Icons.cancel),
              //                 onPressed: () {
              //                   setState(() {
              //                     this.isSearching = false;
              //                     this._searchController.text = '';
              //                   });
              //                 },
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     )),
              // Text(
              //   "Fatwas",
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              SizedBox(
                height: 15,
              ),
              isSearching == false
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: buttoncolor == 0
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Toutes les fatwas!",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: isLoaded,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: questions?.length,
                                    itemBuilder: (context, index) {
                                      _kOptions.add(
                                          questions![index].title.toLowerCase());
      
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3.0),
                                        child: Card(
                                          child: GestureDetector(
                                            onTap: () async {
                                              await http.post(
                                                hp.ApiUrl('/addVusAPI'),
                                                body: {
                                                  'id': questions![index]
                                                      .id
                                                      .toString(),
                                                },
                                              );
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FatwaScreen(
                                                              question:
                                                                  questions![
                                                                      index])));
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(8)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 4,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 1),
                                                    )
                                                  ]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 12.0),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  Color.fromARGB(
                                                                      255,
                                                                      96,
                                                                      192,
                                                                      99),
                                                                  Color.fromARGB(
                                                                      255,
                                                                      1,
                                                                      162,
                                                                      184)
                                                                ]),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical: 5),
                                                            child: 
                                                           questions![index]
                                                                  .title.length > 25 ? Text(
                                                              questions![index]
                                                                  .title.substring(0,25)+'...',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ):Text(
                                                              questions![index]
                                                                  .title,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ),
                                                        ),
                                                        Text('Le: ' +
                                                            questions![index]
                                                                .createdAt
                                                                .toString()
                                                                .substring(
                                                                    0, 10)),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text('Vus: ' +
                                                            questions![index]
                                                                .nbVus
                                                                .toString())
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        if (questions![index]
                                                                .typeqst ==
                                                            1)
                                                          Text(
                                                            "Social",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        if (questions![index]
                                                                .typeqst ==
                                                            2)
                                                          Text(
                                                            "Education",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        if (questions![index]
                                                                .typeqst ==
                                                            3)
                                                          Text(
                                                            "Religion",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        if (questions![index]
                                                                .typeqst ==
                                                            4)
                                                          Text(
                                                            "Language",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        questions![index]
                                                                    .contenu
                                                                    .length >
                                                                100
                                                            ? Expanded(
                                                                child: Text(questions![
                                                                            index]
                                                                        .contenu
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            100) +
                                                                    ' ...'))
                                                            : Expanded(
                                                                child: Text(
                                                                    questions![
                                                                            index]
                                                                        .contenu
                                                                        .toString()))
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  replacement: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    )
                  : searchFatwa != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: buttoncolor == 0
                              ? Visibility(
                                  visible: isLoaded,
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: searchFatwa?.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3.0),
                                        child: Card(
                                          child: GestureDetector(
                                            onTap: () async {
                                              await http.post(
                                                hp.ApiUrl('/addVusAPI'),
                                                body: {
                                                  'id': searchFatwa![index]
                                                      .id
                                                      .toString(),
                                                },
                                              );
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FatwaScreen(
                                                              question:
                                                                  searchFatwa![
                                                                      index])));
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(8)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 4,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 1),
                                                    )
                                                  ]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 12.0),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  Color.fromARGB(
                                                                      255,
                                                                      96,
                                                                      192,
                                                                      99),
                                                                  Color.fromARGB(
                                                                      255,
                                                                      1,
                                                                      162,
                                                                      184)
                                                                ]),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical: 5),
                                                            child:  searchFatwa![index]
                                                                  .title.length > 20 ? Text(
                                                              searchFatwa![index]
                                                                  .title.substring(0,20),
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ):Text(
                                                              searchFatwa![index]
                                                                  .title,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ),
                                                        ),
                                                        Text('Le: ' +
                                                            searchFatwa![index]
                                                                .createdAt
                                                                .toString()
                                                                .substring(
                                                                    0, 10)),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text('Vus: ' +
                                                            searchFatwa![index]
                                                                .nbVus
                                                                .toString())
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        if (searchFatwa![index]
                                                                .typeqst ==
                                                            1)
                                                          Text(
                                                            "Social",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        if (searchFatwa![index]
                                                                .typeqst ==
                                                            2)
                                                          Text(
                                                            "Education",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        if (searchFatwa![index]
                                                                .typeqst ==
                                                            3)
                                                          Text(
                                                            "Religion",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        if (searchFatwa![index]
                                                                .typeqst ==
                                                            4)
                                                          Text(
                                                            "Language",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        searchFatwa![index]
                                                                    .contenu
                                                                    .length >
                                                                100
                                                            ? Expanded(
                                                                child: Text(searchFatwa![
                                                                            index]
                                                                        .contenu
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            100) +
                                                                    ' ...'))
                                                            : Expanded(
                                                                child: Text(
                                                                    searchFatwa![
                                                                            index]
                                                                        .contenu
                                                                        .toString()))
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  replacement: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Container(),
                        )
                      : Text('aucun résultat trouvé pour votre recherche'),
              // SizedBox(
              //   height: 20,
              // ),
              // Visibility(
              //   visible: !isSearching,
              //   child: Column(
              //     children: [
              //       Text(
              //         "Les plus lus aujourd'hui",
              //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //       ),
              //       SizedBox(
              //         height: 20,
              //       ),
              //     ],
              //   ),
              // ),
              buttoncolor == 2
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Les fatwas les plus consultés aujourd'hui!",
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: isQuestionsVusLoaded && !isSearching,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: questions_vus?.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3.0),
                                  child: Card(
                                    child: GestureDetector(
                                      onTap: () async {
                                        await http.post(
                                          hp.ApiUrl('/addVusAPI'),
                                          body: {
                                            'id': questions_vus![index]
                                                .id
                                                .toString(),
                                          },
                                        );
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => FatwaScreen(
                                                    question:
                                                        questions_vus![index])));
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width -
                                            30,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.grey.withOpacity(0.3),
                                                spreadRadius: 4,
                                                blurRadius: 2,
                                                offset: Offset(0, 1),
                                              )
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 12.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Color.fromARGB(
                                                                255, 96, 192, 99),
                                                            Color.fromARGB(
                                                                255, 1, 162, 184)
                                                          ]),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 5),
                                                      child: questions_vus![index]
                                                                  .title.length > 25 ? Text(
                                                              questions_vus![index]
                                                                  .title.substring(0,25)+'...',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ):Text(
                                                              questions_vus![index]
                                                                  .title,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                    ),
                                                  ),
                                                  Text('Le: ' +
                                                      questions_vus![index]
                                                          .createdAt
                                                          .toString()
                                                          .substring(0, 10)),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text('Vus: ' +
                                                      questions_vus![index]
                                                          .nbVus
                                                          .toString())
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  if (questions_vus![index]
                                                          .typeqst ==
                                                      1)
                                                    Text(
                                                      "Social",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  if (questions_vus![index]
                                                          .typeqst ==
                                                      2)
                                                    Text(
                                                      "Education",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  if (questions_vus![index]
                                                          .typeqst ==
                                                      3)
                                                    Text(
                                                      "Religion",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  if (questions_vus![index]
                                                          .typeqst ==
                                                      4)
                                                    Text(
                                                      "Language",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  questions_vus![index]
                                                              .contenu
                                                              .length >
                                                          100
                                                      ? Expanded(
                                                          child: Text(
                                                              questions_vus![
                                                                          index]
                                                                      .contenu
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          100) +
                                                                  ' ...'))
                                                      : Expanded(
                                                          child: Text(
                                                              questions_vus![
                                                                      index]
                                                                  .contenu
                                                                  .toString()))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    )
                  : Container(),
      
              // ? Visibility(
              //     visible: questions_vusVusLoaded && !isSearching,
              //     child: Expanded(
              //       child: ListView.builder(
              //         itemCount: questions_vus?.length,
              //         itemBuilder: (context, index) {
              //           return Card(
              //             child: GestureDetector(
              //               onTap: () async {
              //                 await http.post(
              //                   hp.ApiUrl('/addVusAPI'),
              //                   body: {
              //                     'id': questions_vus![index].id.toString(),
              //                   },
              //                 );
              //                 Navigator.of(context).push(MaterialPageRoute(
              //                     builder: (context) => FatwaScreen(
              //                         question: questions![index])));
              //               },
              //               child: Padding(
              //                 padding: const EdgeInsets.all(8),
              //                 child: Column(
              //                   children: [
              //                     Row(
              //                       children: [
              //                         if (questions_vus![index].typeqst ==
              //                             1)
              //                           Text(
              //                             "Social",
              //                             style: TextStyle(
              //                                 fontWeight: FontWeight.bold),
              //                           ),
              //                         if (questions_vus![index].typeqst ==
              //                             2)
              //                           Text(
              //                             "Education",
              //                             style: TextStyle(
              //                                 fontWeight: FontWeight.bold),
              //                           ),
              //                         if (questions_vus![index].typeqst ==
              //                             3)
              //                           Text(
              //                             "Religion",
              //                             style: TextStyle(
              //                                 fontWeight: FontWeight.bold),
              //                           ),
              //                         if (questions_vus![index].typeqst ==
              //                             4)
              //                           Text(
              //                             "Language",
              //                             style: TextStyle(
              //                                 fontWeight: FontWeight.bold),
              //                           ),
              //                       ],
              //                     ),
              //                     Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Flexible(
              //                             child: Text(questions_vus![index]
              //                                 .title
              //                                 .toString())),
              //                         Flexible(
              //                           child: Text(questions_vus![index]
              //                               .createdAt
              //                               .toString()),
              //                         ),
              //                       ],
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.symmetric(
              //                           vertical: 10),
              //                       child: Row(
              //                         children: [
              //                           Flexible(
              //                               child: Text(
              //                                   questions_vus![index]
              //                                       .contenu
              //                                       .toString())),
              //                         ],
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           );
              //         },
              //       ),
              //     ),
              //   )
              // : Container(),
              buttoncolor == 1
                  ? Consumer<Auth>(builder: (context, auth, child) {
                      if (auth.authenticated && auth.user.usertype == 0) {
                        return !isSearching
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Les fatwas qui pourront vous intéresser!",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: isLoaded,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: questions?.length,
                                      itemBuilder: (context, index) {
                                        return data2.contains(
                                                questions![index].categoryId)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3.0),
                                                child: Card(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await http.post(
                                                        hp.ApiUrl('/addVusAPI'),
                                                        body: {
                                                          'id': questions![index]
                                                              .id
                                                              .toString(),
                                                        },
                                                      );
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FatwaScreen(
                                                                      question:
                                                                          questions![
                                                                              index])));
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              30,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      8)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.3),
                                                              spreadRadius: 4,
                                                              blurRadius: 2,
                                                              offset:
                                                                  Offset(0, 1),
                                                            )
                                                          ]),
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 5.0,
                                                            horizontal: 12.0),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                20.0),
                                                                    gradient:
                                                                        LinearGradient(
                                                                            colors: [
                                                                          Color.fromARGB(
                                                                              255,
                                                                              96,
                                                                              192,
                                                                              99),
                                                                          Color.fromARGB(
                                                                              255,
                                                                              1,
                                                                              162,
                                                                              184)
                                                                        ]),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0,
                                                                        vertical:
                                                                            5),
                                                                    child:questions![
                                                                              index]
                                                                          .title.length >25 ? 
                                                                    Text(
                                                                      questions![
                                                                              index]
                                                                          .title.substring(0,25),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          color: Colors
                                                                              .white),
                                                                    ):
                                                                    questions![
                                                                              index]
                                                                          .title.length >20 ? Text(
                                                                      questions![
                                                                              index]
                                                                          .title.substring(0,20),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          color: Colors
                                                                              .white),
                                                                    ):Text(
                                                                      questions![
                                                                              index]
                                                                          .title,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                          color: Colors
                                                                              .white),
                                                                    )
                                                                  ),
                                                                ),
                                                                Text('Le: ' +
                                                                    questions![
                                                                            index]
                                                                        .createdAt
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10)),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text('Vus: ' +
                                                                    questions![
                                                                            index]
                                                                        .nbVus
                                                                        .toString())
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                if (questions![
                                                                            index]
                                                                        .typeqst ==
                                                                    1)
                                                                  Text(
                                                                    "Social",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                  ),
                                                                if (questions![
                                                                            index]
                                                                        .typeqst ==
                                                                    2)
                                                                  Text(
                                                                    "Education",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                  ),
                                                                if (questions![
                                                                            index]
                                                                        .typeqst ==
                                                                    3)
                                                                  Text(
                                                                    "Religion",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                  ),
                                                                if (questions![
                                                                            index]
                                                                        .typeqst ==
                                                                    4)
                                                                  Text(
                                                                    "Language",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                  ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                questions![index]
                                                                            .contenu
                                                                            .length >
                                                                        100
                                                                    ? Expanded(
                                                                        child: Text(questions![index].contenu.toString().substring(
                                                                                0,
                                                                                100) +
                                                                            ' ...'))
                                                                    : Expanded(
                                                                        child: Text(questions![
                                                                                index]
                                                                            .contenu
                                                                            .toString()))
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container();
                                      },
                                    ),
                                    replacement: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
      
                                  // SizedBox(
                                  //     height: 200,
                                  //     child: Visibility(
                                  //       visible: isLoaded,
                                  //       child: ListView.builder(
                                  //         itemCount: questions?.length,
                                  //         itemBuilder: (context, index) {
                                  //           return data2.contains(
                                  //                   questions![index]
                                  //                       .categoryId)
                                  //               ? Card(
                                  //                   child: GestureDetector(
                                  //                     onTap: () async {
                                  //                       await http.post(
                                  //                         hp.ApiUrl(
                                  //                             '/addVusAPI'),
                                  //                         body: {
                                  //                           'id': questions![
                                  //                                   index]
                                  //                               .id
                                  //                               .toString(),
                                  //                         },
                                  //                       );
                                  //                       Navigator.of(context).push(
                                  //                           MaterialPageRoute(
                                  //                               builder: (context) =>
                                  //                                   FatwaScreen(
                                  //                                       question:
                                  //                                           questions![index])));
                                  //                     },
                                  //                     child: Padding(
                                  //                       padding:
                                  //                           const EdgeInsets
                                  //                               .all(10),
                                  //                       child: Column(
                                  //                         children: [
                                  //                           Row(
                                  //                             children: [
                                  //                               if (questions![
                                  //                                           index]
                                  //                                       .typeqst ==
                                  //                                   1)
                                  //                                 const Text(
                                  //                                   "Social",
                                  //                                   style: TextStyle(
                                  //                                       fontWeight:
                                  //                                           FontWeight.bold),
                                  //                                 ),
                                  //                               if (questions![
                                  //                                           index]
                                  //                                       .typeqst ==
                                  //                                   2)
                                  //                                 const Text(
                                  //                                   "Education",
                                  //                                   style: TextStyle(
                                  //                                       fontWeight:
                                  //                                           FontWeight.bold),
                                  //                                 ),
                                  //                               if (questions![
                                  //                                           index]
                                  //                                       .typeqst ==
                                  //                                   3)
                                  //                                 const Text(
                                  //                                   "Religion",
                                  //                                   style: TextStyle(
                                  //                                       fontWeight:
                                  //                                           FontWeight.bold),
                                  //                                 ),
                                  //                               if (questions![
                                  //                                           index]
                                  //                                       .typeqst ==
                                  //                                   4)
                                  //                                 const Text(
                                  //                                   "Language",
                                  //                                   style: TextStyle(
                                  //                                       fontWeight:
                                  //                                           FontWeight.bold),
                                  //                                 ),
                                  //                             ],
                                  //                           ),
                                  //                           Row(
                                  //                             mainAxisAlignment:
                                  //                                 MainAxisAlignment
                                  //                                     .spaceBetween,
                                  //                             children: [
                                  //                               Expanded(
                                  //                                   child: Text(questions![
                                  //                                           index]
                                  //                                       .title
                                  //                                       .toString())),
                                  //                               Text(questions![
                                  //                                       index]
                                  //                                   .createdAt
                                  //                                   .toString()),
                                  //                             ],
                                  //                           ),
                                  //                           Padding(
                                  //                             padding:
                                  //                                 const EdgeInsets
                                  //                                         .symmetric(
                                  //                                     vertical:
                                  //                                         10),
                                  //                             child: Row(
                                  //                               children: [
                                  //                                 Flexible(
                                  //                                     child: Text(questions![
                                  //                                             index]
                                  //                                         .contenu
                                  //                                         .toString())),
                                  //                               ],
                                  //                             ),
                                  //                           )
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                 )
                                  //               : Container();
                                  //         },
                                  //       ),
                                  //       replacement: Center(
                                  //           child: CircularProgressIndicator()),
                                  //     )),
                                ],
                              )
                            : Container();
                      } else {
                        return Container();
                      }
                    })
                  : Container(),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: SalomonBottomBar(
      //   currentIndex: _currentIndex,
      //   onTap: (i) => setState(() => _currentIndex = i),
      //   items: [
      //     /// Home
      //     SalomonBottomBarItem(
      //       icon: GestureDetector(onTap: () {
      //                       Navigator.of(context).pushReplacement(MaterialPageRoute(
      //                   builder: (context) =>
      //                       HomeScreen()));

      //       }, child: Icon(Icons.home)),
      //       title: Text("Home"),
      //       selectedColor: Colors.green,
      //     ),

      //     /// Likes
      //     SalomonBottomBarItem(
      //       icon: Icon(Icons.book),
      //       title: Text("Articles"),
      //       selectedColor: Colors.green,
      //     ),

      //     SalomonBottomBarItem(
      //       icon: Icon(Icons.add),
      //       title: Text("Publier"),
      //       selectedColor: Colors.green,
      //     ),

      //     /// Search
      //     SalomonBottomBarItem(
      //       icon: GestureDetector(
      //           onTap: () {
      //             Navigator.of(context).push(
      //                 MaterialPageRoute(builder: (context) => FatwasScreen()));
      //           },
      //           child: Icon(Icons.forum)),
      //       title: Text("Fatwas"),
      //       selectedColor: Colors.green,
      //     ),

      //     /// Profile
      //     SalomonBottomBarItem(
      //       icon: GestureDetector(onTap: () {}, child: Icon(Icons.person)),
      //       title: Text("Profile"),
      //       selectedColor: Colors.green,
      //     ),
      //   ],
      // ),
      drawer: Drawer(
        child: Consumer<Auth>(builder: (context, auth, child) {
          if (!auth.authenticated) {
            return ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(
                              MediaQuery.of(context).size.width, 100.0)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/quran.jpg"))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Bienvenu dans Fatwa',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          'Veuillez vous connecter pour profiter de toutes les fonctionnalités de la plateforme!',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0, bottom: 10),
                  child: ListTile(
                    title: Text('Accueil'),
                    leading: Icon(
                      Icons.home,
                      color: Colors.green,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    title: Text('Articles'),
                    leading: Icon(
                      Icons.library_books,
                      color: Colors.green,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ArticlesScreen()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    title: Text('Fatwas'),
                    leading: Icon(
                      Icons.question_answer,
                      color: Colors.green,
                    ),
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    title: Text('Se connecter'),
                    leading: Icon(
                      Icons.person,
                      color: Colors.green,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                  ),
                ),
              ],
            );
            // return ListView(
            //   children: [
            //     ListTile(
            //       title: Text('Home'),
            //       leading: Icon(Icons.home),
            //       onTap: () {
            //         Navigator.of(context).pushReplacement(
            //             MaterialPageRoute(builder: (context) => HomeScreen()));
            //       },
            //     ),
            //     ListTile(
            //       title: Text('Articles'),
            //       leading: Icon(Icons.login),
            //       onTap: () {
            //         Navigator.of(context).pushReplacement(MaterialPageRoute(
            //             builder: (context) => ArticlesScreen()));
            //       },
            //     ),
            //     ListTile(
            //       title: Text('Fatwas'),
            //       leading: Icon(Icons.login),
            //       onTap: () {},
            //     ),
            //     ListTile(
            //       title: Text('Se connecter'),
            //       leading: Icon(Icons.login),
            //       onTap: () {
            //         Navigator.of(context).pushReplacement(
            //             MaterialPageRoute(builder: (context) => LoginScreen()));
            //       },
            //     ),

            //   ],
            // );
          } else {
            return ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height/3,
                  child: DrawerHeader(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(auth.user.avatar),
                          radius: 60,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              auth.user.name,
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              auth.user.lastname,
                              style: TextStyle(fontSize: 18,color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          auth.user.email,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(
                              MediaQuery.of(context).size.width, 100.0)),
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 96, 192, 99),
                        Color.fromARGB(255, 1, 162, 184)
                      ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0, bottom: 10),
                  child: ListTile(
                    title: Text('Accueil'),
                    leading: Icon(
                      Icons.home,
                      color: Colors.green,
                    ),
                    onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    title: Text('Articles'),
                    leading: Icon(
                      Icons.library_books,
                      color: Colors.green,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => ArticlesScreen()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    title: Text('Fatwas'),
                    leading: Icon(
                      Icons.question_answer,
                      color: Colors.green,
                    ),
                    onTap: () {
                   
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    title: Text('Profile'),
                    leading: Icon(
                      Icons.person,
                      color: Colors.green,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              ProfilScreen(userId: auth.user.id.toString())));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    title: Text('Se déconnecter'),
                    leading: Icon(
                      Icons.logout,
                      color: Colors.green,
                    ),
                    onTap: () {
                      Provider.of<Auth>(context, listen: false).logout();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

class Pages extends StatelessWidget {
  final text;
  Pages({this.text});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ]),
    );
  }
}
