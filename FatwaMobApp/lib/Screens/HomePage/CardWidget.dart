import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fatwa/Dimensions.dart';
import 'package:fatwa/Screens/HomePage/FatwaContentPage/FatwaContent.dart';



class CardWidget extends StatelessWidget {
    String CardText='';
    CardWidget({required this.CardText});


  @override
  Widget build(BuildContext context) {
      return   Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
                Navigator.push( context, MaterialPageRoute(
                  builder: (context) {
                    return FatwaContent(fatwasubject: CardText,);
                  },
                )
                );
            },
            child: Container(
              margin: EdgeInsets.only(top: Dimensions.height10 , left: Dimensions.width40 ,right: Dimensions.width40 ),
              height: Dimensions.ListViewCardWidget,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 66, 159, 235),
                borderRadius: BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0) ),
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
                  Text(CardText,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
                ],
              ),
              
            ),
          ),
                  Container(
                    height: Dimensions.ListViewCardRatingStars,
                     margin:  EdgeInsets.only(bottom: Dimensions.height25, left: Dimensions.width40 ,right: Dimensions.width40  ),
                                           decoration: BoxDecoration(
                        color: Color.fromARGB(178, 66, 159, 235),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0),bottomLeft: Radius.circular(20.0) ),
                        boxShadow: [ BoxShadow(
                            color : Color.fromARGB(255, 39, 105, 136).withOpacity(0.3),
                            offset: new Offset(-10.0, 0.0),
                            blurRadius: 20.0,
                            spreadRadius: 4.0,
                          ),
                        ],
                      ),
                      child: Center(child: 
                      RatingBar.builder(
                                initialRating: 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 20,
                                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                 
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                        )
                      ),

                  )
        ],
      );
  }
}