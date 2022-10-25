import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fatwa/Dimensions.dart';
import '../Home_Fatwa/Home_Fatwa.dart';
import '../Search.dart';
import '../CardWidget.dart';
import 'CardQuestion.dart';
import 'Question.dart';

class Forum extends StatefulWidget {


  @override
  State<Forum> createState() => _ForumState();

}
final forumcategorie=['Quran','Hadith','Social','Language'];


class _ForumState extends State<Forum> {



  List cat = ["Hadith","Khoutba","Dourous"];
  List _question = [];
  bool firsttime = true ;
  List data = [];
  int currentLength = 0;


  @override
  void initState() {
    super.initState();
  }


 

  


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PageTitle(pagetitle: 'Forum',),
          PageHeaderProfilePicture(),
          Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              child: const SizedBox(
                height: 50,
                child: CupertinoSearchTextField(),
              ),
            ),
          SizedBox(height:Dimensions.height10),
          const Divider(
              height: 10,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
          SizedBox(height: Dimensions.height30,),
          Search(categorie: forumcategorie),
          SizedBox(height: Dimensions.height10,),
          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          //   itemCount: data.length,
          //   itemBuilder: (context,index){
          //       return CardQuestion(CardQuestionText: data[index].title);
          //   }, 
          // )
          

          

        ],
      ),
    );
    
  }
}