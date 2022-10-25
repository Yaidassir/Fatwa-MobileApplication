import 'package:dio/dio.dart';

Dio dio(){

  Dio dio = new Dio();

  dio.options.baseUrl = "http://172.20.10.5:8000/api";
  dio.options.headers['accept'] = 'Application/Json';


  return dio;
}