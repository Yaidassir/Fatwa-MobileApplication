import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import '../../profile_pic.dart';


class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {

  String passworderror='';
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
      return Scaffold(  
         appBar: AppBar(
            leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation : 1,
          ),
          body: Container(
            padding: EdgeInsets.only(left:16 , top: 25,right: 16),
            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Column(
                 
                  children: [
                    // Center(child: ProfilePic()),
                    SizedBox(height: 35.0,),
                    TextFieldMethod("Full Name","Riache Yassir",false,TextInputType.name),
                    TextFieldMethod("E-mail","Levi_Ackerman@gmail.com",false,TextInputType.emailAddress),
                    TextFieldMethod("Password","YAIDASSIR",true,TextInputType.none),
                    TextFieldMethod("Phone Number","021265853",false,TextInputType.phone),
                  ]
                ),
              ),
            ),
          ),


      );
  }

  Widget TextFieldMethod(String labelText , String placeholder, bool isPasswrodObscured , TextInputType keyboardType) {
    
    return Padding(
      padding: const EdgeInsets.only(bottom : 35.0),
      child: Column(
        children: [
 

            TextFormField(
   
                          autofocus: false,
                          obscureText: isPasswrodObscured ? showPassword : false ,
                          keyboardType : keyboardType,
                            decoration: InputDecoration(    
                              suffixIcon: isPasswrodObscured? IconButton(onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              }, icon: Icon( 
                                 Icons.remove_red_eye, color: Colors.grey[400], )
                                ) : null,
                              contentPadding: EdgeInsets.only(bottom: 3),
                              fillColor: Colors.white,
                              labelText: labelText,
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintText: placeholder,
                              errorText: passworderror,
                              focusColor: Colors.grey,
                                enabledBorder: UnderlineInputBorder(      
                                      borderSide: BorderSide(color: Colors.black),   
                                    ),  
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue),
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
            ),
                              hintStyle: TextStyle(
                                fontSize: 16 , fontWeight: FontWeight.bold,
                                color: Colors.black
                              )
                            ),  
                          ),
          
                        // ignore: avoid_print
                        
                        
        ],
      ),
                    
    );
  }
}