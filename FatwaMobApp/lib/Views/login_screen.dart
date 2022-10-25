import 'package:fatwa/Views/articles_screen.dart';
import 'package:fatwa/Views/fatwas_screen.dart';
import 'package:fatwa/Views/home_screen.dart';
import 'package:fatwa/Views/register_screen.dart';
import 'package:fatwa/Views/registerpro_screen.dart';
import 'package:fatwa/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/Login/components/ForgotPassword/forgot_password.dart';
import '../Screens/Signup/signup_screen.dart';
import '../components/already_have_an_account_acheck.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool notconnected = false;
  bool passwordnotnull = false;
  final _formKey = GlobalKey<FormState>();
  RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  @override
  void initState() {
    _emailController.text = 'user@test.com';
    _passwordController.text = 'sami12346';
    super.initState();
    Auth.isauthenticated = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios))
                  ],
                ),
                const Text(
                  "Connexion",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: defaultPadding * 2),
                Row(
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 8,
                      child: Image.asset("assets/icons/Login_Salat.png"),
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: defaultPadding * 2),
                Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          controller: _emailController,
                          cursorColor: kPrimaryColor,
                          onSaved: (email) {},
                          decoration: InputDecoration(
                            hintText: "Adresse email",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: Icon(Icons.person),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrez votre adresse email !';
                            } else if (!emailValid.hasMatch(value)) {
                              return 'Entrez une adresse email valide!';
                            } else if (notconnected == false) {
                              return 'Email ou mot de passe invalide';
                            }
        
                            return null;
                          },
                        ),
                        // TextFormField(
                        //   controller: _emailController,
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please enter a valid email';
                        //     }
                        //     return null;
                        //   },
                        // ),
        
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding),
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
                                return 'Entrez votre mot de passe';
                              }
                              return null;
                            },
                          ),
                        ),
                        // TextFormField(
                        //   controller: _passwordController,
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please enter a valid password';
                        //     }
                        //     return null;
                        //   },
                        // ),
        
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ForgotPassword();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "Mot de pass oublié ?",
                              style: const TextStyle(color: kPrimaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        Hero(
                          tag: "login_btn",
                          child: ElevatedButton(
                            onPressed: () {
                              Map creds = {
                                'email': _emailController.text,
                                'password': _passwordController.text,
                                'device_name': "mobile",
                              };
                              Provider.of<Auth>(context, listen: false)
                                  .login(creds: creds);
                              if (Auth.isauthenticated == true) {
                                setState(() {
                                  notconnected = true;
                                });
                              }
        
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "Se connecter".toUpperCase(),
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        AlreadyHaveAnAccountCheck(
                          press: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignUpScreen();
                                },
                              ),
                            );
                          },
                        ),
        
                        // TextButton(
                        //   style: TextButton.styleFrom(
                        //     primary: Colors.blue,
                        //   ),
                        //   child: Text('Login'),
                        //   onPressed: () {
                        //     Map creds = {
                        //       'email': _emailController.text,
                        //       'password': _passwordController.text,
                        //       'device_name': "mobile",
                        //     };
                        //     // Validate returns true if the form is valid, or false otherwise.
                        //     if (_formKey.currentState!.validate()) {
                        //       // If the form is valid, display a snackbar. In the real world,
                        //       // you'd often call a server or save the information in a database.
                        //       // ScaffoldMessenger.of(context).showSnackBar(
                        //       //   const SnackBar(content: Text('Processing Data')),
                        //       // );
        
                        //       Provider.of<Auth>(context, listen: false)
                        //           .login(creds: creds);
                        //       Navigator.pop(context);
                        //     }
                        //   },
                        // )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
