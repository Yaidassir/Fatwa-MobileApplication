
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Categorie extends StatelessWidget {

   String cat = '';

  Categorie({ required this.cat});

  @override
  Widget build(BuildContext context) {
      
  
    
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    

    
    return           
               Container(
              height: 200,
              child: Stack(
                children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Material(
                    child: Container(
                      height: 150.0,
                      width: width*0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius : BorderRadius.circular(0.0),
                          boxShadow: [new BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            offset:  Offset(-10.0, 10.0),
                            blurRadius: 20.0,
                            spreadRadius: 4.0
                          )]
      
                      ),
                    ),
                  ),
                        ) 
                ,
                              Positioned(
                    top: 0,
                    left: 30,
                    child: Card(
                      elevation: 10.0,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        height: 170,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/hadith.png")
                          )
                        ),
                      ),
                    ),
                    ),
                 Positioned(
                  top: 60,
                  left: width*0.6,
                  child: Text(cat,style: TextStyle(fontSize: 20.0,color: Color.fromRGBO(33, 150, 243, 1),fontWeight: FontWeight.bold),))
                
                 
                ],
              ),
            );
  
  }
}