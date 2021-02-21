import 'package:flutter/material.dart';
import 'package:flutter_ddd_firebase_demo/application/core/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
void configureInjection(String env) {
  debugPrint('injection.dart, configureInjection');
  $initGetIt(getIt, environment: env);
}
