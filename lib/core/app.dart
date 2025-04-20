import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic/app/utils/app_prefs.dart';
import 'package:islamic/di/di.dart';

import '../app/resources/resources.dart';
import '../presentation/home/cubit/home_cubit.dart';

import '../presentation/home/screens/prayer_times/cubit/prayer_timings_cubit.dart';


class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const MyApp _instance = MyApp._internal();

  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPreferences _preferences = instance<AppPreferences>();

  @override
  void didChangeDependencies() {
    _preferences.getAppLocale().then((locale) => context.setLocale(locale));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (BuildContext context) => instance<HomeCubit>()
                    ..getLocation()
                    ..isThereABookMarked()),

              BlocProvider(
                  create: (BuildContext context) =>
                      instance<PrayerTimingsCubit>()
                        ..getPrayerTimings()
                        ..isNetworkConnected()),
           
            ],
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  darkTheme: getApplicationLDarkTheme(),
                  theme: getApplicationLightTheme(),
                  themeMode: _preferences.getAppTheme(),
                  onGenerateRoute: RoutesGenerator.getRoute,
                  initialRoute: Routes.homeRoute,
                );
              },
            ),
          );
        });
  }
}
