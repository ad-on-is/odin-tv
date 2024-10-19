import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:odin/data/models/auth_model.dart';
import 'package:odin/helpers.dart';

class ApiService with BaseHelper {
  final Ref ref;
  final Dio dio = Dio();
  AuthModel auth;
  ApiService(this.ref, this.auth) {
    // ref.watch(authProvider);
    onInit();
  }

  void onInit() async {
    // (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    //   final client = HttpClient();
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) {
    //     return true;
    //   };
    //   return client;
    // };
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      var creds = await auth.getCredentials();
      var apiUrl = creds["url"];
      var device = creds["device"];
      options.baseUrl = '$apiUrl';
      options.headers.addAll({'Device': device});
      options.followRedirects = true;

      return handler.next(options);
    }));
  }

  Future<Either<Exception, dynamic>> get(String url) async {
    try {
      final response = await dio.get(url);
      return Right(response.data);
    } on DioException catch (e) {
      logWarning(url);
      logError(e, e.stackTrace);
      return Left(e);
    }
  }

  Future<Either<Exception, dynamic>> post(String url, dynamic data) async {
    try {
      final response = await dio.post(url, data: data);
      return Right(response.data);
    } on DioException catch (e) {
      logWarning(url);
      logError(e, e.stackTrace);
      return Left(e);
    }
  }
}

final apiProvider =
    Provider((ref) => ApiService(ref, ref.watch(authProvider.notifier)));
