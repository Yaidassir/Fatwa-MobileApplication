import 'dart:io';
import 'package:fatwa/Views/articles_screen.dart';
import 'package:fatwa/Views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:fatwa/services/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../Dimensions.dart';
import '../Screens/HomePage/Home_Fatwa/Home_Fatwa.dart';
import '../services/auth.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();

  bool ProgressVisible = false;
  bool ajoutVisible = true;

  String selecteddropdownvalue = '1';
  String dropdownvalue = 'Hadith';
  var items = [
    'Hadith',
    'Dars',
    'Khoutba',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  File? image;
  late Dio.FormData formData;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  File? video;
  Future pickVideo() async {
    try {
      final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (video == null) return;

      final videoTemporary = File(video.path);

      setState(() {
        this.video = videoTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void pickAudio() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'mp3',
      ],
    );

    if (result != null) {
      _fileName = result!.files.first.name;
      pickedFile = result!.files.first;
      fileToDisplay = File(pickedFile!.path.toString());
    }
  }

  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedFile;
  bool isLoading = false;
  File? fileToDisplay;
  int progress = 0;
  int total = 0;

  void addPost(Dio.FormData data) async {
    String? token = await storage.read(key: 'token');

    Dio.Response response = await dio().post('/create_postAPI', data: data,
        onSendProgress: (int sent, int max) {
      setState(() {
        progress = (sent * 100 / max).toInt();
        total = max;
      });
    },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $token'},
          followRedirects: false,
          validateStatus: (status) => true,
        ));

    if (response.statusCode == 200) {
      setState(() {
        isLoading = true;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Visibility(
                  visible: ajoutVisible,
                  child: Column(
                    children: [
                        Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    gradient: LinearGradient(colors: [
                                      Color.fromARGB(255, 96, 192, 99),
                                      Color.fromARGB(255, 1, 162, 184)
                                    ]),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Expanded(
                                        child: ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.only(left:20.0),
                                        child: Text('Publier un article',style: TextStyle(color: Colors.white,fontSize: 26,fontWeight:FontWeight.bold)),
                                      ),
                                      leading: IconButton(
                                        icon: Icon(Icons.arrow_back_ios,
                                            color: Colors.white, size: 35),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Titre',
                              hintText: 'Le titre ..',
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            validator:(value){
                              if (value == null || value.isEmpty) {
                                return 'Veuillez remplir ce champ !';
                              } 
                              return null;
                            }
        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            isExpanded: true,
                            value: dropdownvalue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                                switch (dropdownvalue) {
                                  case 'Hadith':
                                    {
                                      selecteddropdownvalue = '1';
                                    }
                                    break;

                                  case 'Dars':
                                    {
                                      selecteddropdownvalue = '2';
                                    }
                                    break;

                                  case 'Khoutba':
                                    {
                                      selecteddropdownvalue = '3';
                                    }
                                    break;
                                  default:
                                    {
                                      selecteddropdownvalue = '1';
                                    }
                                    break;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Text(
                        "Contenu",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextFormField(
                            controller: _contentController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: 'Votre contenu ...',
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            validator:(value){
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ !';
                            } 
                            return null;
                          }
        ),
                      ),
                      SizedBox(height: Dimensions.height10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildButton(
                            title: 'Publier une photo',
                            icon: Icons.image_outlined,
                            onClicked: () async {
                              pickImage();
                            }),
                      ),
                      SizedBox(height: Dimensions.height10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildButton(
                            title: 'Publier une video',
                            icon: Icons.video_call,
                            onClicked: () async {
                              pickVideo();
                            }),
                      ),
                      SizedBox(height: Dimensions.height10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildButton(
                            title: 'Publier un audio',
                            icon: Icons.audio_file,
                            onClicked: () async {
                              pickAudio();
                            }),
                      ),
                      SizedBox(height: Dimensions.height10),
                      Consumer<Auth>(builder: (context, auth, child) {
                        if (auth.authenticated) {
                          return Container(
                            width: 200,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.green, Colors.cyan]),
                                borderRadius: BorderRadius.circular(25)),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: Text(
                                'Publier',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              onPressed: () async {
                                
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                  ProgressVisible = true;
                                  ajoutVisible = false;
                                });
                                Dio.FormData formData = Dio.FormData.fromMap({
                                  'title': _titleController.text,
                                  'typepost': selecteddropdownvalue,
                                  'user_id': auth.user.id.toString(),
                                  'contenu_text': _contentController.text,
                                  'contenu_image': image == null
                                      ? null
                                      : await Dio.MultipartFile.fromFile(
                                          image!.path),
                                  'contenu_video': video == null
                                      ? null
                                      : await Dio.MultipartFile.fromFile(
                                          video!.path),
                                  'contenu_audio': fileToDisplay == null
                                      ? null
                                      : await Dio.MultipartFile.fromFile(
                                          fileToDisplay!.path.toString()),
                                });
                                  addPost(formData);
                                }
                              },
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                    ],
                  ),
                ),
                Visibility(
                  visible: ProgressVisible,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 100),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: progress / 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(progress.toString() + '/100%'),
                        ),
                        progress == 100
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                                },
                                child: Text('Terminer'))
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

Widget buildButton(
        {required String title,
        required IconData icon,
        required VoidCallback onClicked}) =>
    ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          minimumSize: Size.fromHeight(56),
          primary: Colors.orange[300],
          onPrimary: Colors.white,
          textStyle: TextStyle(fontSize: 20),
        ),
        onPressed: onClicked,
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
            ),
            SizedBox(
              width: 16,
            ),
            Text(title),
          ],
        ));
