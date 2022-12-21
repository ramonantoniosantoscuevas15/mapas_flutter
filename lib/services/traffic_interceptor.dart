import 'package:dio/dio.dart';
const accessToken = 'pk.eyJ1IjoicmFtb25zYW50b3MxNSIsImEiOiJjbGJ4c3lyZmkwNmFkM3FtbmQyaXh3cXA1In0.Un7p6UmA04Y1-ZtJs9tOLA';
class TrafficInterceptor extends Interceptor {
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives' : true,
      'geometries' : 'polyline6',
      'overview' : 'simplified',
      'steps' : false,
      'access_token' : accessToken
    });
    super.onRequest(options, handler);
  }
}
