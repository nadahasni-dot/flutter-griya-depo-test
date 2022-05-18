import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../constants/api_endpoint.dart';
import 'custom_exception.dart';

class NetworkService {
  static Map<String, String> headers = {
    'token': 'BLUADlWbOVj78VFX',
    'device': 'test_device'
  };

  static dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 201:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body);
      case 401:
        throw UnauthorisedException(response.body);
      case 409:
        throw ConflictException(response.body);
      case 404:
        throw NotFoundException(response.body);
      case 500:
        throw InternalServerErrorException(response.body);

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  static Future<dynamic> get(
      String url, Map<String, String>? queryParameters) async {
    final uri = Uri.http(ApiEndpoint.baseUrl, url, queryParameters);

    log('GET: ${uri.toString()}');
    log('PARAMS: ${queryParameters.toString()}');

    try {
      late dynamic response;

      response = await http.get(uri, headers: headers);

      return _response(response);
    } on SocketException {
      throw FetchDataException('Tidak ada koneksi internet');
    } on FormatException {
      throw const FormatException('unauthorized');
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> post(String url, Map<String, String> data) async {
    var uri = Uri.http(ApiEndpoint.baseUrl, url);

    log('POST: ${uri.toString()}');
    log('DATA: ${data.toString()}');

    try {
      final response = await http.post(uri, body: data, headers: headers);
      return _response(response);
    } on SocketException {
      throw FetchDataException('Tidak ada koneksi internet');
    } on NotFoundException {
      throw NotFoundException('Akun tidak terdaftar');
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> postWithImages(
      String url, Map<String, String> data, List<File> pictures) async {
    try {
      var uri = Uri.http(ApiEndpoint.baseUrl, url);
      log(uri.toString(), name: 'POST WITH IMAGES');
      log(data.toString(), name: 'POST WITH IMAGES');

      var request = http.MultipartRequest('POST', uri);

      Map<String, String> customHeaders = {
        "Content-type": "multipart/form-data"
      };
      customHeaders.addAll(headers);

      for (var element in pictures) {
        if (element.path.isNotEmpty) {
          request.files.add(
            http.MultipartFile(
              'file',
              element.readAsBytes().asStream(),
              element.lengthSync(),
              filename: 'foto_pengaduan.jpeg',
              contentType: MediaType(
                'image',
                'jpeg',
              ),
            ),
          );
        }
      }

      request.headers.addAll(customHeaders);
      request.fields.addAll(data);

      var res = await request.send();
      final response = await http.Response.fromStream(res);
      return _response(response);
    } on SocketException {
      throw FetchDataException('Tidak ada koneksi internet');
    }
  }
}
