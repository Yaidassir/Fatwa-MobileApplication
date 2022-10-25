import 'package:fatwa/Screens/Profile/Componenets/Profile_pages/MyAccount/My_account_info.dart';
import 'package:fatwa/Screens/Profile/Componenets/profile_pic.dart';
import 'package:fatwa/services/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
// import 'package:get/route_manager.dart';
import '../../../../../services/auth.dart';
import './mybutton_widget.dart';
import 'package:dio/dio.dart' as Dio;

class Myaccountedit extends StatefulWidget {
  String name = '';
  String lastname = '';
  String email = '';
  String description = '';
  String phoneNumber = '';
  String avatar = '';

  Myaccountedit(
      {Key? key,
      required this.name,
      required this.lastname,
      required this.email,
      required this.description,
      required this.phoneNumber,
      required this.avatar})
      : super(key: key);

  @override
  State<Myaccountedit> createState() => _MyaccounteditState();
}

class _MyaccounteditState extends State<Myaccountedit> {
  late var nameController = TextEditingController();
  late var lastnameController = TextEditingController();
  late var descController = TextEditingController();
  late var numberController = TextEditingController();
  String password = '';
  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  final storage = new FlutterSecureStorage();

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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    lastnameController = TextEditingController(text: widget.lastname);
    descController = TextEditingController(text: widget.description);
    numberController = TextEditingController(text: widget.phoneNumber);
  }

  @override
  void dispose() {
    nameController.dispose();
    lastnameController.dispose();
    descController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
         onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Stack(alignment: Alignment.center, children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 35.0, right: 35.0, bottom: 35.0, top: 120.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ProfilePic(avatar: widget.avatar),
                    const SizedBox(
                      height: 40,
                    ),
                    buildName(),
                    const SizedBox(
                      height: 24,
                    ),
                    buildLastName(),
                    const SizedBox(
                      height: 24,
                    ),
                    // buildEmail(),
                    // const SizedBox(
                    //   height: 24,
                    // ),
                    buildNumber(),
                    const SizedBox(height: 24),
                    Consumer<Auth>(builder: (context, auth, child) {
                      if (auth.authenticated && auth.user.usertype == 1) {
                        return Column(
                          children: [
                            buildDescription(),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),
                    ButtonWidget(
                      text: 'Modifier',
                      onClicked: () {
                        Map infos = {
                          'name': nameController.text,
                          'lastname': lastnameController.text,
                          'phonenumber': numberController.text,
                        };
      
                        Map desc = {
                          'description': descController.text,
                        };
                        if (_formKey.currentState!.validate()) {
                          update(infos: infos);
                          description(infos: desc);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => Myaccountinfo()));
                        }
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (context) => Myaccountinfo()));
                        //  Navigator.push( context, MaterialPageRoute(
                        //   builder: (context) {
                        //     return Myaccountinfo(infoname: nameController.text ,
                        //      infoemail: emailController.text ,infophone: numberController.text ,);
                        //   }
                        // ));
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width, 100.0)),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 57, 212, 192),
                      Color.fromARGB(255, 0, 156, 177)
                    ]),
                  ),
                )),
            Positioned(
                top: 20,
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
                top: 30,
                child: Text(
                  "Modifier informations",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
          ]),
        ),
      ),
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: ' Nom...',
          labelText: 'Nom',
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          prefixIcon: const Icon(Icons.person),
          fillColor: Colors.white,
          // icon: Icon(Icons.mail),
          suffixIcon: nameController.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => nameController.clear(),
                ),
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        validator:(value){
          if (value == null || value.isEmpty) {
            return 'Entrer votre Nom !';
          } 
          return null;
        }
        // autofocus: true,
      );

  Widget buildLastName() => TextFormField(
        controller: lastnameController,
        decoration: InputDecoration(
          hintText: ' Prénom...',
          labelText: 'Prénom',
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          prefixIcon: const Icon(Icons.person),
          fillColor: Colors.white,
          // icon: Icon(Icons.mail),
          suffixIcon: lastnameController.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => lastnameController.clear(),
                ),
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        validator:(value){
          if (value == null || value.isEmpty) {
            return 'Entrer votre Prénom !';
          } 
        }
        // autofocus: true,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        controller: descController,
        decoration: InputDecoration(
          hintText: 'Votre description...',
          labelText: 'Description',
          fillColor: Colors.white,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          // icon: Icon(Icons.mail),

          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        validator:(value){
          if (value == null || value.isEmpty) {
            return 'Entrer votre Description !';
          } 
        }
        // autofocus: true,
      );

  Widget buildPassword() => TextFormField(
        onChanged: (value) => setState(() => this.password = value),
        // onSubmitted: (value) => setState(() => this.password = value),
        decoration: InputDecoration(
          hintText: 'Your Password...',
          labelText: 'Password',
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          prefixIcon: Icon(Icons.key),
          fillColor: Colors.white,
          suffixIcon: IconButton(
            icon: isPasswordVisible
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
            onPressed: () =>
                setState(() => isPasswordVisible = !isPasswordVisible),
          ),
          border: OutlineInputBorder(),
        ),
        obscureText: isPasswordVisible,
        validator: (value){
          if (value == null || value.isEmpty) {
            return 'Entrer votre Description !';
          
        }
        },
      );

  Widget buildNumber() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: numberController,
            decoration: const InputDecoration(
              hintText: 'Votre numéro de téléphone...',
              labelText: 'Numéro de téléphone',
              filled: true,
              prefixIcon: Icon(Icons.phone),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
            maxLength: 10,
            keyboardType: TextInputType.phone,
            validator:(value){
          if (value == null || value.isEmpty) {
            return 'Entrer votre Numero !';
          } else if ( value.length !=10){
            return 'Entrer un numero valide';
          }
          return null;
        }
          ),
        ],
      );
}
