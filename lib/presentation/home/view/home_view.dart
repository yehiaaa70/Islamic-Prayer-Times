import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/di.dart';
import '../../../../../app/resources/resources.dart';

import '../cubit/home_cubit.dart';
import '../screens/prayer_times/view/prayer_timings_screen.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeView extends StatelessWidget {

  HomeView({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          HomeViewModel().titles[0],
          style: TextStyle(color: Colors.black), // Ensure color contrast

        ),


      ),

      body: BlocProvider(
        create: (context) => instance<HomeCubit>()..isThereABookMarked(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            var cubit = HomeCubit.get(context);
            bool darkMode = cubit.darkModeOn(context);
            int currentIndex = cubit.currentIndex;
            return PrayerTimingsScreen();
          },
        ),
      ),
    );
  }
}
