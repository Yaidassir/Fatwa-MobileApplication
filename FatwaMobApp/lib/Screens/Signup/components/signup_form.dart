import 'dart:io';

import 'package:fatwa/services/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fatwa/Screens/HomePage/AddContent.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import 'package:dio/dio.dart' as Dio;
import '../../../services/auth.dart';
import '../../Login/login_screen.dart';

const kPrimaryColor = Color.fromARGB(255, 61, 166, 252);

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool isChecked = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordconfirmationController =
      TextEditingController();

  TextEditingController _justificatifController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  RegExp emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  // RegExp regexpassword =RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  File? image;
  late Dio.FormData formData;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);

      // Dio.FormData formDataTemporary = Dio.FormData.fromMap(
      //     {"justificatif": await Dio.MultipartFile.fromFile(image.path)});
      setState(() {
        this.image = imageTemporary;
        // this.formData = formDataTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordconfirmationController.dispose();

    _justificatifController.dispose();

    super.dispose();
  }

  void register({Map? creds}) async {
    print(creds);

    try {
      Dio.Response response = await dio().post('/register', data: creds);
      await dio().get('/verify');

      print(response.data.toString());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: _nameController,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Nom",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
            validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplire ce champ';
                      }else if(value.length<4){
                        return 'Nom trop court';
                      }
                      return null;
                    },
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            controller: _lastnameController,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Prénom",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
            validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplire ce champ';
                      }else if(value.length<4){
                        return 'Prénom trop court';
                      }
                      return null;
                    },
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            controller: _emailController,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.email),
              ),
            ),
            validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez remplire ce champ ';
                          }else if(!emailValid.hasMatch(value)){
                              return 'Entrez une adresse email valide!';   
                            }
                            
                          return null;
                        },
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: _dateController,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            readOnly: true,
            onTap:() async {
               DateTime? pickedDate = await showDatePicker(
                      context: context, initialDate: DateTime(2006),
                      firstDate: DateTime(1900), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2006)
                  );
                  
                  if(pickedDate != null ){
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); 
                      setState(() {
                        _dateController.text = formattedDate;
                      });
                  }else{
                      print("Date is not selected");
                  }
              
            },
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Date de naissance",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.calendar_month),
              ),
            ),
            validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplire ce champ';
                      }
                      return null;
                    },
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            controller: _phoneController,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Numéro de téléphone",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.phone),
              ),
            ),
            validator: (value) {
              
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplire ce champ';
                      }else if (value.substring(0,1)=='05' || value.substring(0,1)=='06' || value.substring(0,1)=='07'){
                        return null;
                      }else if (value.length!=10){
                        return'Entrez un numero de telephone valide';
                      }
                      return null;
                    },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _passwordController,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Mot de pass",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
              validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplire ce champ';
                      }
                      // else if(!regexpassword.hasMatch(value)){
                      //   return 'Veuillez entrer un mot de passe plus solide';
                      // }
                      else if(value.length<6){
                        return 'Mot de passe trop court';
                      }
                      return null;
                    },
            ),
          ),
          TextFormField(
            textInputAction: TextInputAction.done,
            obscureText: true,
            controller: _passwordconfirmationController,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              hintText: "Confirmez votre mot de pass",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock),
              ),
            ),
            validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplire ce champ';
                      }
                      return null;
                    },
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          CheckboxListTile(
              title: Text("S'inscrire en tant qu'imam"),
              subtitle: Text("Imam"),
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                });
              }),
          const SizedBox(height: defaultPadding),
          isChecked
              ? buildButton(
                  title: 'Justificatif',
                  icon: Icons.image_outlined,
                  onClicked: () {
                    pickImage();
                  })
              : const SizedBox.shrink(),
          const SizedBox(height: defaultPadding),
          !isChecked? ElevatedButton(
            onPressed: () {
               Map creds = {
                'name': _nameController.text,
                'lastname': _lastnameController.text,
                'email': _emailController.text,
                'phonenumber': _phoneController.text,
                'dateofbirth': _dateController.text,
                'password': _passwordController.text,
                'device_name': "android",
              };
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Processing Data')),
                // );
                register(creds: creds);

                // Provider.of<Auth>(context, listen: false).login(creds: creds);

                // Navigator.pop(context);
                Provider.of<Auth>(context, listen: false)
                          .login(creds: creds);

                      Navigator.pop(context);


              }
            },
            child: Text("S'inscrire".toUpperCase()),
          ):ElevatedButton(
            onPressed: () async {
              Dio.FormData formData = new Dio.FormData.fromMap({
                      'name': _nameController.text,
                      'lastname': _lastnameController.text,
                      'email': _emailController.text,
                      'phonenumber': _phoneController.text,
                      'dateofbirth': _dateController.text,
                      'justificatif':
                          await Dio.MultipartFile.fromFile(image!.path),
                      'password': _passwordController.text,
                      'device_name': "android",
                    });
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Processing Data')),
                      // );
                      print(formData);
                      try {
                        Dio.Response response =
                            await dio().post('/register_imam', data: formData);
                        print(response.data.toString());
                      } catch (e) {
                        print(e);
                      }

                      Provider.of<Auth>(context, listen: false).login(creds: {
                        'email': _emailController.text,
                        'password': _passwordController.text,
                        'device_name': "mobile",
                      });
                      Navigator.pop(context);


                    }
              
            },
            child: Text("S'inscrire".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
