import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fatwa/Screens/Login/components/ForgotPassword/forgot_password_form.dart';
import 'package:fatwa/Screens/Login/components/ForgotPassword/forgot_password_topimage.dart';
import 'package:fatwa/responsive.dart';

import 'new_password_form.dart';

class NewPassword extends StatelessWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Responsive(
              mobile: const MobileLoginScreen(),
              desktop: Row(
                children: [
                  const Expanded(
                    child: ForgotPasswordTopImage(),
                  ),
                  NewPasswordForm(),
    
                ],
              ),
            ),
          ),
        ),
    );
    
  }
}


class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const ForgotPasswordTopImage(),
          Row(
            children:  const [
              Spacer(),
              Expanded(
                flex: 8,
                child: NewPasswordForm(),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}