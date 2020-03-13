import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zjy/common/common.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LogsInterceptors extends InterceptorsWrapper {
  bool isDebug = Constants.isDebug;

  @override
  onRequest(RequestOptions options) async {
    // TODO: implement onRequest
    if (isDebug) {
      print('┌─────────────────────Begin Request─────────────────────');
      printKV('uri', options.uri);
      printKV('method', options.method);
      printKV('queryParameters', options.queryParameters);
      printKV('contentType', options.contentType.toString());
      printKV('responseType', options.responseType.toString());

      StringBuffer stringBuffer = new StringBuffer();
      options.headers.forEach((key, v) => stringBuffer.write('\n  $key: $v'));
      printKV('headers', stringBuffer.toString());
      stringBuffer.clear();

      if (options.data != null) {
        printKV('body', options.data);
      }
      print('└—————————————————————End Request———————————————————————\n\n');
    }
    return options;
  }

  @override
  onResponse(Response response) async {
    // TODO: implement onResponse
    if (isDebug) {
      print('┌─────────────────────Begin Response—————————————————————');
      printKV('uri', response.request.uri);
      printKV('status', response.statusCode);
      printKV('responseType', response.request.responseType.toString());

      StringBuffer stringBuffer = new StringBuffer();
      response.headers.forEach((key, v) => stringBuffer.write('\n  $key: $v'));
      printKV('headers', stringBuffer.toString());
      stringBuffer.clear();

      printLong('response: ' + response.toString());

      print('└—————————————————————End Response———————————————————————\n\n');
    }
    return response;
  }

  @override
  onError(DioError err) async {
    // TODO: implement onError
    if (isDebug) {
      print('┌─────────────────────Begin Dio Error—————————————————————');
      printKV('error', err.toString());
      printKV('error message', (err.response?.toString() ?? ''));
      print('└—————————————————————End Dio Error———————————————————————\n\n');
    }

    Fluttertoast.showToast(
        msg: err.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        // 消息框弹出的位置
        timeInSecForIos: 1,
        // 消息框持续的时间（目前的版本只有ios有效）
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 13.0);

    return err;
  }

  printKV(String key, Object value) {
    printLong('$key: $value');
  }

  int maxLength = 340;

  void printLong(String log) {
    if (log.length < maxLength) {
      print(log);
    } else {
      while (log.length > maxLength) {
        print(log.substring(0, maxLength));
        log = log.substring(maxLength);
      }

      /// 打印剩余部分
      print(log);
    }
  }
}
