// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:fatwa/models/Post.dart';
import 'package:fatwa/Views/addPost_screen.dart';
import 'package:fatwa/Views/article_screen.dart';
import 'package:fatwa/Views/fatwas_screen.dart';
import 'package:fatwa/Views/home_screen.dart';
import 'package:fatwa/Views/login_screen.dart';
import 'package:fatwa/Views/profil_screen.dart';
import 'package:fatwa/Views/register_screen.dart';
import 'package:fatwa/Views/registerpro_screen.dart';
import 'package:fatwa/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:fatwa/services/http.dart' as hp;

import '../Screens/HomePage/Home_Fatwa/Home_Fatwa.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({Key? key}) : super(key: key);
  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  final storage = new FlutterSecureStorage();
  TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSearching = false;
  int buttoncolor = 0;
  int currentLength = 0;
  int currentlengthandfoot=3;
  bool firsttime = true ;
  List data = [];
  ScrollController _scrollController = ScrollController();

  List<Post>? posts;
  var isLoaded = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

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
          isLoaded = true;
        });
      }
    }
  }

  Future _loadMore() async {
    await Future.delayed(const Duration(seconds: 1));
    for (var i = currentLength; i < currentLength + currentlengthandfoot; i++) {
      data.add(posts![i]);
    }
    setState(() {
      if (data.length + currentlengthandfoot <posts!.length){
          currentLength = data.length;
      }else {
          currentLength = data.length;
          currentlengthandfoot=posts!.length - data.length ;
          print(currentlengthandfoot);
      }
      
    });
  }

  List<Post>? postsbyType;
  var isLoadedType = false;

  Future<List<Post>?> getPostsByType({Map? infos}) async {
    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/articlesType'),
      body: infos,
      // Send authorization headers to the backend.
    );
    if (response.statusCode == 200) {
      var json = response.body;
      postsbyType = postFromJson(json);
      // print(posts.toString());
      if (postsbyType != null) {
        setState(() {
          isLoadedType = true;
        });
      }
    }
  }

  List<String> _kOptions = <String>[];

  @override
  void initState() {
    _searchController.text = "";

    super.initState();
    readToken();
    getPosts();

        if (firsttime) {
      _loadMore();
      firsttime=false;
    }

      _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
            if (data.length<posts!.length) {
              _loadMore();
            }
      }});
  }

  void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token);
  }

  List datasearch = [];

  void search({Map? infos}) async {
    String? token = await storage.read(key: 'token');

    final response = await http.post(
      hp.ApiUrl('/searchAPI'),
      body: infos,
    );
    if (response.statusCode == 200) {
      datasearch = json.decode(response.body);
    }

    if (datasearch != null) {
      setState(() {
        isSearching = true;
      });
    }
    print(datasearch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
         onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
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
                          child: Text('Articles',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                        ),
                        leading: IconButton(
                          icon: Icon(Icons.menu, color: Colors.white, size: 35),
                          onPressed: () => scaffoldKey.currentState?.openDrawer(),
                        ),
                        trailing: SizedBox(
                            height: 100,
                            width: 50,
                            child:
                                Consumer<Auth>(builder: (context, auth, child) {
                              if (auth.authenticated &&
                                  auth.user.usertype == 1 &&
                                  auth.user.etatcompte == 0) {
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
                                                            AddPost()));
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                                size: 32,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ],
                                    ));
                              } else {
                                return SizedBox(
                                    height: 100, width: 50, child: Container());
                              }
                            })),
                      )),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
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
              //                     Map infos = {
              //                       'query': _searchController.text,
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
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
                          child: TextField(
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
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
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
                      Expanded(
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
                                    getPostsByType(
                                        infos: {'query': buttoncolor.toString()});
                                  },
                                  child: Text("Hadith"))),
                        ),
                      ),
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
                                    getPostsByType(
                                        infos: {'query': buttoncolor.toString()});
                                  },
                                  child: Text("Dars"))),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: buttoncolor == 3
                                  ? Color.fromARGB(61, 142, 202, 230)
                                  : Colors.transparent),
                          child: Center(
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      buttoncolor = 3;
                                    });
                                    getPostsByType(
                                        infos: {'query': buttoncolor.toString()});
                                  },
                                  child: Text(
                                      textAlign: TextAlign.center, "Khoutba"))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              isSearching == false
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: buttoncolor == 0
                          ? Visibility(
                              visible: isLoaded,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  _kOptions
                                      .add(data[index].title.toLowerCase());
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ArticleScreen(
                                                        post: posts![index])));
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
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                255, 96, 192, 99),
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  posts![index]
                                                                      .avatar),
                                                          radius: 45,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 18.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 170,
                                                              child: Text(
                                                                posts![index]
                                                                    .imam_name,
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
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
                                                            // Text(
                                                            //   posts![index].title,
                                                            //   style: TextStyle(
                                                            //     fontSize: 14,
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .bold,
                                                            //   ),
                                                            // )
                                                            posts![index].title.length >20 ?
                                                      Text(
                                                        posts![index].title.substring(0,20)+'...',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ):
                                                      Text(
                                                        posts![index].title,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            if (posts![index]
                                                                    .typepost ==
                                                                1)
                                                              Text('hadith'),
                                                            if (posts![index]
                                                                    .typepost ==
                                                                2)
                                                              Text('dars'),
                                                            if (posts![index]
                                                                    .typepost ==
                                                                3)
                                                              Text('khoutba'),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            posts![index]
                                                                        .note
                                                                        .toString() ==
                                                                    'null'
                                                                ? RatingBarIndicator(
                                                                    rating: 0,
                                                                    itemBuilder:
                                                                        (context,
                                                                                index) =>
                                                                            Icon(
                                                                      Icons.star,
                                                                      color: Colors
                                                                          .amber,
                                                                    ),
                                                                    itemCount: 5,
                                                                    itemSize:
                                                                        25.0,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                  )
                                                                : RatingBarIndicator(
                                                                    rating: posts![
                                                                            index]
                                                                        .note!
                                                                        .toDouble(),
                                                                    itemBuilder:
                                                                        (context,
                                                                                index) =>
                                                                            Icon(
                                                                      Icons.star,
                                                                      color: Colors
                                                                          .amber,
                                                                    ),
                                                                    itemCount: 5,
                                                                    itemSize:
                                                                        25.0,
                                                                    direction: Axis
                                                                        .horizontal,
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
                                  );
                                },
                              ),
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Visibility(
                              visible: isLoadedType,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: postsbyType?.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ArticleScreen(
                                                        post: postsbyType![
                                                            index])));
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
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                255, 96, 192, 99),
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  postsbyType![
                                                                          index]
                                                                      .avatar),
                                                          radius: 45,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 18.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 170,
                                                              child: Text(
                                                                postsbyType![index]
                                                                    .imam_name,
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
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
                                                             postsbyType![index].title.length >25 ?
                                                            Text(
                                                              postsbyType![index]
                                                                  .title.substring(0,25)+'...',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ):
                                                             Text(
                                                              postsbyType![index]
                                                                  .title,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            if (postsbyType![
                                                                        index]
                                                                    .typepost ==
                                                                1)
                                                              Text('hadith'),
                                                            if (postsbyType![
                                                                        index]
                                                                    .typepost ==
                                                                2)
                                                              Text('dars'),
                                                            if (postsbyType![
                                                                        index]
                                                                    .typepost ==
                                                                3)
                                                              Text('khoutba'),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            postsbyType![index]
                                                                        .note
                                                                        .toString() ==
                                                                    'null'
                                                                ? RatingBarIndicator(
                                                                    rating: 0,
                                                                    itemBuilder:
                                                                        (context,
                                                                                index) =>
                                                                            Icon(
                                                                      Icons.star,
                                                                      color: Colors
                                                                          .amber,
                                                                    ),
                                                                    itemCount: 5,
                                                                    itemSize:
                                                                        25.0,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                  )
                                                                : RatingBarIndicator(
                                                                    rating: postsbyType![
                                                                            index]
                                                                        .note!
                                                                        .toDouble(),
                                                                    itemBuilder:
                                                                        (context,
                                                                                index) =>
                                                                            Icon(
                                                                      Icons.star,
                                                                      color: Colors
                                                                          .amber,
                                                                    ),
                                                                    itemCount: 5,
                                                                    itemSize:
                                                                        25.0,
                                                                    direction: Axis
                                                                        .horizontal,
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
                                  );
                                },
                              ),
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                    )
                  : datasearch == null
                      ? Center(child: Text('Aucun résultat pour votre recherche'))
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Visibility(
                            visible: isLoaded,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: posts?.length,
                              itemBuilder: (context, index) {
                                _kOptions.add(posts![index].title.toLowerCase());
                                if(datasearch.contains(posts![index].id)){
                                    return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ArticleScreen(
                                                  post: posts![index])));
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width - 30,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
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
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              255, 96, 192, 99),
                                                      child: CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                posts![index]
                                                                    .avatar),
                                                        radius: 45,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 18.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 170,
                                                            child: Text(
                                                              posts![index]
                                                                  .imam_name,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                              ),
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
                                                          posts![index]
                                                                .title.length >20 ?
                                                          Text(
                                                            posts![index]
                                                                .title.substring(0,20)+'...',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ):Text(
                                                            posts![index]
                                                                .title,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          if (posts![index]
                                                                  .typepost ==
                                                              1)
                                                            Text('hadith'),
                                                          if (posts![index]
                                                                  .typepost ==
                                                              2)
                                                            Text('dars'),
                                                          if (posts![index]
                                                                  .typepost ==
                                                              3)
                                                            Text('khoutba'),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          posts![index]
                                                                      .note
                                                                      .toString() ==
                                                                  'null'
                                                              ? RatingBarIndicator(
                                                                  rating: 0,
                                                                  itemBuilder:
                                                                      (context,
                                                                              index) =>
                                                                          Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                  itemCount: 5,
                                                                  itemSize: 25.0,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                )
                                                              : RatingBarIndicator(
                                                                  rating: posts![
                                                                          index]
                                                                      .note!
                                                                      .toDouble(),
                                                                  itemBuilder:
                                                                      (context,
                                                                              index) =>
                                                                          Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                  itemCount: 5,
                                                                  itemSize: 25.0,
                                                                  direction: Axis
                                                                      .horizontal,
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
                                );
      
                                }
                                else{
                                  return Container();
                                }
                              
                              },
                            ),
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
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
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => FatwasScreen()));
                    },
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
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => FatwasScreen()));
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
      // drawer: Drawer(
      //   child: Consumer<Auth>(builder: (context, auth, child) {
      //     if (!auth.authenticated) {
      //       return ListView(
      //         children: [
      //           Container(
      //             height: MediaQuery.of(context).size.height / 3,
      //             width: MediaQuery.of(context).size.width,
      //             decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.vertical(
      //                     bottom: Radius.elliptical(
      //                         MediaQuery.of(context).size.width, 100.0)),
      //                 image: DecorationImage(
      //                     fit: BoxFit.cover,
      //                     image: AssetImage("assets/images/quran.jpg"))),
      //             child: Padding(
      //               padding: const EdgeInsets.all(12.0),
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Text(
      //                     'Bienvenu dans Fatwa',
      //                     style: TextStyle(
      //                         fontSize: 24,
      //                         fontWeight: FontWeight.w900,
      //                         color: Colors.white),
      //                   ),
      //                   SizedBox(
      //                     height: 10,
      //                   ),
      //                   Text(
      //                     textAlign: TextAlign.center,
      //                     'Veuillez vous connecter pour profiter de toutes les fonctionnalités de la plateforme!',
      //                     style: TextStyle(color: Colors.white),
      //                   )
      //                 ],
      //               ),
      //             ),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.only(top: 28.0, bottom: 10),
      //             child: ListTile(
      //               title: Text('Home'),
      //               leading: Icon(
      //                 Icons.home,
      //                 color: Colors.green,
      //               ),
      //               onTap: () {
      //                 Navigator.of(context).pushReplacement(MaterialPageRoute(
      //                     builder: (context) => HomeScreen()));
      //               },
      //             ),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 10.0),
      //             child: ListTile(
      //               title: Text('Articles'),
      //               leading: Icon(
      //                 Icons.library_books,
      //                 color: Colors.green,
      //               ),
      //               onTap: () {},
      //             ),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 10.0),
      //             child: ListTile(
      //               title: Text('Fatwas'),
      //               leading: Icon(
      //                 Icons.question_answer,
      //                 color: Colors.green,
      //               ),
      //               onTap: () {
      //                 Navigator.of(context).pushReplacement(MaterialPageRoute(
      //                     builder: (context) => FatwasScreen()));
      //               },
      //             ),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 10.0),
      //             child: ListTile(
      //               title: Text('Se connecter'),
      //               leading: Icon(
      //                 Icons.person,
      //                 color: Colors.green,
      //               ),
      //               onTap: () {
      //                 Navigator.of(context).pushReplacement(MaterialPageRoute(
      //                     builder: (context) => LoginScreen()));
      //               },
      //             ),
      //           ),
      //         ],
      //       );
      //     } else {
      //       return ListView(
      //         children: [
      //           DrawerHeader(
      //             child: Column(
      //               children: [
      //                 CircleAvatar(
      //                   backgroundImage: NetworkImage(auth.user.avatar),
      //                   radius: 40,
      //                 ),
      //                 SizedBox(
      //                   height: 5,
      //                 ),
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Text(
      //                       auth.user.name,
      //                       style: TextStyle(color: Colors.white),
      //                     ),
      //                     SizedBox(
      //                       width: 10,
      //                     ),
      //                     Text(
      //                       auth.user.lastname,
      //                       style: TextStyle(color: Colors.white),
      //                     ),
      //                   ],
      //                 ),
      //                 SizedBox(
      //                   height: 5,
      //                 ),
      //                 Text(
      //                   auth.user.email,
      //                   style: TextStyle(color: Colors.white),
      //                 ),
      //               ],
      //             ),
      //             decoration: BoxDecoration(color: Colors.blue),
      //           ),
      //           ListTile(
      //             title: Text('Home'),
      //             leading: Icon(Icons.home),
      //             onTap: () {
      //               Navigator.of(context).pushReplacement(
      //                   MaterialPageRoute(builder: (context) => HomeScreen()));
      //             },
      //           ),
      //           ListTile(
      //             title: Text('Articles'),
      //             leading: Icon(Icons.login),
      //             onTap: () {},
      //           ),
      //           ListTile(
      //             title: Text('Fatwas'),
      //             leading: Icon(Icons.login),
      //             onTap: () {
      //               Navigator.of(context).pushReplacement(MaterialPageRoute(
      //                   builder: (context) => FatwasScreen()));
      //             },
      //           ),
      //           ListTile(
      //             title: Text('Profile'),
      //             leading: Icon(Icons.person),
      //             onTap: () {
      //               Navigator.of(context).pushReplacement(MaterialPageRoute(
      //                   builder: (context) =>
      //                       ProfilScreen(userId: auth.user.id.toString())));
      //             },
      //           ),
      //           ListTile(
      //             title: Text('Logout'),
      //             leading: Icon(Icons.logout),
      //             onTap: () {
      //               Provider.of<Auth>(context, listen: false).logout();
      //               Navigator.of(context).pushReplacement(
      //                 MaterialPageRoute(builder: (context) => HomeScreen()),
      //               );
      //             },
      //           ),
      //         ],
      //       );
      //     }
      //   }),
      // ),
    );
  }
}

// class CustomSearchDelegate extends  SearchDelegate {
//   List<String> searchResults = [
//     'Mariage',
//     'Hadj',
//     'Aid el fitre',
//     'Aid el adha'
//   ];
//   List<Post>? searchPost;
//   bool isLoaded = false;
//   void search({Map? infos}) async {
//     print(infos);

//     final response = await http.post(
//       Uri.parse('http://172.20.10.5:8000/api/searchAPI'),
//       body: infos,
//     );
//     if (response.statusCode == 200) {
//       var json = response.body;
//       searchPost = postFromJson(json);
//     }
//     if (searchPost != null) {
//           isLoaded = true;
//     }
//   }

//   @override
//   List<Widget>? buildActions(BuildContext context) => [
//         IconButton(
//             onPressed: () {
//               if (query.isEmpty) {
//                 close(context, null);
//               } else {
//                 query = '';
//               }
//             },
//             icon: const Icon(Icons.clear))
//       ];

//   @override
//   Widget? buildLeading(BuildContext context) => IconButton(
//       onPressed: () => close(context, null),
//       icon: const Icon(Icons.arrow_back));

//   @override
//   Widget buildResults(BuildContext context) {
//     Map infos = {'query': query};
//     search(infos: infos);
//     return searchPost != null ? Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//         child: ListView.builder(
//           scrollDirection: Axis.vertical,
//           shrinkWrap: true,
//           itemCount: searchPost?.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.only(top: 20),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(searchPost![index].avatar),
//                     radius: 25,
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(searchPost![index].imam_name.toString()),
//                       Text(searchPost![index].title.toString() +
//                           ' ' +
//                           searchPost![index].imamId.toString()),
//                       if (searchPost![index].typepost == 1) Text('hadith'),
//                       if (searchPost![index].typepost == 2) Text('dars'),
//                       if (searchPost![index].typepost == 3) Text('khoutba'),
//                       searchPost![index].note.toString() == 'null'
//                           ? Text('.../5')
//                           : Text(searchPost![index].note.toString() + '/5'),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         )):Center(child: Text('Aucun résultat n\'a été trouvé pour votre recherche'));
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> suggestions = searchResults.where((searchResult) {
//       final result = searchResult.toLowerCase();
//       final input = query.toLowerCase();
//       return result.contains(input);
//     }).toList();
//     return ListView.builder(
//         itemCount: suggestions.length,
//         itemBuilder: (context, index) {
//           final suggestion = suggestions[index];

//           return ListTile(
//               title: Text(suggestion),
//               onTap: () {
//                 query = suggestion;
//                 showResults(context);
//               });
//         });
//   }
// }
