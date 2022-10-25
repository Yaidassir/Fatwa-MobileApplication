import 'package:fatwa/Screens/Profile/Profile.dart';
import 'package:provider/provider.dart';
import 'package:fatwa/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:fatwa/Dimensions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './My_accountEdit.dart';
import 'mybutton_widget.dart';

class Myaccountinfo extends StatefulWidget {
//  infoname: auth.user.name,
//                             infolastname: auth.user.lastname,
//                             infoemail: auth.user.email,
//                             infophone: auth.user.phonenumber,
//                             avatar: auth.user.avatar,

  @override
  State<Myaccountinfo> createState() => _MyaccountinfoState();
}

class _MyaccountinfoState extends State<Myaccountinfo> {
  void readToken() async {
    final storage = new FlutterSecureStorage();

    String? token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token);
    print(token);
  }

  @override
  void initState() {
    super.initState();
    readToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<Auth>(builder: (context, auth, child) {
      if (auth.authenticated) {
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                  height: 200,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 57, 212, 192),
                      Color.fromARGB(255, 0, 156, 177)
                    ]),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                  )),
            ),
            Positioned(
                top: 35,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFfcf4e4),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: Color(0xFF756d54),
                    ),
                  ),
                )),
            Positioned(
                top: 40,
                child: Text(
                  "Profile",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: Dimensions.height200 - 80,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 39, 105, 136)
                              .withOpacity(0.3),
                          offset: Offset(-10.0, 0.0),
                          blurRadius: 20.0,
                          spreadRadius: 1.0,
                        ),
                      ]),
                  padding: EdgeInsets.all(20),
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      SizedBox(
                        height: 120,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: -80,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 80,
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      NetworkImage(auth.user.avatar),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Informations personelles",
                            style: TextStyle(fontSize: 16, color: Colors.cyan),
                          )),
                      SizedBox(
                        height: Dimensions.height25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Nom"),
                          Text(auth.user.name),
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.height25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Prénom"),
                          Text(auth.user.lastname),
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.height25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Adresse email"),
                          SizedBox(width: 30,),
                          Flexible(child: Text(auth.user.email)),
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.height25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Numéro de téléphone"),
                          Text(auth.user.phonenumber),
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.height35,
                      ),
                      auth.user.usertype == 1 ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Description"),
                          Flexible(child: Text(auth.user.description)),
                        ],
                      ):Container(),
                      SizedBox(
                        height: Dimensions.height35,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ButtonWidget(
                          text: 'Modifier',
                          onClicked: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Myaccountedit(
                                lastname: auth.user.lastname,
                                name: auth.user.name,
                                email: auth.user.email,
                                description: auth.user.description,
                                phoneNumber: auth.user.phonenumber,
                                avatar: auth.user.avatar,
                              );
                            }));
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return Container();
      }
    }));
  }
}











/*

My Account lowal 

Center(
        child: Column(
        children:  [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  decoration :  BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.green,Colors.cyan]),
                    borderRadius: new BorderRadius.vertical(bottom: new Radius.elliptical(
                      MediaQuery.of(context).size.width, 100.0)),

                  )
                ),
                Positioned( 
                  bottom: -50.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("assets/images/ProfileImage.png"),),
                  )
                  )
              ],
            ),
            const SizedBox(height: 80,),
            Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Full Name :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                SizedBox(height: Dimensions.height10,),
                Text(widget.infoname,style: TextStyle(fontSize: 20.0)),
              ],
            ), 
            const SizedBox(height: 24,),
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                const Text("Email :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                SizedBox(height: Dimensions.height10,),
                Text(widget.infoemail,style: TextStyle(fontSize: 24.0),),
               ],
             ),
            const SizedBox(height: 24,),
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Text("Phone Number :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                 SizedBox(height: Dimensions.height10,),
                 Text(widget.infophone,style: TextStyle(fontSize: 24.0),),
               ],
             ),
            const SizedBox(height: 24,),

              ],
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: Colors.green[300],
                ),
                onPressed: (){
                    Navigator.push( context, MaterialPageRoute(
                      builder: (context) {
                        return Myaccountedit(fullname: widget.infoname,email: widget.infoemail,phoneNumber: widget.infophone,);
                      },
                    ),
                  );
              }, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Icon(Icons.edit),
                    SizedBox(width: Dimensions.width10,),  
                    Text("Edit")
              ],)),
            )
        ],
    ),
      ),

      */






/*
My Account Deuxieme


        child: Stack(
          children: [
            Container(
              height: 300,
              decoration :  BoxDecoration(
                gradient: LinearGradient(colors: [Color.fromARGB(255, 57, 212, 192),Color.fromARGB(255, 0, 156, 177)]),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
              )
            ),

            Container(
              padding: EdgeInsets.all(20),
              height: 400,
              width: double.maxFinite,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(Dimensions.height20),
                    height: 400,
                       decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(10),
                      ),
                        child:Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                                           Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("First Name"),
                          Text("Aida"),
                        ],),
                        SizedBox(height: Dimensions.height25,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("Family Name "),
                          Text("Riache"),
                        ],),
                        SizedBox(height: Dimensions.height25,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("Email "),
                          Text("Aida_Riache@gmail.com"),
                        ],),
                        SizedBox(height: Dimensions.height25,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("Phone Number "),
                          Text("0541728930"),
                        ],),
                         SizedBox(height: Dimensions.height25,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.green
                          ),
                          onPressed: (){}, child: Text("Edit",style: TextStyle(color: Colors.white),))
                      ],
                    ),
                  ),
                  ),
                  Positioned(
                    top: -80,
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 80,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage("assets/images/ProfileImage.png"),),
                     ),
                  ),

  
                ],
              ),
            ),
            
          ],
        ),

        */

/*
My Account 3éme



SingleChildScrollView(
        child: Container(
          height: 200,
          width: double.maxFinite,
          decoration :  BoxDecoration(
          gradient: LinearGradient(colors: [Color.fromARGB(255, 57, 212, 192),Color.fromARGB(255, 0, 156, 177)]),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
        ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: -400,
                child: Container(
                  height: 450,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [ BoxShadow(
                  color : Color.fromARGB(255, 39, 105, 136).withOpacity(0.3),
                  offset: new Offset(-10.0, 0.0),
                  blurRadius: 20.0,
                  spreadRadius: 1.0,
                ),]
                  ),

                  child:
                   Container(
                    padding: EdgeInsets.all(20),
                    width: double.maxFinite,
                    height: double.maxFinite,
                     child: Column(
                      children: [
                      SizedBox(
                        height: 120,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                           Positioned(
                            top: -80,
                            child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 80,
                           child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage("assets/images/ProfileImage.png"),),
                     ),
                ),],
                        ),
                      ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("First Name"),
                          Text("Aida"),
                        ],),
                        SizedBox(height: Dimensions.height25,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("Family Name "),
                          Text("Riache"),
                        ],),
                        SizedBox(height: Dimensions.height25,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("Email "),
                          Text("Aida_Riache@gmail.com"),
                        ],),
                        SizedBox(height: Dimensions.height25,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("Phone Number "),
                          Text("0541728930"),
                        ],),
                        SizedBox(height: Dimensions.height35,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.green
                          ),
                          onPressed: (){
                            print("FUCK");
                          
                            }, child: Text("Edit",style: TextStyle(color: Colors.white),)),
                  
                  ]),
                   ),
                ),
              ),  
              Positioned(
                top: 20,
                left: 20,
                child:
                 GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                   child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[100]
                    ),
                    child: Icon(Icons.arrow_back_ios_new,size: 16,),
                   ),
                 )),
              Positioned(
                top: 30,
                child: 
                Text("Profile"))
            ],
          ),
        ),
      ) 





*/




