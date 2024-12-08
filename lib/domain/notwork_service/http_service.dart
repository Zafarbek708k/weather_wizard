import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class HttpClientService {
  static const String baseUrl = "https://65c717aae7c384aada6e2dae.mockapi.io";
  static const String apiLocation = "/location";

  static const HttpClientService service = HttpClientService._internal();

  const HttpClientService._internal();

  factory HttpClientService() {
    return service;
  }

  static Future<String?> getData({required String api}) async {
    HttpClient httpClient = HttpClient();
    Uri url = Uri.parse("$baseUrl/$api");
    HttpClientRequest request = await httpClient.getUrl(url);
    HttpClientResponse response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      String result = await response.transform(utf8.decoder).join();
      httpClient.close();
      log("HttpClient response: $result");
      return result;
    } else {
      return null;
    }
  }

  static Future<String?> post({required String api, required Map<String, Object?> data}) async {

    // dart io kutubxonasidagi HttpClient classidan object olinayabdi
    HttpClient httpClient = HttpClient();

    // url yasab olinayabdi
    Uri url = Uri.parse('$baseUrl/$api');

    // get methodi orqali so'rov jo'natilayabdi
    HttpClientRequest request = await httpClient.postUrl(url);

    // headers qo'shilayabdi
    request.headers.set('Content-Type', 'application/json');

    //  Map data avval string formatga keyin esa utf8 characterga o'tib requestga qo'shilayabdi
    request.add(utf8.encode(jsonEncode(data)));

    // jo'natilgan so'rov close qilib yopilayabdi
    HttpClientResponse response = await request.close();

    // tekshirilayabdi agar ok bo'lsa response body qaytarilayabdi
    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {

      String responseBody = await response.transform(utf8.decoder).join();

      httpClient.close();

      return responseBody;

      // throw exception
    } else {
      httpClient.close();
      throw Exception('Failed to load data');
    }

  }

  static Future<String?> deleteData({required String api, required String id}) async {
    HttpClient client = HttpClient();
    Uri url = Uri.parse("$baseUrl/$api/$id");
    HttpClientRequest request = await client.deleteUrl(url);
    HttpClientResponse response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      String responseBody = await response.transform(utf8.decoder).join();
      return responseBody;
    } else {
      return null;
    }
  }
}
