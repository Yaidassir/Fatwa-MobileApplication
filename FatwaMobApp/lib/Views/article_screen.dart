// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:fatwa/models/Comment.dart';
import 'package:fatwa/models/Note.dart';
import 'package:fatwa/models/Post.dart';
import 'package:fatwa/Views/articles_screen.dart';
import 'package:fatwa/Views/imam_screen.dart';
import 'package:fatwa/Views/networkPlayerWidget.dart';
import 'package:fatwa/Views/profil_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fatwa/services/http.dart' as hp;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:expandable/expandable.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import '../Dimensions.dart';
import '../Screens/AppbarLike.dart';
import '../services/auth.dart';

class ArticleScreen extends StatefulWidget {
  ArticleScreen({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final audioPlayer = AudioPlayer();

  Duration duration = Duration.zero;

  Duration position = Duration.zero;

  bool isPlaying = false;

  bool showRapportForm = false;
  bool audioVisible = false;

  double value = 0;
  bool commentsshown = false;

  TextEditingController _rapportController = TextEditingController();

  TextEditingController _commentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formCommentKey = GlobalKey<FormState>();

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));

    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  List comm = ['test', 'test', 'test'];

  final storage = new FlutterSecureStorage();

  void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryToken(token: token);
  }

  Future<void> sendRapport({Map? infos}) async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/create_post_rapportAPI'),
      body: infos,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
  }

  Future<void> postComment({Map? infos}) async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/post_comment'),
      body: infos,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
  }

  Future<void> postNote({Map? infos}) async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/rateAPI'),
      body: infos,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
  }

  Future<void> deleteComment({Map? infos}) async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/delete_comment'),
      body: infos,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
  }

  void deletePost() async {
    String? token = await storage.read(key: 'token');
    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/delete_postAPI'),
      body: {
        'query': widget.post.id.toString(),
      },
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
  }

  List<Comment>? comments;
  var isLoaded = false;

  Future<List<Comment>?> getComments(Map infos) async {
    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/show_comments'),
      body: infos,
    );
    if (response.statusCode == 200) {
      var json = response.body;
      comments = commentFromJson(json);
      if (comments != null) {
        setState(() {
          isLoaded = true;
        });
      }
    }
  }

  Note? note;

  var isLoadednote = false;
  Future<Note?> getNote(Map infos) async {
    String? token = await storage.read(key: 'token');

    var client = http.Client();

    final response = await client.post(
      hp.ApiUrl('/getNoteAPI'),
      body: infos,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var json = response.body;
      if (response.body.isNotEmpty) {
        note = noteFromJson(json);
      }

      print(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    _rapportController.text = "";
    _commentController.text = "";
    readToken();
    Map infos = {
      'post_id': widget.post.id.toString(),
    };

    getComments(infos);

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  // // Future setAudio() async {
  // //   audioPlayer.setReleaseMode(ReleaseMode.loop);

  // //   UrlSource src = UrlSource(widget.post.contenuAudio.toString());

  // //   String url =
  // //       'https://www.applesaucekids.com/sound%20effects/baby%20sounds.mp3';
  // //   audioPlayer.setSourceUrl(src.url);
  // // }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.green[700],
      //   title: Text('Article'),
      // ),

      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());

        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(Dimensions.height10),
                  child: appbarlike(text: widget.post.title.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ImamScreen(id: widget.post.userId)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      new BorderRadius.all(Radius.circular(50))),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(widget.post.avatar),
                              ),
                            ),
                            SizedBox(
                              width: Dimensions.width10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.imam_name,
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.post.createdAt.toString().substring(0,10),
                                  style:
                                      TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                            Consumer<Auth>(builder: (context, auth, child) {
                              if (auth.authenticated) {
                                if (auth.user.id == widget.post.userId) {
                                  return IconButton(
                                      onPressed: () {
                                        deletePost();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ArticlesScreen()));
                                      },
                                      icon: Icon(Icons.delete),
                                      color: Colors.red);
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            })
                          ],
                        ),
                      ),
                      Consumer<Auth>(builder: (context, auth, child) {
                        if (auth.authenticated &&
                            auth.user.usertype == 0 &&
                            auth.user.etatcompte == 0) {
                          return PopupMenuButton(
                            itemBuilder: (context) => [
                              // popupmenu item 1
                              PopupMenuItem(
                                onTap: () {
                                  Future.delayed(
                                      Duration(seconds: 0),
                                      () => showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Votre rapport'),
                                              content: TextField(
                                                controller: _rapportController,
                                                autofocus: true,
                                                maxLines: 4,
                                                decoration: InputDecoration(
                                                  fillColor: Colors.grey[300],
                                                  hintText:
                                                      'Entrez votre rapport!',
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Map infos = {
                                                        'sender_id': auth.user.id
                                                            .toString(),
                                                        'motif':
                                                            _rapportController
                                                                .text,
                                                        'post_id': widget.post.id
                                                            .toString()
                                                      };
      
                                                      sendRapport(infos: infos);
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  super.widget));
                                                    },
                                                    child: Text(
                                                      'Envoyer',
                                                      style:
                                                          TextStyle(fontSize: 16),
                                                    ))
                                              ],
                                            ),
                                          ));
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.report),
                                    SizedBox(
                                      // sized box with width 10
                                      width: 10,
                                    ),
                                    Text("Rapport")
                                  ],
                                ),
                              ),
                            ],
                            offset: Offset(-10, 45),
                            color: Colors.white,
                            elevation: 2,
                          );
                        } else {
                          return Container();
                        }
                      }),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey,
                  indent: 40,
                  endIndent: 40,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sujet',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      Text(widget.post.title.toString()),
                    ],
                  ),
                ),
                widget.post.contenuText.toString().length > 400
                    ? ExpandableNotifier(
                        child: Column(
                          children: [
                            Expandable(
                              collapsed: ExpandableButton(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.orange[300],
                                  ),
                                  width: double.maxFinite,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Contenu',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white)),
                                        SizedBox(
                                          height: Dimensions.height10,
                                        ),
                                        Text(
                                          widget.post.contenuText
                                                  .toString()
                                                  .substring(1, 400) +
                                              '........',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        // Text('...'),
                                        SizedBox(
                                          height: Dimensions.height10,
                                        ),
                                        Center(
                                            child: Icon(
                                          Icons.arrow_circle_down_outlined,
                                          color: Colors.white,
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              expanded: Column(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.orange[300],
                                  ),
                                  width: double.maxFinite,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Content',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white)),
                                        SizedBox(
                                          height: Dimensions.height10,
                                        ),
                                        Text(
                                          widget.post.contenuText.toString(),
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ExpandableButton(
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Color.fromARGB(255, 227, 248, 255),
                                    ),
                                    child: Icon(
                                      Icons.keyboard_double_arrow_up,
                                      size: 24,
                                      color: Color(0xFF756d54),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.orange[300],
                        ),
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Contenu',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white)),
                              SizedBox(
                                height: Dimensions.height10,
                              ),
                              Text(
                                widget.post.contenuText.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: Dimensions.height10,
                              ),
                            ],
                          ),
                        ),
                      ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(
                      top: Dimensions.height10, bottom: Dimensions.height20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    color: Colors.grey[300],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      widget.post.contenuImage != null
                          ? IconButton(
                              icon: Icon(Icons.image),
                              onPressed: () {
                                showImageViewer(
                                    context,
                                    Image.network(
                                            widget.post.contenuImage.toString())
                                        .image,
                                    swipeDismissible: true);
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.image_not_supported),
                              onPressed: () {},
                            ),
                      widget.post.contenuVideo != null
                          ? IconButton(
                              icon: Icon(Icons.video_collection_rounded),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NetworkPlayerWidget(
                                          video:
                                              widget.post.contenuVideo.toString(),
                                        )));
                              },
                            )
                          : IconButton(
                              onPressed: () {}, icon: Icon(Icons.videocam_off)),
                      widget.post.contenuAudio != null
                          ? IconButton(
                              icon: Icon(Icons.headset),
                              onPressed: () {
                                setState(() {
                                  audioVisible = !audioVisible;
                                });
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.headset_off),
                              onPressed: () {},
                            ),
                    ],
                  ),
                ),
                Visibility(
                  visible: audioVisible,
                  child: Column(
                    children: [
                      Slider(
                          activeColor: Color.fromARGB(255, 96, 192, 99),
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final position = Duration(seconds: value.toInt());
                            await audioPlayer.seek(position);
      
                            await audioPlayer.resume();
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formatTime(position)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70.0),
                            child: CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 96, 192, 99),
                              radius: 25,
                              child: IconButton(
                                color: Colors.white,
                                icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                ),
                                iconSize: 35,
                                onPressed: () async {
                                  if (isPlaying) {
                                    await audioPlayer.pause();
                                  } else {
                                    UrlSource src = UrlSource(
                                        widget.post.contenuAudio.toString());
                                    await audioPlayer.play(src);
                                  }
                                },
                              ),
                            ),
                          ),
                          Text(formatTime(duration - position)),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      commentsshown = !commentsshown;
                    });
                  },
                  child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        color: Colors.grey[300],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                              'assets/icons/comment-svgrepo-com.svg'),
                          SizedBox(
                            width: Dimensions.width10,
                          ),
                          Text(
                            "Commentaires",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                Visibility(
                  visible: commentsshown,
                  child: Visibility(
                    visible: isLoaded,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: comments?.length,
                      itemBuilder: (context, index) {
                        // return Text('test');
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height10,
                              horizontal: Dimensions.width10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                              comments![index].avatar)),
                                      SizedBox(
                                        width: Dimensions.width10,
                                      ),
                                      Text(comments![index].username),
                                        Consumer<Auth>(builder:
                                                      (context, auth, child) {
                                                    if (auth.authenticated) {
                                                      if (auth.user.id ==
                                                          comments![index]
                                                              .userId) {
                                                        return IconButton(
                                                            onPressed: () {
                                                              Map infos = {
                                                                'id': comments![
                                                                        index]
                                                                    .id
                                                                    .toString()
                                                              };
      
                                                              deleteComment(
                                                                  infos: infos);
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          super
                                                                              .widget));
                                                            },
                                                            color: Colors.red,
                                                            icon: Icon(
                                                              Icons.delete,
                                                            ));
                                                      } else {
                                                        return Container();
                                                      }
                                                    } else {
                                                      return Container();
                                                    }
                                                  }),
                                      SizedBox(
                                        width: Dimensions.width10,
                                      ),
                                      Expanded(
                                        child: Divider(
                                          height: 2,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dimensions.height20,
                                  ),
                                  Text(comments![index].contenu),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    replacement: CircularProgressIndicator(),
                  ),
                ),
                Consumer<Auth>(builder: (context, auth, child) {
                  if (auth.authenticated && auth.user.etatcompte == 0) {
                    return Visibility(
                      visible: commentsshown,
                      child: Form(
                        key: _formCommentKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              indent: 20,
                              endIndent: 20,
                              height: 1,
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _commentController,
                              autofocus: true,
                              decoration: InputDecoration(
                                fillColor: Colors.grey[200],
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                    Map infos = {
                                      'user_id': auth.user.id.toString(),
                                      'post_id': widget.post.id.toString(),
                                      'contenu': _commentController.text
                                    };
                                    if (_formCommentKey.currentState!
                                        .validate()) {
                                      postComment(infos: infos);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  super.widget));
                                    }
                                  },
                                ),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Consumer<Auth>(builder: (context, auth, child) {
                  if (auth.authenticated && auth.user.usertype == 0 && auth.user.etatcompte == 0) {
                    if (auth.user.id != widget.post.userId) {
                      getNote({
                        'user_id': auth.user.id.toString(),
                        'post_id': widget.post.id.toString()
                      });
                      return Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Noter',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Divider(
                                  indent: 20,
                                  endIndent: 20,
                                  height: 2,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Dimensions.height10,
                          ),
                          auth.user.id == widget.post.userId
                              ? Container()
                              : note?.note != null
                                  ? Container(
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.grey[300]),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Center(
                                          child: RatingBar.builder(
                                            initialRating: note!.note.toDouble(),
                                            itemSize: 30,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              Map infos = {
                                                'user_id':
                                                    auth.user.id.toString(),
                                                'post_id':
                                                    widget.post.id.toString(),
                                                'note': rating.toString()
                                              };
      
                                              postNote(infos: infos);
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.grey[300]),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Center(
                                          child: RatingBar.builder(
                                            initialRating: 0,
                                            minRating: 1,
                                            itemSize: 30,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              Map infos = {
                                                'user_id':
                                                    auth.user.id.toString(),
                                                'post_id':
                                                    widget.post.id.toString(),
                                                'note': rating.toString()
                                              };
      
                                              postNote(infos: infos);
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                        ],
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
//         body: SingleChildScrollView(
//             child: Column(children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, top: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Consumer<Auth>(builder: (context, auth, child) {
//                           if (auth.authenticated &&
//                               auth.user.id == widget.post.userId) {
//                             return GestureDetector(
//                               onTap: () {
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) =>
//                                         ProfilScreen(userId: auth.user.id.toString())));
//                               },
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   CircleAvatar(
//                                     backgroundImage:
//                                         NetworkImage(widget.post.avatar),
//                                     radius: 25,
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text(
//                                     widget.post.imam_name.toString(),
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.green[700]),
//                                   ),
//                                   SizedBox(
//                                     width: 20,
//                                   ),
//                                   widget.post.note.toString() == 'null'
//                                       ? Text('.../5')
//                                       : Text(widget.post.note
//                                               .toString()
//                                               .substring(0, 1) +
//                                           '/5'),
//                                   SizedBox(
//                                     width: 20,
//                                   ),
//                                   Consumer<Auth>(
//                                       builder: (context, auth, child) {
//                                     if (auth.authenticated) {
//                                       if (auth.user.id == widget.post.userId) {
//                                         return IconButton(
//                                             onPressed: () {
//                                               deletePost();
//                                               Navigator.of(context).push(
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           ArticlesScreen()));
//                                             },
//                                             icon: Icon(Icons.delete),
//                                             color: Colors.red);
//                                       } else {
//                                         return Container();
//                                       }
//                                     } else {
//                                       return Container();
//                                     }
//                                   })
//                                 ],
//                               ),
//                             );
//                           } else {
// return GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) =>
//                                     ImamScreen(id: widget.post.userId)));
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               CircleAvatar(
//                                 backgroundImage:
//                                     NetworkImage(widget.post.avatar),
//                                 radius: 25,
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Text(
//                                 widget.post.imam_name.toString(),
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.green[700]),
//                               ),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               widget.post.note.toString() == 'null'
//                                   ? Text('.../5')
//                                   : Text(widget.post.note
//                                           .toString()
//                                           .substring(0, 1) +
//                                       '/5'),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               Consumer<Auth>(builder: (context, auth, child) {
//                                 if (auth.authenticated) {
//                                   if (auth.user.id == widget.post.userId) {
//                                     return IconButton(
//                                         onPressed: () {
//                                           deletePost();
//                                           Navigator.of(context).push(
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       ArticlesScreen()));
//                                         },
//                                         icon: Icon(Icons.delete),
//                                         color: Colors.red);
//                                   } else {
//                                     return Container();
//                                   }
//                                 } else {
//                                   return Container();
//                                 }
//                               })
//                             ],
//                           ),
//                         );                          }
//                         }),

//                         Text(
//                           widget.post.title.toString(),
//                           style: TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                         if (widget.post.typepost == 1) Text('hadith'),
//                         if (widget.post.typepost == 2) Text('dars'),
//                         if (widget.post.typepost == 3) Text('khoutba'),
//                         Text(widget.post.createdAt.toString()),
//                         SizedBox(
//                           height: 30,
//                         ),
//                         Consumer<Auth>(builder: (context, auth, child) {
//                           if (auth.authenticated && auth.user.etatcompte==0) {
//                             if (auth.user.id != widget.post.userId) {
//                               getNote({
//                                 'user_id': auth.user.id.toString(),
//                                 'post_id': widget.post.id.toString()
//                               });
//                               return Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       ElevatedButton(
//                                           onPressed: () {
//                                             setState(() {
//                                               showRapportForm =
//                                                   !showRapportForm;
//                                             });
//                                           },
//                                           child: Text('Signaler le post'))
//                                     ],
//                                   ),
//                                   Visibility(
//                                       visible: showRapportForm,
//                                       child: SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width -
//                                                 100,
//                                         child: Form(
//                                             key: _formKey,
//                                             child: Column(
//                                               children: [
//                                                 TextFormField(
//                                                   controller:
//                                                       _rapportController,
//                                                   decoration: InputDecoration(
//                                                     labelText:
//                                                         "Motif du rapport",
//                                                   ),
//                                                 ),
//                                                 TextButton(
//                                                   style: TextButton.styleFrom(
//                                                     primary: Colors.blue,
//                                                   ),
//                                                   child: Text('Envoyer'),
//                                                   onPressed: () {
//                                                     Map infos = {
//                                                       'sender_id': auth.user.id
//                                                           .toString(),
//                                                       'motif':
//                                                           _rapportController
//                                                               .text,
//                                                       'post_id': widget.post.id
//                                                           .toString()
//                                                     };
//                                                     if (_formKey.currentState!
//                                                         .validate()) {
//                                                       sendRapport(infos: infos);
//                                                       Navigator.pushReplacement(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                               builder: (BuildContext
//                                                                       context) =>
//                                                                   super
//                                                                       .widget));
//                                                     }
//                                                   },
//                                                 )
//                                               ],
//                                             )),
//                                       )),
//                                 ],
//                               );
//                             } else {
//                               return Container();
//                             }
//                           } else {
//                             return Container();
//                           }
//                         }),
//                         widget.post.contenuText != null
//                             ? Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Flexible(
//                                     child: Text(
//                                         widget.post.contenuText.toString())),
//                               )
//                             : Container(),
//                         widget.post.contenuImage != null
//                             ? Image.network(
//                                 width: 300, widget.post.contenuImage.toString())
//                             : Text('no image'),
//                         widget.post.contenuAudio != null
//                             ? Column(
//                                 children: [
//                                   Slider(
//                                       min: 0,
//                                       max: duration.inSeconds.toDouble(),
//                                       value: position.inSeconds.toDouble(),
//                                       onChanged: (value) async {
//                                         final position =
//                                             Duration(seconds: value.toInt());
//                                         await audioPlayer.seek(position);

//                                         await audioPlayer.resume();
//                                       }),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 16),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(formatTime(position)),
//                                         SizedBox(
//                                           width: 60,
//                                         ),
//                                         Text(formatTime(duration - position)),
//                                         SizedBox(
//                                           height: 30,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   CircleAvatar(
//                                     radius: 25,
//                                     child: IconButton(
//                                       icon: Icon(
//                                         isPlaying
//                                             ? Icons.pause
//                                             : Icons.play_arrow,
//                                       ),
//                                       iconSize: 35,
//                                       onPressed: () async {
//                                         if (isPlaying) {
//                                           await audioPlayer.pause();
//                                         } else {
//                                           UrlSource src = UrlSource(widget
//                                               .post.contenuAudio
//                                               .toString());
//                                           await audioPlayer.play(src);
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : Container(),
//                         widget.post.contenuVideo != null
//                             ? Column(
//                                 children: [
//                                   SizedBox(
//                                     height: 50,
//                                   ),
//                                   CircleAvatar(
//                                     radius: 25,
//                                     child: IconButton(
//                                       icon: Icon(
//                                         Icons.play_circle_fill_sharp,
//                                       ),
//                                       iconSize: 35,
//                                       onPressed: () {
//                                         Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     NetworkPlayerWidget(
//                                                       video: widget
//                                                           .post.contenuVideo
//                                                           .toString(),
//                                                     )));
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : Container(),
//                         Consumer<Auth>(builder: (context, auth, child) {
//                           if (auth.authenticated && auth.user.etatcompte==0 ) {
//                             return SizedBox(
//                               height: 150,
//                               width: MediaQuery.of(context).size.width - 40,
//                               child: Form(
//                                   key: _formCommentKey,
//                                   child: Column(
//                                     children: [
//                                       TextFormField(
//                                         controller: _commentController,
//                                         decoration: InputDecoration(
//                                           labelText:
//                                               "Entrez votre commentaire!",
//                                         ),
//                                       ),
//                                       TextButton(
//                                         style: TextButton.styleFrom(
//                                           primary: Colors.blue,
//                                         ),
//                                         child: Text('Commenter'),
//                                         onPressed: () {
//                                           Map infos = {
//                                             'user_id': auth.user.id.toString(),
//                                             'post_id':
//                                                 widget.post.id.toString(),
//                                             'contenu': _commentController.text
//                                           };
//                                           if (_formCommentKey.currentState!
//                                               .validate()) {
//                                             postComment(infos: infos);
//                                             Navigator.pushReplacement(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (BuildContext
//                                                             context) =>
//                                                         super.widget));
//                                           }
//                                         },
//                                       ),
//                                       auth.user.id == widget.post.userId
//                                           ? Container()
//                                           : note?.note != null
//                                               ? RatingBar.builder(
//                                                   initialRating:
//                                                       note!.note.toDouble(),
//                                                   // initialRating: 0,
//                                                   minRating: 1,
//                                                   direction: Axis.horizontal,
//                                                   allowHalfRating: false,
//                                                   itemCount: 5,
//                                                   itemPadding:
//                                                       EdgeInsets.symmetric(
//                                                           horizontal: 4.0),
//                                                   itemBuilder: (context, _) =>
//                                                       Icon(
//                                                     Icons.star,
//                                                     color: Colors.amber,
//                                                   ),
//                                                   onRatingUpdate: (rating) {
//                                                     Map infos = {
//                                                       'user_id': auth.user.id
//                                                           .toString(),
//                                                       'post_id': widget.post.id
//                                                           .toString(),
//                                                       'note': rating.toString()
//                                                     };

//                                                     postNote(infos: infos);
//                                                   },
//                                                 )
//                                               : RatingBar.builder(
//                                                   initialRating: 0,
//                                                   minRating: 1,
//                                                   direction: Axis.horizontal,
//                                                   allowHalfRating: false,
//                                                   itemCount: 5,
//                                                   itemPadding:
//                                                       EdgeInsets.symmetric(
//                                                           horizontal: 4.0),
//                                                   itemBuilder: (context, _) =>
//                                                       Icon(
//                                                     Icons.star,
//                                                     color: Colors.amber,
//                                                   ),
//                                                   onRatingUpdate: (rating) {
//                                                     Map infos = {
//                                                       'user_id': auth.user.id
//                                                           .toString(),
//                                                       'post_id': widget.post.id
//                                                           .toString(),
//                                                       'note': rating.toString()
//                                                     };

//                                                     postNote(infos: infos);
//                                                   },
//                                                 )
//                                     ],
//                                   )),
//                             );
//                           } else {
//                             return Container();
//                           }
//                         }),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Commentaires',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 24),
//                             ),
//                           ],
//                         ),
//                         Container(
//                           height: double.maxFinite,
//                           width: MediaQuery.of(context).size.width - 30,
//                           child: Visibility(
//                             visible: isLoaded,
//                             child: ListView.builder(
//                                 scrollDirection: Axis.vertical,
//                                 shrinkWrap: true,
//                                 itemCount: comments?.length,
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Card(
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceAround,
//                                               children: [
//                                                 CircleAvatar(
//                                                   backgroundImage: NetworkImage(
//                                                       comments![index].avatar),
//                                                   radius: 25,
//                                                 ),
//                                                 Text(comments![index].username),
//                                                 Consumer<Auth>(builder:
//                                                     (context, auth, child) {
//                                                   if (auth.authenticated) {
//                                                     if (auth.user.id ==
//                                                         comments![index]
//                                                             .userId) {
//                                                       return IconButton(
//                                                           onPressed: () {
//                                                             Map infos = {
//                                                               'id': comments![
//                                                                       index]
//                                                                   .id
//                                                                   .toString()
//                                                             };

//                                                             deleteComment(
//                                                                 infos: infos);
//                                                             Navigator.pushReplacement(
//                                                                 context,
//                                                                 MaterialPageRoute(
//                                                                     builder: (BuildContext
//                                                                             context) =>
//                                                                         super
//                                                                             .widget));
//                                                           },
//                                                           color: Colors.red,
//                                                           icon: Icon(
//                                                             Icons.delete,
//                                                           ));
//                                                     } else {
//                                                       return Container();
//                                                     }
//                                                   } else {
//                                                     return Container();
//                                                   }
//                                                 })
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(comments![index].contenu),
//                                               ],
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                               children: [
//                                                 Text(comments![index]
//                                                     .createdAt
//                                                     .toString()),
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                             replacement: Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ]))
    );
  }
}

// Column Commentbox() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Divider(
//         indent: 20,
//         endIndent: 20,
//         height: 1,
//         color: Colors.grey[300],
//         thickness: 1,
//       ),
//       const SizedBox(height: 10),
//       TextFormField(
//         // controller: controller,
//         autofocus: true,
//         decoration: InputDecoration(
//           fillColor: Colors.grey[200],
//           suffixIcon: IconButton(
//             icon: Icon(Icons.send),
//             onPressed: () {},
//             // onPressed: (){
//             //     setState(() {
//             //       comments.add(controller.text);
//             //     });

//             //     controller.clear();
//             // },
//           ),
//           filled: true,
//           border: OutlineInputBorder(
//             borderSide: BorderSide.none,
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//       ),
//     ],
//   );
// }
