import 'package:fatwa/Screens/Profile/Componenets/Profile_pages/MyAccount/My_account_info.dart';
import 'package:fatwa/Screens/Profile/Componenets/profile_body.dart';
import 'package:fatwa/Screens/Profile/Profile.dart';
import 'package:fatwa/services/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as Dio;

class ProfilePic extends StatefulWidget {
  String avatar = '';
  ProfilePic({Key? key, required this.avatar}) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  final storage = new FlutterSecureStorage();

  File? image;

  Future pickImage() async {
    String? token = await storage.read(key: 'token');

    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      if (mounted) {
        setState(() {
          this.image = imageTemporary;
        });
      }

      Dio.FormData formData = Dio.FormData.fromMap(
          {"profil_picture": await Dio.MultipartFile.fromFile(image.path)});

      Dio.Response response = await dio().post('/changeProfilPicture',
          data: formData,
          options: Dio.Options(
            headers: {'Authorization': 'Bearer $token'},
            validateStatus: (status) => true,
          ));

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Myaccountinfo()));
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: <Widget>[
        Container(
          color: Colors.white,
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.avatar),
            radius: 70,
          ),
        ),
        Positioned(
          bottom: -10,
          right: -10,
          child: Container(
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Center(
              child: IconButton(
                  icon: Icon(Icons.camera_alt),
                  iconSize: 28,
                  color: Colors.grey,
                  onPressed: () async {
                    pickImage();
                  }),
            ),
          ),
        ),
      ]),
    );
    // return SizedBox(
    //   height: 115,
    //   width: 115,
    //   child: Stack(
    //     fit: StackFit.expand,
    //     clipBehavior: Clip.none,
    //     children: [
    //       CircleAvatar(
    //         backgroundImage: NetworkImage(avatar),
    //       ),
    //       Positioned(
    //         right: -16,
    //         bottom: 0,
    //         child: SizedBox(
    //           height: 46,
    //           width: 46,
    //           child: Padding(
    //             padding: const EdgeInsets.only(right:10.0,bottom: 6.0),
    //             child: IconButton(
    //               icon: Icon(Icons.camera_alt),
    //               onPressed: () {},
    //               color: Colors.grey,
    //             ),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
