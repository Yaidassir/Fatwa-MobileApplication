import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fatwa/Dimensions.dart';
import 'package:fatwa/Screens/HomePage/Forum/QuestionContent.dart';

class CardQuestion extends StatelessWidget {
  
    String CardQuestionText='';
    CardQuestion({required this.CardQuestionText});

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
            onTap: () {
                Navigator.push( context, MaterialPageRoute(
                  builder: (context) {
                    return QuestionContent(questionsubject: CardQuestionText,);
                  },
                )
                );
            },
            child: Container(
              margin: EdgeInsets.only(top: Dimensions.height20 , left: Dimensions.width40 ,right: Dimensions.width40 ),
              height: Dimensions.ListViewCardWidget,
              decoration: BoxDecoration(
                color: Colors.orange[300],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [ BoxShadow(
                    color : Color.fromARGB(255, 39, 105, 136).withOpacity(0.3),
                    offset: new Offset(-10.0, 0.0),
                    blurRadius: 20.0,
                    spreadRadius: 4.0,
                  ),
                ],
              ),
              padding: EdgeInsets.only(left: Dimensions.width20,top: 50.0,bottom: 50,right: Dimensions.width20
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("The best",style: TextStyle(color: Colors.white,fontSize: 12),),
                  SizedBox(height: Dimensions.height10,),
                  Text(CardQuestionText,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
                ],
              ),
              
            ),
          );
  }
}