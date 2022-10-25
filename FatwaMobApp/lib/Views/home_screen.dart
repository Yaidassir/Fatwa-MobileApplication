// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fatwa/Views/fatwa_screen.dart';
import 'package:fatwa/models/Post.dart';
import 'package:adhan/adhan.dart';
import 'package:fatwa/models/Question.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fatwa/Views/articles_screen.dart';
import 'package:fatwa/Views/fatwas_screen.dart';
import 'package:fatwa/Views/login_screen.dart';
import 'package:fatwa/Views/profil_screen.dart';
import 'package:fatwa/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:fatwa/services/http.dart' as hp;
import '../Dimensions.dart';
import 'article_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = new FlutterSecureStorage();

  List<Post>? posts;
  var isLoaded = false;
  var _currentIndex = 0;

  Future<List<Post>?> getPosts() async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.get(hp.ApiUrl('/articlesByNoteAPI')
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

  List<Question>? questions_vus;
  var isQuestionsVusLoaded = false;

  Future<List<Question>?> getQuestionsByVus() async {
    var client = http.Client();

    final response = await client.get(
      hp.ApiUrl('/showFatwasByViewsAPI'),
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

  late PrayerTimes prayer;
  main() {
    final myCoordinates = Coordinates(36.735523208597336,
        3.187052578222671); // Replace with your own location lat, lng.
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes.today(myCoordinates, params);

    setState(() {
      prayer = prayerTimes;
    });
  }

  @override
  void initState() {
    super.initState();
    readToken();
    getPosts();
    getQuestionsByVus();
    main();
  }

  int index = 0;

  void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token);
    print(token);
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
         onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.elliptical(
                                  MediaQuery.of(context).size.width, 100.0)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/images/Bgfatwa.jpg"))),
                    ),
                    Positioned(
                      top: 25,
                      left: 15,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 218, 218, 218)
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20)),
                        child: IconButton(
                          icon: Icon(Icons.menu,
                              color: Color.fromARGB(255, 243, 243, 243),
                              size: 30),
                          onPressed: () => scaffoldKey.currentState?.openDrawer(),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 40,
                        left: 115,
                        child: Column(
                          children: [
                            Text(
                              "Fatwa",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              "le sens de l'islam",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        )),
                    Positioned(
                        top: 250,
                        left: 120,
                        child: Text(
                          "ISLAM",
                          style: TextStyle(color: Colors.white, fontSize: 45),
                        ))
                  ],
                ),
      
                // SizedBox(
                //   height: 30,
                // ),
                // PageTitle(pagetitle: "Accueil"),
                // Padding(
                //   padding: const EdgeInsets.all(20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Row(
                //         children: [
                //           Container(
                //             decoration: BoxDecoration(
                //               color: Color.fromARGB(61, 142, 202, 230),
                //               borderRadius: BorderRadius.circular(10),
                //             ),
                //             child: IconButton(
                //               onPressed: () {},
                //               icon: Icon(Icons.mail),
                //             ),
                //           ),
                //           //  SvgPicture.asset('../../../../assets/icons/mail-svgrepo-com.svg',height: 35,width: 35,color: Colors.grey,))),
                //           SizedBox(
                //             width: Dimensions.width20,
                //           ),
                //           Column(
                //             children: [
                //               Text('Bienvenue'),
                //               Text(
                //                 'Sami ben',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.bold, fontSize: 16),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //       // CircleAvatar(
                //       //   radius: 25,
                //       //   backgroundImage: NetworkImage('data:image/jpeg;base64,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'),
                //       // ),
                //     ],
                //   ),
                // ),
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                //   child: const SizedBox(
                //     height: 50,
                //     child: CupertinoSearchTextField(),
                //   ),
                // ),
                // SizedBox(height: Dimensions.height10),
                // const Divider(
                //   height: 10,
                //   thickness: 2,
                //   indent: 20,
                //   endIndent: 20,
                // ),
                SizedBox(height: Dimensions.height10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'Horaires de priéres d\'aujourd\'hui',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Text(
                          prayer.dhuhr.toString().substring(0, 10),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
      
                Container(
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      PrayerCard(
                        prayer: prayer.fajr,
                        salat: 'Fajr',
                      ),
                      PrayerCard(
                        prayer: prayer.dhuhr,
                        salat: 'Dohr',
                      ),
                      PrayerCard(
                        prayer: prayer.asr,
                        salat: 'Asr',
                      ),
                      PrayerCard(
                        prayer: prayer.maghrib,
                        salat: 'Maghrib',
                      ),
                      PrayerCard(
                        prayer: prayer.isha,
                        salat: 'Isha',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Les fatwas les plus lus aujourd\'hui',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => FatwasScreen()),
                            );
                          },
                          child: Text(
                            'voir plus',
                            style: TextStyle(fontSize: 12),
                          ))
                    ],
                  ),
                ),
      
                Visibility(
                  visible: isQuestionsVusLoaded,
                  child: Container(
                    height: 130,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: questions_vus?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Card(
                              child: GestureDetector(
                                onTap: () async {
                                  await http.post(
                                    hp.ApiUrl('/addVusAPI'),
                                    body: {
                                      'id': questions_vus![index].id.toString(),
                                    },
                                  );
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => FatwaScreen(
                                          question: questions_vus![index])));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 1.7,
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
                                        vertical: 5.0, horizontal: 12.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints:
                                                  BoxConstraints(maxWidth: 200),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                gradient: LinearGradient(colors: [
                                                  Color.fromARGB(
                                                      255, 96, 192, 99),
                                                  Color.fromARGB(255, 1, 162, 184)
                                                ]),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 5),
                                                child: Expanded(
                                                  child: questions_vus![index]
                                                              .title
                                                              .length >
                                                          30
                                                      ? Text(
                                                          questions_vus![index]
                                                              .title
                                                              .substring(0, 30),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      : Text(
                                                          questions_vus![index]
                                                              .title,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            if (questions_vus![index].typeqst ==
                                                1)
                                              Text(
                                                "Social",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            if (questions_vus![index].typeqst ==
                                                2)
                                              Text(
                                                "Education",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            if (questions_vus![index].typeqst ==
                                                3)
                                              Text(
                                                "Religion",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            if (questions_vus![index].typeqst ==
                                                4)
                                              Text(
                                                "Language",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            questions_vus![index].contenu.length >
                                                    20
                                                ? Expanded(
                                                    child: Text(
                                                        questions_vus![index]
                                                                .contenu
                                                                .toString()
                                                                .substring(
                                                                    0, 20) +
                                                            ' ...'))
                                                : Expanded(
                                                    child: Text(
                                                        questions_vus![index]
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
                  ),
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Les articles les mieux notés',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => ArticlesScreen()),
                            );
                          },
                          child: Text(
                            'voir plus',
                            style: TextStyle(fontSize: 12),
                          ))
                    ],
                  ),
                ),
                Visibility(
                  visible: isLoaded,
                  child: Container(
                    height: 150,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: posts?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Card(
                              child: GestureDetector(
                                onTap: () async {
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
                                        vertical: 10.0, horizontal: 12.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: 34,
                                                  backgroundColor: Color.fromARGB(
                                                      255, 96, 192, 99),
                                                  child: CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        posts![index].avatar),
                                                    radius: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        posts![index].imam_name,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                      posts![index].title.length >30 ?
                                                      Text(
                                                        posts![index].title.substring(0,30)+'...',
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
                                                                color:
                                                                    Colors.amber,
                                                              ),
                                                              itemCount: 5,
                                                              itemSize: 25.0,
                                                              direction:
                                                                  Axis.horizontal,
                                                            )
                                                          : RatingBarIndicator(
                                                              rating:
                                                                  posts![index]
                                                                      .note!
                                                                      .toDouble(),
                                                              itemBuilder:
                                                                  (context,
                                                                          index) =>
                                                                      Icon(
                                                                Icons.star,
                                                                color:
                                                                    Colors.amber,
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
                            ),
                          );
                        }),
                  ),
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // bottomNavigationBar: SalomonBottomBar(
      //   currentIndex: _currentIndex,
      //   onTap: (i) => setState(() => _currentIndex = i),
      //   items: [
      //     /// Home
      //     SalomonBottomBarItem(
      //       icon: Icon(Icons.home),
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
      //       icon: GestureDetector(onTap: () {
      //         Navigator.of(context).pushReplacement(MaterialPageRoute(
      //                   builder: (context) =>
      //                       FatwasScreen()));
      //       }, child: Icon(Icons.forum)),
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
                    onTap: () {},
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
                    onTap: () {},
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
    );
  }
}

class PrayerCard extends StatelessWidget {
  const PrayerCard({
    Key? key,
    required this.prayer,
    required this.salat,
  }) : super(key: key);

  final DateTime prayer;
  final String salat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(colors: const [
            Color.fromARGB(255, 96, 192, 99),
            Color.fromARGB(255, 1, 162, 184)
          ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(salat,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(DateFormat.Hm().format(prayer),
                style: TextStyle(fontSize: 16, color: Colors.white))
          ],
        ),
      ),
    );
  }
}
