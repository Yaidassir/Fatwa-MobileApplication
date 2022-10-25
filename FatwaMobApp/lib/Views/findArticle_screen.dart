import 'package:fatwa/models/Post.dart';
import 'package:fatwa/Views/articles_screen.dart';
import 'package:fatwa/Views/fatwas_screen.dart';
import 'package:fatwa/Views/home_screen.dart';
import 'package:fatwa/Views/login_screen.dart';
import 'package:fatwa/Views/profil_screen.dart';
import 'package:fatwa/Views/register_screen.dart';
import 'package:fatwa/Views/registerpro_screen.dart';
import 'package:fatwa/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as Dio;
import 'package:fatwa/services/http.dart' as hp;

import 'dart:io' as io;

import '../services/dio.dart';

class findArticleScreen extends StatefulWidget {
  final List<Post>? findedposts;
  const findArticleScreen(findedpost, {Key? key, this.findedposts})
      : super(key: key);
  @override
  State<findArticleScreen> createState() => _findArticleScreenState();
}

class _findArticleScreenState extends State<findArticleScreen> {
  final storage = new FlutterSecureStorage();
  TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Post>? posts;
  var isLoaded = false;

  Future<List<Post>?> getPosts() async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.get(
      hp.ApiUrl('/articlesAPI'),
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

  @override
  void initState() {
    _searchController.text = "";

    super.initState();
    readToken();
    getPosts();
  }

  void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token);
    print(token);
  }

  List<Post>? searchPost;

  void search({Map? infos}) async {
    String? token = await storage.read(key: 'token');
    print(infos);

    final response = await http.post(
      hp.ApiUrl('/searchAPI'),
      body: infos,
    );
    if (response.statusCode == 200) {
      var json = response.body;
      searchPost = postFromJson(json);
    }

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticlesScreen(),
        ));
    print(searchPost![0].imam_name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.green[700],

      //   title: Text('Articles'),
      //   // actions: [
      //   //   IconButton(
      //   //       onPressed: () {
      //   //         showSearch(
      //   //           context: context,
      //   //           delegate: CustomSearchDelegate(),
      //   //         );
      //   //       },
      //   //       icon: const Icon(Icons.search)),
      //   // ],
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: "Entre votre recherche",
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      child: Text('Rechercher'),
                      onPressed: () {
                        Map infos = {
                          'query': _searchController.text,
                        };

                        if (_formKey.currentState!.validate()) {
                          search(infos: infos);
                        }
                      },
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Visibility(
                visible: isLoaded,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: posts?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(posts![index].avatar),
                            radius: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(posts![index].imam_name.toString()),
                              Text(posts![index].title.toString() +
                                  ' ' +
                                  posts![index].imamId.toString()),
                              if (posts![index].typepost == 1) Text('hadith'),
                              if (posts![index].typepost == 2) Text('dars'),
                              if (posts![index].typepost == 3) Text('khoutba'),
                              posts![index].note.toString() == 'null'
                                  ? Text('.../5')
                                  : Text(posts![index].note.toString() + '/5'),
                            ],
                          ),
                        ],
                      ),
                    );
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
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FatwasScreen()));
                  },
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

// class CustomSearchDelegate extends SearchDelegate {
//   List<String> searchTerms = [
//     'Femmes',
//     'Mariage',
//     'Hijra',
//     'Aid adha',
//     'Aid elfitre'
//   ];
  
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//     throw UnimplementedError();
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     List<String> matchQuery = [];

//     for(var article in searchTerms){
//       if(article.toLowerCase().contains(query.toLowerCase())){
//         matchQuery.add(article);
//       }
//     }

//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context,index){
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> matchQuery = [];
//     for(var article in searchTerms){
//       if(article.toLowerCase().contains(query.toLowerCase())){
//         matchQuery.add(article);
//       }
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context,index){
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//     throw UnimplementedError();
//   }
// }
