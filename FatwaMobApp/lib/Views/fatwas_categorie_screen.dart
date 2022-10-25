import 'dart:convert';

import 'package:fatwa/models/Category.dart';
import 'package:fatwa/models/Question.dart';
import 'package:fatwa/Views/articles_screen.dart';
import 'package:fatwa/Views/fatwa_screen.dart';
import 'package:fatwa/Views/fatwas_screen.dart';
import 'package:fatwa/Views/home_screen.dart';
import 'package:fatwa/Views/login_screen.dart';
import 'package:fatwa/Views/profil_screen.dart';
import 'package:fatwa/Views/register_screen.dart';
import 'package:fatwa/Views/registerpro_screen.dart';
import 'package:fatwa/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:fatwa/services/http.dart' as hp;

import '../Screens/HomePage/Home_Fatwa/Home_Fatwa.dart';

class FatwasCategoriesScreen extends StatefulWidget {
  const FatwasCategoriesScreen({Key? key, required this.categorie})
      : super(key: key);
  @override
  State<FatwasCategoriesScreen> createState() => _FatwasCategoriesScreenState();

  final Category categorie;
}

class _FatwasCategoriesScreenState extends State<FatwasCategoriesScreen> {
  int selectedIndex = 0;

  List<Question>? questions;
  var isLoaded = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _searchController = TextEditingController();

  Future<List<Question>?> getQuestions() async {
    var client = http.Client();

    final response = await client.get(hp.ApiUrl('/showFatwasAPI')
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

  List data = [];
  Future<void> getSouscat() async {
    var client = http.Client();

    final response =
        await client.post(hp.ApiUrl('/showFatwasByCategorieAPI'), body: {
      'query': widget.categorie.id.toString(),
    });

    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody);
    setState(() {
      data = jsonData;
    });
  }

  List<Category>? categories;
  var isCategoriesLoaded = false;

  Future<List<Category>?> getCategories() async {
    var client = http.Client();

    final response = await client.post(hp.ApiUrl('/souscatAPI'), body: {
      'query': widget.categorie.id.toString(),
    });
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
    getCategories();
    getQuestions();
    getSouscat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.green[700],
      //   title: Text(widget.categorie.name),
      // ),
      body: GestureDetector(
         onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Expanded(
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
                              child: Text(widget.categorie.name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold)),
                            ),
                            leading: IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  color: Colors.white, size: 35),
                              onPressed: () =>
                              Navigator.pop(context),
                            ),
                            ))),
                  ),
                ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
                  child: Row(
                    children: [
                      Text(
                        "Sous catégories",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                data.length == 0
                    ? Container()
                    : SizedBox(
                        height: 25,
                        child: Visibility(
                          visible: isCategoriesLoaded,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories?.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            FatwasCategoriesScreen(
                                                categorie: categories![index])));
      
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          categories![index].name.toString(),
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
                      const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
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
                      child: Form(
                        key: _formKey,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                              prefixIcon: IconButton(
                                  onPressed: () {
                                    print(_searchController.text);
                                    Map infos = {
                                      'query': _searchController.text,
                                      'user_id': '1'
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
                        ),
                      ),
                    ),
                  ),
                ),
                isSearching == false
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Visibility(
                          visible: isLoaded,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: questions?.length,
                            itemBuilder: (context, index) {
                              return data.contains(
                                          questions![index].categoryId) ||
                                      questions![index].categoryId ==
                                          widget.categorie.id
                                  ? Padding(
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
                                                            question: questions![
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
                                              padding: const EdgeInsets.symmetric(
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
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20.0),
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
                                                                  horizontal: 8.0,
                                                                  vertical: 5),
                                                          child:  questions![index]
                                                                .title.length>25? 
                                                          Text(
                                                            questions![index]
                                                                .title.substring(0,25)+'...',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.white),
                                                          ):
                                                          Text(
                                                            questions![index]
                                                                .title,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.white),
                                                          )
                                                        ),
                                                      ),
                                                      Text('Le: ' +
                                                          questions![index]
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
                                    )
                                  : Container();
                            },
                          ),
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ))
                    : searchFatwa != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Visibility(
                              visible: isLoaded,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: searchFatwa?.length,
                                itemBuilder: (context, index) {
                                  return data.contains(
                                              questions![index].categoryId) ||
                                          questions![index].categoryId ==
                                              widget.categorie.id
                                      ? Padding(
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
                                                    borderRadius:
                                                        BorderRadius.all(
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
                                                                    Color
                                                                        .fromARGB(
                                                                            255,
                                                                            96,
                                                                            192,
                                                                            99),
                                                                    Color
                                                                        .fromARGB(
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
                                                                      vertical:
                                                                          5),
                                                              child: Text(
                                                                searchFatwa![
                                                                        index]
                                                                    .title,
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
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
                                        )
                                      : Container();
                                },
                              ),
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ))
                        : Text('aucun résultat trouvé pour votre recherche'),
                //   Form(
                //       key: _formKey,
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.symmetric(vertical: 10),
                //             child: Row(
                //               children: [
                //                 SizedBox(
                //                   width: 270,
                //                   height: 50,
                //                   child: TextFormField(
                //                     controller: _searchController,
                //                     decoration: InputDecoration(
                //                       border: OutlineInputBorder(),
                //                       hintText: 'Rechercher dans les fatwas',
                //                     ),
                //                   ),
                //                 ),
                //                 IconButton(
                //                   icon: Icon(Icons.search),
                //                   onPressed: () {
                //                     Map infos = {
                //                       'query': _searchController.text,
                //                     };
      
                //                     if (_formKey.currentState!.validate()) {
                //                       search(infos: infos);
                //                     }
                //                   },
                //                 ),
                //                 IconButton(
                //                   icon: Icon(Icons.cancel),
                //                   onPressed: () {
                //                     setState(() {
                //                       this.isSearching = false;
                //                       this._searchController.text = '';
                //                     });
                //                   },
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       )),
                //   SizedBox(
                //     height: 20,
                //   ),
                //   Text(
                //     "Fatwas",
                //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                //   ),
                //   SizedBox(
                //     height: 20,
                //   ),
                //   isSearching == false
                //       ? Visibility(
                //           visible: isLoaded,
                //           child: Expanded(
                //             child: ListView.builder(
                //               itemCount: questions?.length,
                //               itemBuilder: (context, index) {
                //                 return data.contains(questions![index].categoryId) || questions![index].categoryId == widget.categorie.id  ?  Card(
                //                   child:GestureDetector(
                //                     onTap: () {
                //                       Navigator.of(context).push(MaterialPageRoute(
                //                           builder: (context) => FatwaScreen(
                //                               question: questions![index])));
                //                     },
                //                     child: Padding(
                //                       padding: const EdgeInsets.all(10),
                //                       child: Column(
                //                         children: [
                //                           Row(
                //                             children: [
                //                               if (questions![index].typeqst == 1)
                //                                 Text(
                //                                   "Social",
                //                                   style: TextStyle(
                //                                       fontWeight: FontWeight.bold),
                //                                 ),
                //                               if (questions![index].typeqst == 2)
                //                                 Text(
                //                                   "Education",
                //                                   style: TextStyle(
                //                                       fontWeight: FontWeight.bold),
                //                                 ),
                //                               if (questions![index].typeqst == 3)
                //                                 Text(
                //                                   "Religion",
                //                                   style: TextStyle(
                //                                       fontWeight: FontWeight.bold),
                //                                 ),
                //                               if (questions![index].typeqst == 4)
                //                                 Text(
                //                                   "Language",
                //                                   style: TextStyle(
                //                                       fontWeight: FontWeight.bold),
                //                                 ),
                //                             ],
                //                           ),
                //                           Row(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.spaceBetween,
                //                             children: [
                //                               Expanded(
                //                                   child: Text(questions![index]
                //                                       .title
                //                                       .toString())),
                //                               Text(questions![index]
                //                                   .createdAt
                //                                   .toString()),
                //                             ],
                //                           ),
                //                           Padding(
                //                             padding: const EdgeInsets.symmetric(
                //                                 vertical: 10),
                //                             child: Row(
                //                               children: [
                //                                 Flexible(
                //                                     child: Text(questions![index]
                //                                         .contenu
                //                                         .toString())),
                //                               ],
                //                             ),
                //                           )
                //                         ],
                //                       ),
                //                     ),
                //                   )
                //                 ):Container();
                //               },
                //             ),
                //           ),
                //           replacement: const Center(
                //             child: CircularProgressIndicator(),
                //           ),
                //         )
                //       : searchFatwa != null
                //           ? Visibility(
                //               visible: isLoaded,
                //               child: ListView.builder(
                //                 scrollDirection: Axis.vertical,
                //                 shrinkWrap: true,
                //                 itemCount: searchFatwa?.length,
                //                 itemBuilder: (context, index) {
                //                   return Padding(
                //                     padding: const EdgeInsets.only(top: 20),
                //                     child: Column(
                //                       children: [
                //                         Row(
                //                           children: [
                //                             if (searchFatwa![index].typeqst == 1)
                //                               Text(
                //                                 "Social",
                //                                 style: TextStyle(
                //                                     fontWeight: FontWeight.bold),
                //                               ),
                //                             if (searchFatwa![index].typeqst == 2)
                //                               Text(
                //                                 "Education",
                //                                 style: TextStyle(
                //                                     fontWeight: FontWeight.bold),
                //                               ),
                //                             if (searchFatwa![index].typeqst == 3)
                //                               Text(
                //                                 "Religion",
                //                                 style: TextStyle(
                //                                     fontWeight: FontWeight.bold),
                //                               ),
                //                             if (searchFatwa![index].typeqst == 4)
                //                               Text(
                //                                 "Language",
                //                                 style: TextStyle(
                //                                     fontWeight: FontWeight.bold),
                //                               ),
                //                           ],
                //                         ),
                //                         Row(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.spaceBetween,
                //                           children: [
                //                             Text(
                //                                 searchFatwa![index].title.toString()),
                //                             Text(searchFatwa![index]
                //                                 .createdAt
                //                                 .toString()),
                //                           ],
                //                         ),
                //                         Padding(
                //                           padding: const EdgeInsets.symmetric(
                //                               vertical: 10),
                //                           child: Row(
                //                             children: [
                //                               Flexible(
                //                                   child: Text(searchFatwa![index]
                //                                       .contenu
                //                                       .toString())),
                //                             ],
                //                           ),
                //                         )
                //                       ],
                //                     ),
                //                   );
                //                 },
                //               ),
                //               replacement: const Center(
                //                 child: CircularProgressIndicator(),
                //               ),
                //             )
                //           : Text('aucun résultat trouvé pour votre recherche'),
                //   SizedBox(
                //     height: 20,
                //   ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Consumer<Auth>(builder: (context, auth, child) {
          if (!auth.authenticated) {
            return ListView(
              children: [
                ListTile(
                  title: Text('Home'),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
                ListTile(
                  title: Text('Articles'),
                  leading: Icon(Icons.login),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ArticlesScreen()));
                  },
                ),
                ListTile(
                  title: Text('Fatwas'),
                  leading: Icon(Icons.login),
                  onTap: () {},
                ),
                ListTile(
                  title: Text('Se connecter'),
                  leading: Icon(Icons.login),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
                ListTile(
                  title: Text('S\'inscire'),
                  leading: Icon(Icons.signal_cellular_0_bar),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterScreen()));
                  },
                ),
                ListTile(
                  title: Text('S\'inscire en tant qu\'imam'),
                  leading: Icon(Icons.signal_cellular_0_bar),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterProScreen()));
                  },
                ),
              ],
            );
          } else {
            return ListView(
              children: [
                DrawerHeader(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(auth.user.avatar),
                        radius: 40,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            auth.user.name,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            auth.user.lastname,
                            style: TextStyle(color: Colors.white),
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
                  decoration: BoxDecoration(color: Colors.blue),
                ),
                ListTile(
                  title: Text('Home'),
                  leading: Icon(Icons.home),
                  onTap: () {},
                ),
                ListTile(
                  title: Text('Articles'),
                  leading: Icon(Icons.login),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ArticlesScreen()));
                  },
                ),
                ListTile(
                  title: Text('Fatwas'),
                  leading: Icon(Icons.login),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FatwasScreen()));
                  },
                ),
                ListTile(
                  title: Text('Profile'),
                  leading: Icon(Icons.person),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProfilScreen(userId: auth.user.id.toString())));
                  },
                ),
                ListTile(
                  title: Text('Logout'),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).logout();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
