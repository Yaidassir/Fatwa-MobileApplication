import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fatwa/Views/profil_screen.dart';
import 'package:fatwa/Widget/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fatwa/Screens/Profile/Profile.dart';
import 'package:fatwa/responsive.dart';
import 'Forum/Forum.dart';
import 'Notifications.dart';
import './AddContent.dart';
import 'Home_Fatwa/Home_Fatwa.dart';



class Fatwatest extends StatefulWidget {


  @override
  State<Fatwatest> createState() => _FatwatestState();
}

class _FatwatestState extends State<Fatwatest> {

  int index=0;
  final controller = PageController(initialPage: 0);

 
   final List<IconData> _icons = const [
    Icons.home,
    Icons.forum_rounded,
    MdiIcons.plusCircleOutline,
    MdiIcons.bell,
    Icons.person,
  ];


  final screens = [
    Home(),
    Forum(),
    AddContent(),
    Notifications(),
    ProfilScreen(userId: '1',),
  ];

 
  @override
  Widget build(BuildContext context) {

    
    final Size screenSize = MediaQuery.of(context).size;
     final pageview = PageView(controller: controller,scrollDirection: Axis.horizontal,children: [
         Home(),
         Forum(),
         AddContent(),
         Notifications(),
         Profile(),
     ],);

    
    return DefaultTabController(
      length: _icons.length,
      child: Scaffold(

        body: IndexedStack(
          index: index,
          children: screens,
        ),
        bottomNavigationBar: !Responsive.isDesktop(context)
            ? Container(
                padding: const EdgeInsets.only(bottom: 4.0),
                color: Colors.white,
                child: CustomTabBar(
                  icons: _icons,
                  selectedIndex: index,
                  onTap: (index) => setState(() => this.index = index),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  CurvedNavigationBar Bottombar(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.blue,
      backgroundColor: Colors.white,
      items: [
        Icon(Icons.home),
        Icon(Icons.forum),
        Icon(Icons.add),
        Icon(Icons.notifications),
        Icon(Icons.person),
      ],
      index: index,
      height: 50,
      onTap: (index){setState(() {
        this.index=index;
      });},

    );
  }
}





/*

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fatwapp/Dimensions.dart';
import 'package:fatwapp/Screens/HomePage/Home_Fatwa/CustomSearchDelegate.dart';
import '../CategorieWidget.dart';
import '../CardWidget.dart';
import '../Search.dart';
import 'package:http/http.dart' as http;

import 'fatwa.dart';

const kPrimaryColor = Color.fromARGB(255, 61, 166, 252);



class Home extends StatefulWidget {





  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List cat = ["Hadith","Khoutba","Dourous"];
  List<fatwa> _fat = [];
  bool firsttime = true ;
  List<fatwa> data = [];
  int currentLength = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
        fetchFatwas('https://jsonplaceholder.typicode.com/posts').then((value) {
      setState(() {
        _fat.addAll(value);
      });
    });

    if (firsttime) {
      _loadMore();
      firsttime=false;
    }

      _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }});
  }


  Future<List<fatwa>> fetchFatwas (String MyUrl) async {
    var url = MyUrl;
    var response = await http.get(Uri.parse(url));

    List<fatwa> fatwas = [];

    if (response.statusCode == 200) {
      var fatwasJson = json.decode(response.body);
        for (var fatwaJson in fatwasJson){
          fatwas.add(fatwa.fromJson(fatwaJson));
        }
    }
    return fatwas;
  }

  Future _loadMore() async {
    await Future.delayed(const Duration(seconds: 1));
    for (var i = currentLength; i <= currentLength + 10; i++) {
      data.add(_fat[i]);
    }
    setState(() {
      currentLength = data.length;
    });
  }
  
  


  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body : SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children :[
                      Text("Fatwa",style: TextStyle(color: Colors.black,fontSize: 20),), 
                      SizedBox(width: Dimensions.width10,),
                      SvgPicture.asset('../../../../assets/icons/mosque-svgrepo-com.svg',color: kPrimaryColor,width: 24,height: 24,)
                  ]),
                  Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle
                        ),
                        child: IconButton(onPressed: (){
                          showSearch(context: context, delegate: CustomSearchDelegate());
                        }, icon: Icon(Icons.search,color: Colors.black,)),
                      ),
                      SizedBox(width: Dimensions.width10,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle
                        ),
                        child: IconButton(onPressed: () {}, icon: SvgPicture.asset('../../../../assets/icons/mail-svgrepo-com.svg',height: 35,width: 35,color: Colors.black,)))
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              height: 10,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: Search(categorie: cat,)),
      
           ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context,index){
                  return CardWidget(CardText: data[index].title);
              }, 
            )
      
          ],
        ),
      ));
  }
}

*/

