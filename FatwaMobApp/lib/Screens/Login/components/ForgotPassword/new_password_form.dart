import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fatwa/constants.dart';

import '../../../Welcome/welcome_screen.dart';
import 'forgot_password_newpassword.dart';

class NewPasswordForm extends StatelessWidget {
  const NewPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Form(child: 
      Column(
        children: [
            Text('Re enter a new password for your account',style: TextStyle(color: Colors.grey),),
              SizedBox(height: defaultPadding,),
             TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "New Password",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock),
              ),
            ),
          ),
          SizedBox(height: defaultPadding,),
                       TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Re Enter Password",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock),
              ),
            ),
          ),
          SizedBox(height: defaultPadding,),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
               Navigator.pushReplacement( context, MaterialPageRoute(
                  builder: (context) {
                    return WelcomeScreen();
                  },
                ),
              );
              },
              child: Text(
                "Submit".toUpperCase(),
              ),
            ),
          ),
          
          

        ],
      )
      );
    
  }
}