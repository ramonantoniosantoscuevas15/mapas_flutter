import 'package:dio/dio.dart';


class PlacesInterceptor extends Interceptor {
  final accessToken = 'pk.eyJ1IjoicmFtb25zYW50b3MxNSIsImEiOiJjbGJ4c3lyZmkwNmFkM3FtbmQyaXh3cXA1In0.Un7p6UmA04Y1-ZtJs9tOLA';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'access_token' : accessToken,
      'language' : 'es',
     

    });
    super.onRequest(options, handler);
  }
}
