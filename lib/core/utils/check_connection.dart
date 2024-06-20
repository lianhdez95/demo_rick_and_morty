import 'package:dio/dio.dart';

Future<bool> isConnected() async {
  var dio = Dio();
  try {
    await dio.get('https://rickandmortyapi.com/api/character');
    return true; // connected to internet
  } catch (e) {
    return false; // not connected to internet
  }
}