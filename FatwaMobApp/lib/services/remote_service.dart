import 'dart:io';

import 'package:fatwa/models/Follow.dart';

import 'package:http/http.dart' as http;

class RemoteService {
  // Future<List<Follow>?> getFollows() async {
  //   var client = http.Client();

  //   var uri = Uri.parse('http://172.20.10.5:8000/api/follows');

  //   var response = await client.get(uri);

  //   // final response = await client.get(
  //   //   Uri.parse('http://172.20.10.5:8000/api/follows'),
  //   //   // Send authorization headers to the backend.
  //   //   headers: {
  //   //     HttpHeaders.authorizationHeader: '106|9bjueJPIkbRBatWsD3E4vHTevH77x2ym7SL5eryk',
  //   //   },
  //   // );

  //   if (response.statusCode == 200) {
  //     var json = response.body;
  //     return followFromJson(json);
  //   }
  // }
}
