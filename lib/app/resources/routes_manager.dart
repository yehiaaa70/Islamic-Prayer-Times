import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:islamic/app/resources/strings_manager.dart';

import '../../di/di.dart';
import '../../presentation/home/view/home_view.dart';


class Routes {
  static const String dashboardRoute = "/";
  static const String homeRoute = "/home";

}

class RoutesGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeRoute:

        initPrayerTimingsModule();
        return MaterialPageRoute(builder: (_) => HomeView());


      // case Routes.browsenetRoute:
      //   return MaterialPageRoute(builder: (_) => BrowseYoutubeScreen());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.noRouteFound.tr(),
          ),
        ),
        body: Center(
          child: Text(
            AppStrings.noRouteFound.tr(),
          ),
        ),
      ),
    );
  }
}
