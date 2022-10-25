import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fatwa/constants.dart';

import 'forgot_password_newpassword.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Form(child: 
      Column(
        children: [
            Text('Ne vous inquiétez pas, cela arrive. Veuillez saisir l\'adresse associée à votre compte.',style: TextStyle(color: Colors.grey),),
              SizedBox(height: defaultPadding,),
             TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Votre adresse email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          SizedBox(height: defaultPadding,),

          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
               Navigator.push( context, MaterialPageRoute(
                  builder: (context) {
                    return NewPassword();
                  },
                ),
              );
              },
              child: Text(
                "Envoyer".toUpperCase(),
              ),
            ),
          ),
          
          

        ],
      )
      );
    
  }
}