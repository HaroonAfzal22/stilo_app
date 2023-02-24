import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/constant.dart';

final dioProvider = ChangeNotifierProvider((ref) => DioProvider());

class DioProvider extends ChangeNotifier {
  Dio dio = Dio(Constant.options);
}
