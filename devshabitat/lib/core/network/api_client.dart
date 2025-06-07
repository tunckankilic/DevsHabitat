import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../errors/failures.dart';

class ApiClient {
  final String baseUrl;

  ApiClient({this.baseUrl = ApiConstants.baseUrl});

  Future<http.Response> get(String path,
      {Map<String, String>? headers, Map<String, String>? params}) async {
    final uri = Uri.parse(baseUrl + path).replace(queryParameters: params);
    try {
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  Future<http.Response> post(String path,
      {Map<String, String>? headers,
      Object? body,
      Map<String, String>? params}) async {
    final uri = Uri.parse(baseUrl + path).replace(queryParameters: params);
    try {
      final response = await http.post(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  Future<http.Response> put(String path,
      {Map<String, String>? headers,
      Object? body,
      Map<String, String>? params}) async {
    final uri = Uri.parse(baseUrl + path).replace(queryParameters: params);
    try {
      final response = await http.put(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  Future<http.Response> delete(String path,
      {Map<String, String>? headers,
      Object? body,
      Map<String, String>? params}) async {
    final uri = Uri.parse(baseUrl + path).replace(queryParameters: params);
    try {
      final response = await http.delete(uri, headers: headers, body: body);
      return response;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
