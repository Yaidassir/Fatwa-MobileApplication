import 'package:fatwa/models/Alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:fatwa/services/http.dart' as hp;
import 'package:http/http.dart' as http;

import '../Dimensions.dart';
import '../Screens/HomePage/Home_Fatwa/Home_Fatwa.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<AlertScreen> createState() => AlertScreenState();
}

class AlertScreenState extends State<AlertScreen> {
  bool isLoading = false;
  List<Alert>? alerts;
  final storage = new FlutterSecureStorage();

  void getNotifications() async {
    String? token = await storage.read(key: 'token');

    final response =
        await http.post(hp.ApiUrl('/showAlerts'), body: {'query': widget.id});
    if (response.statusCode == 200) {
      var json = response.body;
      alerts = alertFromJson(json);
    }
    if (alerts != null) {
      setState(() {
        isLoading = true;
      });
    }
    print(alerts);
  }

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.green[700],
        //   title: Text('Notifications'),
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Padding(
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
                              child: Text('Notifications',style: TextStyle(color: Colors.white,fontSize: 26,fontWeight:FontWeight.bold)),
                            ),
                            leading: IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  color: Colors.white, size: 35),
                              onPressed: () =>
                              Navigator.pop(context),
                            ),
                          )),
                        ),
                      ),
                    ),
            ),              Visibility(
                visible: isLoading,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: alerts?.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  padding:
                                      EdgeInsets.only(left: Dimensions.width20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        alerts![index].title,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        alerts![index].contenu,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12.0),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            alerts![index].createdAt.toString(),
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.grey),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                replacement: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ));
  }
}
