import 'dart:io';

import 'package:fatwa/Views/articles_screen.dart';
import 'package:fatwa/Views/fatwas_screen.dart';
import 'package:fatwa/Views/home_screen.dart';
import 'package:fatwa/Views/login_screen.dart';
import 'package:fatwa/Views/register_screen.dart';
import 'package:fatwa/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:fatwa/services/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';

class RegisterProScreen extends StatefulWidget {
  const RegisterProScreen({Key? key}) : super(key: key);

  @override
  State<RegisterProScreen> createState() => _RegisterProScreenState();
}

class _RegisterProScreenState extends State<RegisterProScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _justificatifController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordconfirmationController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

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
    super.dispose();
  }

  // void register({Map? creds}) async {
  //   print(creds);
  //   try {
  //     Dio.Response response = await dio().post('/register_imam', data: creds);
  //     print(response.data.toString());
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.green[700],
      //   title: Text('Inscription imam')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  "Inscription Imam",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nom',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplire ce champ';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _lastnameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Pr??nom',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplire ce champ';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Adresse email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplire ce champ';
                      }
                      return null;
                    },
                  ),
                ),
                // FormBuilderFilePicker(
                //   name: 'images',
                //   decoration: const InputDecoration(labelText: 'Attachments'),
                //   maxFiles: null,
                //   onChanged: (val) => debugPrint(val.toString()),
                //   selector: Row(
                //     children: const <Widget>[
                //       Icon(Icons.file_upload),
                //       Text('Upload'),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _phoneController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Num??ro de t??l??phone',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplire ce champ';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.datetime,
                    controller: _dateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Date de naissance',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplire ce champ';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                    child: const Text('upload picture'),
                    onPressed: () async {
                      pickImage();
                    }),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mot de pass',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplire ce champ';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _passwordconfirmationController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirmez le mot de pass',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplire ce champ';
                      }
                      return null;
                    },
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: Text('S\'inscrire'),
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
                )
              ],
            )),
      ),
      drawer: Drawer(
        child: ListView(
              children: [
                 ListTile(
                  title: Text('Home'),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
                ListTile(
                  title: Text('Articles'),
                  leading: Icon(Icons.login),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ArticlesScreen()));
                  },
                ),
                 ListTile(
                  title: Text('Fatwas'),
                  leading: Icon(Icons.login),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => FatwasScreen()));
                  },
                ),
                ListTile(
                  title: Text('Se connecter'),
                  leading: Icon(Icons.login),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
                ListTile(
                  title: Text('S\'inscire'),
                  leading: Icon(Icons.signal_cellular_0_bar),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterScreen()));
                  },
                ),
                ListTile(
                  title: Text('S\'inscire en tant qu\'imam'),
                  leading: Icon(Icons.signal_cellular_0_bar),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterProScreen()));
                  },
                ),
              ],
            ),
        ),
    );
  }
}
