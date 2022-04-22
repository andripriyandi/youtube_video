import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:network/model/tupple.dart';
import 'package:network/model/handle_failure.dart';
import 'package:network/model/tupple_handle_status.dart';
import 'package:network/model/response_object.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:network/internal_service/http_config.dart';

class GetDataApi {
  Random random = Random();

  Future<Tupple<HandleFailure, ResponseObject>> getdataAPI({
    required String baseUrl,
    required String endPoint,
    required Map<String, dynamic> nullSafety,
    required ResponseObject Function(Map<String, dynamic>) serializer,
  }) async {
    try {
      if (kDebugMode) print(baseUrl + endPoint);
      var responseResult = await TrustAllCertificates.getInstance
          .sslClient()
          .get(Uri.parse(baseUrl + endPoint));
      debugPrint(responseResult.body);

      var handleResponseStatus =
          handleResponseStatusCode(responseResult.statusCode);
      if (handleResponseStatus.status!) {
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer(
                jsonDecode(responseResult.body) as Map<String, dynamic>));
      } else {
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer(nullSafety));
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      return Tupple(
          handleFailure: HandleFailure(), onSuccess: serializer(nullSafety));
    }
  }

  Future<Tupple<HandleFailure, ResponseObject>> getdataAPIHeaders({
    required String baseUrl,
    required String endPoint,
    required Map<String, String> headers,
    required Map<String, dynamic> nullSafety,
    required ResponseObject Function(Map<String, dynamic>) serializer,
  }) async {
    try {
      if (kDebugMode) print(baseUrl + endPoint);
      var responseResult = await TrustAllCertificates.getInstance
          .sslClient()
          .get(Uri.parse(baseUrl + endPoint), headers: headers)
          .timeout(const Duration(seconds: 30));
      var handleResponseStatus =
          handleResponseStatusCode(responseResult.statusCode);
      if (handleResponseStatus.status!) {
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer(
                jsonDecode(responseResult.body) as Map<String, dynamic>));
      } else {
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer(nullSafety));
      }
    } on Exception catch (_) {
      return Tupple(
          handleFailure: HandleFailure(), onSuccess: serializer(nullSafety));
    }
  }

  Future<Tupple<HandleFailure, ResponseObject>> getdataAPIHeadersString({
    required String baseUrl,
    required String endPoint,
    required Map<String, String> headers,
    required String nullSafety,
    required ResponseObject Function(List<dynamic>) serializer,
  }) async {
    try {
      if (kDebugMode) print(baseUrl + endPoint);
      var responseResult = await TrustAllCertificates.getInstance
          .sslClient()
          .get(Uri.parse(baseUrl + endPoint), headers: headers)
          .timeout(const Duration(seconds: 30));
      var handleResponseStatus =
          handleResponseStatusCode(responseResult.statusCode);
      if (handleResponseStatus.status!) {
        debugPrint("success");
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess:
                serializer(jsonDecode(responseResult.body) as List<dynamic>));
      } else {
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer([]));
      }
    } on Exception catch (_) {
      debugPrint("-----------------------");
      return Tupple(handleFailure: HandleFailure(), onSuccess: serializer([]));
    }
  }

  Future<Tupple<HandleFailure, ResponseObject>> postdataAPIHeadersBody({
    required String baseUrl,
    required String endPoint,
    required Map<String, String> headers,
    required Map<String, dynamic> bodyObject,
    required Map<String, dynamic> nullSafety,
    required ResponseObject Function(Map<String, dynamic>) serializer,
  }) async {
    try {
      if (kDebugMode) print(baseUrl + endPoint);
      var responseResult = await TrustAllCertificates.getInstance
          .sslClient()
          .post(Uri.parse(baseUrl + endPoint),
              headers: headers, body: json.encode(bodyObject));
      var request = responseResult.request;
      debugPrint("Request to DataAPI => ${request!.headers}");
      return Tupple(
          handleFailure: HandleFailure(
              message: "Internal Server Error",
              statusCode: responseResult.statusCode),
          onSuccess: serializer(
              jsonDecode(responseResult.body) as Map<String, dynamic>));
    } on Exception catch (_) {
      return Tupple(
          handleFailure: HandleFailure(), onSuccess: serializer(nullSafety));
    }
  }

  Future<Tupple<HandleFailure, ResponseObject>> putdataAPIHeadersBody({
    required String baseUrl,
    required String endPoint,
    required Map<String, String> headers,
    required Map<String, dynamic> bodyObject,
    required Map<String, dynamic> nullSafety,
    required ResponseObject Function(Map<String, dynamic>) serializer,
  }) async {
    try {
      if (kDebugMode) print(baseUrl + endPoint);
      var responseResult = await TrustAllCertificates.getInstance
          .sslClient()
          .put(Uri.parse(baseUrl + endPoint),
              headers: headers, body: json.encode(bodyObject));
      var request = responseResult.request;
      debugPrint("mantap request => ${request!.headers}");
      return Tupple(
          handleFailure: HandleFailure(
              message: "Internal Server Error",
              statusCode: responseResult.statusCode),
          onSuccess: serializer(
              jsonDecode(responseResult.body) as Map<String, dynamic>));
    } on Exception catch (_) {
      return Tupple(
          handleFailure: HandleFailure(), onSuccess: serializer(nullSafety));
    }
  }

  Future<Tupple<HandleFailure, ResponseObject>> postdataAPIHeadersBodyWithFile({
    required String baseUrl,
    required String endPoint,
    required Map<String, String> headers,
    required File file,
    required Map<String, String> bodyObject,
    required Map<String, dynamic> nullSafety,
    required ResponseObject Function(Map<String, dynamic>) serializer,
  }) async {
    try {
      if (kDebugMode) print(baseUrl + endPoint);

      // var responseResult = await http.post(Uri.parse(baseUrl + endPoint),
      //     headers: headers, body: json.encode(bodyObject));
      TrustAllCertificates.getInstance.sslClient();

      var length = await file.length();

      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(baseUrl + endPoint))
            ..fields.addAll(bodyObject)
            ..headers.addAll(headers)
            ..files.add(
              // replace file with your field name exampe: image
              http.MultipartFile('file', file.openRead(), length,
                  filename: 'logo${random.nextInt(10000)}.png'),
            );
      var responseResult = await http.Response.fromStream(await request.send());

      debugPrint("status code ${responseResult.statusCode}");
      debugPrint("response body ${responseResult.body}");

      var handleResponseStatus =
          handleResponseStatusCode(responseResult.statusCode);
      if (handleResponseStatus.status!) {
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer(
                jsonDecode(responseResult.body) as Map<String, dynamic>));
      } else {
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer(nullSafety));
      }
    } on Exception catch (e) {
      debugPrint("response body error");
      debugPrint("response body ${e.toString()}");
      return Tupple(
          handleFailure: HandleFailure(), onSuccess: serializer(nullSafety));
    }
  }

  Future<Tupple<HandleFailure, ResponseObject>> postdataAPIBody({
    required String baseUrl,
    required String endPoint,
    required Map<String, dynamic> bodyObject,
    required Map<String, dynamic> nullSafety,
    required ResponseObject Function(Map<String, dynamic>) serializer,
  }) async {
    try {
      if (kDebugMode) print(baseUrl + endPoint);
      var responseResult = await TrustAllCertificates.getInstance
          .sslClient()
          .post(Uri.parse(baseUrl + endPoint), body: json.encode(bodyObject));
      var handleResponseStatus =
          handleResponseStatusCode(responseResult.statusCode);
      if (handleResponseStatus.status!) {
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer(
                jsonDecode(responseResult.body) as Map<String, dynamic>));
      } else {
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer(nullSafety));
      }
    } on Exception catch (_) {
      return Tupple(
          handleFailure: HandleFailure(), onSuccess: serializer(nullSafety));
    }
  }

  Future<Tupple<HandleFailure, ResponseObject>> postdataAPI({
    required String baseUrl,
    required String endPoint,
    required Map<String, dynamic> nullSafety,
    required ResponseObject Function(Map<String, dynamic>) serializer,
  }) async {
    try {
      if (kDebugMode) print(baseUrl + endPoint);
      var responseResult = await TrustAllCertificates.getInstance
          .sslClient()
          .post(Uri.parse(baseUrl + endPoint));
      var handleResponseStatus =
          handleResponseStatusCode(responseResult.statusCode);
      if (handleResponseStatus.status!) {
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer(
                jsonDecode(responseResult.body) as Map<String, dynamic>));
      } else {
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer(nullSafety));
      }
    } on Exception catch (_) {
      return Tupple(
          handleFailure: HandleFailure(), onSuccess: serializer(nullSafety));
    }
  }

  Future<Tupple<HandleFailure, ResponseObject>> postdataAPIBodyWithoutSSL({
    required String baseUrl,
    required String endPoint,
    required Map<String, dynamic> bodyObject,
    required Map<String, dynamic> nullSafety,
    required ResponseObject Function(Map<String, dynamic>) serializer,
  }) async {
    try {
      if (kDebugMode) print(baseUrl + endPoint);
      HttpClient client = HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      HttpClientRequest request =
          await client.postUrl(Uri.parse(baseUrl + endPoint));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(bodyObject)));
      HttpClientResponse responseResult = await request.close();

      var handleResponseStatus =
          handleResponseStatusCode(responseResult.statusCode);
      if (handleResponseStatus.status!) {
        debugPrint('data from black ' +
            await responseResult.transform(utf8.decoder).join());
        return Tupple(
            handleFailure: HandleFailure(statusCode: 404, message: ""),
            onSuccess: serializer(
                jsonDecode(await responseResult.transform(utf8.decoder).join())
                    as Map<String, dynamic>));
      } else {
        debugPrint(
            'else ' + await responseResult.transform(utf8.decoder).join());
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer(nullSafety));
      }
    } on Exception catch (_) {
      debugPrint('Exception ');
      return Tupple(
          handleFailure: HandleFailure(), onSuccess: serializer(nullSafety));
    }
  }

  Future<Tupple<HandleFailure, ResponseObject>>
      postdataAPIHeadersBodyWithFileDio({
    required String baseUrl,
    required String endPoint,
    required Map<String, String> headers,
    required Map<String, dynamic> bodyObject,
    required Map<String, dynamic> nullSafety,
    required ResponseObject Function(Map<String, dynamic>) serializer,
  }) async {
    try {
      if (kDebugMode) print(baseUrl + endPoint);

      var data = FormData.fromMap(
        bodyObject,
      );

      debugPrint(bodyObject.toString());

      Dio dio = Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      var responseResult = await dio.post(
        baseUrl + endPoint,
        data: data,
        options: Options(
          contentType: 'multipart/form-data',
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      var handleResponseStatus =
          handleResponseStatusCode(responseResult.statusCode!);

      if (handleResponseStatus.status!) {
        return Tupple(
            handleFailure: HandleFailure(
                statusCode: responseResult.statusCode,
                message: "Internal Server Error"),
            onSuccess: serializer(responseResult.data as Map<String, dynamic>));
      } else {
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer(nullSafety));
      }
    } on Exception catch (e) {
      return Tupple(
          handleFailure: HandleFailure(), onSuccess: serializer(nullSafety));
    }
  }

  Future<Tupple<HandleFailure, ResponseObject>>
      putdataAPIHeadersBodyWithFileDio({
    required String baseUrl,
    required String endPoint,
    required Map<String, String> headers,
    required Map<String, dynamic> bodyObject,
    required Map<String, dynamic> nullSafety,
    required ResponseObject Function(Map<String, dynamic>) serializer,
  }) async {
    try {
      if (kDebugMode) print(baseUrl + endPoint);

      debugPrint(bodyObject.toString());

      Dio dio = Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      var responseResult = await dio.put(
        baseUrl + endPoint,
        data: bodyObject,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      return Tupple(
          handleFailure: HandleFailure(
              statusCode: responseResult.statusCode,
              message: "Internal Server Error"),
          onSuccess: serializer(responseResult.data as Map<String, dynamic>));
    } on Exception {
      return Tupple(
          handleFailure: HandleFailure(), onSuccess: serializer(nullSafety));
    }
  }

  Future<Tupple<HandleFailure, ResponseObject>>
      patchdataAPIHeadersBodyWithFileDio({
    required String baseUrl,
    required String endPoint,
    required Map<String, String> headers,
    required Map<String, dynamic> bodyObject,
    required Map<String, dynamic> nullSafety,
    required ResponseObject Function(Map<String, dynamic>) serializer,
  }) async {
    try {
      if (kDebugMode) print(baseUrl + endPoint);

      debugPrint(bodyObject.toString());

      Dio dio = Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      var responseResult = await dio.patch(
        baseUrl + endPoint,
        data: bodyObject,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      return Tupple(
          handleFailure: HandleFailure(
              statusCode: responseResult.statusCode,
              message: "Internal Server Error"),
          onSuccess: serializer(responseResult.data as Map<String, dynamic>));
    } on Exception catch (e) {
      return Tupple(
          handleFailure: HandleFailure(), onSuccess: serializer(nullSafety));
    }
  }

  Future<Tupple<HandleFailure, ResponseObject>>
      deleteDataAPIHeadersBodyWithFileDio({
    required String baseUrl,
    required String endPoint,
    required Map<String, String> headers,
    required Map<String, dynamic> bodyObject,
    required Map<String, dynamic> nullSafety,
    required ResponseObject Function(Map<String, dynamic>) serializer,
  }) async {
    try {
      if (kDebugMode) print(baseUrl + endPoint);

      debugPrint(bodyObject.toString());

      var responseResult = await TrustAllCertificates.getInstance
          .sslClient()
          .delete(Uri.parse(baseUrl + endPoint), headers: headers)
          .timeout(const Duration(seconds: 30));
      var handleResponseStatus =
          handleResponseStatusCode(responseResult.statusCode);
      if (handleResponseStatus.status!) {
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer(
                jsonDecode(responseResult.body) as Map<String, dynamic>));
      } else {
        return Tupple(
            handleFailure: handleResponseStatus.handleFailure,
            onSuccess: serializer(nullSafety));
      }
    } on Exception catch (e) {
      debugPrint("error : ${e.toString()}");
      return Tupple(
          handleFailure: HandleFailure(), onSuccess: serializer(nullSafety));
    }
  }

  Future<Tupple<HandleFailure, ResponseObject>>
      putdataAPIHeadersBodyWithUrlEncodeDio({
    required String baseUrl,
    required String endPoint,
    required Map<String, String> headers,
    required Map<String, dynamic> bodyObject,
    required Map<String, dynamic> nullSafety,
    required ResponseObject Function(Map<String, dynamic>) serializer,
  }) async {
    try {
      if (kDebugMode) print(baseUrl + endPoint);

      var data = FormData.fromMap(
        bodyObject,
      );

      debugPrint(bodyObject.toString());

      Dio dio = Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      var responseResult = await dio.put(
        baseUrl + endPoint,
        data: data,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      return Tupple(
          handleFailure: HandleFailure(
              statusCode: responseResult.statusCode,
              message: "Internal Server Error"),
          onSuccess: serializer(responseResult.data as Map<String, dynamic>));
    } on Exception {
      return Tupple(
          handleFailure: HandleFailure(), onSuccess: serializer(nullSafety));
    }
  }

  TuppleHandleStatusCode<bool, HandleFailure> handleResponseStatusCode(
      int statusCode) {
    switch (statusCode) {
      case 200:
        return TuppleHandleStatusCode(
          status: true,
          handleFailure: HandleFailure(message: "OK", statusCode: 200),
        );
      case 201:
        return TuppleHandleStatusCode(
          status: true,
          handleFailure: HandleFailure(message: "OK", statusCode: 201),
        );
      case 204:
        return TuppleHandleStatusCode(
          status: true,
          handleFailure: HandleFailure(message: "OK", statusCode: 204),
        );
      case 401:
        return TuppleHandleStatusCode(
          status: true,
          handleFailure:
              HandleFailure(message: "Unauthorized", statusCode: 401),
        );
      case 403:
        return TuppleHandleStatusCode(
          status: false,
          handleFailure: HandleFailure(message: "Forbidden", statusCode: 403),
        );
      case 404:
        return TuppleHandleStatusCode(
          status: false,
          handleFailure: HandleFailure(message: "Not Found", statusCode: 404),
        );
      case 409:
        return TuppleHandleStatusCode(
          status: false,
          handleFailure: HandleFailure(message: "Conflict", statusCode: 409),
        );
      case 504:
        return TuppleHandleStatusCode(
          status: false,
          handleFailure:
              HandleFailure(message: "Gateway Timeout", statusCode: 504),
        );
      case 503:
        return TuppleHandleStatusCode(
          status: false,
          handleFailure:
              HandleFailure(message: "Service Unavailable", statusCode: 503),
        );
      case 502:
        return TuppleHandleStatusCode(
          status: false,
          handleFailure: HandleFailure(message: "Bad Gateway", statusCode: 502),
        );
      case 500:
        return TuppleHandleStatusCode(
          status: false,
          handleFailure:
              HandleFailure(message: "Internal Server Error", statusCode: 500),
        );
      case 499:
        return TuppleHandleStatusCode(
          status: false,
          handleFailure:
              HandleFailure(message: "Client Closed Request", statusCode: 499),
        );
      case 429:
        return TuppleHandleStatusCode(
          status: false,
          handleFailure:
              HandleFailure(message: "Too Many Request", statusCode: 429),
        );
      case 413:
        return TuppleHandleStatusCode(
          status: false,
          handleFailure:
              HandleFailure(message: "Payload Too Large", statusCode: 413),
        );
      case 412:
        return TuppleHandleStatusCode(
          status: false,
          handleFailure:
              HandleFailure(message: "Precondition Failed", statusCode: 412),
        );
      case 411:
        return TuppleHandleStatusCode(
          status: false,
          handleFailure:
              HandleFailure(message: "Length Required", statusCode: 411),
        );
      case 410:
        return TuppleHandleStatusCode(
          status: false,
          handleFailure: HandleFailure(message: "Gone", statusCode: 410),
        );
      case 405:
        return TuppleHandleStatusCode(
          status: false,
          handleFailure: HandleFailure(message: "Conflict", statusCode: 405),
        );
      case 400:
        return TuppleHandleStatusCode(
          status: true,
          handleFailure: HandleFailure(message: "Bad Request", statusCode: 400),
        );
      default:
        return TuppleHandleStatusCode(status: false, handleFailure: null);
    }
  }
}
