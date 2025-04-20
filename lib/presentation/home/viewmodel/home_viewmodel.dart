import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

import '../../../../../app/resources/resources.dart';
import '../screens/prayer_times/view/prayer_timings_screen.dart';

class HomeViewModel {
  HomeViewModel();

  List<Widget> screens = [

     PrayerTimingsScreen(),

  ];

  List<String> titles = [

    AppStrings.prayerTimes.tr(),

  ];
}
