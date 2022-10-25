import 'package:fatwa/Views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fatwa/Dimensions.dart';
import 'package:fatwa/Screens/Profile/Componenets/Profile_pages/About/About.dart';
import 'package:fatwa/Screens/Profile/Componenets/Profile_pages/ChangePassword/change_password.dart';

import 'package:fatwa/Screens/Profile/Componenets/Profile_pages/NotificationSettings/NotificationsSettings.dart';
import 'package:provider/provider.dart';
import '../../../services/auth.dart';
import '../../HomePage/Home_Fatwa/Home_Fatwa.dart';
import 'Profile_pages/MyAccount/My_account_info.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20),
        child: Consumer<Auth>(builder: (context, auth, child) {
          if (auth.authenticated) {
            return Column(
              children: [
                PageTitle(pagetitle: "Profile"),
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
                  text: "My Account",
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
                // ProfileMenuNotification(
                //   text: "Notifications",
                //   icon: "assets/icons/Bell.svg",
                //   press: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) {
                //           return NotificationSettings();
                //         },
                //       ),
                //     );
                //   },
                // ),
                ProfileMenu(
                  text: "Change Password",
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
                  text: "Help Center",
                  icon: "assets/icons/Questionmark.svg",
                  press: () {},
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
                  text: "About",
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
                  text: "Log Out",
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
          } else {
            return Container();
          }
        }));
  }
}
