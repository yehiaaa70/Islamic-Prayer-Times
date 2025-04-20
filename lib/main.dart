import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
// import 'package:wakelock/wakelock.dart';

import 'app/resources/resources.dart';
import 'core/app.dart';
import 'core/bloc_observer.dart';
import 'di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initAppModule();
  // Wakelock.enable();
  Bloc.observer = MyBlocObserver();
  runApp(
    EasyLocalization(
      supportedLocales: const [arabicLocale, englishLocale],
      startLocale: arabicLocale,
      path: localisationPath,
      child: Phoenix(
        child: MyApp(),
      ),
    ),
  );
}
