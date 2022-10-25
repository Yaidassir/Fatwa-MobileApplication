import 'dart:io';
import 'package:fatwa/Views/Contacts_screen.dart';
import 'package:fatwa/models/user.dart';
import 'package:fatwa/Views/alerts_screen.dart';
import 'package:fatwa/Views/articles_screen.dart';
import 'package:fatwa/Views/fatwas_screen.dart';
import 'package:fatwa/Views/home_screen.dart';
import 'package:fatwa/Views/login_screen.dart';
import 'package:fatwa/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:fatwa/services/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:fatwa/services/http.dart' as hp;

import '../Dimensions.dart';
import '../Screens/Profile/Componenets/Profile_pages/About/About.dart';
import '../Screens/Profile/Componenets/Profile_pages/ChangePassword/change_password.dart';
import '../Screens/Profile/Componenets/Profile_pages/MyAccount/My_account_info.dart';
import '../Screens/Profile/Componenets/Profile_pages/NotificationSettings/NotificationsSettings.dart';
import '../Screens/Profile/Componenets/profile_menu.dart';
import 'imam_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;
  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final storage = new FlutterSecureStorage();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _prenomController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  TextEditingController _mdpController = TextEditingController();
  TextEditingController _newmdpController = TextEditingController();
  TextEditingController _newmdpconfirmationController = TextEditingController();

  var id;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token);
    print(token);
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  void update({Map? infos}) async {
    String? token = await storage.read(key: 'token');
    print(token);
    print(infos);
    Dio.Response response = await dio().post('/update_informations',
        data: infos,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
          followRedirects: false,
          validateStatus: (status) => true,
        ));
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  void description({Map? infos}) async {
    String? token = await storage.read(key: 'token');
    print(infos);
    Dio.Response response = await dio().post('/description',
        data: infos,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
          followRedirects: false,
          validateStatus: (status) => true,
        ));
  }

  void change_password({Map? passwords}) async {
    String? token = await storage.read(key: 'token');
    print(token);
    print(passwords);
    Dio.Response response = await dio().post('/changePassword',
        data: passwords,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
          followRedirects: false,
          validateStatus: (status) => true,
        ));
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  File? image;

  Future pickImage() async {
    String? token = await storage.read(key: 'token');

    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);

      setState(() {
        this.image = imageTemporary;
      });

      Dio.FormData formData = Dio.FormData.fromMap(
          {"profil_picture": await Dio.MultipartFile.fromFile(image.path)});

      Dio.Response response = await dio().post('/changeProfilPicture',
          data: formData,
          options: Dio.Options(
            headers: {'Authorization': 'Bearer $token'},
            followRedirects: false,
            validateStatus: (status) => true,
          ));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  List<User>? follows;
  var isLoaded = false;

  Future<List<User>?> getFollows() async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.get(
      hp.ApiUrl('/follows'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var json = response.body;
      follows = userFromJson(json);
      // print(follows!.length);
      if (follows != null) {
        setState(() {
          isLoaded = true;
        });
      }
    }
  }

  String nbAlerts = '';

  void alertNonLues(String id) async {
    print(id);
    final response = await http
        .post(hp.ApiUrl('/alertsCount'), body: {'query': id.toString()});
    if (response.statusCode == 200) {
      setState(() {
        nbAlerts = response.body;
      });
    }
  }

  void marquerLu(String id) async {
    final response = await http
        .post(hp.ApiUrl('/marquerluAPI'), body: {'query': id.toString()});
  }

  @override
  void initState() {
    _nameController.text = "";
    _prenomController.text = "";
    _phoneController.text = "";
    _descriptionController.text = "";
    _mdpController.text = "";
    _newmdpController.text = "";
    _newmdpconfirmationController.text = "";

    super.initState();
    readToken();
    getFollows();
    alertNonLues(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   backgroundColor: Colors.green[700],
      //   title: Text('Profil'),
      //   actions: [
      //     Stack(children: [
      //       IconButton(
      //         icon: const Icon(Icons.notifications),
      //         onPressed: () {
      //           print(widget.userId);
      //           marquerLu(widget.userId.toString());
      //           Navigator.of(context).push(MaterialPageRoute(
      //               builder: (context) => AlertScreen(id: widget.userId.toString())));
      //         },
      //       ),
      //       nbAlerts == '0'
      //           ? Container()
      //           : Positioned(
      //               left: 0,
      //               top: 0,
      //               child: Container(
      //                   padding: EdgeInsets.all(1),
      //                   decoration: new BoxDecoration(
      //                     color: Colors.red,
      //                     borderRadius: BorderRadius.circular(6),
      //                   ),
      //                   constraints: BoxConstraints(
      //                     minWidth: 12,
      //                     minHeight: 12,
      //                   ),
      //                   child: Text(nbAlerts))),
      //     ]),
      //   ],
      // ),
      body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20),
          child: Consumer<Auth>(builder: (context, auth, child) {
            if (auth.authenticated) {
              if (auth.user.etatcompte != 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                      SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 96, 192, 99),
                            Color.fromARGB(255, 1, 162, 184)
                          ]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Expanded(
                              child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text('Profile',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold)),
                            ),
                            leading: IconButton(
                              icon: Icon(Icons.menu,
                                  color: Colors.white, size: 35),
                              onPressed: () =>
                                  scaffoldKey.currentState?.openDrawer(),
                            ),
                            trailing: SizedBox(
                              height: 40, width: 20,
                              child: Stack(children: [
                                IconButton(
                                  icon: const Icon(Icons.notifications),
                                  onPressed: () {
                                    print(widget.userId);
                                    marquerLu(widget.userId.toString());
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => AlertScreen(
                                            id: widget.userId.toString())));
                                  },
                                ),
                                nbAlerts == '0'
                                    ? Container()
                                    : Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                            decoration: new BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            constraints: BoxConstraints(
                                              minWidth: 12,
                                              minHeight: 12,
                                            ),
                                            child: Center(child: Text(nbAlerts,style: TextStyle(color: Colors.white),)))),
                              ]),
                            ),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    
                   auth.user.usertype == 1 && auth.user.etatcompte == 1 ?  Padding(
                     padding: const EdgeInsets.symmetric(vertical:28.0, horizontal: 20),
                     child: const Text(
                                'Votre compte est en cours d\'examination, Vous serez admis dans un moment et vous pourrez profiter de vos priviléges d\'imam'),
                   ):Padding(
                     padding: const EdgeInsets.symmetric(vertical:28.0, horizontal: 20),
                     child: const Text(
                                'Votre compte a été banni!'),
                   )
                   
                   ]);
              } else {
                return Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 96, 192, 99),
                            Color.fromARGB(255, 1, 162, 184)
                          ]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Expanded(
                              child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text('Profile',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold)),
                            ),
                            leading: IconButton(
                              icon: Icon(Icons.menu,
                                  color: Colors.white, size: 35),
                              onPressed: () =>
                                  scaffoldKey.currentState?.openDrawer(),
                            ),
                            trailing: SizedBox(
                              height: 40, width: 20,
                              child: Stack(children: [
                                IconButton(
                                  icon: const Icon(Icons.notifications),
                                  onPressed: () {
                                    print(widget.userId);
                                    marquerLu(widget.userId.toString());
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => AlertScreen(
                                            id: widget.userId.toString())));
                                  },
                                ),
                                nbAlerts == '0'
                                    ? Container()
                                    : Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                            decoration: new BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            constraints: BoxConstraints(
                                              minWidth: 12,
                                              minHeight: 12,
                                            ),
                                            child: Center(child: Text(nbAlerts,style: TextStyle(color: Colors.white),)))),
                              ]),
                            ),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    CircleAvatar(
                      backgroundImage: NetworkImage(auth.user.avatar),
                      radius: 60,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Align(
                        child: Text(
                          "General",
                          style: TextStyle(color: Colors.cyan),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    ProfileMenu(
                      text: "Mon compte",
                      icon: "assets/icons/User.svg",
                      press: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Myaccountinfo();
                            },
                          ),
                        ),
                      },
                    ),
                    auth.user.usertype == 0 ?
                    ProfileMenu(
                      text: "Abonnements",
                      icon: "assets/icons/key-svgrepo-com.svg",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return NotificationSettings();
                            },
                          ),
                        );
                      },
                    ):Container(),
                    ProfileMenu(
                      text: "Modifier mot de pass",
                      icon: "assets/icons/key-svgrepo-com.svg",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChangePassword();
                            },
                          ),
                        );
                      },
                    ),
                    ProfileMenu(
                      text: "Messagerie",
                      icon: "assets/icons/Questionmark.svg",
                      press: () {
                                                Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Contacts();
                            },
                          ),
                        );


                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Align(
                        child: Text(
                          "Support",
                          style: TextStyle(color: Colors.cyan),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    ProfileMenu(
                      text: "A propos",
                      icon:
                          "assets/icons/about-information-info-help-svgrepo-com.svg",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return About();
                            },
                          ),
                        );
                      },
                    ),
                    ProfileMenu(
                      text: "Se déconnecter",
                      icon: "assets/icons/Logout.svg",
                      press: () {
                        Provider.of<Auth>(context, listen: false).logout();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    ),
                  ],
                );
              }
            } else {
              return Container();
            }
            // return Scaffold(
            //   appBar: AppBar(
            //     backgroundColor: Colors.green[700],

            //     title: Text('Profil'),
            //     actions: [
            //       Stack(children: [
            //         IconButton(
            //           icon: const Icon(Icons.notifications),
            //           onPressed: () {
            //             marquerLu(id.toString());
            //             Navigator.of(context).push(MaterialPageRoute(
            //                 builder: (context) => AlertScreen(id: id.toString())));
            //           },
            //         ),
            //         nbAlerts == '0'
            //             ? Container()
            //             : Positioned(
            //                 left: 0,
            //                 top: 0,
            //                 child: Container(
            //                     padding: EdgeInsets.all(1),
            //                     decoration: new BoxDecoration(
            //                       color: Colors.red,
            //                       borderRadius: BorderRadius.circular(6),
            //                     ),
            //                     constraints: BoxConstraints(
            //                       minWidth: 12,
            //                       minHeight: 12,
            //                     ),
            //                     child: Text(nbAlerts))),
            //       ]),
            //     ],
            //   ),
            //   body: Center(
            //     child: Consumer<Auth>(builder: (context, auth, child) {
            //       if (auth.authenticated) {
            //         _nameController.text = auth.user.name;
            //         _prenomController.text = auth.user.lastname;
            //         _phoneController.text = auth.user.phonenumber;
            //         _descriptionController.text = auth.user.description;

            //         id = auth.user.id;

            //         return Padding(
            //           padding: const EdgeInsets.only(top: 30, left: 10),
            //           child: ListView(children: <Widget>[
            //             auth.user.etatcompte == 1
            //                 ? Text(
            //                     'Veuillez attendre l\'approbation des admin de la platforme')
            //                 : Column(
            //                     children: [
            //                       Row(
            //                         children: [
            //                           Text(
            //                             "Nom:",
            //                             style: TextStyle(
            //                               fontSize: 24,
            //                             ),
            //                           ),
            //                           Text(
            //                             auth.user.name,
            //                             style: TextStyle(
            //                               fontSize: 20,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       Row(
            //                         children: [
            //                           Text(
            //                             "Prénom:",
            //                             style: TextStyle(
            //                               fontSize: 24,
            //                             ),
            //                           ),
            //                           Text(
            //                             auth.user.lastname,
            //                             style: TextStyle(
            //                               fontSize: 20,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       Row(
            //                         children: [
            //                           Text(
            //                             "Adresse email:",
            //                             style: TextStyle(
            //                               fontSize: 24,
            //                             ),
            //                           ),
            //                           Text(
            //                             auth.user.email,
            //                             style: TextStyle(
            //                               fontSize: 20,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       Row(
            //                         children: [
            //                           Text(
            //                             "Numéro de téléphone:",
            //                             style: TextStyle(
            //                               fontSize: 24,
            //                             ),
            //                           ),
            //                           Text(
            //                             auth.user.phonenumber,
            //                             style: TextStyle(
            //                               fontSize: 20,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       auth.user.usertype == 1
            //                           ? Row(
            //                               children: [
            //                                 Text(
            //                                   "Description:",
            //                                   style: TextStyle(
            //                                     fontSize: 24,
            //                                   ),
            //                                 ),
            //                                 Text(
            //                                   auth.user.description,
            //                                   style: TextStyle(
            //                                     fontSize: 20,
            //                                   ),
            //                                 ),
            //                               ],
            //                             )
            //                           : SizedBox(
            //                               height: 0,
            //                             ),
            //                       SizedBox(
            //                         height: 30,
            //                       ),
            //                       Center(
            //                           child: Text(
            //                         "Modifier informations personelles",
            //                         style: TextStyle(fontSize: 22),
            //                       )),
            //                       Padding(
            //                         padding: const EdgeInsets.all(20.0),
            //                         child: Form(
            //                             key: _formKey,
            //                             child: Column(
            //                               mainAxisAlignment: MainAxisAlignment.center,
            //                               children: [
            //                                 TextFormField(
            //                                   controller: _nameController,
            //                                   decoration: InputDecoration(
            //                                     labelText: "nom",
            //                                   ),
            //                                 ),
            //                                 TextFormField(
            //                                   controller: _prenomController,
            //                                   keyboardType: TextInputType.name,
            //                                   decoration: InputDecoration(
            //                                     labelText: "Prénom",
            //                                   ),
            //                                 ),
            //                                 TextFormField(
            //                                   controller: _phoneController,
            //                                   keyboardType: TextInputType.number,
            //                                   decoration: InputDecoration(
            //                                     labelText: "Numéro de téléphone",
            //                                   ),
            //                                 ),
            //                                 auth.user.usertype == 1
            //                                     ? TextFormField(
            //                                         maxLines: 5,
            //                                         controller: _descriptionController,
            //                                         decoration: InputDecoration(
            //                                           labelText: "Description",
            //                                         ),
            //                                       )
            //                                     : SizedBox(
            //                                         height: 1,
            //                                       ),
            //                                 TextButton(
            //                                   style: TextButton.styleFrom(
            //                                     primary: Colors.blue,
            //                                   ),
            //                                   child: Text('Modifier'),
            //                                   onPressed: () {
            //                                     Map infos = {
            //                                       'name': _nameController.text,
            //                                       'lastname': _prenomController.text,
            //                                       'phonenumber': _phoneController.text,
            //                                     };

            //                                     Map desc = {
            //                                       'description':
            //                                           _descriptionController.text,
            //                                     };
            //                                     if (_formKey.currentState!.validate()) {
            //                                       update(infos: infos);
            //                                       description(infos: desc);
            //                                     }
            //                                   },
            //                                 )
            //                               ],
            //                             )),
            //                       ),
            //                       Center(
            //                           child: Text(
            //                         "Modifier mot de passe",
            //                         style: TextStyle(fontSize: 22),
            //                       )),
            //                       Padding(
            //                         padding: const EdgeInsets.all(20.0),
            //                         child: Form(
            //                             key: _formKey2,
            //                             child: Column(
            //                               mainAxisAlignment: MainAxisAlignment.center,
            //                               children: [
            //                                 TextFormField(
            //                                   controller: _mdpController,
            //                                   decoration: InputDecoration(
            //                                     labelText: "Ancien mot de passe",
            //                                   ),
            //                                 ),
            //                                 TextFormField(
            //                                   controller: _newmdpController,
            //                                   decoration: InputDecoration(
            //                                     labelText: "Nouveau mot de passe",
            //                                   ),
            //                                 ),
            //                                 TextFormField(
            //                                   controller: _newmdpconfirmationController,
            //                                   decoration: InputDecoration(
            //                                     labelText:
            //                                         "Confirmer le nouveau mot de passe",
            //                                   ),
            //                                 ),
            //                                 TextButton(
            //                                   style: TextButton.styleFrom(
            //                                     primary: Colors.blue,
            //                                   ),
            //                                   child: Text('Modifier'),
            //                                   onPressed: () {
            //                                     Map passwords = {
            //                                       'current-password':
            //                                           _mdpController.text,
            //                                       'new-password':
            //                                           _newmdpController.text,
            //                                       'new-password_confirmation':
            //                                           _newmdpconfirmationController.text
            //                                     };
            //                                     if (_formKey2.currentState!
            //                                         .validate()) {
            //                                       print("password changed");
            //                                       try {
            //                                         change_password(
            //                                             passwords: passwords);
            //                                       } catch (e) {
            //                                         print(e);
            //                                       }
            //                                     }
            //                                   },
            //                                 ),
            //                               ],
            //                             )),
            //                       ),
            //                       auth.user.usertype == 0
            //                           ? Padding(
            //                               padding: const EdgeInsets.all(8.0),
            //                               child: Row(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment.center,
            //                                   children: [
            //                                     Text(
            //                                       'Abonnements',
            //                                       style: TextStyle(
            //                                           fontSize: 20,
            //                                           fontWeight: FontWeight.bold),
            //                                     ),
            //                                   ]))
            //                           : SizedBox(
            //                               height: 0,
            //                             ),
            //                       auth.user.usertype == 0
            //                           ? Visibility(
            //                               visible: isLoaded,
            //                               child: SizedBox(
            //                                 height: 200,
            //                                 child: ListView.builder(
            //                                   itemCount: follows?.length,
            //                                   itemBuilder: (context, index) {
            //                                     return Container(
            //                                       child: GestureDetector(
            //                                         onTap: () {
            //                                           Navigator.of(context).push(
            //                                               MaterialPageRoute(
            //                                                   builder: (context) =>
            //                                                       ImamScreen(id: follows![index].id,)));
            //                                         },
            //                                         child: Row(
            //                                           children: [
            //                                             CircleAvatar(
            //                                               backgroundImage: NetworkImage(
            //                                                   follows![index].avatar),
            //                                               radius: 30,
            //                                             ),
            //                                             SizedBox(
            //                                               width: 10,
            //                                             ),
            //                                             Text(follows![index]
            //                                                     .name
            //                                                     .toString() +
            //                                                 ' ' +
            //                                                 follows![index]
            //                                                     .lastname
            //                                                     .toString()),
            //                                           ],
            //                                         ),
            //                                       ),
            //                                     );
            //                                   },
            //                                 ),
            //                               ),
            //                               replacement: const Center(
            //                                 child: CircularProgressIndicator(),
            //                               ),
            //                             )
            //                           : SizedBox(
            //                               height: 0,
            //                             )
            //                     ],
            //                   ),
            //           ]),
            //         );
            //       } else {
            //         return Column(
            //           children: [
            //             Text("Home Screen"),
            //           ],
            //         );
          })),
      drawer: Drawer(
        child: Consumer<Auth>(builder: (context, auth, child) {
          if (!auth.authenticated) {
            return Container();
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
                    onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                      
                    },
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
            // return ListView(
            //   children: [
            //     DrawerHeader(
            //       child: Column(
            //         children: [
            //           Stack(children: <Widget>[
            //             CircleAvatar(
            //               backgroundImage: NetworkImage(auth.user.avatar),
            //               radius: 40,
            //             ),
            //             Positioned(
            //               bottom: -10,
            //               right: -10,
            //               child: IconButton(
            //                   icon: Icon(Icons.camera_alt),
            //                   iconSize: 18,
            //                   color: Colors.white,
            //                   onPressed: () async {
            //                     pickImage();
            //                   }),
            //             ),
            //           ]),
            //           SizedBox(
            //             height: 5,
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Text(
            //                 auth.user.name,
            //                 style: TextStyle(color: Colors.white),
            //               ),
            //               SizedBox(
            //                 width: 10,
            //               ),
            //               Text(
            //                 auth.user.lastname,
            //                 style: TextStyle(color: Colors.white),
            //               ),
            //             ],
            //           ),
            //           SizedBox(
            //             height: 5,
            //           ),
            //           Text(
            //             auth.user.email,
            //             style: TextStyle(color: Colors.white),
            //           ),
            //         ],
            //       ),
            //       decoration: BoxDecoration(color: Colors.blue),
            //     ),
            //     ListTile(
            //       title: Text('Home'),
            //       leading: Icon(Icons.home),
            //       onTap: () {
            //         Navigator.of(context).pushReplacement(
            //           MaterialPageRoute(builder: (context) => HomeScreen()),
            //         );
            //       },
            //     ),
            //     ListTile(
            //       title: Text('Articles'),
            //       leading: Icon(Icons.login),
            //       onTap: () {
            //         Navigator.of(context).pushReplacement(MaterialPageRoute(
            //             builder: (context) => ArticlesScreen()));
            //       },
            //     ),
            //     ListTile(
            //       title: Text('Fatwas'),
            //       leading: Icon(Icons.login),
            //       onTap: () {
            //         Navigator.of(context).pushReplacement(MaterialPageRoute(
            //             builder: (context) => FatwasScreen()));
            //       },
            //     ),
            //     ListTile(
            //       title: Text('Profile'),
            //       leading: Icon(Icons.person),
            //       onTap: () {},
            //     ),
            //     ListTile(
            //       title: Text('Logout'),
            //       leading: Icon(Icons.logout),
            //       onTap: () {
            //         Provider.of<Auth>(context, listen: false).logout();
            //         Navigator.of(context).pushReplacement(
            //           MaterialPageRoute(builder: (context) => HomeScreen()),
            //         );
            //       },
            //     ),
            //   ],
            // );
          }
        }),
      ),
    );
  }
}

const kPrimaryColor = Color.fromARGB(255, 61, 166, 252);

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: kPrimaryColor,
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            // SvgPicture.asset(
            //   icon,
            //   color: kPrimaryColor,
            //   width: 22,
            // ),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
