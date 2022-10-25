import 'package:fatwa/Dimensions.dart';
import 'package:fatwa/Views/profil_screen.dart';
import 'package:flutter/material.dart';
import 'package:fatwa/Screens/Profile/Profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../services/dio.dart';
import '../MyAccount/mybutton_widget.dart';
import 'package:dio/dio.dart' as Dio;

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isPasswordVisible = true;
  final _formKey = GlobalKey<FormState>();
  String oldpass = "";
  String newpass = "";
  String newpassconfirm = "";

  bool oldpasstrue = false;

  TextEditingController _mdpController = TextEditingController();
  TextEditingController _newmdpController = TextEditingController();
  TextEditingController _newmdpconfirmationController = TextEditingController();

  final storage = new FlutterSecureStorage();

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
    if (response.data == 'Password changed successfully !') {
      Navigator.pop(context);
      setState(() {
        oldpasstrue = false;
      });
    } else {
      setState(() {
        oldpasstrue = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mdpController.text = "";
    _newmdpController.text = "";
    _newmdpconfirmationController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
         onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: GestureDetector(
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
                  ),
                  title: Text(
                    'Modifier mot de pass',
                    style: TextStyle(),
                  ),
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Text(
                  'Entrez un nouveau mot de pass',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                Text(
                    'créer un mot de passe fort et sécurisé qui protège votre compte',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                SizedBox(
                  height: Dimensions.height25,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text('Mot de pass actuel'),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        buildPassword(),
                        Visibility(
                            visible: oldpasstrue,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Ancien mot de pass incorrect',
                                style: TextStyle(color: Colors.red,fontSize: 14),
                              ),
                            )),
                        SizedBox(
                          height: Dimensions.height25,
                        ),
                        Text('Nouveau mot de pass'),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        buildNewPassword(),
                        SizedBox(
                          height: Dimensions.height25,
                        ),
                        Text('Ré-entre le nouveau mot de pass'),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        buildConfirmationPassword(),
                        SizedBox(
                          height: Dimensions.height35,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ButtonWidget(
                            text: 'Save',
                            onClicked: () {
                              Map passwords = {
                                'current-password': _mdpController.text,
                                'new-password': _newmdpController.text,
                                'new-password_confirmation':
                                    _newmdpconfirmationController.text
                              };
      
                              if (_formKey.currentState!.validate()) {
                                change_password(passwords: passwords);
                                // Navigator.pushReplacement(context,
                                //     MaterialPageRoute(builder: (context) {
                                //   return Profile();
                                // }));
                              }
                            },
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPassword() => TextFormField(
        onChanged: (value) => setState(() => oldpass = value),
        controller: _mdpController,
        decoration: InputDecoration(
          hintText: 'Votre ancien mot de pass...',
          labelText: 'Mot de pass actuel',
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 1),
              borderRadius: BorderRadius.circular(10)),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Entrez votre mot de passe';
          }
          return null;
        },
      );

  Widget buildNewPassword() => TextFormField(
        onChanged: (value) => setState(() => newpass = value),
        // onSubmitted: (value) => setState(() => password = value),
        controller: _newmdpController,
        decoration: InputDecoration(
          hintText: 'Votre nouveau mot de pass...',
          labelText: 'Nouveau mot de pass',
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 1),
              borderRadius: BorderRadius.circular(10)),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Entrez votre mot de passe';
          } else if (newpass == oldpass) {
            return "Entrez un mot de passe différent de l'ancien";
          }
          return null;
        },
      );

  Widget buildConfirmationPassword() => TextFormField(
        onChanged: (value) => setState(() => newpassconfirm = value),
        // onSubmitted: (value) => setState(() => password = value),
        controller: _newmdpconfirmationController,
        decoration: InputDecoration(
          hintText: 'Veuillez confirmer votre nouveau mot de pass...',
          labelText: 'Confimer nouveau mot de pass',
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 1),
              borderRadius: BorderRadius.circular(10)),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Entrez votre mot de passe';
          } else if (newpassconfirm != newpass) {
            return 'Veuillez vérifier votre mot de pass et sa confirmation';
          }
          return null;
        },
      );
}
