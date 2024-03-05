import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:odin/data/services/db.dart';
import 'package:odin/helpers.dart';

class ApiService with BaseHelper {
  final Ref ref;
  final Dio dio = Dio();
  HiveBox hive;
  ApiService(this.ref, this.hive) {
    // ref.watch(authProvider);
    onInit();
  }

  void onInit() async {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      var apiUrl = await hive.hive?.get('apiUrl');
      var device = await hive.hive?.get('apiDevice');
      options.baseUrl = '$apiUrl';
      options.headers.addAll({'Device': device});
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

final apiProvider = Provider((ref) => ApiService(
      ref,
      ref.watch(hiveProvider),
    ));
