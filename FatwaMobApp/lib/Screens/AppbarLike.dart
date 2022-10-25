import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class appbarlike extends StatelessWidget {
  String text='';
  appbarlike({required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
                    leading: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                         child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 227, 248, 255),
                          ),
                          child: Icon(Icons.arrow_back_ios_new,size: 16,color: Color(0xFF756d54),),
                         ),
                     ),
                     title: Text(text,style: TextStyle(),),
                  );
    
  }
}